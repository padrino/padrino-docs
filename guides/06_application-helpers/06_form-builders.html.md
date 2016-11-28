---
chapter: Application Helpers
title: Form Builders
---

# Form Builders

Form builders are full-featured objects allowing the construction of complex
object-based forms using a simple, intuitive syntax.

A `form_for` using these basic fields might look like:

```haml
= form_for @user, '/register', :id => 'register' do |f|
  = f.error_messages
  %p
    = f.label :username, :caption => "Nickname"
    = f.text_field :username
  %p
    = f.label :email
    = f.text_field :email
  %p
    = f.label :password
    = f.password_field :password
  %p
    = f.label :is_admin, :caption => "Admin User?"
    = f.check_box :is_admin
  %p
    = f.label :color, :caption => "Favorite Color?"
    = f.select :color, :options => ['red', 'black']
  %p
    = fields_for @user.location do |location|
      = location.text_field :street
      = location.text_field :city
  %p
    = f.submit "Create", :class => 'button'
```

## List of Form Builder Helpers

- `form_for(object, url, settings={}, &block)`
  - Constructs a form using given or default `form_builder`
  - Supports form methods 'put' and 'delete' through hidden field
  - Defaults to `StandardFormBuilder` but you can
  [easily create your own](/guides/application-helpers/custom-form-builders "Custom Form Builders")!
  - `form_for(@user, '/register', :id => 'register') { |f| ...field-elements...  }`
  - `form_for(:user, '/register', :id => 'register') { |f| ...field-elements...  }`
- `fields_for(object, settings={}, &block)`
  - Constructs fields for a given object for use in an existing form
  - Defaults to StandardFormBuilder but you can easily create your own!
  - `fields_for @user.assignment do |assignment| ... end`
  - `fields_for :assignment do |assigment| ... end`

The following are fields provided by `AbstractFormBuilder` that can be used
within a `form_for` or `fields_for`:

- `error_messages(options={})`
  - Displays list html for the errors on form object
  - `f.error_messages`
- `label(field, options={})`
  - `f.label :name, :class => 'long'`
- `text_field(field, options={})`
  - `f.text_field :username, :class => 'long'`
- `check_box(field, options={})`
  - Uses hidden field to provide a 'unchecked' value for field
  - `f.check_box :remember_me, :uncheck_value => 'false'`
- `radio_button(field, options={})`
  - `f.radio_button :gender, :value => 'male'`
- `hidden_field(field, options={})`
  - `f.hidden_field :session_id, :class => 'hidden'`
- `text_area(field, options={})`
  - `f.text_area :summary, :class => 'long'`
- `password_field(field, options={})`
  - `f.password_field :secret, :class => 'long'`
- `number_field(field, options={})`
  - `f.number_field :age, :class => 'long'`
- `telephone_field(field, options={})`
  - `f.telephone_field :mobile, :class => 'long'`
- `email_field(field, options={})`
  - `f.email_field :email, :class => 'long'`
- `search_field(field, options={})`
  - `f.search_field :query, :class => 'long'`
- `url_field(field, options={})`
  - `f.url_field :image_source, :class => 'long'`
- `file_field(field, options={})`
  - `f.file_field :photo, :class => 'long'`
- `select(field, options={})`
  - `f.select(:state, :options => ['California', 'Texas', 'Wyoming'])`
  - `f.select(:state, :collection => @states, :fields => [:name, :id])`
  - `f.select(:state, :options => [...], :include_blank => true)`
- `submit(caption, options={})`
  - `f.submit "Update", :class => 'long'`
- `image_submit(source, options={})`
  - `f.image_submit "submit.png", :class => 'long'`
