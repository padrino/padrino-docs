---
chapter: Generators
title: Controllers
---

# Controllers

Padrino provides generator support for quickly creating new controllers within
your Padrino application. Note that the controller tests are generated
specifically tailored towards the testing framework chosen during application
generation.

Options   | Default | Aliases | Description
--------- | ------- | ------- | ----------------------------------------------
app       | /app    | -a      | specify the application
root      | .       | -r      | specify the root destination
namespace |         | -n      | specify the name space of your padrino project
layout    |         | -l      | specify the layout
parent    |         | -p      | specify the parent
provides  |         | -f      | specify the formats for this controller
destroy   | false   | -d      | removes all generated files

Very important to note that controller generators are intended primarily to work
within applications created through the Padrino application generator and that
follow Padrino conventions.

Using the controller generator is as simple as:

```shell
$ padrino g controller Admin
```

If you want create a controller for a specified sub app you can:

```shell
$ padrino g controller Admin -a my_sub_app
```

You can also specify desired actions to be added to your controller:

```shell
$ padrino g controller Admin get:index get:new post:create
```

The controller generator will then construct the controller file within
`app/controllers/admin.rb` and also a controller test file at
`test/controllers/admin_controller_test.rb` according to the test framework
chosen during app generation. A default route will also be generated mapping to
name of the controller and the route name. For example:

```shell
$ padrino g controller User get:index
```

will create a url route for `:index` mapping to `/user/index`.

You may also specify layout, parent and provides respectively:

```shell
$ padrino g controller User -l global
$ padrino g controller User -p users
$ padrino g controller User -f :html,:json
```

You can destroy controllers that you created via the destroy option and setting
it to true. Default is false.

```shell
$ padrino g controller User -d
```

This removes all created controller files.
