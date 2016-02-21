---
chapter: Application Helpers
title: Tag Helpers
---

# Tag Helpers

Tag helpers are the basic building blocks used to construct html 'tags' within a
view template. There are three major functions for this category: `tag`,
`content_tag` and `input_tag`.

The tag and `content_tag` are for building arbitrary html tags with a name and
specified options. If the tag contains 'content' within then `content_tag` is
used. For example:

```erb
tag(:br, :style => ‘clear:both’) # => <br style="clear:both" />
content_tag(:p, "demo", :class => ‘light’) # => <p class="light">demo</p>
```

The `input_tag` is used to build tags that are related to accepting input from
the user:

```erb
input_tag :text, :class => "demo" # => <input type='text' class='demo' />
input_tag :password, :value => "secret", :class => "demo"
```

Note that all of these accept html options and result in returning a string
containing html tags.

## List of Tag Helpers

- `tag(name, options=nil, open=false)`

  - Creates an html tag with the given name and options
  - `tag(:br, :style => 'clear:both', :open => true)` => `<br
    style="clear:both">`

- `content_tag(name, content, options=nil, &block)`

  - Creates an html tag with given name, content and options
  - `content_tag(:p, "demo", :class => 'light')` => `<p class="light">demo</p>`
  - `content_tag(:p, :class => 'dark') { ...content... }` => `<p
    class="dark">...content...</p>`

- `input_tag(type, options = {})`

  - Creates an html input field with given type and options
  - `input_tag :text,     :class => "demo"`
  - `input_tag :password, :value => "secret", :class => "demo"`
