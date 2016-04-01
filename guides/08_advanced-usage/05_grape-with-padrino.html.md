---
chapter: Advanced Usage
title: Grape with Padrino
---

# Grape with Padrino

Create your new project. It can be a regular one:

```shell
$ padrino g project grappe
```

Or a lean one if you don't want any Sinatra apps in it:

```shell
$ padrino g project grappe --lean
```

Go to the new `grappe` folder and add `gem 'grape'` to `Gemfile`. Then install the
required gems:

```shell
$ bundle
```

Create file `api/api.rb` and put your Grape code there:

```ruby
module Grappe
  class API < Grape::API
    get :hello do
      { hello: 'grape' }
    end

    get 'status' do
      cookies[:status_count] ||= 0
      cookies[:status_count] = cookies[:status_count].to_i + 1
      { status_count: cookies[:status_count] }
    end
  end
end
```

Go to file `config/apps.rb` and add to the end of it:

```ruby
Padrino.mount('API', :app_file => Padrino.root('api/api.rb'), :app_class => 'Grappe::API').to('/master')
```

Now you can run `rackup` from your `gapp` folder and visit
<http://127.0.0.1:3000/master/hello> or <http://127.0.0.1:3000/master/status>

```html
<?xml version="1.0" encoding="UTF-8"?>
<hash>
  <hello>grape</hello>
</hash>

<?xml version="1.0" encoding="UTF-8"?>
<hash>
  <status-count type="integer">1</status-count>
</hash>
```

You can find the code on [Github](https://github.com/padrino/grape-example "Github").
