---
chapter: Generators
title: Admin
---

# Admin

Padrino also comes with a built-in admin dashboard. To generate the admin
application in your project:

>
  Options|Default|Aliases|Description
  :------|:------|:------|:----------
  admin_name|admin|-a|allows you to specify the admin app’s name
  admin_model|"Account"|-m|specify the name of model for access controlling
  root|.|-r|specify the root destination path
  theme|default|none|generate admin app with theme
  skip\_migration|false|-s|skip migration generation
  renderer||-e|the default value is a renderer used in the main app
  destroy|false|-d|removes all generated files
{: .excerpt--small }

```shell
$ padrino g admin
```

You can specify the theme to use for your admin application using the `theme`
flag:

```shell
$ padrino g admin --theme blue
```

The available themes are: `amro`, `bec`, `bec-green`, `blue`, `default`,
`djime-cerulean`, `kathleene`, `olive`, `orange`, `reidb-greenish`, `ruby`,
`warehouse`.

This will generate the admin application and mount this at `/admin`. For more
information, check out the
[Admin Guide](/guides/padrino-admin "Admin Guide").
