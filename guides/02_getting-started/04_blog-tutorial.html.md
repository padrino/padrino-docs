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
<iframe src="//player.vimeo.com/video/10522357" width="500" height="313" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe> <p><a href="http://vimeo.com/10522357">Blog Tutorial</a> from <a href="http://vimeo.com/user3479413">Padrino Framework</a> on <a href="https://vimeo.com">Vimeo</a>.</p>
</div>

Please note that the screencast was written for Padrino 0.12.2, so some things
mentioned there may not be valid.

--------------------------------------------------------------------------------

## Study Guide

To skip this tutorial or immediately see the complete blog tutorial project, you
can either checkout the
[blog tutorial repository](https://github.com/padrino/blog-tutorial "blog tutorial
repository") using Git:


```shell
$ git clone git@github.com:padrino/blog-tutorial.git
```


or even execute the
[blog tutorial project template](https://github.com/padrino/padrino-recipes/blob/master/templates/sampleblog_template.rb "blog tutorial
project template") which will automatically build the blog project step by step
using our excellent template runner. You can do this simply by invoking:


```shell
$ padrino g project blog-tutorial --template blogtutorial
```


To learn more about our template generator, be sure to check out the
[generators guide](/guides/generators/overview "generators guide").

Please note that you can find the code for code for Padrino 0.12.2 under
[blog tutorial repository for Padrino 0.12.2](http://github.com/padrino/sample_blog "blog tutorial repository for
Padrino 0.12.2").

--------------------------------------------------------------------------------

## Installation

In order to develop a Padrino application, we must have a few things installed.
First, we must obviously have [ruby](http://www.ruby-lang.org/en/ "ruby") and
[rubygems](https://rubygems.org/ "rubygems") installed. Next, we must install
the padrino framework gems:

```shell
$ gem install padrino
```

For more details on installation, check out the
[installation guide](/guides/getting-started/installation "installation guide"). Once this has
been finished, all necessary dependencies should be ready and we can begin
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

- `Gemfile` – Be sure to include any necessary gem dependencies for your app in
  this file!
- `app/app.rb` – This is the primary configuration file for your core
  application.
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
- `spec` – This is where your model and controller tests should be stored.

For now, the defaults for the database connection settings (`config/database.rb`) are
OK for this tutorial.

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

    # Add these routes below to the app file...
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
=> Padrino/0.14.1.1 has taken the stage development at http://127.0.0.1:3000
[2017-05-20 09:40:49] INFO  WEBrick 1.3.1
[2017-05-20 09:40:49] INFO  ruby 2.4.1 (2017-03-22) [i686-linux]
[2017-05-20 09:40:49] INFO  WEBrick::HTTPServer#start: pid=26641 port=3000
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
automatically displayed. You might want to open up a new terminal and `cd` to
your directory and keep the server running.

--------------------------------------------------------------------------------

## Creating Posts

Now that the application is ready and the layouts have been defined, let's
implement the functionality to view our blog posts and even add the ability to
create new posts!

Let's start off by generating the model into our app directory. As of version
**0.13.1**, the models will default to generating at the top level 'models'
directory in a project. If you want to place your models to another location, you can append
the `-a` option to the command - this is handy if you would like to have models which
should be coped only to sub-apps.

```shell
$ padrino g model post title:string body:text created_ad:datetime
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
   INFO -  (0.000159s) PRAGMA foreign_keys = 1
   INFO -  (0.000021s) PRAGMA case_sensitive_like = 1
   INFO -  (0.000080s) SELECT sqlite_version()
   INFO -  (0.000037s) CREATE TABLE IF NOT EXISTS `schema_info` (`version` integer DEFAULT (0) NOT NULL)
   INFO -  (0.000077s) SELECT * FROM `schema_info` LIMIT 1
   INFO -  (0.000061s) SELECT 1 AS 'one' FROM `schema_info` LIMIT 1
   INFO -  (0.000058s) SELECT count(*) AS 'count' FROM `schema_info` LIMIT 1
   INFO -  (0.000063s) SELECT `version` FROM `schema_info` LIMIT 1
   INFO -  Begin applying migration version 2, direction: up
   INFO -  (0.014988s) CREATE TABLE `posts` (`id` integer NOT NULL PRIMARY KEY AUTOINCREMENT, `title` varchar(255), `body` Text, `created_at` date)
   INFO -  (0.017424s) UPDATE `schema_info` SET `version` = 2
   INFO -  Finished applying migration version 2, direction: up, took 0.028866 seconds
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
.post
  .title= link_to post.title, url_for(:posts, :show, :id => post.id)
  .date= time_ago_in_words(post.created_at || Time.now) + ' ago'
  .body= simple_format(post.body)

-# app/views/posts/show.haml
- @title = @post.title
#show
  .post
    .title= @post.title
    .date= time_ago_in_words(@post.created_at || Time.now) + ' ago'
    .body= simple_format(@post.body)
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

There should now be two tabs, one for Posts and the other, Accounts. Click on
Posts.

Padrino Admin allows you to easily create new records by clicking "New". It has
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
the post. Let's modify this migration to add the accounts FK to posts:

```ruby
# db/migrate/003_add_account_to_post.rb

Sequel.migration do
  class Account < Sequel::Model; end
  class Post < Sequel::Model
    many_to_one :account
  end

  up do
    alter_table :posts do
      add_column :account_id, Integer
    end
  end

  down do
    alter_table :posts do
      drop_column :account_id
    end
  end
end
```


Now, we'll return to the Post Model to setup the `account` association and add a
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
class Account < Sequel::Model
  one_to_one :post
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
  class Account < Sequel::Model; end
  class Post < Sequel::Model
    many_to_one :account
  end

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

Our database now has the appropriate associations and validations.


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
- @title = @post.title
#show
  .post
    .title= @post.title
    .date= time_ago_in_words(@post.created_at || Time.now) + ' ago'
    .body= simple_format(@post.body)
    .details
      .author Posted by #{@post.account.email}
%p= link_to 'View all posts', url_for(:posts, :index)

-# app/views/posts/_post.haml
.post
  .title= link_to post.title, url_for(:posts, :show, :id => post)
  .date= time_ago_in_words(post.created_at || Time.now) + ' ago'
  .body= simple_format(post.body)
  .details
    .author Posted by #{post.account.email}
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

First, let us create a layout for our application to use. A layout is a file
that acts as a container for the content templates yielded by each route. The
layout should be used to create a consistent structure between each page of the
application. To create a layout, simply add a file to the `app/views/layouts`
directory:

```haml
-# app/views/layouts/application.haml

!!! Strict
%html
  %head
    %title
      = [@title, "Padrino Sample Blog"].compact.join(" | ")
    = stylesheet_link_tag 'normalize', 'application'
    = javascript_include_tag 'jquery', 'application'
    = yield_content :include
    %body
      #header
        %h1 Sample Padrino Blog
        %ul.menu
        %li= link_to 'Blog', url_for(:posts, :index)
        %li= link_to 'About', url_for(:about)
      #container
        #main= yield
        #sidebar
          = form_tag url_for(:posts, :index), :method => 'get'  do
            Search for:
            = text_field_tag 'query', :value => params[:query]
            = submit_tag 'Search'
          %p
            Recent Posts
          %ul.bulleted
            %li Item 1 - Lorem ipsum dolorum itsum estem
            %li Item 2 - Lorem ipsum dolorum itsum estem
            %li Item 3 - Lorem ipsum dolorum itsum estem
          %p
            Categories
            %ul.bulleted
              %li
                Item 1 - Lorem ipsum dolorum itsum estem
              %li
                Item 2 - Lorem ipsum dolorum itsum estem
              %li
                Item 3 - Lorem ipsum dolorum itsum estem
            %p
              Latest Comments
              %ul.bulleted
                %li Item 1 - Lorem ipsum dolorum itsum estem
                %li Item 2 - Lorem ipsum dolorum itsum estem
                %li Item 3 - Lorem ipsum dolorum itsum estem
      #footer
        Copyright (c) 2009-2017 Padrino
```

This layout creates a basic structure for the blog and requires the necessary
stylesheets and javascript files for controlling the behavior and presentation
of our site. The layout also includes some dummy elements such as a fake search
and stubs for list items left as an exercise for the reader.

Next, we simply need to setup the style sheets. There are two we will use for
this demo. The first is a generic [normalize CSS reset by Nicolas Gallagher](https://necolas.github.io/normalize.css/). The
full reset style sheet can be found in the
[sample blog repository](https://raw.githubusercontent.com/padrino/blog-tutorial/master/public/stylesheets/normalize.css
"sample blog repository") and should be put into
`public/stylesheets/normalize.css`.

The second style sheet is the application style sheet to give our blog a better
look and feel. The
full contents of the style sheet can be found in the
[sample blog repository]( https://raw.githubusercontent.com/padrino/blog-tutorial/master/app/stylesheets/application.scss
"sample blog repository") and should be put into
`app/stylesheets/application.scss`.

With the layout and these two stylesheets in place, the blog will now have a
much improved look and feel! See the new style by visiting
<http://localhost:3000/posts>.

--------------------------------------------------------------------------------

## Generating RSS Feed for Posts

Finally, before the application is deployed, let's set up RSS and Atom feeds for
our new blog so people can subscribe to our posts. For the feeds, we're going to
head back to the posts controller and make a few changes by appending a
`provides` option to our `index` block. This command below instructs the route
that it should respond to HTML, RSS and Atom formats.

```ruby
# app/controllers/posts.rb
SampleBlogUpdated::App.controllers :posts do
# ...
  get :index, :provides => [:html, :rss, :atom] do
    @posts = Post.order('created_at DESC').all
    render 'posts/index'
  end
# ...
end
```

Note that this route also instructs the rendering engine to avoid rendering the
layout when using RSS or atom formats.

Back in the `index.haml` file, we'll use the `auto_discovery_link_tag` helpers to
generate the RSS feed using builder.

```haml
-# app/views/posts/index.haml
- @title = "Welcome"

- content_for :include do
  = feed_tag(:rss, url(:posts, :index, :format => :rss), :title => "RSS")
  = feed_tag(:atom, url(:posts, :index, :format => :atom), :title => "ATOM")

#posts= partial 'posts/post', :collection => @posts
```

Next, let us add the templates for atom using [builder](https://github.com/jimweirich/builder) templates:

```ruby
# app/views/posts/index.atom.builder

xml.instruct!
xml.feed "xmlns" => "http://www.w3.org/2005/Atom" do
  xml.title   "Padrino Sample Blog"
  xml.link    "rel" => "self", "href" => url_for(:posts, :index)
  xml.id      url_for(:posts, :index)
  xml.updated @posts.first.created_at.strftime "%Y-%m-%dT%H:%M:%SZ" if @posts.any?
  xml.author  { xml.name "Padrino Team" }

  @posts.each do |post|
    xml.entry do
      xml.title   post.title
      xml.link    "rel" => "alternate", "href" => url_for(:posts, :show, :id => post)
      xml.id      url_for(:posts, :show, :id => post)
      xml.updated post.created_at.strftime "%Y-%m-%dT%H:%M:%SZ"
      xml.author  {}
    end
  end
end
```

and also the template for rss using builder:

```ruby
# app/views/posts/index.rss.builder

xml.instruct!
xml.rss "version" => "2.0", "xmlns:dc" => "http://dublincore.org/documents/dc-xml-guidelines/" do
  xml.channel do
    xml.title "Padrino Blog"
    xml.description "The fantastic padrino sample blog"
    xml.link url_for(:posts, :index)

    for post in @posts
      xml.item do
        xml.title post.title
        xml.description post.body
        xml.pubDate post.created_at
        xml.link url_for(:posts, :show, :id => post.id)
      end
    end
  end
end
```

Please note, that you have to add `builder` in your `Gemfile` and run `bundle`.
Let's check out our changes. View the available feeds at
<http://localhost:3000/posts.atom> or <http://localhost:3000/posts.rss>.
You now have rss and atom feeds available for your blog!

--------------------------------------------------------------------------------

## Deploying our Application

Finally, our basic blog has been built and we should deploy our application so
the world can check it out! The easiest way to do this quickly and for free is
to use a service such as Heroku. Let's deploy our application to Heroku right
now.

The best way to get started using Heroku is by following the
[Heroku Quickstart Guide](https://devcenter.heroku.com/start "Heroku Quickstart
guide"). As explained in the guide, be sure to have Git installed and
[setup a Heroku account](https://signup.heroku.com/dc "setup a Heroku account") as
well as
[install the Heroku command-line tool](https://devcenter.heroku.com/articles/heroku-command
"install the Heroku command-line tool") before continuing this tutorial.

Now, to deploy to Heroku, the application needs to be set up as a Git
repository:

```shell
$ cd sample-blog-updated
$ git init
$ git add .
$ git commit -m "initial commit for app"
```

This initializes the Git repository, adds all the contents and commit them to
the repo.

Currently Padrino defaults to **SQLite** but Heroku only supports
**PostgreSQL**, so we'll need to add `pg` gem as a dependency for production as well add `sqlite3`
for development.

```ruby
# Gemfile
group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
```

Now you can bundle :

```shell
$ bundle
```

and then commit these changes to your git repository:

```shell
$ git add --all
$ git commit -m "added pg dependency"
```

Next, the application must be set up on Heroku.

```shell
$ heroku login
  Enter your Heroku credentials.
  Email: <your-email>
  Password (typing will be hidden):
  Logged in as <your-email>
$ heroku create
  Creating app... done, ⬢ secret-taiga-32690
  https://secret-taiga-32690.herokuapp.com/ | https://git.heroku.com/secret-taiga-32690.git
$ git push heroku master
```

That's it, your app is now running on Heroku! To see if we have a database addon connected
to out heroku app, run `heroku addons`:

```sh
$ heroku addons
  Add-on                                       Plan       Price
  ───────────────────────────────────────────  ─────────  ─────
  heroku-postgresql (postgresql-taiga-32690)   hobby-dev  free
   └─ as DATABASE
```

and configure the `config/database.rb` for production:

```ruby
# config/database.rb

Sequel::Model.plugin(:schema)
Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
Sequel::Model.db = case Padrino.env
  when :development then Sequel.connect("sqlite://db/blog_tutorial_development.db", :loggers => [logger])
  when :production  then Sequel.connect("<your-url>",  :loggers => [logger])
  when :test        then Sequel.connect("sqlite://db/blog_tutorial_test.db",        :loggers => [logger])
end
```

You can get the value of `<your-url>` via `heroku config`.


Run `heroku open` to open your site in your default web browser.

Now run our `migrations/seeds`:

```shell
$ heroku run rake sq:migrate
$ heroku run rake sq:seed
```

You'll see something like:

```shell
$ heroku run rake ar:migrate
Running rake ar:migrate on calm-tor-92217.... up, run.7316
== 1 CreateAccounts: migrating ================================================
-- create_table(:accounts)
   -> 0.0162s
== 1 CreateAccounts: migrated (0.0164s) =======================================

== 2 CreatePosts: migrating ===================================================
-- create_table(:posts)
   -> 0.0078s
== 2 CreatePosts: migrated (0.0080s) ==========================================

== 3 AddAccountToPost: migrating ==============================================
-- change_table(:posts)
   -> 0.0048s
== 3 AddAccountToPost: migrated (0.0254s) =====================================

$ heroku run rake seed
Running rake seed on calm-tor-92217.... up, run.9169

Which email do you want use for logging into admin?
Tell me the password to use:

=================================================================
Account has been successfully created, now you can login with:
=================================================================
   email: info@padrinorb.com
   password: *****
=================================================================
```

Now let's open our newly deployed app:

```shell
$ heroku open
```

and surf. You can see [posts](https://calm-tor-92217.herokuapp.com/posts "posts") and the
[admin screen](https://calm-tor-92217.herokuapp.com/admin/sessions/new "admin screen").

Enjoy!
