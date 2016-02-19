---
chapter: Adding Components
title: Stylesheet Engine
---

# Stylesheet Engine

Contributing an additional stylesheet engine to Padrino is actually quite
straightforward. For this guide, let’s assume we want to add
[Less](http://lesscss.org) as a stylesheet engine component integrated into
Padrino.

## Generators

First, let’s add `less` to the project generator’s available components in
[padrino-gen/generators/project.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/project.rb#L33):

```ruby
# padrino-gen/lib/padrino-gen/generators/project.rb

component_option :stylesheet, "stylesheet engine", :choices => [:sass, :less]
```

Next, let’s define the actual integration of the stylesheet engine into the
generator in
[padrino-gen/generators/components/stylesheets/less.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/components/stylesheets/less.rb):

```ruby
# padrino-gen/lib/padrino-gen/generators/components/stylesheets/less.rb

LESS_INIT = (<<-LESS).gsub(/^ {6}/, '')
require 'rack/less'
Rack::Less.configure do |config|
  config.compress = true
end
app.use Rack::Less, :root => app.root, :source  => 'stylesheets/',
                    :public    => 'public/', :hosted_at => '/stylesheets'
LESS

def setup_stylesheet
  require_dependencies 'less', 'rack-less'
  initializer :less, LESS_INIT
  empty_directory destination_root('/app/stylesheets')
end
```

## Tests

Let’s also add a test to ensure the new stylesheet engine component generates as
expected in
[padrino-gen/test/test\_project\_generator.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/test/test_project_generator.rb#L656):

```ruby
# padrino-gen/test/test_project_generator.rb

should "properly generate for less" do
  buffer = silence_logger { @project.start(['sample_project', '--root=/tmp', '--stylesheet=less']) }
  assert_match_in_file(/gem 'less'/, '/tmp/sample_project/Gemfile')
  assert_match_in_file(/gem 'rack-less'/, '/tmp/sample_project/Gemfile')
  assert_match_in_file(/module LessInitializer.*Rack::Less/m, '/tmp/sample_project/lib/less_init.rb')
  assert_match_in_file(/register LessInitializer/m, '/tmp/sample_project/app/app.rb')
  assert_dir_exists('/tmp/sample_project/app/stylesheets')
end
```

## README

Finally, let’s update the README for `padrino-gen` to reflect the new
component in
[padrino-gen/README.rdoc](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/README.rdoc):

```ruby
# padrino-gen/README.rdoc

stylesheet:: sass (default), less
```

## Contribute to Padrino

This completes the full integration of a stylesheet engine into Padrino. Once
all of this has been finished in your GitHub fork, send us a pull request and
assuming you followed these instructions properly and the engine actually works
when generated, we will include the component into the next Padrino version
crediting you for the contribution!
