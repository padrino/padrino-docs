---
chapter: Application Helpers
title: Format Helpers
---

# Format Helpers

Format helpers are several useful utilities for manipulating the format of text
to achieve a goal. The four format helpers are `escape_html`,
`distance_of_time_in_words`, `time_ago_in_words`, and `js_escape_html`.

The `escape_html` and `js_escape_html` function are for taking an html string
and escaping certain characters. `escape_html` will escape ampersands, brackets
and quotes to their HTML/XML entities. This is useful to sanitize user content
before displaying this on a template. `js_escape_html` is used for passing
javascript information from a js template to a javascript function.

```ruby
escape_html('<hello>&<goodbye>') # => &lt;hello&gt;&amp;&lt;goodbye&gt;
```

There is also an alias for `escape_html` called `h` for even easier usage within
templates.

Format helpers also includes a number of useful text manipulation functions such
as `simple_format`, `pluralize`, `word_wrap`, and `truncate`.

```ruby
simple_format("hello\nworld") # => "<p>hello<br/>world</p>"
pluralize(2, 'person') => '2 people'
word_wrap('Once upon a time', :line_width => 8) => "Once upon\na time"
truncate("Once upon a time in a world far far away", :length => 8) => "Once upon..."
truncate_words("Once upon a time in a world far far away", :length => 4) => "Once upon a time..."
highlight('Lorem dolor sit', 'dolor') => "Lorem <strong class="highlight">dolor</strong> sit"
```

These helpers can be invoked from any route or view within your application.

## List of Format Helpers

- `simple_format(text, html_options)`
  - Returns text transformed into HTML using simple formatting rules.
  - `simple_format("hello\nworld")` => `"<p>hello<br/>world</p>"`
- `pluralize(count, singular, plural = nil)`
  - Attempts to pluralize the singular word unless count is 1.
  - `pluralize(2, 'person')` => '2 people'
- `word_wrap(text, *args)`
  - Wraps the text into lines no longer than line_width width.
  - `word_wrap('Once upon a time', :line_width => 8)` => "Once upon\na time"
- `truncate(text, *args)`
  - Truncates a given text after a given `:length` if text is longer than `:length`
    (defaults to 30).
  - `truncate("Once upon a time in a world far far away", :length => 8)` =>
    "Once upon..."
- `truncate_words(text, *args)`
  - Truncates a given text after a given :length of total words (defaults to
    30).
  - `truncate_words("Once upon a time in a world far far away", :length => 4)
    => "Once upon a time..."`
- `highlight(text, words, *args)`
  - Highlights one or more words everywhere in text by inserting it into a
    `:highlighter` string.
  - `highlight('Lorem ipsum dolor sit amet', 'dolor')`
- `escape_html` (alias `h` and `h!`)
  - (from RackUtils) Escape ampersands, brackets and quotes to their HTML/XML
    entities.
- `strip_tags(html)`
  - Remove all html tags and return only a clean text.
- `distance_of_time_in_words(from_time, to_time = 0)`
  - Returns relative time in words referencing the given date
  - `distance_of_time_in_words(2.days.ago)` => "2 days"
  - `distance_of_time_in_words(5.minutes.ago)` => "5 minutes"
  - `distance_of_time_in_words(2800.days.ago)` => "over 7 years"
- `time_ago_in_words(from_time)`
  - Returns relative time in words from the current date
  - `time_ago_in_words(2.days.ago)` => "2 days"
  - `time_ago_in_words(1.day.from_now)` => "tomorrow"
- `js_escape_html(html_content)`
  - Escapes html to allow passing information to javascript. Used for passing
    data inside an ajax .js.erb template.
  - `js_escape_html("<h1>Hey</h1>")`
