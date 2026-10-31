---
chapter: Generators
title: Models
---

# Models

Padrino provides generator support for quickly creating new models within your
Padrino application. Note that the models (and migrations) generated are
specifically tailored towards the ORM component and testing framework chosen
during application generation.

Options         | Default | Aliases | Description
--------------- | ------- | ------- | ----------------------------------------
root            | .       | -r      | specify the root destination path
app             | .       | -a      | specify the application destination path
skip\_migration | false   | -s      | skip migration generation
destroy         | false   | -d      | removes all generated files
force           | false   | -f      | generate the model even if a model with that name already exists

Run model generators from the root of a Padrino project, the folder that
contains `config/boot.rb`. They read project settings, such as the ORM and test
framework, from the `.components` file that the project generator creates, so
they will not work in a project without it.

Using the model generator is as simple as:

```shell
$ padrino g model User
```

You can also specify desired fields to be contained within your `User` model:

```shell
$ padrino g model User name:string age:integer email:string
```

A field can take modifiers after its type, in any order:

- `index` adds an index on the column, and `uniq` adds a unique index. Given
  both, the column gets one unique index.
- A `references` (or `belongs_to`) field adds a `<name>_id` column. With
  `polymorphic` it also adds a `<name>_type` column, so the field can point at
  more than one model.

```shell
$ padrino g model Post title:string slug:string:uniq user:references:index
$ padrino g model Comment body:text commentable:references:polymorphic:index
```

With ActiveRecord and Sequel the modifiers go in the migration. Sequel makes a
`references` field a foreign key to the pluralized table, with an index; a
polymorphic one gets an index on both columns and no foreign key. With Mongoid,
which has no migrations, a `references` field becomes a `belongs_to`
association in the model, and `index` and `uniq` are ignored. Other modifiers
are ignored.

The model generator will create multiple files within your application and based
on your ORM component. Usually the model file will generate files similar to the
following:

- Model definition file (`models/user.rb`)
- Migration declaration (`db/migrate/xxx_create_users.rb`)
- Model unit test file (`test/models/user_test.rb`)

You can define as many models as you would like in a Padrino application using
this generator.

You can destroy models that you created via the destroy option and setting it to
true. Default is false.

```shell
$ padrino g model User -d
```

This remove all created model files.
