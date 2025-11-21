---
chapter: Controllers
title: Custom Conditions
---

# Custom Conditions

Padrino has support for Sinatra's custom route conditions as well. This allows
you to apply custom condition checks to evaluate before a route is executed for
an incoming request:

```ruby
Demo::App.controllers :projects do
  def protect(*args)
    condition do
      unless username == 'foo' && password == 'bar'
        halt 403, 'Not Authorized'
      end
    end
  end

  get '/', protect: true do
    'Only foo can see this'
  end
end
```

Conditions can also be specified at the controller and route levels:

```ruby
# You can specify conditions to run for all routes:
Demo::App.controllers :projects, conditions: { protect: true } do
  def self.protect(protected)
    condition do
      halt 403, 'No secrets for you!' unless params[:key] == 's3cr3t'
    end if protected
  end

  # This route will only return "secret stuff" if the user goes to
  # `/private?key=s3cr3t`.
  get('/private') { 'secret stuff' }

  # And this one, too!
  get('/also-private') { 'secret stuff' }

  # But you can override the conditions for each route as needed.
  # This route will be publicly accessible without providing the
  # secret key.
  get :index, protect: false do
    'Welcome!'
  end
end
```

This gives the developer considerable power to construct arbitrarily complex
route conditions and apply them to any route within their application.
