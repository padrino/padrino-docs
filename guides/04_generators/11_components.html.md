---
chapter: Generators
title: Components
---

# Components

The available components and their default options are same as the Project
Generator.

Options | Default | Aliases | Description
------- | ------- | ------- | ------------------------------------------------------------------
app     |         | -n      | the application name
root    | .       | -r      | the root destination path for the project
adapter | sqlite  | -a      | specify orm db adapter (sqlite, mysql, mysql2, mysql-gem, postgres)

## Examples

Show help and selected components:

```shell
$ padrino g component
```

Add to `activerecord` with `mysql` and `rspec` in your project:

```shell
$ padrino g component -d activerecord -a mysql2 -t rspec
```

## The .components File

The project generator records your choices in a `.components` file, in YAML,
at the root of the project. `padrino g project demo -d sequel -e erb -t minitest`
writes:

```yaml
---
:orm: sequel
:test: minitest
:mock: none
:script: none
:renderer: erb
:stylesheet: none
:namespace: Demo
:migration_format: number
:adapter: sqlite
```

Next to the component choices it keeps the project's namespace, the migration
file format (`number` or `timestamp`) and, for an SQL ORM, the database adapter.

The other generators read this file instead of asking again: `padrino g model`
and `padrino g migration` write code for the stored ORM, the model and
controller generators add tests for the stored test framework, and the
generators that create classes put them in the stored namespace.

`padrino g component` with no options lists the current choices:

```shell
$ padrino g component
...
Current Selected Components:
  orm         sequel
  test        minitest
  mock        none
  script      none
  renderer    erb
  stylesheet  none
```

With options, it sets up each component you name and then stores the new choice
in `.components`. If the project already has another choice for that component,
it asks first, and answering `no` leaves that component as it was:

```shell
$ padrino g component -e haml
Switch renderer to 'haml' from 'erb' ?[yes/no]:
```

Switching adds the new component's gems and setup files, and asks before
overwriting a file such as `config/database.rb`. It doesn't remove the old
component's gems or convert what was already generated: after switching from
Sequel to Active Record, existing models are still Sequel models.

Since the generators trust `.components`, editing it by hand changes what they
generate next. For example, after changing `:test: minitest` to `:test: rspec`,
`padrino g model book` writes `spec/models/book_spec.rb` instead of
`test/models/book_test.rb`, but nothing adds RSpec to the Gemfile or sets up
`spec/`. To change a component, run `padrino g component` rather than editing
the file.
