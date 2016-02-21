---
chapter: Application Helpers
title: Standard Form Builder
---

# Standard Form Builder

There is also an additional StandardFormBuilder which builds on the abstract
fields that can be used within a form_for.

A `form_for` using these standard fields might be:

```haml
# app/views/example.haml
= form_for @user, '/register', :id => 'register' do |f|
    = f.error_messages
    = f.text_field_block :name, :caption => "Full name"
    = f.text_field_block :email
    = f.check_box_block  :remember_me
    = f.select_block     :fav_color, :options => ['red', 'blue']
    = f.password_field_block :password
    = f.submit_block "Create", :class => 'button'
```

and would generate this html (with each input contained in a paragraph and
containing a label):

```html
<form id="register" action="/register" method="post">
  <label for="user_name">Full name:</label>
  <input type="text" id="user_name" name="user[name]" />
    ...omitted...
  <input type="submit" value="Create" class="button" />
</form>
```

## List of Standard Form Builder Helpers

The following are fields provided by StandardFormBuilder that can be used within
a form_for or fields_for:

- `text_field_block(field, options={}, label_options={})`

  - `text_field_block(:nickname, :class => 'big', :caption => "Username")`

- `text_area_block(field, options={}, label_options={})`

  - `text_area_block(:about, :class => 'big')`

- `password_field_block(field, options={}, label_options={})`

  - `password_field_block(:code, :class => 'big')`

- `file_field_block(field, options={}, label_options={})`

  - `file_field_block(:photo, :class => 'big')`

- `check_box_block(field, options={}, label_options={})`

  - `check_box_block(:remember_me, :class => 'big')`

- `select_block(field, options={}, label_options={})`

  - `select_block(:country, :option => ['USA', 'Canada'])`

- `submit_block(caption, options={})`

  - `submit_block(:username, :class => 'big')`

- `image_submit_block(source, options={})`

  - `image_submit_block('submit.png', :class => 'big')`
