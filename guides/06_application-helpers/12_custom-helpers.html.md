---
chapter: Application Helpers
title: Custom Helpers
---

# Custom Helpers

In addition to the helpers provided by Padrino out of the box, you can also add
your own helper methods and classes that will be accessible within any
controller or view automatically.

To define a helper method, simply use an existing helper file (created when
generating a controller) or define your own file in `app/helpers` within your
application. Methods can be made available within you controller by simply
wrapping the methods in the `helpers` block:

```ruby
# app/helpers/some_helper.rb
MyAppName.helpers do
  def some_method
    # ...do something here...
  end
end
```

You can also define entire classes for use as helpers just as easily:

```ruby
# app/helpers/some_helper.rb
class SomeHelper
  def self.do_something
    # ...do something here...
  end
end
```

These helpers can then easily be invoked in any controllers or templates within
your application:

```ruby
# app/controllers/posts.rb
MyAppName.controllers :posts do
  get :index do
    some_method # helper method
    SomeHelper.do_something # helper class
  end
end
```

Use these in situations where you wish to cleanup your controller or your view
code. Helpers are particularly useful for DRY'ing up repeated use of the same
markup or behavior. **Note** that helper methods and objects should be reloaded
automatically for you in development.
