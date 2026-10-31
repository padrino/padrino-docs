---
chapter: Controllers
title: CSRF Protection
---

# CSRF Protection

Cross-site request forgery (CSRF) protection stops other sites from submitting
forms to your app on behalf of a logged-in user. Padrino adds
`Rack::Protection::AuthenticityToken` to an app when `protect_from_csrf` is on.
Every request that is not a GET, HEAD, OPTIONS or TRACE must then carry a token
that matches the one stored in the session, or it is rejected with
`403 Forbidden`.

## Turning it on

Protection is off in a bare `Padrino::Application`. New projects turn it on for
every app in `config/apps.rb`:

```ruby
Padrino.configure_apps do
  set :session_secret, ENV.fetch('SESSION_SECRET') { '...' }
  set :protection, except: :path_traversal
  set :protect_from_csrf, Padrino.env != :test
end
```

You can also set it per app:

```ruby
module Demo
  class App < Padrino::Application
    enable :sessions
    enable :protect_from_csrf
  end
end
```

The token lives in the session, so CSRF protection needs sessions. Generated
apps turn them on with
`set :sessions, same_site: :lax, secure: Padrino.env == :production`. If
sessions are off, Padrino prints a warning and every request, GETs included, is
rejected with `403 Forbidden`.

To use another session store, pass it to the `sessions` setting so that Padrino
adds it before the CSRF check:

```ruby
set :sessions, use: Rack::Session::Pool, config: { same_site: :lax, expire_after: 2592000 }
```

Middleware added with `use` inside the app runs after the CSRF check, so every
request is rejected. If you add the session middleware outside Padrino, in
`config.ru`, silence the warning in `config/boot.rb`:

```ruby
Padrino::IGNORE_CSRF_SETUP_WARNING = true
```

## Forms

The form helpers add the token for you. `form_tag`, `form_for` and `button_to`
render a hidden `authenticity_token` field in every form that does not use the
GET method:

```erb
<% form_tag '/register' do %>
  <%= text_field_tag :email %>
  <%= submit_tag 'Sign up' %>
<% end %>
```

```html
<form action="/register" accept-charset="UTF-8" method="post">
  <input type="hidden" name="authenticity_token" value="..." />
  ...
</form>
```

Use `button_to` for links that change data, such as a delete link. It renders a
small form with the token.

To leave the token out of one form, pass `protect_from_csrf: false`:

```erb
<% form_tag '/search', protect_from_csrf: false do %>
```

If you write a form by hand, add the field with `csrf_token_field`.

## JavaScript requests

Put the token in your layout with `csrf_meta_tags`:

```erb
<head>
  <%= csrf_meta_tags %>
</head>
```

It renders `csrf-param` and `csrf-token` meta tags. Send the token back in the
`X-CSRF-Token` header:

```javascript
const token = document.querySelector('meta[name="csrf-token"]').content
fetch('/items', { method: 'POST', headers: { 'X-CSRF-Token': token } })
```

## Skipping routes

To skip the check for some paths, such as a webhook, pass `except`. It takes a
string, a regular expression, an array of them, or a proc that receives the Rack
env. Paths are matched inside the app, without its mount point:

```ruby
set :protect_from_csrf, except: %r{\A/webhooks/}
```

To opt out route by route, enable `allow_disabled_csrf` and pass
`csrf_protection: false` to the route:

```ruby
enable :allow_disabled_csrf

post :callback, csrf_protection: false do
  # no token needed
end
```

Without `allow_disabled_csrf`, `csrf_protection: false` has no effect.

With `allow_disabled_csrf` (or `report_csrf_failure`, which does the same), the
middleware only flags a failed check and each route rejects it with a 403. The
response body is `Forbidden`, or the `message` you set:

```ruby
set :protect_from_csrf, message: 'Invalid form token'
enable :allow_disabled_csrf
```

Set these before your routes are defined, for example in `app/app.rb` or
`config/apps.rb`. Routes defined before `allow_disabled_csrf` is enabled are
not checked at all.

A hash value for `protect_from_csrf` turns protection on in every environment,
replacing the generated `Padrino.env != :test`. To keep tests free of tokens,
choose the value by environment:

```ruby
set :protect_from_csrf, Padrino.env == :test ? false : { except: %r{\A/webhooks/} }
```

## Testing

The generated `config/apps.rb` turns protection off in the test environment, so
test requests don't need a token and forms are rendered without the hidden
field.

The app reads `protect_from_csrf` when it builds its middleware, on its first
request, so turning it on inside one test does nothing if an earlier test has
already made a request. To test the protection itself, turn it on before the
app is loaded and run those tests in their own process. For example, use
`set :protect_from_csrf, Padrino.env != :test || ENV['CSRF'] == '1'` in
`config/apps.rb`, and run the CSRF tests with `CSRF=1`. Get the form, then post
the `authenticity_token` back with the session cookie.

`rake test` loads every test file, so skip the CSRF tests when `CSRF` isn't set:

```ruby
before { skip 'run with CSRF=1' unless ENV['CSRF'] == '1' }
```

Run them on their own, since `CSRF=1` turns protection on for every test in the
process:

```bash
$ CSRF=1 bundle exec ruby -Itest test/app/csrf_test.rb
```
