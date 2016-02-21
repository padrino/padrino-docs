---
chapter: Controllers
title: Route Filters
---

# Route Filters

Before filters are evaluated before each request within the context of the
request and can modify the request and response. Instance variables set in
filters are accessible by routes and templates:

```ruby
before do
  @note = 'Hi!'
end
```

After filters are evaluated after each request within the context of the request
and can also modify the request and response. Instance variables set in before
filters and routes are accessible by after filters:

```ruby
after do
  puts @note
end
```

This is now standard in Sinatra, but Padrino adds support for filters being
_scoped by controller_ which means that unlike Sinatra in which a filter is
global, in Padrino you can run different filters for each controller:

```ruby
SimpleApp.controllers :posts do
  before { @foo = "bar" }
  get("/posts") { render :haml, "Has access to @foo variable" }
end

SimpleApp.controllers :accounts do
  before { @bar = "foo" }
  get("/accounts") { render :haml, "Has access to @bar variable" }
end
```

This allows for more fine-grained filters and prevents the need to have
unnecessary filters running on every route. As of Padrino 0.10.0, there is also
a much more powerful route selection system that has been setup:

```ruby
# app/controllers/example_controller.rb
DemoApp.controller :example do
  # Based on a symbol
  before :index do
    # Code here to be executed
  end

  # Based on a symbol, regexp and string all in one
  before :index, /main/, '/example' do
    # Code here to be executed
  end

  # Also filter by excluding an action
  before :except => :index do
    # Code here to be executed
  end

  get :index do
    # ...
  end
end
```

This gives developers a lot more flexibility when running filters and enables
much more selective execution in a convenient way.
