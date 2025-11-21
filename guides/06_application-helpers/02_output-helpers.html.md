---
chapter: Application Helpers
title: Output Helpers
---

# Output Helpers

Output helpers are a collection of important methods for managing, capturing and
displaying output in various ways and is used frequently to support higher-level
helper functions. There are three output helpers worth mentioning:
`content_for`, `capture_html`, and `concat_content`

The `content_for` functionality supports capturing content and then rendering
this into a different place such as within a layout. One such popular example is
including assets onto the layout from a template:

```erb
# app/views/site/index.erb
# ...
<% content_for :assets do %>
  <%= stylesheet_link_tag 'index', 'custom' %>
<% end %>
# ...
```

Added to a template, this will capture the includes from the block and allow
them to be yielded into the layout:

```erb
# app/views/layout.erb
<head>
  <title>Example</title>
  <%= stylesheet_link_tag 'style' %>
  <%= yield_content :assets %>
</head>
```

This will automatically insert the contents of the block (in this case a
stylesheet include) into the location the content is yielded within the layout.

You can also check if a `content_for` block exists for a given key using
`content_for?`:

```erb
# app/views/layout.erb
<% if content_for?(:assets) %>
  <div><%= yield_content :assets %></div>
<% end %>
```

The `capture_html` and the `concat_content` methods allow content to be
manipulated and stored for use in building additional helpers accepting blocks
or displaying information in a template. One example is the use of these in
constructing a simplified `form_tag` helper which accepts a block.

```ruby
# form_tag '/register' do ... end
def form_tag(url, options = {}, &block)
  # ... truncated ...
  inner_form_html = capture_html(&block)
  concat_content '<form>' + inner_form_html + '</form>'
end
```

This will capture the template body passed into the `form_tag` block and then
append the content to the template through the use of `concat_content`. Note
have been built to work for both haml and erb templates using the same syntax.

## List of Output Helpers

- `content_for(key, &block)`
  - Capture a block of content to be rendered at a later time.
  - Existence can be checked using the `content_for?(key)` method.
  - `content_for(:head) { ...content... }`
  - Also supports arguments passed to the content block
  - `content_for(:head) { |param1, param2| ...content... }`
- `yield_content(key, *args)`
  - Render the captured content blocks for a given key.
  - `yield_content :head`
  - Also supports arguments yielded to the content block
  - `yield_content :head, param1, param2`
- `capture_html(*args, &block)`
  - Captures the html from a block of template code for erb or haml
  - `capture_html(&block)` => "...html..."
- `concat_content(text = '')`
  - Outputs the given text to the templates buffer directly in erb or haml
  - `concat_content("This will be output to the template buffer in erb or
    haml")`
