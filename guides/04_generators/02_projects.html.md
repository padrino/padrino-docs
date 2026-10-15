---
chapter: Generators
title: Projects
---

# Projects

The usage for the project generator is quite simple:

```shell
$ padrino g project <app_name> --root </path/to/create/app> --<component-name> <value>
```

The simplest possible command to generate a base application would be:

```shell
$ padrino g project demo_project
```

This would construct a Padrino application DemoProject (which extends from
`Padrino::Application`) inside the folder `demo_project` at our current path.
Inside the application there would be configuration and setup performed for the
default components.

You can also define specific components to be used:

```shell
$ padrino g project demo_project -t rspec -e haml -m rr -s jquery -d sequel -c sass
```

You can also instruct the generator to skip a certain component to avoid using
one at all (or to use your own):

```shell
$ padrino g project demo_project --test none --renderer none
```

You can also specify an alternate name for your core application using the
`--app` option:

```shell
$ padrino g project demo_project --app alternate_app_name # alias -n
```

The generator uses the `bundler` gem to resolve any application dependencies
when the application is newly created. The necessary bundler command can be
executed automatically through the generator with:

```shell
$ padrino g project demo_project --bundle # alias -b
```

This can also be done manually by running `bundle install && bundle binstubs --all`
in the terminal at the root of the generated application.

For more examples of using the project generator in common cases, check out the
[Basic Projects](/guides/getting-started/basic-projects "Basic Projects") guide.

The generator framework within Padrino is extensible and additional components
and tools can be added easily. This would be achieved through forking our
project and reading through the code in `padrino-gen/lib/padrino-gen/generators/project.rb` and the
setup instructions inside the relevant files within
`padrino-gen/lib/padrino-gen/generators/components/`. We are happy to accept pull requests for
additional component types not originally included (although helping us maintain
them would also be appreciated).

## Options

The project generator has several available configuration options:

Option           | Default | Aliases | Description
---------------- | ------- | ------- | ------------------------------------------------
bundle           | false   | -b      | execute bundler dependencies installation
root             | .       | -r      | the root destination path for the project
dev              | false   | none    | use edge version from local git checkout
app              | nil     | -n      | specify app name different from the project name
tiny             | false   | -i      | generate tiny project skeleton
lean             | false   | -l      | generate a lean project without apps
api              | false   | none    | generate a minimal project for APIs
template         | nil     | -p      | generate the project from a template
gem              | false   | -g      | generate the project as a gem
adapter          | sqlite  | -a      | specify orm db adapter (sqlite, mysql, mysql2, mysql-gem, postgres)
migration\_format | number  | none    | format for migrations (number, timestamp)

The available components and their default options are listed below:

Component  | Default | Aliases | Options
---------- | ------- | ------- | ---------------------------------------------------------------------------------------
server     | webrick | none    | thin, **puma** (recommended), falcon (fiber-based, Ruby 3.0+), spider-gazelle (unmaintained), mongrel (unmaintained), trinidad, webrick
orm        | none    | -d      | mongoid, activerecord, minirecord, ohm, sequel, dynamoid
test       | none    | -t      | bacon, shoulda, cucumber, testunit, rspec, minitest
script     | none    | -s      | prototype, jquery, mootools, dojo, vite
renderer   | none    | -e      | erb, haml, slim, liquid
stylesheet | none    | -c      | sass, less, scss, tailwind
mock       | none    | -m      | rr, mocha

Note: Be careful with your naming when using generators and do not have your
project name, or any models or controllers overlap. Avoid naming your app
"Posts" and then your controller or subapp with the same name.

## Examples

**Generate a project with a different application name from the project path**

```shell
$ padrino g project my_project -n blog
```

This will generate the project at path `my_project/` but the applications name
will be **Blog**.

**Generate a project with mongoid and run bundler after**

```shell
$ padrino g project your_project -d mongoid -b
```

**Generate a project with shoulda test and rr mocking**

```shell
$ padrino g project your_project -t shoulda -m rr
```

**Generate a project with sequel with mysql**

