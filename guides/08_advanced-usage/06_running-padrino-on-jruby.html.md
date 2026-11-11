---
chapter: Advanced Usage
title: Running Padrino on JRuby
---

# Running Padrino on JRuby

You can run Padrino on JRuby. Padrino 0.18.5 is tested on JRuby 10.1.

--------------------------------------------------------------------------------

## Install on JRuby

You can easily install Padrino on jruby when you use
[RVM](https://rvm.io/rvm/install "RVM"):

```shell
$ rvm install jruby
$ rvm use --create jruby@padrino
$ gem install bundler
$ gem install padrino -v=0.18.5
```

Create Padrino project just as you do when using MRI:

```shell
$ padrino g project jrack-test -e erb
```

`cd ./jrack-test` and now you can go:

```shell
$ bundle install && bundle binstubs --all
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

  get :hello, map: '/:id' do
    "Hello, #{params[:id]}!"
  end

  get :show_path, map: '/show-path/*urls' do
    "You accessed: #{params[:urls].inspect}"
  end
end
```

Then run:

```shell
$ padrino s
```

You can access <http://localhost:3000> as you run padrino on MRI...

--------------------------------------------------------------------------------

## Deploying on JRuby

[Warbler](https://github.com/jruby/warbler "Warbler") packages an app as a WAR
file with [JRuby-Rack](https://github.com/jruby/jruby-rack "JRuby-Rack"),
which doesn't support Rack 3. Padrino 0.18 needs Rack 3, so a WAR built from a
Padrino 0.18 project fails to start (`cannot load such file -- rack/chunked`).
Serve the project with a Rack server that runs on JRuby instead, such as Puma.
Add it to your `Gemfile`:

```ruby
gem 'puma'
```

Then run:

```shell
$ bundle install
$ padrino start -a puma
```
