---
chapter: Adding Components
title: Testing Library
---

# Testing Library

Contributing an additional testing library to Padrino is actually quite
straightforward. For this guide, let’s assume we want to add `shoulda` as a
testing component integrated into Padrino.

## Generators

First, let’s add `shoulda` to the project generator’s available components in
[padrino-gen/generators/project.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/project.rb#L36):

```ruby
# padrino-gen/lib/padrino-gen/generators/project.rb

component_option :test, "testing framework", :choices => [:rspec, :shoulda]
```

Next, let’s define the actual integration of the testing library into the
generator in
[padrino-gen/generators/components/tests/shoulda.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/components/tests/shoulda.rb):

```ruby
# padrino-gen/lib/padrino-gen/generators/components/tests/shoulda.rb

SHOULDA_SETUP = (<<-TEST).gsub(/^ {10}/, '')
PADRINO_ENV = 'test' unless defined?(PADRINO_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

class Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    CLASS_NAME
  end
end
TEST

def setup_test
  require_dependencies 'shoulda', :group => 'test'
  insert_test_suite_setup SHOULDA_SETUP
  create_file destination_root("test/test.rake"), SHOULDA_RAKE
end

# Generates a controller test given the controllers name
def generate_controller_test(name)
  # ...truncated...
end

def generate_model_test(name)
  # ...truncated...
end
```

## Tests

Let’s also add a test to ensure the new testing component generates as expected
in
[padrino-gen/test/test\_project\_generator.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/test/test_project_generator.rb#L580):

```ruby
# padrino-gen/test/test_project_generator.rb

should "properly generate for shoulda" do
  buffer = silence_logger {@project.start(['sample_project', '--root=/tmp', '--test=shoulda', '--script=none'])}
  assert_match /Applying.*?shoulda.*?test/, buffer
  assert_match_in_file(/gem 'shoulda'/, '/tmp/sample_project/Gemfile')
  assert_match_in_file(/Test::Unit::TestCase/, '/tmp/sample_project/test/test_config.rb')
  assert_file_exists('/tmp/sample_project/test/test.rake')
end
```

## README

Finally, let’s update the README for `padrino-gen` to reflect the new
component in
[padrino-gen/README.rdoc](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/README.rdoc):

```ruby
# padrino-gen/README.rdoc

test:: rspec (default), bacon, shoulda, cucumber, testspec, riot
```

## Contribute to Padrino

This completes the full integration of a testing library into Padrino. Once
all of this has been finished in your GitHub fork, send us a pull request and
assuming you followed these instructions properly and the library actually works
when generated, we will include the component into the next Padrino version
crediting you for the contribution!
