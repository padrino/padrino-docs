---
chapter: Application Helpers
title: Unobtrusive JavaScript Helpers
---

# Unobtrusive JavaScript Helpers

Certain helpers have certain unobtrusive JavaScript options that are available
to be used with any of the javascript adapters packaged with padrino. Once your
app has been [generated](/guides/generators "generated") with a particular
javascript adapter, you can utilize the baked in support with the `link_to` and
`form_for` tags.

## Remote Forms

To generate a ‘remote’ form in a view:

```haml
# /app/views/users/new.html.haml
= form_for :user, url(:create, :format => :js), :remote => true do |f|
  .content=partial "/users/form"
```

which will generate the following unobtrusive markup:

```html
<form data-remote="true" action="/items/create.js" method="post">
  <div class="content">
    <input type="text" id="post_title" name="post[title]">
    <input type="submit" value="Create">
  </div>
</form>
```

```ruby
# /app/controllers/users.rb
post :create, :provides => :js do
  @user = User.new(params[:user])
  if @user.save
    "$('form.content').html('#{partial("/users/form")}');"
  else
    "alert('User is not valid');"
  end
end
```

A remote form, when submitted by the user, invokes an xhr request to the
specified url (with the appropriate form parameters) and then evaluates the
response as javascript.

## Remote Links

To generate a ‘remote’ link in a view:

```ruby
link_to "add item", url(:items, :new, :format => :js), :remote => true
```

which will generate the following unobtrusive markup:

```html
<a href="/items/new.js" data-remote="true">add item</a>
```

A remote link, when clicked by the user, invokes an xhr request to the specified
url and then evaluates the response as javascript.

## Link Confirmations

To generate a ‘confirmation’ link in a view:

```ruby
link_to "delete item", url(:items, :destroy, :format => :js), :confirm => "Are You Sure?"
```

which will generate the following unobtrusive markup:

```html
<a data-confirm="Are You Sure?" href="/posts/destroy/7">[destroy]</a>
```

A link with confirmation, when clicked by the user, displays an alert box
confirming the action before invoking the link.

## Custom Method Links

To generate a ‘method’ link in a view:

```ruby
link_to "logout", url(:session, :destroy, :format => :js), :method => :delete
```

which will generate the following unobtrusive markup:

```html
<a data-method="delete" href="/posts/destroy/7" rel="nofollow">[destroy]</a>
```

A link with a custom method, when clicked by the user, visits the link using the
http method specified rather than via the ‘GET’ method.

## Enabling UJS Adapter

**Note**: In order for the unobstrusive javascript to work, you must be sure to
  include the chosen javascript framework and ujs adapter in your views (or
  layout). For instance, if I selected jquery for my project:

```haml
-# /apps/views/layouts/application.haml
= javascript_include_tag 'jquery', 'jquery-ujs', 'application'
```

This will ensure jquery and the jquery ujs adapter are properly loaded to work
with the helpers listed above.
