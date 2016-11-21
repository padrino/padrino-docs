---
chapter: Generators
title: Admin
---

# Admin

Padrino also comes with a built-in admin dashboard. To generate the admin
application in your project:

Options         | Default   | Aliases | Description
--------------- | --------- | ------- | ----------------------------------------------------
admin_name      | admin     | -a      | allows you to specify the admin app’s name
admin_model     | "Account" | -m      | specify the name of model for access controlling
root            | .         | -r      | specify the root destination path
skip\_migration | false     | -s      | skip migration generation
renderer        |           | -e      | the default value is a renderer used in the main app
destroy         | false     | -d      | removes all generated files

```shell
$ padrino g admin
```

This will generate the admin application and mount it at `/admin`. For more
information, check out the [Admin Guide](/guides/features/padrino-admin "Admin Guide").
