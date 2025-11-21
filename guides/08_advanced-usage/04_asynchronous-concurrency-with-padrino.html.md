---
chapter: Advanced Usage
title: Asyncronous Concurrency
---

# Asynchronous Concurrency

Lately, the Ruby community has become fascinated by asynchronous and concurrent
web servers, the newest of which is called
[Goliath](http://www.igvita.com/2011/03/08/goliath-non-blocking-ruby-19-web-server
"Goliath"). This can be advantageous for your application especially if you have
a lot of traffic and slow IO or Database calls (like HTTP calls to external
APIs) since this substantially increases the number of clients your application
can serve per process.

This guide is dedicated to documenting how to achieve non-blocking, asynchronous
requests while still using Sinatra and Padrino. For a more detailed guide be
sure to checkout the
[Sinatra Synchrony](https://github.com/kyledrake/sinatra-synchrony "Sinatra
Synchrony") docs.

## Setup

Add the gem to you Gemfile:

```ruby
# Gemfile
gem "sinatra-synchrony"
```

And then add the synchrony library to your Padrino application:

```ruby
# app/app.rb
require 'sinatra/synchrony'

class DemoApp < Padrino::Application
  register Sinatra::Synchrony
end
```

And that is really all you need for the basics. Also, you may want to take a
look at [Rubinius](http://rubini.us "Rubinius") or [JRuby](http://jruby.org
"JRuby") ruby runtimes.

## Benchmarks

Added to Gemfile:

```ruby
# Gemfile
gem 'rest-client'
gem 'sinatra-synchrony'
gem 'faraday'
```

And the benchmark app:

```ruby
# app/app.rb
require 'sinatra/synchrony'
require 'rest-client'
require 'faraday'

Faraday.default_adapter = :em_synchrony

class DemoApp < Padrino::Application
  register Sinatra::Synchrony

  get '/' do
    Faraday.get 'http://google.com'
  end
end
```

And results with `ab`:

```
$ ab -c 100 -n 100 http://127.0.0.1:9292/
...
Time taken for tests:   0.256 seconds
```

For a perspective, this operation took 33 seconds without this extension in
thin.
