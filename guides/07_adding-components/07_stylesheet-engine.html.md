---
chapter: Adding Components
title: Stylesheet Engine
---

# Stylesheet Engine

Contributing an additional stylesheet engine to Padrino is actually quite
straightforward. For this guide, let's look at how the `sass` component is
integrated into Padrino; a new engine follows the same steps.

## Generators

Every file in `padrino-gen/lib/padrino-gen/generators/components/stylesheets/`
is a choice for `--stylesheet`, named after the file. There's no list of
components to edit: adding `stylesheets/myengine.rb` is enough for
`padrino g project --stylesheet=myengine` and, in an existing project,
`padrino g component --stylesheet=myengine`. Both read the file and then
[call its `setup_stylesheet` method](https://github.com/padrino/padrino-framework/blob/0.17.0/padrino-gen/lib/padrino-gen/generators/actions.rb#L41-L46).

Here is the integration of Sass into the generator, in
[padrino-gen/generators/components/stylesheets/sass.rb](https://github.com/padrino/padrino-framework/blob/0.17.0/padrino-gen/lib/padrino-gen/generators/components/stylesheets/sass.rb):

```ruby
# padrino-gen/lib/padrino-gen/generators/components/stylesheets/sass.rb

SASS_INIT = <<-SASS unless defined?(SASS_INIT)
    # Enables support for SASS template reloading in rack applications.
    # See http://nex-3.com/posts/88-sass-supports-rack for more details.
    # Store SASS files (by default) within 'app/stylesheets'.
    require 'sass/plugin/rack'
    Sass::Plugin.options[:template_location] = Padrino.root("app/stylesheets")
    Sass::Plugin.options[:css_location] = Padrino.root("public/stylesheets")
    app.use Sass::Plugin::Rack
SASS

def setup_stylesheet
  require_dependencies 'sass'
  initializer :sass, SASS_INIT.chomp
  empty_directory destination_root('/app/stylesheets')
end
```

`require_dependencies` adds the gem to the project's `Gemfile`.
[`initializer`](https://github.com/padrino/padrino-framework/blob/0.17.0/padrino-gen/lib/padrino-gen/generators/actions.rb#L426-L431)
writes `config/initializers/sass.rb` with a `SassInitializer` module whose
`registered` hook runs the code in `SASS_INIT`, and adds
`register SassInitializer` to `app/app.rb`. Sass compiles the files in
`app/stylesheets` to `public/stylesheets` as requests come in, so the last line
creates `app/stylesheets` for the source files.

## Tests

Let's also add a test to ensure the stylesheet engine component generates as
expected in
[padrino-gen/test/test\_project\_generator.rb](https://github.com/padrino/padrino-framework/blob/0.17.0/padrino-gen/test/test_project_generator.rb#L739-L746):

```ruby
# padrino-gen/test/test_project_generator.rb
describe 'the generator for stylesheet component' do
  it 'should properly generate for sass' do
    capture_io { generate(:project, 'sample_project', "--root=#{@apptmp}", '--renderer=haml', '--script=none', '--stylesheet=sass') }
    assert_match_in_file(/gem 'sass'/, "#{@apptmp}/sample_project/Gemfile")
    assert_match_in_file(/module SassInitializer.*Sass::Plugin::Rack/m, "#{@apptmp}/sample_project/config/initializers/sass.rb")
    assert_match_in_file(/register SassInitializer/m, "#{@apptmp}/sample_project/app/app.rb")
    assert_dir_exists("#{@apptmp}/sample_project/app/stylesheets")
  end
  ...
end
```

## README

Finally, let's update the README for `padrino-gen` to list the component
in
[padrino-gen/README.rdoc](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/README.rdoc):

```ruby
# padrino-gen/README.rdoc
stylesheet:: none  (default), tailwind, sass, scss
```

## Contribute to Padrino

This completes the full integration of a stylesheet engine into Padrino. Once
all of this has been finished in your GitHub fork, send us a pull request and
assuming you followed these instructions properly and the engine actually works
when generated, we will include the component into the next Padrino version
crediting you for the contribution!
