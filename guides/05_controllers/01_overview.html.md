---
chapter: Controllers
title: Overview
---

# Overview

Suppose we wanted to add routes to our Padrino application, and we want to
organize a set of related routes within a more structured grouping. Padrino has
the notion of a ‘controller’ block which can group related routes and make URL
generation much easier. Simply add a `controllers.rb` file or `app/controllers`
folder and create a file as such:

```ruby
# app/controllers/main.rb or controllers.rb

SimpleApp.controller do
  # url_for(:admin, :other, :id => 5, :name => "hey")
  #   => "/admin/other/5/hey"
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
