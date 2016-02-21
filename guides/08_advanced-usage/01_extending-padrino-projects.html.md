---
chapter: Advanced Usage
title: Extending Padrino Projects
---

# Extending Padrino Projects

As you being building real projects with Padrino, you will quickly require
additional functionality not built into Padrino itself. Thankfully finding and
using modular libraries that add additional functionality to your Sinatra and
Padrino applications is quite painless.

## Managing Dependencies with Bundler

In order to manage dependencies for a project, Padrino relies on another gem
called [Bundler](http://bundler.io/ "Bundler"). A default Padrino `Gemfile`
looks akin to this:

```ruby
# Gemfile
source 'https://rubygems.org'

# Project requirements
gem 'rake'

# ...more gems...

# Padrino Stable Gem
gem 'padrino', '0.13.0'
```

All dependencies and libraries required for your project should be declared in
the Bundler `Gemfile` which is generated automatically with every Padrino
application. Once the dependencies have been declared, simply run Bundler's
install command:

```shell
$ bundle install
```

This will resolve and install all the required libraries. Check out the
[Bundler documentation](http://bundler.io/v1.11/man/bundle.1.html "Bundler
documentation") for more details about how this works.

## Padrino Recipes

The best extensions to look for are those that have already been included as
"recipes" in our [padrino-recipes](https://github.com/padrino/padrino-recipes
"padrino-recipes") repository. Any recipe included there represents a single
command installation of the specified functionality. For instance, suppose you
want to setup pagination in your application for a resource. Installing the
[will_paginate](https://github.com/mislav/will_paginate "will paginate") gem is
as simple as applying the recipe:

```shell
$ padrino g plugin will_paginate
```

This will install that gem into your project (and Gemfile) automatically.

## Discovering Libraries

If you can't find a recipe in the
[padrino-recipes](http://github.com/padrino/padrino-recipes "padrino-recipes")
repository, then be sure to search for Rack middlewares or Sinatra compatible
libraries to use in your app.

- [Rack Middlewares](https://github.com/rack/rack/wiki/List-of-Middleware "Rack
  Middlewares")
- [Sinatra Extensions](http://www.sinatrarb.com/extensions-wild.html "Sinatra
  Extensions")
- [Padrino Extensions](https://github.com/padrino/padrino-framework/wiki/Extensions
  "Padrino Extensions")
- [Padrino Integrations](https://github.com/padrino/padrino-framework/wiki/Integrations
  "Padrino Integrations")

And, of course, never underestimate searching [GitHub](https://github.com
"GitHub") to find Rack or Sinatra compatible repositories. Any
Rack/Sinatra/Padrino library will generally work seamlessly in Padrino projects.
Consider [adding a recipe](http://github.com/padrino/padrino-recipes "adding a
recipe") for your favorite extensions!
