---
chapter: Application Helpers
title: Form Helpers
---

# Form Helpers

Form helpers are the 'standard' form tag helpers you would come to expect when
building forms. A simple example of constructing a non-object form would be:

```haml
# app/views/example.haml
= form_tag '/destroy', :class => 'destroy-form', :method => 'delete' do
  = flash_tag(:notice)
  = field_set_tag do
    %p
      = label_tag :username, :class => 'first'
      = text_field_tag :username, :value => params[:username]
    %p
      = label_tag :password, :class => 'first'
      = password_field_tag :password, :value => params[:password]
    %p
      = label_tag :strategy
      = select_tag :strategy, :options => ['delete', 'destroy'], :selected => 'delete'
    %p
      = check_box_tag :confirm_delete
  = field_set_tag(:class => 'buttons') do
    = submit_tag "Remove"
```

## List of Form Helpers

- `form_tag(url, options={}, &block)`
  - Constructs a form without object based on options
  - Supports form methods 'put' and 'delete' through hidden field
  - `form_tag('/register', :class => 'example') { ... }`
- `field_set_tag(*args, &block)`
  - Constructs a field_set to group fields with given options
  - `field_set_tag(:class => 'office-set') { }`
  - `field_set_tag("Office", :class => 'office-set') { }`
- `error_messages_for(:record, options={})`
  - Constructs list html for the errors for a given object
  - `error_messages_for :user`
- `label_tag(name, options={}, &block)`
  - Constructs a label tag from the given options
  - `label_tag :username, :class => 'long-label'`
  - `label_tag(:username, :class => 'blocked-label') { ... }`
- `hidden_field_tag(name, options={})`
  - Constructs a hidden field input from the given options
  - `hidden_field_tag :session_key, :value => 'secret'`
- `text_field_tag(name, options={})`
  - Constructs a text field input from the given options
  - `text_field_tag :username, :class => 'long'`
- `text_area_tag(name, options={})`
  - Constructs a text area input from the given options
  - `text_area_tag :username, :class => 'long'`
- `password_field_tag(name, options={})`
  - Constructs a password field input from the given options
  - `password_field_tag :password, :class => 'long'`
- `number_field_tag(name, options={})`
  - Constructs a number field input from the given options
  - `number_field_tag :age, :class => 'long'`
- `telephone_field_tag(name, options={})`
  - Constructs a phone field input from the given options
  - `telephone_field_tag :mobile, :class => 'long'`
- `email_field_tag(name, options={})`
  - Constructs a email field input from the given options
  - `email_field_tag :email, :class => 'long'`
- `search_field_tag(name, options={})`
  - Constructs a search field input from the given options
  - `search_field_tag :query, :class => 'long'`
- `url_field_tag(name, options={})`
  - Constructs a url field input from the given options
  - `url_field_tag :image_source_url, :class => 'long'`
- `check_box_tag(name, options={})`
  - Constructs a checkbox input from the given options
  - `check_box_tag :remember_me, :checked => true`
- `radio_button_tag(name, options={})`
  - Constructs a radio button input from the given options
  - `radio_button_tag :gender, :value => 'male'`
- `select_tag(name, settings={})`
  - Constructs a select tag with options from the given settings
  - `select_tag(:favorite_color, :options => ['1', '2', '3'], :selected => '1')`
  - `select_tag(:more_color, :options => [['label', '1'], ['label2', '2']])`
  - `select_tag(:multiple_color, :options => ['1', '2', '3'], :multiple => true,
    :selected => ['1', '3'])`
- `file_field_tag(name, options={})`
  - Constructs a file field input from the given options
  - `file_field_tag :photo, :class => 'long'`
- `submit_tag(caption, options={})`
  - Constructs a submit button from the given options
  - `submit_tag "Create", :class => 'success'`
- `button_tag(caption, options={})`
  - Constructs an input (type => 'button') from the given options
  - `button_tag "Cancel", :class => 'clear'`
- `image_submit_tag(source, options={})`
  - Constructs an image submit button from the given options
  - `image_submit_tag "submit.png", :class => 'success'`
