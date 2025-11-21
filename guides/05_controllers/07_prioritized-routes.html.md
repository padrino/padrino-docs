---
chapter: Controllers
title: Prioritized Routes
---

# Prioritized Routes

Padrino (0.10.0+) has added support for respecting route order in controllers
and also allows the developer to specify certain routes as less or more
"important" than others in the route recognition order. Consider two
controllers, the first with a "catch-all" route:

```ruby
# app/controllers/pages.rb
Demo::App.controllers :pages do
  get :show, map: '/*page' do
    'Catchall route'
  end
end

# app/controllers/projects.rb
Demo::App.controllers :projects do
  get :index do
    'Index'
  end
end
```

This wouldn't work by default because the second "/projects" endpoint would be
eclipsed by the "/*page" catch-all route and as such `projects` would not be
accessible. To solve this, you can do the following:

```ruby
# app/controllers/pages.rb
Demo::App.controllers :pages do
  # NOTE that this route is now marked as low priority
  get :show, map: '/*page', priority: :low do
    'Catchall route'
  end
end

# app/controllers/projects.rb
Demo::App.controllers :projects do
  get :index do
    'Index'
  end
end
```

When setting a routes priority to `:low`, this route is then recognized lower
than all "high" and "normal" priority routes. You are encouraged in cases where
there is ambiguity, to mark key routes as `priority: :high` or catch-all
routes as `priority: :low` in order to guarantee expected behavior.
