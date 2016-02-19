---
chapter: Generators
title: Mailers
---

# Mailers

Padrino provides generator support for quickly creating new mailers within your
Padrino application.

>
  Options|Default|Aliases|Description
  :------|:------|:------|:----------
  app|nil|-n|specify the application
  root|.|-r|specify the root destination path
  namespace||-n|specify the name space of your padrino project
  destroy|false|-d|removes all generated files
{: .excerpt--small }

Very important to note that mailer generators are intended primarily to work
within applications created through the Padrino application generator and that
follow Padrino conventions.

Using the mailer generator is as simple as:

```shell
$ padrino g mailer UserNotifier
```

If you want create a mailer for a specified sub app you can:

```shell
$ padrino g mailer UserNotifier -a my_sub_app
```

You can also specify desired delivery actions to be added to the mailer:

```shell
$ padrino g mailer UserNotifier confirm_account welcome inactive_account
```

The mailer generator will then construct the mailer file within
`app/mailers/user_notifier.rb`

You can destroy mailer that you created via the destroy option and setting it to
true. Default is false.

```shell
$ padrino g mailer UserNotifer -d
```

This remove all created mailer files.
