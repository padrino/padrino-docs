---
chapter: Generators
title: Projects
---

# Projects

The usage for the project generator is quite simple:

```shell
$ padrino g project <app_name> </path/to/create/app> --<component-name> <value>
```

The simplest possible command to generate a base application would be:

```shell
$ padrino g project demo_project
```

This would construct a Padrino application DemoApp (which extends from
`Padrino::Application`) inside the folder `demo_project` at our current path.
Inside the application there would be configuration and setup performed for the
default components.

You can also define specific components to be used:

```shell
$ padrino g project demo_project -t rspec -e haml -m rr -s jquery -d datamapper -c sass
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
$ padrino g project demo_project --run_bundler # alias -b
```

This can also be done manually through executing command `bundle install` in the
terminal at the root of the generated application.

For more examples of using the project generator in common cases, check out the
[Basic Projects](/guides/getting-started/basic-projects "Basic Projects") guide.

The generator framework within Padrino is extensible and additional components
and tools can be added easily. This would be achieved through forking our
project and reading through the code in `lib/generators/project.rb` and the
setup instructions inside the relevant files within
`lib/generators/components/`. We are happy to accept pull requests for
additional component types not originally included (although helping us maintain
them would also be appreciated).

## Options

The project generator has several available configuration options:

Options | Default | Aliases | Description
------- | ------- | ------- | ------------------------------------------------
bundle  | false   | -b      | execute bundler dependencies installation
root    | .       | -r      | the root destination path for the project
dev     | false   | none    | use edge version from local git checkout
app     | nil     | -n      | specify app name different from the project name
tiny    | false   | -i      | generate tiny project skeleton
adapter | sqlite  | -a      | specify orm db adapter (mysql, sqlite, postgres)

The available components and their default options are listed below:

Component  | Default | Aliases | Options
---------- | ------- | ------- | ---------------------------------------------------------------------------------------
orm        | none    | -d      | mongoid, activerecord, datamapper, couchrest, mongomatic, ohm, ripple, sequel, dynamoid
test       | none    | -t      | bacon, shoulda, cucumber, testunit, riot, rspec, minitest, steak
script     | none    | -s      | prototype, rightjs, jquery, mootools, extcore, dojo
renderer   | haml    | -e      | erb, haml, slim, liquid
stylesheet | none    | -c      | sass, less, scss, compass
mock       | none    | -m      | rr, mocha

Note: Be careful with your naming when using generators and do not have your
project name, or any models or controllers overlap. Avoid naming your app
"Posts" and then your controller or subapp with the same name.

## Examples

**Generate a project with a different application name from the project path**

```shell
$ padrino g my_project -n blog
```

This will generate the project at path `my_project/` but the applications name
will be **Blog**.

**Generate a project with mongoid and run bundler after**

```shell
$ padrino g project your_project -d mongoid -b
```

**Generate a project with riot test and rr mocking**

```shell
$ padrino g project your_project -t riot -m rr
```

**Generate a project with sequel with mysql**

```shell
$ padrino g project your_project -d sequel -a mysql
```

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
