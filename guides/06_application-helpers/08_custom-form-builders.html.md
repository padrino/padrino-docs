---
chapter: Application Helpers
title: Custom Form Builders
---

# Custom Form Builders

You can also easily build your own FormBuilder which allows for customized
fields and behavior:

```ruby
class MyCustomFormBuilder < AbstractFormBuilder
  # Here we have access to a number of useful variables
  #
  # ** template  (use this to invoke any helpers)(ex. template.hidden_field_tag(...))
  # ** object    (the record for this form) (ex. object.valid?)
  # ** object_name (object's underscored type) (ex. object_name => 'admin_user')
  #
  # We also have access to self.field_types => [:text_field, :text_area, ...]
  # In addition, we have access to all the existing field tag
  # helpers (text_field, hidden_field, file_field, ...)
end
```

Once a custom builder is defined, any call to form_for can use the new builder:

```haml
= form_for @user, '/register', :builder => 'MyCustomFormBuilder', :id => 'register' do |f|
  ...fields here...
```

The form builder can even be made into the default builder when `form_for` is
invoked:

```ruby
# anywhere in the Padrino or Sinatra application
set :default_builder, 'MyCustomFormBuilder'
```

And there you have it, a fairly complete form builder solution for Padrino (and
Sinatra). I hope to create or merge in an even better 'default' form_builder in
the near future.
