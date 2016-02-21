---
chapter: Controllers
title: Parsing Params
---

# Parsing Params

Padrino is often used for web service applications. One common need these
applications have is to parse incoming messages, typically JSON or XML. This
data will come as part of the request's body instead of the typical form data
approach, i.e. url parameters or multipart form data.

Here's when [Rack::Parser](https://github.com/achiu/rack-parser "Rack::Parser")
comes in handy since it will do just that. In `app/app.rb` or in `config.ru`
just add:

```ruby
use Rack::Parser, :content_types => {
  'application/json'  => Proc.new { |body| ::MultiJson.decode body }
}
```

Now all of your controllers will have the request's body JSON object parse as
inside `params` and you would be able to do something along the lines of:

```ruby
post '/people'
  order = Person.new(name: params['name'] )
  # ...
end
```

Have a look at
[this great Sinatra recipe](http://recipes.sinatrarb.com/p/middleware/rack_parser?#article
"this great Sinatra recipe") for a more detailed guide of how this middleware
works.
