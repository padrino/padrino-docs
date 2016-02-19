---
chapter: Application Helpers
title: Asset Helpers
---

# Asset Helpers

Asset helpers are intended to help insert useful html onto a view template such
as ‘flash’ notices, hyperlinks, mail\_to links, images, stylesheets and
javascript. An example of their uses would be on a simple view template:

```haml
# app/views/example.haml
...
%head
  = stylesheet_link_tag 'layout'
  = javascript_include_tag 'application'
  = favicon_tag 'images/favicon.png'
%body
  ...
  = flash_tag :notice
  %p= link_to 'Blog', '/blog', :class => 'example'
  %p Mail me at #{mail_to 'fake@faker.com', "Fake Email Link", :cc => "test@demo.com"}
  %p= image_tag 'padrino.png', :width => '35', :class => 'logo'
```

By default, all ‘assets’ including images, scripts, and stylesheets have a
timestamp appended at the end to clear the stale cache for the item when
modified. To disable this, simply put the setting `disable :asset_stamp` in your
application configuration within `app/app.rb`.

## List of Asset Helpers

- `flash_tag(kind, options={})`
  - Creates a div to display the flash of given type if it exists
  - `flash_tag(:notice, :class => ‘flash’, :id => ‘flash-notice’)`
- `link_to(*args, &block)`
  - Creates a link element with given name, url and options
  - `link_to ‘click me’, ‘/dashboard’, :class => ‘linky’`
  - `link_to ‘click me’, ‘/dashboard’, :class => ‘linky’, :if => @foo.present?`
  - `link_to ‘click me’, ‘/dashboard’, :class => ‘linky’, :unless => @foo.blank?`
  - `link_to ‘click me’, ‘/dashboard’, :class => ‘linky’, :unless => :current`
  - `link_to(‘/dashboard’, :class => ‘blocky’) { …content… }`
- `mail_to(email, caption=nil, mail_options={})`
  - Creates a mailto link tag to the specified email\_address
  - `mail_to “me@demo.com”`
  - `mail_to “me@demo.com”, “My Email”, :subject => “Feedback”, :cc => ‘test@demo.com’`
- `image_tag(url, options={})`
  - Creates an image element with given url and options
  - `image_tag(‘icons/avatar.png’)`
- `stylesheet_link_tag(*sources)`
  - Returns a stylesheet link tag for the sources specified as arguments
  - `stylesheet_link_tag ‘style’, ‘application’, ‘layout’`
- `javascript_include_tag(*sources)`
  - Returns an html script tag for each of the sources provided.
  - `javascript_include_tag ‘application’, ‘special’`
- `favicon_tag(source, options={})`
  - Returns a favicon tag for the header for the source specified.
  - `favicon_tag ‘images/favicon.ico’, :type => ‘image/ico’`
- `feed_tag(mime,source, options={})`
  - Returns a feed tag for the mime and source specified
  - `feed_tag :atom, url(:blog, :posts, :format => :atom), :title => “ATOM”`
