---
chapter: Controllers
title: Layouts
---

# Layouts

With Padrino, a custom layout can be specified or the layout can be disabled
altogether:

```ruby
class SimpleApp < Padrino::Application
  # Disable layouts
  disable :layout

  # Use the layout located in views/layouts/custom.haml
  layout :custom
end
```

Note that layouts are *scoped by controller*, so you can apply different layouts
to different controllers:

```ruby
SimpleApp.controllers :posts do
  # Apply a layout for routes in this controller
  # Layout file would be in 'app/views/layouts/posts.haml'
  layout :posts
  get("/posts") { render :haml, "Uses posts layout" }
end

SimpleApp.controllers :accounts do
  # Padrino allows you to apply a different layout for this controller
  # Layout file would be in 'app/views/layouts/accounts.haml'
  layout :accounts
  get("/accounts") { render :haml, "Uses accounts layout" }
end
```

If necessary, you also can overwrite the layout for a given route:

```ruby
SimpleApp.controllers :admin do
  get :index do
    render "admin/index", :layout => :admin
  end

  get :show, :with => :id do
    render "admin/show", :layout => false
  end
end
```
