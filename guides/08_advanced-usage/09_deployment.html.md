---
chapter: Advanced Usage
title: Deployment
---

# Deployment

A Padrino project is a Rack application, so any host that runs Ruby can run it:
a virtual machine, a container or a platform as a service. This guide covers
the steps most deployments share.

## The production environment

Run the app with `RACK_ENV=production`, or pass `-e production` to `padrino`
commands. In production:

- the log goes to `log/production.log` and only records warnings and errors;
- requests are not logged, and code is not reloaded;
- an unhandled error returns a plain `500 Internal Server Error` page and is
  written to the log.

Many platforms collect logs from standard output instead of files. To log
there, add this to `config/boot.rb` before `Padrino.load!`:

```ruby
Padrino::Logger::Config[:production][:stream] = :stdout
```

## Starting the server

New projects use WEBrick unless you chose another server. For production, use
Puma or Falcon. Add the gem to your `Gemfile` (`gem 'puma'`), or generate the
project with `--server=puma` or `--server=falcon`.

Start the app with `padrino start`:

```bash
$ padrino start -e production -a puma -h 0.0.0.0 -p 3000
```

`padrino start` binds to `127.0.0.1:3000` by default, so pass `-h 0.0.0.0` when
the app must accept outside connections, as in a container.

You can also run the server's own command, which loads `config.ru`:

```bash
$ RACK_ENV=production bundle exec puma -p 3000
$ RACK_ENV=production bundle exec falcon serve --bind http://0.0.0.0:3000
```

For threads, workers and processes, see
[Concurrency](/guides/advanced-usage/asynchronous-concurrency-with-padrino).

## Session secret

Anyone with the session secret can forge session cookies, so production needs
its own. Projects generated with Padrino 0.18.0 or later read it from the
`SESSION_SECRET` environment variable, and fall back to the random value
written into `config/apps.rb`:

```ruby
set :session_secret, ENV.fetch('SESSION_SECRET') { '...' } # the generated value
```

Set `SESSION_SECRET` on the server. Older projects get only the random value in
`config/apps.rb`, so don't use that committed value in production. Read it
from the environment instead:

```ruby
Padrino.configure_apps do
  set :session_secret, '...' # the generated value, used in development

  configure :production do
    set :session_secret, ENV.fetch('SESSION_SECRET')
  end
end
```

The secret must be at least 64 bytes long. Generate one with:

```bash
$ ruby -rsecurerandom -e 'puts SecureRandom.hex(64)'
```

Generated apps mark the session cookie Secure in production, so the app must
see requests as HTTPS. Behind a proxy or load balancer that terminates TLS, have
it send the `X-Forwarded-Proto: https` header; a site served over plain HTTP
needs `secure: false`. See [Sessions](/guides/controllers/sessions "Sessions").

## Database

The generated `config/database.rb` has a production entry that points at a
local database. Most hosts give you a `DATABASE_URL` instead.

With Sequel, connect to it in the production branch:

```ruby
when :production then Sequel.connect(ENV.fetch('DATABASE_URL'), loggers: [logger])
```

Active Record reads `DATABASE_URL` itself, and it takes precedence over the
configuration for the current environment, so you only need to set the
variable.

Either way, make sure the `Gemfile` has the driver for the production database,
such as `pg` or `mysql2`.

Run the migrations on each deploy:

```bash
$ RACK_ENV=production bundle exec rake sq:migrate   # Sequel
$ RACK_ENV=production bundle exec rake ar:migrate   # Active Record
```

The rake tasks load the app, so they need the same environment variables as the
server, such as `SESSION_SECRET` and `DATABASE_URL`.

## Assets

If the project uses the Vite script component or the Tailwind stylesheet
component, build the assets on each deploy:

```bash
$ RACK_ENV=production bundle exec rake assets:precompile
```

- Tailwind writes a minified `public/stylesheets/application.css`.
- Vite runs `npm ci` and builds into `public/vite`. `npm ci` needs a
  `package-lock.json`, so run `npm install` once and commit the lock file. The
  build machine needs Node.js.

The generators add these build outputs to `.gitignore`, so they have to be
built where you deploy, not committed.

## Static files

Padrino serves the files in `public/` itself, in every environment. To let
browsers cache them, set a `Cache-Control` header:

```ruby
set :static_cache_control, [:public, max_age: 31536000]
```

Padrino's asset helpers (`stylesheet_link_tag`, `javascript_include_tag`,
`image_tag`, `favicon_tag` and `asset_path`) add the file's modification time to
the URL when you give them a name relative to their folder
(`image_tag 'logo.png'`, not `'/images/logo.png'`), and Vite puts a content hash
in its file names, so browsers fetch the new files after a deploy. Other files keep the
cached copy until `max_age` runs out: helper calls given a path starting with `/`
or a full URL, images referenced from CSS, the `/favicon.ico` browsers request on
their own, and links you write by hand. Use a shorter `max_age` if those change
often. If a web server such as nginx sits in front of the app, you can let it
serve `public/` directly instead.
