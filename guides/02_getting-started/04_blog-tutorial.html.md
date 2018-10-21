---
chapter: Getting Started
title: Blog Tutorial
---

# Blog Tutorial

When reading about a new framework, I often find that the best way to get
familiar is to read a brief tutorial on how to develop a simple application.
This can quickly give new users a sense of the development flow and processes
involved in using a framework. This guide will show new users how to develop a
simple blog using the Padrino framework. Along the way, each step will be
explained and links will be provided to further information on different
relevant topics.

--------------------------------------------------------------------------------
## Screencast

There is also a screencast available for this tutorial. You can check it out by:
<div class="flex-video widescreen" style="margin: 0 auto;text-align:center;">
<iframe src="//player.vimeo.com/video/296146309" width="500" height="313" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="https://vimeo.com/296146309">Blog Tutorial</a> from <a href="https://vimeo.com/padrinocasts">PadrinoCasts</a> on <a href="https://vimeo.com">Vimeo</a>.</p>
</div>

Please note that previous screencast, written for Padrino 0.12.2, is available under <http://vimeo.com/10522357>.

--------------------------------------------------------------------------------

## Study Guide

To skip this tutorial or immediately see the complete blog tutorial project, you
can checkout the
[blog tutorial repository](https://github.com/padrino/blog-tutorial "blog tutorial
repository") using git:


```shell
$ git clone git@github.com:padrino/blog-tutorial.git
```


<!--
or even execute the
[blog tutorial project template](https://github.com/padrino/padrino-recipes/blob/master/templates/sampleblog_template.rb "blog tutorial
project template") which will automatically build the blog project step by step
using our excellent template runner. You can do this simply by invoking:


```shell
$ padrino g project blog-tutorial --template blogtutorial
```


To learn more about our template generator, be sure to check out the
[generators guide](/guides/generators/overview "generators guide").
-->

--------------------------------------------------------------------------------

## Installation

In order to develop a Padrino application, we have to do a few things.
First, we must obviously have [ruby](http://www.ruby-lang.org/en/ "ruby") (at least version 2.2.2 or laster) and
[rubygems](https://rubygems.org/ "rubygems") installed. Next, we must install
the padrino framework gems:


```shell
$ gem install padrino
```


For more details on installation, check out the
[installation guide](/guides/getting-started/installation "installation guide"). Now we can begin
developing our sample blog.

--------------------------------------------------------------------------------

## Project Generation

To create a Padrino application, the best place to start is using the convenient
Padrino generator. Similar to Rails, Padrino has a project generator which will
create a skeleton application with all the files you need to being development
of your new idea. Padrino is an agnostic framework and supports using a variety
of different template, testing, JavaScript and database components. You can
learn more by reading the [generators guide](/guides/generators/overview "generators
guide").

For this sample application, we will use the ActiveRecord ORM, the Slim
templating language, the RSpec testing framework and the jQuery JavaScript
library. With that in mind, let us generate our new project:


```shell
$ padrino g project blog-tutorial -t rspec -e haml -c scss -s jquery -d sequel -b
```


This command will generate our basic Padrino project and the print out a nice
report of the files generated. The output of this generation command can be
viewed in [this gist](https://gist.github.com/wikimatze/0f8b63d28bccac84014f8a592f79197d "gist for initial project
generation") file. Notice the `-b` flag in the previous command which automatically instructs bundler
to install all dependencies. All we need to do now is `cd` into our brand new application.


```shell
$ cd blog-tutorial
```


Now, the terminal should be inside the root of our newly generated application
with all necessary gem dependencies installed. Let us take a closer look at the
particularly important generated files before we continue on with development.


- `Gemfile` – Includes any necessary gem dependencies for your app.
- `app/app.rb` – The primary configuration file for your app.
- `config/apps.rb` – This defines which applications are mounted in your
  project.
- `config/database.rb` – This defines the connection details for your chosen
  database adapter.

The following important directories are also generated:

- `app/controllers` – This is where the Padrino route definitions should be
  defined.
- `app/helpers` – This is where helper methods should be defined for your
  application.
- `app/views` – This should contain your template views to be rendered in a
  controller.
- `lib` – This should contain any extensions, libraries or other code to be used
  in your project.
- `public` – This is where images, style sheets and JavaScript files should be
  stored.
- `spec` – This is where your model and controller tests are stored.

For now, the defaults for the database connection settings (`config/database.rb`) are
fine for this tutorial.


This environment can be configured in `config/apps.rb` as:


```ruby
Padrino.configure_apps do
  if RACK_ENV == 'production'
    disable :reload
    disable :reload_templates
  else
    enable :reload
    enable :reload_templates
  end
end
```


or can be configured in `app/app.rb` as


```ruby
if Padrino.env == :production
  # do production
else
  # non production here
end
```


Let us also setup a few simple routes in our application to demonstrate the
Padrino routing system. Let's go into the `app/app.rb` file and enter the
following routes:


```ruby
# app/app.rb
module BlogTutorial
  class App < Padrino::Application
    register ScssInitializer
    register Padrino::Mailer
    register Padrino::Helpers

    enable :sessions

    # Here are the defined routes
    get "/" do
      'Hello World!'
    end

    get :about, :map => '/about-us' do
      render :haml, '%p This is a sample blog created to demonstrate how Padrino works!'
    end
  end
end
```


Note that the first route here sets up a simple string to be returned at the
root URL of the application. The second route defines a one-line `about` page
inline using Haml which is then explicitly mapped to the `/about-us` URL. The
symbol `:about` is used to reference the route later.

Be sure to check out the [controllers guide](/guides/controllers/overview "controllers
guide") for a comprehensive overview of the routing system.

--------------------------------------------------------------------------------

## Admin Dashboard Setup

Next, this is a good time to setup the Padrino admin panel which allows us to
easily view, search and modify data for a project. Let's go back to the console
and enter:


```shell
$ padrino g admin
```


This will create the admin sub-application within your project and mount it
within the `config/apps.rb` file. The output of this command can be viewed in
[this gist](https://gist.github.com/wikimatze/2a325cb7d019371a5403d7420cdf2458 "gist for admin generation output") file.

Now, you should follow the instructions of the output:


```sh
  1) Run 'bundle'
  2) Run 'bundle exec rake db:create' if you have not created a database yet
  3) Run 'bundle exec rake db:migrate'
  4) Run 'bundle exec rake db:seed'
  5) Visit the admin panel in the browser at '/admin'
```


During this process, you will be prompted to enter an email and password to use
for the admin dashboard. Be sure to remember this for use later in development.

To read more about the features of the admin panel, check out the
[Admin Panel Guide](/guides/features/padrino-admin "Admin Panel Guide").

--------------------------------------------------------------------------------

## Booting Padrino

Now the Padrino project has been generated, the database has been configured and
created and the admin panel has been properly setup. We can now start up our
Padrino application server. This is quite easy to do with the built-in Padrino
tasks. Simply execute the following in the terminal:

```shell
$ padrino s
```

You should see no errors, and the terminal should output:


```shell
=> Padrino/0.14.3 has taken the stage development at http://127.0.0.1:3000
[2018-05-10 08:01:56] INFO  WEBrick 1.3.1
[2018-05-10 08:01:56] INFO  ruby 2.4.2 (2017-09-14) [i686-linux]
[2018-05-10 08:01:56] INFO  WEBrick::HTTPServer#start: pid=3489 port=3000
```


To read more about available terminal commands, checkout the
[Development and Terminal Commands](/guides/features/development-commands "Development
and Terminal Commands") guide.

Your application now exists on <http://localhost:3000>. Visit this URL in the
browser and you should see the `Hello World!`.

We can also visit the admin panel by going to the URL:
<http://localhost:3000/admin> and then log in using the admin credentials
specified during the `rake db:seed` command performed earlier. Feel free to explore
this area and checkout the existing accounts. We will come back to this in more
detail later. To read more about the features of the admin panel, check out the
[Admin Panel Guide](/guides/features/padrino-admin "Admin Panel Guide").

Worth noting here is that Padrino has full support for code reloading in
development mode. This means you can keep the Padrino server running and change
your code source and when you refresh in the browser, the changes will be
automatically displayed.

--------------------------------------------------------------------------------

## Creating Posts

Now that the application is ready and the layouts have been defined, let's
implement the functionality to view our blog posts and even add the ability to
create new posts!

Let's start off by generating the model into our app directory. The models will be generated at the top level
`models`
directory in a project. If you want to place your models to another location, you can append
the `-a` option to the command - this is handy if you would like to have models which
should be coped only to sub-apps.


```shell
$ padrino g model post title:string body:text created_at:datetime
       apply  orms/sequel
       apply  tests/rspec
      create  models/post.rb
      create  spec/models/post_spec.rb
      create  db/migrate/002_create_posts.rb
```


Go ahead and migrate the database now.


```shell
$ padrino rake sq:migrate
=> Executing Rake sq:migrate ...
   INFO -  (0.000163s) PRAGMA foreign_keys = 1
   INFO -  (0.000022s) PRAGMA case_sensitive_like = 1
   INFO -  (0.000107s) SELECT sqlite_version()
   INFO -  (0.000061s) CREATE TABLE IF NOT EXISTS `schema_info` (`version` integer DEFAULT (0) NOT NULL)
   INFO -  (0.000103s) SELECT * FROM `schema_info` LIMIT 1
   INFO -  (0.000068s) SELECT 1 AS 'one' FROM `schema_info` LIMIT 1
   INFO -  (0.000062s) SELECT count(*) AS 'count' FROM `schema_info` LIMIT 1
   INFO -  (0.000070s) SELECT `version` FROM `schema_info` LIMIT 1
   INFO -  Begin applying migration version 2, direction: up
   INFO -  (0.011094s) CREATE TABLE `posts` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `title` varchar(255), `body` Text, `created_at` timestamp)
   INFO -  (0.014224s) UPDATE `schema_info` SET `version` = 2
   INFO -  Finished applying migration version 2, direction: up, took 0.025778 seconds
<= sq:migrate:up executed
```


Next, let's create the controller to allow the basic viewing functionality.


```shell
$ padrino g controller posts get:index get:show
      create  app/controllers/posts.rb
      create  app/views/posts
       apply  tests/rspec
      create  spec/app/controllers/posts_controller_spec.rb
      create  app/helpers/posts_helper.rb
       apply  tests/rspec
      create  spec/app/helpers/posts_helper_spec.rb
```


We'll want to attached some of the standard routes (`:index` and `:show`) to the
controller.


```ruby
# app/controllers/posts.rb
BlogTutorial::App.controllers :posts do
  get :index do
    @posts = Post.reverse_order(:created_at).all
    render 'posts/index'
  end

  get :show, :with => :id do
    @post = Post[id: params[:id]]
    render 'posts/show'
  end
end
```


This controller is defining routes that can be accessed via our application. The
"http method" `get` starts off the declaration followed by a symbol representing
the "action". Inside a block we store an instance variable fetching the
necessary objects and then render a view template. This should look familiar to
those coming from Rails or Sinatra.

Next, we'll want to create the views for the two controller actions we defined:
`index` and `show`.


```haml
-# app/views/posts/index.haml
- @title = "Welcome"

#posts= partial 'posts/post', :collection => @posts

-# app/views/posts/_post.haml

.column.is-7.is-offset-2
  .card.article
    .card-content
      .media
        .media-content.has-text-centered
          %p.title.article-title
            %h3.has-text-centered
              = link_to post.title, url_for(:posts, :show, :id => post.id)
          .has-addons
            %span.tag.is-rounded= time_ago_in_words(post.created_at || Time.now) + ' ago'
      .content.article-body
        = simple_format(post.body)


-# app/views/posts/show.haml

%section.articles
  .column.is-8.is-offset-2
    .card.article
      .card-content
        .media
          .media-content.has-text-centered
            %h3.title.article-title= @post.title
            .tags.has-addons.level-item
              %span.tag.is-rounded= time_ago_in_words(@post.created_at || Time.now) + ' ago'
        .content.article-body
          = simple_format(@post.body)
          %p= link_to 'View all posts', url_for(:posts, :index)
```


Padrino Admin makes it easy to create, edit and delete records automatically. To
manage posts using Padrino Admin, run this command.


```shell
$ padrino g admin_page post
      create  admin/controllers/posts.rb
      create  admin/views/posts/_form.haml
      create  admin/views/posts/edit.haml
      create  admin/views/posts/index.haml
      create  admin/views/posts/new.haml
      insert  admin/app.rb
```


Let's make sure the server is running (`padrino s`) and give this admin
interface a try.

Visit <http://localhost:3000/admin> and login using the credentials you had
setup during the seed.

There should now be two tabs, one for **Posts** and one for **Accounts**.

Now click on 'Posts'. Padrino Admin allows you to easily create new records by clicking "New". It has
a form all ready complete with the fields you had generated prior in the
creation of the Post model.

**Note:** make sure to use `padrino g admin_page post` **after** the creation of your
  model and their migration.

Now that you have added a few posts through the admin interface, check out
<http://localhost:3000/posts> and notice that the posts you created now show up
in the "index" action!

You can see all the routes that we now have defined using the `padrino rake
routes` command:


```shell
$ padrino rake routes

Application: BlogTutorial::Admin
    URL                           REQUEST  PATH
    (:sessions, :new)               GET    /admin/sessions/new
    (:sessions, :create)           POST    /admin/sessions/create
    (:sessions, :destroy)         DELETE   /admin/sessions/destroy
    (:base, :index)                 GET    /admin/
    (:accounts, :index)             GET    /admin/accounts
    (:accounts, :new)               GET    /admin/accounts/new
    (:accounts, :create)           POST    /admin/accounts/create
    (:accounts, :edit)              GET    /admin/accounts/edit/:id
    (:accounts, :update)            PUT    /admin/accounts/update/:id
    (:accounts, :destroy)         DELETE   /admin/accounts/destroy/:id
    (:accounts, :destroy_many)    DELETE   /admin/accounts/destroy_many
    (:posts, :index)                GET    /admin/posts
    (:posts, :new)                  GET    /admin/posts/new
    (:posts, :create)              POST    /admin/posts/create
    (:posts, :edit)                 GET    /admin/posts/edit/:id
    (:posts, :update)               PUT    /admin/posts/update/:id
    (:posts, :destroy)            DELETE   /admin/posts/destroy/:id
    (:posts, :destroy_many)       DELETE   /admin/posts/destroy_many

Application: BlogTutorial::App
    URL                 REQUEST  PATH
    (:about)              GET    /about-us
    (:posts, :index)      GET    /posts
    (:posts, :show)       GET    /posts/show/:id
```


This can be helpful to understand the mapping between controllers and urls.

--------------------------------------------------------------------------------

## Attaching Accounts to Posts

So far, a post does not have a user associated as the author. Suppose that now
we want to let every post have an author. Let's revisit our post model. We'll
start by adding a new migration to attach an Account to a Post.


```shell
$ padrino g migration AddAccountToPost account_id:integer
       apply  orms/activerecord
      create  db/migrate/003_add_account_to_post.rb
```


This creates a new migration with the desired field attaching the `account_id` to
the post.


Now, we'll return to the post model to setup the `account` association and add a
few validations.


```ruby
# models/post.rb

class Post < Sequel::Model
  many_to_one :account

  plugin :validation_helpers
  def validate
    super
    validates_presence [:title, :body]
  end
end
```


And add the association to the Account model:


```ruby
# models/account.rb

class Account < Sequel::Model
  one_to_many :posts
  ...
end
```

Now we are ready to run the migration: `$ padrino rake sq:migrate`

Let's create another migration to assign the first user to all existing posts:


```shell
$ padrino g migration MigrateExistingPostsToFirstAccount
       apply  orms/activerecord
      create  db/migrate/004_migrate_existing_posts_to_first_account.rb
```


And change the content of the migration:


```ruby
# db/migrate/004_migrate_existing_posts_to_first_account.rb
Sequel.migration do
  up do
    first_account_id = from(:accounts).get(:id)

    if first_account_id
      from(:posts).update(account_id: first_account_id)
    end
  end

  down do
    from(:posts).update(account_id: nil)
  end
end
```


And run the migrations again: `$ padrino rake sq:migrate`


We'll need to go
inside the generated Padrino Admin and make some changes to include the account
with the post.

Head on over to `admin/controllers/posts.rb`. We're going to include the
[current_account](https://github.com/padrino/padrino-framework/blob/master/padrino-admin/lib/padrino-admin/helpers/authentication_helpers.rb#L18 "current_account")
to the creation of a new Post.

```ruby
# admin/controllers/posts.rb
Admin.controllers :posts do
  ...

  post :create do
    @post = Post.new(params[:post])
    @post.account = current_account
    ...
  end
 ...
end
```

We'll also update the post view to show the changes that we made and display the
author:

```haml
-# app/views/posts/show.haml
%section.articles
  .column.is-8.is-offset-2
    .card.article
      .card-content
        .media
          .media-content.has-text-centered
            %h3.title.article-title= @post.title
            .tags.has-addons.level-item
              %span.tag.is-rounded.is-info= @post.account.email
              %span.tag.is-rounded= time_ago_in_words(@post.created_at || Time.now) + ' ago'
        .content.article-body
          = simple_format(@post.body)
          %p= link_to 'View all posts', url_for(:posts, :index)


-# app/views/posts/_post.haml
.column.is-7.is-offset-2
  .card.article
    .card-content
      .media
        .media-content.has-text-centered
          %p.title.article-title
            %h3.has-text-centered
              = link_to post.title, url_for(:posts, :show, :id => post.id)
          .has-addons
            %span.tag.is-rounded.is-info= post.account.email
            %span.tag.is-rounded= time_ago_in_words(post.created_at || Time.now) + ' ago'
      .content.article-body
        = simple_format(post.body)
```

Now, lets add another user. Revisit <http://localhost:3000/admin> and click on
the Account tab. Now create a new Account record (don't forget to give the new
account the admin role). Once you have a new account, try logging into it and
then adding one more post in the admin interface. There you have it,
multiple users and posts!

See the effects of our changes by visiting <http://localhost:3000/posts> to see
our newly created posts linked to the author that wrote them.

--------------------------------------------------------------------------------

## Site Layout

Now that the application has been properly configured and the server has been
started, let's create a few basic styles and define a layout to prepare the
application for continued development.

We will take the [bulma css framework](https://bulma.io/ "bulma") for our application. Let's install the plugin with
`padrino g plugin bulma`. You can find more plugins under https://github.com/padrino/padrino-recipes.

Next, let us create a layout for our application to use. A layout is a file
that acts as a container for the content templates yielded by each route. The
layout should be used to create a consistent structure between each page of the
application. To create a layout, simply add a file to the `app/views/layouts`
directory:


```haml
-# app/views/layouts/application.haml
!!! Strict
%html
  %head
    %title= "Padrino Sample Blog"
    = stylesheet_link_tag 'bulma', 'application'
    = javascript_include_tag 'jquery', 'application'
  %body
    %nav.navbar
      %div.container
        .navbar-brand
          %a.navbar-item{:href => "/"}
            %img{:alt => "Logo of Padrino blog", :src => "http://padrinorb.com/images/logo-6475397a.svg"}/
          %span.navbar-burger.burger{"data-target" => "navbarMenu"}
            %span
            %span
            %span
        #navbarMenu.navbar-menu
          .navbar-end
            = link_to 'Home', '/', {:class => 'navbar-item'}
            = link_to 'Blog', url_for(:posts, :index), {:class => 'navbar-item'}
            = link_to 'About us', url_for(:about), {:class => 'navbar-item'}
    %section.hero.is-info.is-medium.is-bold
      .hero-body
        .container.has-text-centered
          %h1.title
            An example blog created with Padrino
    %div.container
      #main= yield
```


This layout creates a basic structure for the blog and requires the necessary
stylesheets and javascript files for controlling the behavior and presentation
of our site.

Next, we adjust some styling for our blog in the `/public/stylesheets/application.css`:


```css
.hero-body {
  background-image: url(https://farm3.staticflickr.com/2840/33942486610_e0c80a7999_o_d.jpg);
  background-position: center;
  background-size: cover;
  background-repeat: no-repeat;
  height: 700px;
  background-color: black;
}

h1.title {
  margin-top: 145px;
}

h3.has-text-centered {
  color: #363636;
  font-size: 2rem;
  font-weight: 600;
  line-height: 1.125;
  margin-bottom: 1.5rem;
}

.articles {
  margin: 5rem 0;
  margin-top: 5rem;
  margin-top: -200px;
}
```

And to have a proper mobile burger navigation we need JavaScript in `public/javascripts/application.js`:


```js
document.addEventListener('DOMContentLoaded', function () {
  // Get all "navbar-burger" elements
  var $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach(function ($el) {
      $el.addEventListener('click', function () {

        // Get the target from the "data-target" attribute
        var target = $el.dataset.target;
        var $target = document.getElementById(target);

        // Toggle the class on both the "navbar-burger" and the "navbar-menu"
        $el.classList.toggle('is-active');
        $target.classList.toggle('is-active');

      });
    });
  }
});
```


The blog has now a
much improved look and feel! See the new style by visiting
<http://localhost:3000/posts>.

If you want to setup a RSS feed for your page please follow [the instructions on our wiki](https://github.com/padrino/padrino-docs/wiki/Blog-Tutorial-generating-RSS-feed "the instructions on the wiki").

