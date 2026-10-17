---
chapter: Generators
title: Migrations
---

# Migrations

Padrino provides generator for quickly generating new migrations to change or
manipulate the database schema. These migrations generated will be tailored
towards the ORM chosen when generating the application.

Options | Default | Aliases | Description
------- | ------- | ------- | ---------------------------------
root    | .       | -r      | specify the root destination path
destroy | false   | -d      | removes all generated files

Run migration generators from the root of a Padrino project, the folder that
contains `config/boot.rb`. They read project settings, such as the ORM, from the
`.components` file that the project generator creates, so they will not work in
a project without it.

Using the migration generator is as simple as:

```shell
$ padrino g migration AddFieldsToUsers
$ padrino g migration RemoveFieldsFromUsers
```

You can also specify desired columns to be added to the migration file:

```shell
$ padrino g migration AddFieldsToUsers last_login:datetime crypted_password:string
$ padrino g migration RemoveFieldsFromUsers password:string ip_address:string
```

The migration generator will then construct the migration file according to your
ORM component chosen within `db/migrate/xxx_add_fields_to_users.rb` including
the columns specified in the command.

With ActiveRecord and Sequel, a column takes the same modifiers as in the
[model generator](/guides/generators/models/), in any order: `index` or `uniq`
adds an index or a unique index, `references` (or `belongs_to`) adds a
`<name>_id` column, and `polymorphic` adds a `<name>_type` column next to it.
Rolling the migration back removes the columns and their indexes:

```shell
$ padrino g migration AddFieldsToPosts slug:string:uniq author:references:index
$ padrino g migration AddOwnerToProfiles owner:belongs_to:polymorphic:uniq
```

You can destroy migrations that you created via the destroy option and setting
it to true. Default is false.

```shell
$ padrino g migration AddFieldsToUsers -d
```
