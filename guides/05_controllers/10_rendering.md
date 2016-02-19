---
chapter: Controllers
title: Rendering
---

# Rendering

Unlike Sinatra, Padrino supports automatic template engine lookups with:

```ruby
# searches for 'account/index.{erb,haml,...}
render 'account/index'
```

It will choose the first one that is discovered, without regards to the type of
rendering (erb, haml, slim). Otherwise you can explicitly specify the type of
rendering of your choice (erb, haml, slim).

```ruby
# will use example.haml
render :haml, 'account/index'
```

Padrino also automatically considers your current locale and/or content\_type.

```ruby
# app/controllers/example.rb
SimpleApp.controllers :admin do
  get :show, :with => :id, :provides => [:html, :js] do
    render "admin/show"
  end
end
```

When you visit the `:show` route with `I18n.locale == :ru` enabled, Padrino will
first try to look for “admin/show.ru.js.\*” if nothing matches that criteria, it
will try “admin/show.ru.\*” then “admin/show.js.\*”. As a last resort, if he
finds nothing matching your criteria, it will return “admin/show.erb” (or
admin/show.haml)
