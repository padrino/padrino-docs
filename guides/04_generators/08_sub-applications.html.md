---
chapter: Generators
title: Sub-Applications
---

# Sub-Applications

Unlike other Ruby frameworks, Padrino is principally designed for mounting
multiple apps at the same time.

Options   | Default | Aliases | Description
--------- | ------- | ------- | ----------------------------------------------
root      | .       | -r      | specify the root destination path
destroy   | false   | -d      | removes all generated files
tiny      | false   | -i      | generate tiny app skeleton
namespace |         | -n      | specify the name space of your padrino project
force     | false   | -f      | generate app files if the app already exists

First you need to create a project:

```shell
$ padrino g project demo_project
$ cd demo_project
$ bundle install && bundle binstubs --all
```

Now you are in `demo_project` and you can create your apps:

```shell
$ padrino g app one
$ padrino g app two
```

By default these apps are mounted under:

- `/one`
- `/two`

feel free to change the routing in `config/apps.rb`.

You can create controllers:

```shell
$ padrino g controller base --app one # create controller for app one
$ padrino g controller base           # create controller for main app
$ padrino g controller base --app two # create controller for app two
```

Or mailers:

```shell
$ padrino g mailer registration --app one # create mailer for app one
$ padrino g mailer registration           # create mailer for main app
$ padrino g mailer registration --app two # create mailer for app two
```
