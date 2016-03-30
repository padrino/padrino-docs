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
$ padrino g project fun-test -d datamapper
$ cd fun-test
```

Create the admin application:

```shell
$ padrino g admin
```

Follow the instructions in your terminal and provide a valid email and
password for your newly created admin account:

- edit your config/database.rb
- migrate your database: `$ padrino rake ar:migrate` or `$ padrino rake
  dm:migrate`
- seed your database with data # padrino rake seed

Your admin section is now "setup": you can start padrino `padrino start` and
point your web browser to <http://localhost:3000/admin> and log in with your
admin account credentials.

If you need to create some sort of "scaffold" (basic CRUD actions) create a
_model_, migrate your database, generate your scaffolding folder structure and
views and add those to your admin section by running this series of commands:

```shell
$ padrino g model post title:string body:text
$ padrino rake dm:migrate # or ar:migrate
$ padrino g admin_page post
$ padrino start
```

That's it! Browse to <http://localhost:3000/admin> and access your model by
clicking on the newly created tab on your admin navbar: there you can create,
edit, destroy and display your objects.

--------------------------------------------------------------------------------

## Admin Authentication

Padrino Admin uses a single model Account for managing roles, memberships and
permissions (User Authentication and Authorization).

--------------------------------------------------------------------------------

## Scenario E-commerce (User Authentication)

For a practical example, let's examine a common e-commerce application
scenario, where we need to prevent user access to some controller actions. 
We can easily accomplish this by editing `app.rb` accordingly:

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

In the above example we are protecting those paths starting with
`/customer/orders` and `/cart/checkout`. The result will be that an
unauthenticated user will not be able to access those actions, and he will be
asked to authenticate first by visiting our `:login_page` defined as `/login`
and by providing his login credentials (default authentication behaviour is
email and password).

When successfully logged in, he will be granted access to those two pages.

--------------------------------------------------------------------------------

## Admin Scenario (User Authorization)

For Another example, let's suppose that you need your **admin** account to do
certain things and have access to certain controller actions, and your
**editor** account needs to be prevented from accessing those same admin
actions.

The padrino admin generator can create a new `Account` model with a
default `role` attribute.

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
with "/") with the only exception being those paths starting with `/sessions`.
This gives  our `unauthenticated` users the possibility to log in by redirecting them
to our login page and asking them to provide their email and password.

If we are logged in as an **admin** (`account.role == 'admin'`) we can **only** 
access the `/settings` path.

If we are logged in as an **editor** (`account.role == 'editor'`) we can **only**
access the `/posts` and `/categories` paths instead.

--------------------------------------------------------------------------------

## Sharing Sessions Between Mounted Applications

Sessions can be shared between mounted applications by setting a `:session_id`
with the line `set :session_id, "your_session_id"` in each app's `app.rb`.

--------------------------------------------------------------------------------

## Contributing Persistence Adapters

If you are planning to use padrino with other adapters rather than the currently
supported ones, and you want to contribute to the project by extending its
support with additional adapters like [ohm](https://github.com/soveran/ohm
"ohm"), [cassandra](https://github.com/cassandra-rb/cassandra "cassandra"), 
be sure to check out the [adding components](/guides/adding-components/overview "adding components")
guide.
