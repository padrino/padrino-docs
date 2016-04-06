---
chapter: Features
title: Padrino Admin
---

# Padrino Admin

Padrino comes shipped with a slick and beautiful Admin Interface, with the
following features:

Feature               | Description
--------------------- | ------------------------------------------------------------------------------
**Orm Agnostic**      | Adapters for datamapper, sequel, activerecord, mongomapper, mongoid, couchrest
**Authentication**    | User Authentication Support, User Authorization Management
**Template Agnostic** | Erb and Haml Rendering Support
**Scaffold**          | You can create a new "admin interface" by providing a single Model
**MultiLanguage**     | English, German, Russian, Danish, French, Brazilian and Italian localizations

--------------------------------------------------------------------------------

## Admin Usage

Create a new project:

```shell
$ padrino g project admin-test-sample -d datamapper
$ cd admin-test-sample && bundle
```

Create the admin application:

```shell
$ padrino g admin -e erb
```

Follow the instructions in your terminal and provide a valid email and
password for your newly created admin account:

- edit your config/database.rb
- create the database: `$ bundle exec rake db:create`
- migrate your database: `$ bundle exec rake db:migrate`
- seed your database with some data: `$ bundle exec rake db:seed`

Your admin section is now "setup": you can start padrino `padrino s` and
point your web browser to <http://localhost:3000/admin> and log in with your
admin account credentials.


<img src="https://farm2.staticflickr.com/1720/26277208545_496eb24ac8_z_d.jpg">


If you need to create a "scaffold", (basic CRUD actions) create a
_model_, migrate your database, generate your scaffolding folder structure and
views and add those to your admin section by running the following commands:

```shell
$ padrino g model post title:string body:text
$ padrino rake db:migrate
$ padrino g admin_page post
$ padrino s
```

That's it! Browse to <http://localhost:3000/admin> and access your model by
clicking on the newly created tab on your admin navbar: there you can create,
edit, destroy and display your objects.

You can find the sample app on [github](https://github.com/padrino/admin-test-sample "github").

--------------------------------------------------------------------------------

## Admin Authentication

Padrino Admin uses a single model Account for managing roles, memberships and
permissions (User Authentication and Authorization).

--------------------------------------------------------------------------------

## Scenario E-commerce (User Authentication)

To use a practical example, let's examine a common e-commerce application
scenario, where we need to limit access to some of our controllers actions;
we can easily accomplish this by editing `app.rb` accordingly:

```ruby
class MyEcommerce < Padrino::Application
  register Padrino::Admin::AccessControl

  enable :authentication
  enable :store_location
  set    :login_page, "/login"

  access_control.roles_for :any do |role|
    role.protect "/customer/orders"
    role.protect "/cart/checkout"
  end
end
```

In the above example we protect paths starting with `/customer/orders`
and `/cart/checkout`. The result will be that an unauthenticated user will
not be able to access those actions, and they will be asked to authenticate;
first by visiting our `:login_page` defined as `/login` and by providing their
login credentials (default authentication behaviour will use email and password).

When successfully logged in, they will be granted access to the two protected pages.

<img src="https://farm2.staticflickr.com/1714/25674474983_26e311f126_z_d.jpg">

--------------------------------------------------------------------------------

## Admin Scenario (User Authorization)
Another common scenario is needing multiple roles with various level of access,
instead of providing all management functionality to all logged in users.

Consider a site where you want to allow unauthenticated users to login, an
**editor** to manage posts and categories, and an **admin** role to manage settings.

The Padrino admin generator will by default create an `Account` model with a
`role` attribute which you can combine with the `project_module` method to
easily manage which functionality is available to your users.

```ruby
class Admin < Padrino::Application
  register Padrino::Admin::AccessControl

  enable :authentication
  disable :store_location
  set :login_page, "/admin/sessions/new"

  access_control.roles_for :any do |role|
    role.protect "/"
    role.allow "/sessions"
  end

    access_control.roles_for :admin do |role|
    role.project_module :settings, "/settings"
  end

  access_control.roles_for :editor do |role|
    role.project_module :posts, "/posts"
    role.project_module :categories, "/categories"
  end
end
```

In the above example, we _protect_ the entire admin section (all paths starting
with "/") with the only exception for all those paths starting with `/sessions`
giving our `unauthenticated` users the possibility to log in by redirecting them
to our login page and asking them to provide their email and password.

If we are logged in as an **admin** (`account.role == 'admin'`) we will **only**
have access to the `/settings` path.

If we are logged in as an **editor** (`account.role == 'editor'`) we will **only**
have access to the `/posts` and `/categories` paths.

--------------------------------------------------------------------------------

## Sharing Sessions Between Mounted Applications

Sessions can be shared between mounted applications by setting a `:session_id`
with the line `set :session_id, "your_session_id"` in each apps `app.rb`.

--------------------------------------------------------------------------------

## Contributing Persistence Adapters

If you are planning to use padrino with other adapters rather than the currently
supported ones, and you want to contribute to the project by extending its
support with additional adapters like [ohm](https://github.com/soveran/ohm
"ohm"), [cassandra](https://github.com/cassandra-rb/cassandra "cassandra") and
so on, be sure to check out the
[adding components](/guides/adding-components/overview "adding components")
guide.
