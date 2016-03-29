---
chapter: Advanced Usage
title: 3rd Party Plugins
---

# 3rd Party Plugins

Padrino is a modular framework. As such, you can leverage other libraries such
as Sinatra libraries which complement Padrino quite well.

## Rendering JSON with sinatra-contrib

First you must reference
[sinatra-contrib](https://github.com/sinatra/sinatra-contrib) in your Gemfile:

```ruby
# Gemfile

source 'https://rubygems.org'

# Project requirements
gem 'rake'

# Component requirements
gem 'haml'

# Test requirements

# Padrino Stable Gem
gem 'padrino', '0.13.1'

# Or Padrino Edge
# gem 'padrino', :github => 'padrino/padrino-framework'

# Or Individual Gems
# %w(core support gen helpers cache mailer admin).each do |g|
#   gem 'padrino-' + g, '0.13.1'
# end

gem 'sinatra-contrib'
```

You may use the #json method after you have registered the sinatra helper:

```ruby

module MyJsonApp
  class App < Padrino::Application
    register Padrino::Mailer
    register Padrino::Helpers

    helpers Sinatra::JSON

    enable :sessions

    get '/' do
      hash = {foo: 'bar'}
      json hash
    end
  end
end
```
