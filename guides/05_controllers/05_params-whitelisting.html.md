---
chapter: Controllers
title: Params Whitelisting
---

# Params Whitelisting

We can provide a set of whitelisted params for a given request with:

```ruby
Demo::App.controllers :admin do
  get :show, map: "show", params: [:foo, :bar] do
    # Only accepts params "foo" and "bar". All other params are removed.
  end
end
```
