---
chapter: Generators
title: Plugins
---

# Plugins

The Plugin Generator allows you to create Padrino projects based on a template
file that contains all the necessary actions needed to create the project.
Plugins can also be executed within an existing Padrino application. The plugin
generator provides a simple DSL in addition with leveraging Thor to make
generating projects a breeze!

```shell
$ padrino g project my_project --template path/to/my_template.rb
```

This will generate a project based on the template file provided. You can also
generate a project based on a remote url such as a
[gist](https://gist.github.com/ "gist") for an additional level of convenience:

```shell
$ padrino g project my_project --template https://gist.github.com/356156
```

You can also execute template files directly from
[the official templates repo](http://github.com/padrino/padrino-recipes/tree/master/templates
"the official templates repo"):

```shell
$ padrino g project my_project --template sampleblog
```

You can also apply templates as plugins to existing Padrino applications:

```shell
$ cd path/to/existing/padrino/app
$ padrino g plugin path/to/my_plugin.rb
```

You can also execute plugin files directly from
[the official plugins repo](https://github.com/padrino/padrino-recipes/tree/master/plugins/
"the official plugins repo"):

```shell
$ cd path/to/existing/padrino/app
$ padrino g plugin hoptoad
```

You can even get a list of available plugins with the following command:

```shell
$ padrino g plugin --list
```

A simple template (plugin) file might look like this:

```ruby
# my_template.rb

project :test => :rspec, :orm => :activerecord
generate 'model', 'account username:string password:string'
generate 'model', 'post title:string body:text'
generate 'controller', 'posts get:index get:new post:new'
generate 'controller', 'users get:index'
generate 'migration', 'AddEmailToAccount email:string'
require_dependencies 'nokogiri'

git :init
git :add, "."
git :commit, "-m 'initial commit'"

inject_into_file 'app/models/post.rb','#Hello', :after => "end\n"
rake 'ar:create ar:migrate'
initializer :test, '# Example'

git :add, '.'
git :commit, "- m 'second commit'"
```

Keep in mind that the template file is pure Ruby and has full access to
[all available thor actions](https://github.com/erikhuda/thor/blob/master/lib/thor/actions.rb
"thor actions").
