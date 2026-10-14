---
chapter: Features
title: Development Commands
---

# Development Commands

## Logging

Padrino comes with its own logger. By default it writes to `STDOUT` in
development, to `log/production.log` in production, and nowhere in test.

To use the logger within a Padrino application, simply refer to the `logger`
method accessible within your app and any controller or views:

```ruby
# controllers/example.rb
SimpleApp.controllers do
  get('/test') { logger.info 'This is a test' }
end
```

The logger supports the levels `fatal`, `error`, `warn`, `info`, `debug` and
`devel`, through `logger.info`, `logger.warn`, et al.

Each environment has its own settings in `Padrino::Logger::Config`. Change them
in `config/boot.rb` before `Padrino.load!`:

```ruby
# config/boot.rb
Padrino::Logger::Config[:development][:stream] = :to_file
Padrino::Logger::Config[:production][:log_level] = :info
Padrino.load!
```

Option             | Default                                   | Description
------------------ | ----------------------------------------- | -----------------------------------------------------------------
`log_level`        | `:debug`, `:warn` in production           | lowest level written, from `:fatal` down to `:devel`
`stream`           | `:stdout`, `:to_file` in production, `:null` in test | `:to_file`, `:stdout`, `:stderr`, `:null` (discard) or any IO object
`log_path`         | `log/<environment>.log`                   | file or folder for `:to_file`, relative to the project root; a folder gets `<environment>.log`
`format_datetime`  | `'%d/%b/%Y %H:%M:%S'`, none in development | `strftime` format of the timestamp
`format_message`   | `'%s - %s %s'`                            | format of the level, timestamp and message
`log_static`       | `false`                                   | also log requests for static files
`colorize_logging` | `true`                                    | add ANSI colors; set it to `false` for plain log files
`auto_flush`       | `true`                                    | write each message at once; when `false`, call `logger.flush`
`source_location`  | `false`                                   | prefix each message with the file and line that logged it

The `PADRINO_LOG_LEVEL` environment variable makes Padrino use the settings of
another environment, for example `PADRINO_LOG_LEVEL=test` to silence the log.
Despite its name, it takes an environment name, not a level; an unknown name
falls back to the production settings.

You can also replace the logger, for example with one from Ruby's standard
library. The settings above then no longer apply:

```ruby
# config/boot.rb
require 'logger'
Padrino.logger = Logger.new($stdout)
Padrino.load!
```

For more information about the logger, check out our
[Logger RDoc](http://www.rubydoc.info/github/padrino/padrino-framework/Padrino/Logger
"Logger RDoc").

--------------------------------------------------------------------------------

## Development Reloader

Padrino applications also have the enabled ability to automatically reload all
changing application files without the need to restart the server. Through the
use of a customized Rack middleware, all files on the 'load path' are monitored
and reloaded whenever changes are applied.

This makes rapid development much easier and provides a better alternative to
'shotgun' or 'rerun' which require the application server to be restarted which
makes requests take much longer to complete.

An application can explicitly enable / disable reloading through the use of
options:

```ruby
# app.rb
class SimpleApp < Padrino::Application
  disable :reload # reload is disabled in all environments
  enable  :reload # enabled in all environments
end
```

Files are only tracked for reloading in development. To reload in another
environment, also set `Padrino::Reloader.enabled = true` in `config/boot.rb`
before `Padrino.load!`.

--------------------------------------------------------------------------------

## Gemfile Dependency Resolution

Padrino has native support for `bundler` and the Gemfile system. If your Padrino
application was generated with `padrino g`, a Gemfile has already been created
for your application. This file will contain a list of all the dependencies for
our application.

```ruby
# Gemfile
source 'https://rubygems.org'
gem 'rake'
gem 'padrino', '0.16.1'
```

This manifest file uses the standard `bundler` gem syntax of which details can
be found in the [Bundler Website](http://bundler.io/ "Bundle Website").

This gem allows us to place all our dependencies into a single file. Padrino
will then automatically require all necessary files (if they exist on the
system).

If the dependencies are not on the system, run `bundle install` within the
application root. To keep the gems inside the project, run
`bundle config set --local path vendor/bundle` first. Note that this is all
possible without any further effort than adding the Gemfile (or having this
generated automatically with generators explained later).

--------------------------------------------------------------------------------

## Auto Load Paths

Padrino also intelligently supports requiring useful files within your
application automatically and provides functionality for easily splitting up
your application into separate files. Padrino automatically requires
`config/database.rb` as a convention for establishing database connection. Also,
any files within the `lib` folder will be required automatically by Padrino.

This is powered by the fact that Padrino will automatically load (and reload)
any directory patterns within the 'prerequisite paths'. Additional directory
patterns can be added by appending to `Padrino.dependency_paths` before
`Padrino.load!`:

```ruby
# config/boot.rb
Padrino.dependency_paths << Padrino.root('custom_folder/*.rb')
Padrino.load!
```

This will instruct Padrino to load these files in every environment (and reload
them in development when changes are detected). By default, the load path
contains certain paths known to contain important files such as controllers,
mailers, models, urls, and helpers.

--------------------------------------------------------------------------------

## Terminal Commands

Padrino also comes equipped with multiple useful terminal commands which can be
activated to perform common tasks such as starting / stopping the application,
executing the unit tests or activating an irb session.

The following commands are available:

```shell
# starts the app server (non-daemonized)
$ padrino start
# starts the app server (daemonized) with given port, environment and adapter
$ padrino start -d -p 3000 -e development -a thin

# Stops a daemonized app server
$ padrino stop

# Bootup the Padrino console (irb)
$ padrino console

# Run/List tasks
$ padrino rake -T

# Run piece of code in the context of Padrino (with given environment)
$ padrino runner 'puts Padrino.env' -e development

# Run Ruby file in the context of Padrino
$ padrino r script/my_script.rb
```

The last command "padrino rake" look for rake files in:

- `lib/tasks/**/*.rake`
- `tasks/**/*.rake`
- `test/test.rake`
- `spec/spec.rake`

In this way you can customize project tasks.

Using these commands can simplify common tasks making development that much
smoother.

--------------------------------------------------------------------------------

## Special Folders

Padrino load these paths:

```shell
# special folders
project/lib
project/models
project/shared/lib
project/shared/models
project/each_app/models
```

This mean that you are free to store for example `models` where you prefer, if
you have two or more apps with same models you can use `project/shared/models`
or `root/models`.

If you have only one app you still use `project/app/models`(this is the default
`padrino g` choice)
