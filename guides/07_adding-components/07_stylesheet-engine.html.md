---
chapter: Adding Components
title: Stylesheet Engine
---

# Stylesheet Engine

Contributing an additional stylesheet engine to Padrino is actually quite
straightforward. For this guide, let's assume we want to add
[Less](http://lesscss.org) as a stylesheet engine component integrated into
Padrino.

## Generators

First, let's define the actual integration of the stylesheet engine into the
generator in
[padrino-gen/generators/components/stylesheets/less.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/components/stylesheets/less.rb):

```ruby
# padrino-gen/lib/padrino-gen/generators/components/stylesheets/less.rb

LESS_INIT = <<-LESS unless defined?(LESS_INIT)
    # Enables support for Less template reloading for rack.
    # Store Less files by default within 'app/stylesheets/'.
    # See http://github.com/kelredd/rack-less for more details.
    require 'rack/less'
    # optional - use as necessary
    Rack::Less.configure do |config|
      config.compress = true
      # config.cache = true
      # other configs ...
    end
    app.use Rack::Less,
      :root      => Padrino.root,
      :source    => 'app/stylesheets',
      :public    => 'public',
      :hosted_at => 'stylesheets'
LESS

def setup_stylesheet
  require_dependencies 'less'
  require_dependencies 'rack-less'
  require_dependencies 'therubyracer'
  initializer :less, LESS_INIT
  empty_directory destination_root('/app/stylesheets')
end
```

## Tests

Let's also add a test to ensure the new stylesheet engine component generates as
expected in
[padrino-gen/test/test\_project\_generator.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/test/test_project_generator.rb#L656):

```ruby
# padrino-gen/test/test_project_generator.rb
it 'should properly generate for less' do
  capture_io { generate(:project, 'sample_project', "--root=#{@apptmp}", '--renderer=haml','--script=none','--stylesheet=less') }
  assert_match_in_file(/gem 'rack-less'/, "#{@apptmp}/sample_project/Gemfile")
  assert_match_in_file(/module LessInitializer.*Rack::Less/m, "#{@apptmp}/sample_project/lib/less_initializer.rb")
  assert_match_in_file(/register LessInitializer/m, "#{@apptmp}/sample_project/app/app.rb")
  assert_dir_exists("#{@apptmp}/sample_project/app/stylesheets")
end
```

## README

Finally, let's update the README for `padrino-gen` to reflect the new component
in
[padrino-gen/README.rdoc](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/README.rdoc):

```ruby
# padrino-gen/README.rdoc
stylesheet:: none  (default), less, compass, sass, scss
```

## Contribute to Padrino

This completes the full integration of a stylesheet engine into Padrino. Once
all of this has been finished in your GitHub fork, send us a pull request and
assuming you followed these instructions properly and the engine actually works
when generated, we will include the component into the next Padrino version
crediting you for the contribution!
