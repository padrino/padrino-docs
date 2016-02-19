---
chapter: Application Helpers
title: Render Helpers
---

# Render Helpers

This component provides a number of rendering helpers making the process of
displaying templates a bit easier. This plugin also has support for useful
additions such as partials (with support for `:collection`) for the templating
system.

Using render plugin helpers is extremely simple. If you want to render an erb
template in your view path:

```ruby
render :erb, 'path/to/erb/template'
```

or using haml templates works just as well:

```ruby
render :haml, 'path/to/haml/template'
```

There is also a method which renders the first view matching the path and
removes the need to define an engine:

```ruby
render 'path/to/any/template'
```

It is worth noting these are mostly for convenience. With nested view file paths
in Sinatra, this becomes tiresome:

```ruby
haml :"the/path/to/file"
erb "/path/to/file".to_sym
```

Finally, we have the all-important partials support for rendering mini-templates
onto a page:

```ruby
partial 'photo/item', :object => @photo, :locals => { :foo => 'bar' }
partial 'photo/item', :collection => @photos
```

This works as you would expect and also supports the collection counter inside
the partial `item_counter`

```ruby
# /views/photo/_item.haml
# Access to collection counter with <partial_name>_counter i.e item_counter
# Access the object with the partial_name i.e item
```

## List of Render Helpers

- `render(engine, data, options, locals)`
    - Renders the specified template with the given options
    - `render ‘user/new’`
    - `render :erb, ‘users/new’, :layout => false`

- `partial(template, *args)`
    - Renders the html related to the partial template for object or collection
    - `partial ‘photo/item’, :object => @photo, :locals => { :foo => ‘bar’ }`
    - `partial ‘photo/item’, :collection => @photos`
