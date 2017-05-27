---
date: 2015-02-12
author: Nathan Esquenazi
email: nesquena@gmail.com
categories: ruby update
tags: padrino sinatra ruby
title: Upgrading Padrino from 0.11.X to 0.12.0 Guide
---

This is the step-by-step guide for upgrading from Padrino 0.11.X to 0.12.0! This will review all the breaking changes and modifications made within the new release.
blog/2015-02-12-upgrading-padrino-from-0-11-x-to-0-12-0-guide.html.md

## Ruby 1.8 Support Dropped

Padrino **no longer supports Ruby 1.8.X** so please ensure that you are running on at least Ruby 1.9.3 before beginning this upgrade! Note that we recommend using Ruby 2.0 or 2.1.0 with Padrino to ensure compatibility with future versions. Also, Ruby 2.X is faster and more memory efficient. Note that Padrino also requires `ActiveSupport >= 3.1` now but currently works best with ActiveSupport 4.

## Moneta Caching

Because the caching store system has been completely replaced, we need to make the following changes **if you are using the caching module**.

First, we need to delete old cache files with `rm -rf ./tmp/*`. Make sure to delete these old temp files in your project! Also, the syntax for configuring the cache store has changed substantially:


```ruby
# BEFORE
Padrino.cache = Padrino::Cache::Store::File.new(Padrino.root(tmp, app_name, cache)

# AFTER
Padrino.cache = Padrino::Cache.new(:File, :dir => Padrino.root(tmp, app_name.to_s, cache))
```


We have also deprecated `expires_in` in favor of just `expires`:

```ruby
get /foo, :cache => true do expires 30  Hello world end
```


Also the old style of getting and setting values has been deprecated in favor of a new syntax:

```ruby
# BEFORE
MyApp.cache.set(val, test)
MyApp.cache.get(val)

# AFTER
MyApp.cache[val] = testMyApp.cache[val]
```


More examples of configuring caching store settings are provided below:


```ruby
Padrino.cache = Padrino::Cache.new(:LRUHash)

# Keeps cached values in memory
Padrino.cache = Padrino::Cache.new(:Memcached)

# Uses default server at localhost

Padrino.cache = Padrino::Cache.new(:Memcached, 127.0.0.1:11211, :exception_retry_limit => 1)
Padrino.cache = Padrino::Cache.new(:Memcached, :backend => memcached_or_dalli_instance)
Padrino.cache = Padrino::Cache.new(:Redis)

# Uses default server at localhost
Padrino.cache = Padrino::Cache.new(:Redis, :host => 127.0.0.1, :port => 6379, :db => 0)
Padrino.cache = Padrino::Cache.new(:Redis, :backend => redis_instance)
Padrino.cache = Padrino::Cache.new(:Mongo)

# Uses default server at localhost
Padrino.cache = Padrino::Cache.new(:Mongo, :backend => mongo_client_instance)
Padrino.cache = Padrino::Cache.new(:File, :dir => Padrino.root(tmp, app_name.to_s, cache))
```


You can see full details about the new caching system by checking out the [padrino-cache readme](guides/features/padrino-cache/ "padrino-cache readme")!


## Rack::Protection and CSRF

We need to rewrite the protection settings within `config/apps.rb`:


```ruby
# before
set :protection, true

# after
set :protection, :except => :path_traversal
```


Once that change has been made, the protections should work as expected.


## CSRF Protection

In past Padrino versions, there have been [compatibility issues](https://github.com/padrino/padrino-framework/issues/1489 "compatibility issues") with the excellent [better_errors](https://web.archive.org/web/20150208055316/https://github.com/charliesome/better_errors "better_errors") gem that provides a nifty dashboard whenever an exception occurs in development. In this release, we have added an easy way to avoid any issues with the added :except argument when configuring CSRF.


```ruby
# /app/app.rb
module Foobar
  class App < Padrino::Application
    enable :sessions
    configure :development do
    use BetterErrors::Middleware
    BetterErrors.application_root = PADRINO_ROOT
    set :protect_from_csrf, except: %r{/__better_errors/\d+/\w+\z}
  end
end
```


Once you've properly setup the `:except` regex, there shouldn't be any issues. This is also useful for when a Padrino project wants to mount a Sinatra or Rack app.


## Slim and Haml Content Blocks

The major template handling rewrite and compatibility update for 0.12.0 requires us to use = instead of - in certain cases when creating templates with tag helpers. (Reference Issues [#1442](https://github.com/padrino/padrino-framework/pull/1442 "#1442"), [#1441](https://github.com/padrino/padrino-framework/pull/1441 "#1441"). For example, before we might have written a form with dashes:


```ruby
- form_tag /destroy, :class => destroy-form, :method => delete do
  - field_set_tag do
    %p
      = label_tag :username, :class => first
      = text_field_tag :username, :value => params[:username]
```


Now in 0.12.0, we want to write them with = instead:


```ruby
= form_tag /destroy, :class => destroy-form, :method => delete do
  = field_set_tag do
    %p
      = label_tag :username, :class => first
      = text_field_tag :username, :value => params[:username]
```


Note that this is a breaking change and that you should upgrade all your templates to this new format as part of the upgrade process!


## Reorder Mounter Apps

The Padrino mounter parsing `config/apps.rb` was modified substantially with support added for cascading requests. These changes have made the apps list order dependent. In particular, we need to insert the sub-apps for a project before the main app in `config/apps.rb`:


```ruby
# config/apps.rb
Padrino.mount("Blog").to('/blog')
Padrino.mount("Forum").to('/forum')
Padrino.mount("MainApp").to('/'') # <-- main app last
```


Make sure to re-order your apps to put the main app at the bottom otherwise you may run into unexpected routing issues.


## Fix URL Routes

We have had some odd and unexpected URL routing ambiguity for quite some time. In 0.12.0 we set out to fix this weirdness. As a result, you need to be aware of places which are using incorrect url routing aliases with `url_for`. Given this route:


```ruby
SampleApp.controllers :cap_alerts do
  get :index do
    "hello"
  end
end
```


The following strictness changes with `url` should be noted:


```ruby
# BEFORE
url(:cap_alerts, :index)   #=> "/cap_alerts"
url(:cap, :alerts, :index) #=> "/cap_alerts"
url(:cap, :alerts_index)   #=> "/cap_alerts"

# AFTER
url(:cap_alerts, :index)   #=> "/cap_alerts"
url(:cap, :alerts, :index) #=> UnrecognizedException
url(:cap, :alerts_index)   #=> UnrecognizedException
```


In general as long as you are accessing the url routes properly, this shouldn't cause any issues.


## Updated Route Names

We have also adjusted the route names slightly with this release:


```ruby
# BEFORE
route.name #=> :cap_alerts_index

# AFTER
route.name #=> :"cap_alerts index"
```


## Adjust Admin login_page Configuration

```ruby
class Admin < Padrino::Application
  # before
  set :login_page, "/admin/sessions/new"

  # after
  set :login_page, "/sessions/new"
```


Once you've followed this guide, we hope the transition from 0.11.X to 0.12.0 will be very smooth

