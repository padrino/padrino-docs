---
chapter: Controllers
title: Overview
---

# Overview

Suppose we wanted to add routes to our Padrino application, and we want to
organize a set of related routes within a more structured grouping. Padrino has
the notion of a 'controller' block which can group related routes and make URL
generation much easier. Simply add a `controllers.rb` file or `app/controllers`
folder and create a file as such:

```ruby
# app/controllers/main.rb or controllers.rb

SimpleApp.controller do
  get "/test" do
    "Text to return"
  end

  get "/sample" do
    "Sample Route"
  end
end
```

In this case, the controller merely acts as a structured grouping mechanism to
allow better organization of routes. Controllers actually have other benefits as
well when used in conjunction with the enhanced Padrino routing system.


- [Routing](/guides/controllers/routing "Routing")
- [Layouts](/guides/controllers/layouts "Layouts")
- [Provides Formats](/guides/controllers/provides-formats "Provides Formats")
- [Route Filters](/guides/controllers/route-filters "Route Filters")
- [Prioritized Routes](/guides/controllers/prioritized-routes "Prioritized Routes")
- [Custom Conditions](/guides/controllers/custom-conditions "Custom Conditions")
- [Parsing Params](/guides/controllers/parsing-params "Parsing Params")
- [Rendering](/guides/controllers/rendering "Rendering")
- [Sessions](/guides/controllers/sessions "Sessions")
- [Params Whitelisting](/guides/controllers/params-whitelisting "Params Whitelisting")