```shell
$ padrino g project your_project -d sequel -a mysql
```

**Generate a project with Vite and Tailwind CSS**

```shell
$ padrino g project your_project -s vite -c tailwind -e haml
```

Both components also work on an existing project, e.g.
`padrino g component -s vite` or `padrino g component -c tailwind`. See
[Vite](#vite) and [Tailwind CSS](#tailwind-css) below for what they set up.

**Generate a tiny project skeleton**

```shell
$ padrino g project your_project --tiny
```

**Choose a root for your project**

```shell
$ padrino g project your_project -r /usr/local/padrino
```

This will create a new padrino project in `/usr/local/padrino/your_project/`

**Use Padrino from a git cloned repository**

```shell
padrino g project your_project [--dev] # Use padrino from a git checkout
```

Visit [The Bleeding Edge](/guides/introduction/the-bleeding-edge "The Bleeding Edge") for
more info how to setup a **dev** environment.

## Vite

`-s vite` sets up [Vite](https://vite.dev) through
[vite_padrino](https://github.com/ElMassimo/vite_ruby/tree/main/vite_padrino). It adds the
`vite_padrino` gem and `register VitePadrino`, `config/vite.json`,
`vite.config.ts`, a `package.json` and an entrypoint at
`app/frontend/entrypoints/application.js`. It also adds the Vite rake tasks
and a `vite: bundle exec vite dev` process in `Procfile.dev`.

Vite needs [Node.js](https://nodejs.org). The generator doesn't run npm: run
`npm install` (if the project already had a `package.json`, which is left as
is, run the `npm install -D ...` command the generator prints instead), then
add the tags to the `<head>` of your layout. The generator prints them in your
renderer's syntax:

```haml
= vite_client_tag
= vite_javascript_tag 'application'
```

In development, `autoBuild` builds the assets on demand, or run
`bundle exec vite dev` (or `Procfile.dev` with a process manager such as
foreman) for hot reloading. `rake assets:precompile` builds them for
production; it runs `npm ci` first, so commit your `package-lock.json`.

`vite_padrino` 3.0.0 needs ActiveSupport's `Object#try`, so the generator
requires `active_support/core_ext/object/try` in `config/boot.rb` and adds
`activesupport` to the Gemfile if it isn't there yet. Once
[vite_ruby#635](https://github.com/ElMassimo/vite_ruby/pull/635) is released
the require can go, and so can `activesupport` if nothing else needs it.

## Tailwind CSS

`-c tailwind` sets up [Tailwind CSS](https://tailwindcss.com) v4 with the
[tailwindcss-ruby](https://github.com/flavorjones/tailwindcss-ruby) gem, which
ships the standalone Tailwind binary, so Node isn't needed. It needs Ruby 3.0
or later.

The source is `app/stylesheets/application.css`, which starts with
`@import "tailwindcss";`. It builds to `public/stylesheets/application.css`,
which is gitignored. Link it in your layout:

```haml
= stylesheet_link_tag 'application'
```

- `rake tailwind:build` builds the stylesheet once, minified.
- `rake tailwind:watch` rebuilds it on every change. `Procfile.dev` gets a
  `css: bundle exec rake tailwind:watch` process for it.
- `rake assets:precompile` runs `tailwind:build`, so deploys that precompile
  assets build the CSS too.

When you add Tailwind to an existing project, a hand-written
`public/stylesheets/application.css` is moved into the new source, with its
`@charset` and `@import` lines kept at the top. If you switch from sass, scss
or less, remove that engine's gems from the Gemfile, its
`register ...Initializer` line from `app/app.rb` and
`config/initializers/<engine>.rb`.

The binary comes in platform-specific gems. If you develop on macOS and deploy
to Linux, add the platform to your lockfile:

```shell
$ bundle lock --add-platform x86_64-linux
```

On platforms without a prebuilt binary, such as JRuby, download the
standalone Tailwind executable for your OS, save it as `tailwindcss` (and make
it executable), and point `TAILWINDCSS_INSTALL_DIR` at that directory.
