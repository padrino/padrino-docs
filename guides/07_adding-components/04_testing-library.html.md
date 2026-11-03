---
chapter: Adding Components
title: Testing Library
---

# Testing Library

Contributing an additional testing library to Padrino is actually quite
straightforward. For this guide, let's look at how the `testunit` component is
integrated into Padrino; a new library follows the same steps.

## Generators

Every file in `padrino-gen/lib/padrino-gen/generators/components/tests/` is a
choice for `--test`, named after the file. Here is the integration of test-unit
into the generator, in
[padrino-gen/generators/components/tests/testunit.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/components/tests/testunit.rb):

```ruby
# padrino-gen/lib/padrino-gen/generators/components/tests/testunit.rb

TESTUNIT_SETUP = <<~TEST.gsub(/^ {10}/, '') unless defined?(TESTUNIT_SETUP)
  RACK_ENV = 'test' unless defined?(RACK_ENV)
  require_relative '../config/boot'
  Padrino.mounted_apps.each { |app| Padrino.require_dependencies(File.join(app.app_root, '{helpers.rb,helpers/**/*.rb}')) }

  class Test::Unit::TestCase
    include Rack::Test::Methods

    # You can use this method to custom specify a Rack app
    # you want rack-test to invoke:
    #
    #   app CLASS_NAME
    #   app CLASS_NAME.tap { |a| }
    #   app(CLASS_NAME) do
    #     set :foo, :bar
    #   end
    #
    def app(app = nil, &blk)
      @app ||= block_given? ? app.instance_eval(&blk) : app
      @app ||= Padrino.application
    end
  end
TEST

TESTUNIT_RAKE = <<~TEST.gsub(/^ {10}/, '') unless defined?(TESTUNIT_RAKE)
  require 'rake/testtask'

  test_tasks = Dir['test/*/'].map { |d| File.basename(d) }

  test_tasks.each do |folder|
    Rake::TestTask.new("test:\#{folder}") do |test|
      test.pattern = "test/\#{folder}/**/*_test.rb"
      test.verbose = true
    end
  end

  desc "Run application test suite"
  task 'test' => test_tasks.map { |f| "test:\#{f}" }

  task default: :test
TEST

def setup_test
  require_dependencies 'rack-test', require: 'rack/test', group: 'test'
  require_dependencies 'test-unit', require: 'test/unit', group: 'test'
  insert_test_suite_setup TESTUNIT_SETUP
  create_file destination_root('test/test.rake'), TESTUNIT_RAKE, skip: reapplying_component?(:test)
end

# Generates a controller test given the controller's name
def generate_controller_test(name, path)
  # ...truncated...
end

def generate_model_test(name)
  # ...truncated...
end

def generate_helper_test(name, project_name, app_name)
  # ...truncated...
end
```

## Tests

Let's also add a test to ensure the new testing component generates as expected
in the `describe 'the generator for test component'` block of
[padrino-gen/test/test\_project\_generator.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/test/test_project_generator.rb):

```ruby
# padrino-gen/test/test_project_generator.rb
it 'should properly generate for testunit' do
  out, = capture_io { generate(:project, 'sample_project', "--root=#{@apptmp}", '--test=testunit', '--script=none') }
  assert_match(/applying.*?testunit.*?test/, out)
  assert_match_in_file(/gem 'rack-test'/, "#{@apptmp}/sample_project/Gemfile")
  assert_match_in_file(%r{require: 'rack/test'}, "#{@apptmp}/sample_project/Gemfile")
  assert_match_in_file(/group: 'test'/, "#{@apptmp}/sample_project/Gemfile")
  assert_match_in_file(/gem 'test-unit'/, "#{@apptmp}/sample_project/Gemfile")
  assert_match_in_file(/RACK_ENV = 'test' unless defined\?\(RACK_ENV\)/, "#{@apptmp}/sample_project/test/test_config.rb")
  assert_match_in_file(/Test::Unit::TestCase/, "#{@apptmp}/sample_project/test/test_config.rb")
  assert_file_exists("#{@apptmp}/sample_project/test/test.rake")
  assert_match_in_file(/Rake::TestTask\.new\("test:\#/, "#{@apptmp}/sample_project/test/test.rake")
  assert_match_in_file(/task 'test' => test_tasks/, "#{@apptmp}/sample_project/test/test.rake")
end
```

## README

Finally, let's update the README for `padrino-gen` to reflect the new component
in
[padrino-gen/README.rdoc](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/README.rdoc):

```ruby
# padrino-gen/README.rdoc
test::       none  (default), cucumber, rspec, minitest, testunit
```

## Contribute to Padrino

This completes the full integration of a testing library into Padrino. Once all
of this has been finished in your GitHub fork, send us a pull request and
assuming you followed these instructions properly and the library actually works
when generated, we will include the component into the next Padrino version
crediting you for the contribution!
