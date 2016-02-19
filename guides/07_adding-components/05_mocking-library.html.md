---
chapter: Adding Components
title: Mocking Library
---

# Mocking Library

Contributing an additional mocking library to Padrino is actually quite
straightforward. For this guide, let’s assume we want to add
[Mocha](https://github.com/freerange/mocha) as a mocking component integrated
into Padrino.

## Generators

First, let’s add `mocha` to the project generator’s available components in
[padrino-gen/generators/project.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/project.rb#L36):

```ruby
# padrino-gen/lib/padrino-gen/generators/project.rb

component_option :mock, "mocking library", :choices => [:mocha, :rr]
```

Next, let’s define the actual integration of the mocking library into the
generator in
[padrino-gen/generators/components/mocks/mocha.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/components/mocks/mocha.rb):

```ruby
# padrino-gen/lib/padrino-gen/generators/components/mocks/mocha.rb

def setup_mock
  require_dependencies 'mocha', :group => 'test'
  insert_mocking_include "Mocha::API"
end
```

## Tests

Let’s also add a test to ensure the new mocking component generates as expected
in
[padrino-gen/test/test\_project\_generator.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/test/test_project_generator.rb#L248):

```ruby
# padrino-gen/test/test_project_generator.rb

should "properly generate for mocha and rspec" do
  buffer = silence_logger {@project.start(['sample_project', '--root=/tmp', '--mock=mocha'])}
  assert_match /Applying.*?mocha.*?mock/, buffer
  assert_match_in_file(/gem 'mocha'/, '/tmp/sample_project/Gemfile')
  assert_match_in_file(/conf.mock_with :mocha/m, '/tmp/sample_project/spec/spec_helper.rb')
end
```

## README

Finally, let’s update the README for `padrino-gen` to reflect the new
component in
[padrino-gen/README.rdoc](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/README.rdoc):

```ruby
# padrino-gen/README.rdoc

mock:: none (default), mocha, rr
```

## Contribute to Padrino

This completes the full integration of a mocking library into Padrino. Once all
of this has been finished in your GitHub fork, send us a pull request and
assuming you followed these instructions properly and the library actually works
when generated, we will include the component into the next Padrino version
crediting you for the contribution!
