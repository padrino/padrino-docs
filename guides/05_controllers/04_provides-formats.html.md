---
chapter: Controllers
title: Provides Format
---

# Provides Formats

With Padrino you can simply declare which formats a request will respond to by
using the `provides` route configuration:

```ruby
Demo::App.controllers :admin do
  get :show, :with => :id, :provides => :js do
    # url is generated as "/admin/show/#{params[:id]}.#{params[:format]}"
    # url_for(:admin, :show, :id => 5, :format => :js) => "/admin/show/5.js"
  end

  get :other, :with => [:id, :name], :provides => [:html, :json] do
    case content_type
      when :js    then ... end
      when :json  then ... end
    end
  end
end
```

These formatted route paths can be accessed easily using `url_for` and then
`format` option:

```haml
= link_to 'admin show page', url_for(:admin, show, :id => 25, :format => :js)
= link_to 'admin other page', url_for(:admin, index, :id => 25, :name => :foo)
= link_to 'other json', url(:admin, index, :id => 25, :name => :foo, :format => :json)
```
