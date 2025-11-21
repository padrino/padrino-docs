---
chapter: Application Helpers
title: Nested Object Form Support
---

# Nested Object Form Support

Nested This allows forms to have arbitrarily complex nested forms that can
build multiple related objects together. Let's take a simple example of a person
with an address. Here are the related pseudo models:

```ruby
class Person < ORM::Base
  has_many :addresses, class_name: 'Address'
  accepts_nested_attributes_for :addresses, allow_destroy: true
end

class Address < ORM::Base
  belongs_to :person
end
```

The model declarations are dependent on your chosen ORM. Check the documentation
to understand how to declare nested attributes in your given ORM component.
Given those models and enabling nested attributes for the association, the
following view will allow nested form creation:

```haml
= form_for @person, '/person/create' do |f|
  = f.text_field :name
  = f.text_field :favorite_color
  = f.fields_for :addresses do |address_form|
    = address_form.label :street
    = address_form.text_field :street
    = address_form.label :city
    = address_form.text_field :city
    - unless address_form.object.new_record?
      = address_form.check_box '_destroy'
      = address_form.label '_destroy', caption: 'Remove'
    = submit_tag 'Save'
```

This will present a form that allows the person's name and color to be set along
with their first address. Using this functionality, the controller does not need
to change whatsoever as the nested data will be passed in and instantiated as
part of the parent model.
