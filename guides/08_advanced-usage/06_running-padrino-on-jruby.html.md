---
chapter: Advanced Usage
title: Running Padrino on JRuby
---

# Running Padrino on JRuby

You can run Padrino (0.9.29 ... 0.10.5 is tested) on JRuby 1.7.27

--------------------------------------------------------------------------------

## Install on JRuby

You can easily install Padrino on jruby when you use
[RVM](https://rvm.io/rvm/install "RVM"):

```shell
$ rvm install jruby-1.7.27
$ rvm use --create jruby-1.7.27@padrino
$ gem install bundler
$ gem install padrino -v=0.10.5
```

Create Padrino project just as you do when using MRI or REE:

```shell
$ padrino g project jrack-test -e erb
```

`cd ./jrack-test` and you should edit `Gemfile`:

```ruby
# JRuby deployment requirements
# please add these lines...
gem 'jruby-openssl'
gem 'jruby-rack'
gem 'warbler'
```

Now you can go:

```shell
$ bundle
```

Then, create the test controller:

```shell
$ padrino gen controller index get:index get:hello get:show_path
```

A controller sample is here:

```ruby
# app/controllers/index.rb

JrackTest::App.controllers :index do
  get :index do
    "Hello, JPadrino!"
  end

  get :hello, :map => '/:id' do
    "Hello, #{params[:id]}!"
  end

  get :show_path, :map => '/show-path/*urls' do
    "You accessed: #{params[:urls].inspect}"
  end
end
```

Then run:

```shell
$ padrino s
```

To run JRuby on 1.9 compat mode:

```shell
alias padrino='jruby --1.9 -S padrino'
padrino start
```

You can access <http://localhost:3000> as you run padrino on MRI...

--------------------------------------------------------------------------------

## How to create WAR

Now you should install the `warbler` gem with `$ gem install warbler`, so you can:

```shell
$ warble config
```

Edit `config/warble.rb` if you want to apply some customizations. You can access
[JRuby-Rack official README](https://github.com/jruby/jruby-rack) and
[Warbler rdoc](http://www.rubydoc.info/github/jruby/warbler).

For example, if you want to deploy the app to server root directory, just add to
`config/warble.rb`:

```ruby
config.jar_name = "jrack-test"
```

Deploying with JRuby on 1.9 compat mode:

```ruby
config.webxml.jruby.compat.version = "1.9"
```

If you are ready, run:

```shell
$ warble war
```

You would get `jrack-test.war` (the same name as your project directory name),
and you can deploy this war file to tomcat! I tested on tomcat 6.0.20, and it
works well with quick response.
