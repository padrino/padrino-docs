---
chapter: Generators
title: Sub-Applications
---

# Sub-Applications

Unlike other Ruby frameworks, Padrino is principally designed for mounting
multiple apps at the same time.

>
  Options|Default|Aliases|Description
  :------|:------|:------|:----------
  tiny|false|-i|generate tiny app skeleton
  root|.|-r|specify the root destination path
  destroy|false|-d|removes all generated files
{: .excerpt--small }

First you need to create a project:

```shell
$ padrino g project demo_project
$ cd demo_project
```

Now you are in `demo_project` and you can create your apps:

```shell
$ padrino g app one
$ padrino g app two
```

By default these apps are mounted under:

- `/one`
- `/two`

but you can edit `config/apps.rb` and change it.

And create controllers:

```shell
$ padrino g controller base --app foo # This will be created for app Foo
$ padrino g controller base           # This will be created for Core app
$ padrino g controller base --app bar # This will be created for app Bar
```

Or mailers:

```shell
$ padrino g mailer registration --app foo  # This will be created for app Foo
$ padrino g mailer registration            # This will be created for Core app
$ padrino g mailer registration --app bar  # This will be created for app Bar
```
