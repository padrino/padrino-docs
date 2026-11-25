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
[padrino-gen/generators/components/stylesheets/sass.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/components/stylesheets/sass.rb)
(shortened). The `scss` component applies the same file, since Dart Sass tells
the two syntaxes apart by file extension:

```ruby
# padrino-gen/lib/padrino-gen/generators/components/stylesheets/sass.rb

SASS_RAKE = <<~RAKE unless defined?(SASS_RAKE)
  # Dart Sass compiles each file in app/stylesheets to public/stylesheets, in the same folders:
  # app/stylesheets/application.scss becomes public/stylesheets/application.css.
  # Files whose names start with "_" are partials, compiled only into the stylesheets that @use them.
  # Plain .css files are written out as plain CSS too.
  SASS_ARGS = %w[--no-source-map --load-path=app/stylesheets app/stylesheets:public/stylesheets].freeze

  namespace :sass do
    desc 'Build public/stylesheets from the Sass and SCSS files in app/stylesheets'
    task :build do
      mkdir_p 'app/stylesheets', verbose: false
      sh Gem.ruby, Gem.bin_path('sass-embedded', 'sass'), '--no-error-css', *SASS_ARGS
    end

    desc 'Rebuild public/stylesheets whenever a file in app/stylesheets changes'
    task :watch do
      mkdir_p 'app/stylesheets', verbose: false
      sh Gem.ruby, Gem.bin_path('sass-embedded', 'sass'), '--watch', *SASS_ARGS
    end
  end

  namespace :assets do
    task precompile: 'sass:build'
  end
RAKE

def setup_stylesheet
  require_dependencies 'sass-embedded', version: '~> 1.63', require: false
  empty_directory destination_root('/app/stylesheets')
  create_file destination_root('tasks/sass.rake'), SASS_RAKE, skip: true

  watcher = "css: bundle exec rake sass:watch\n"
  procfile = destination_root('Procfile.dev')
  if !File.exist?(procfile)
    create_file procfile, "web: bundle exec padrino start\n#{watcher}"
  elsif !(content = File.binread(procfile)).match?(/^css:/n)
    append_line(procfile, watcher)
  elsif !content.match?(/^#{watcher.chomp}\r?$/n)
    say "Procfile.dev already runs a css: process; to rebuild stylesheets on change, make it `#{watcher.chomp}`.", :yellow
  end
  ...
  say 'Run `bundle exec rake sass:build` to compile app/stylesheets into public/stylesheets (or run Procfile.dev to rebuild on change).', :yellow
end
```

`require_dependencies` adds the gem to the project's `Gemfile`. `require: false`
keeps the app from loading it: only the rake tasks run Dart Sass, through the
`sass` executable the gem ships. The method then creates `app/stylesheets` for
the source files and writes `tasks/sass.rake`, which the project's `Rakefile`
loads with every other file in `tasks/`. `skip: true` leaves a
`tasks/sass.rake` the project already has alone, so running
`padrino g component -c sass` again doesn't undo your edits.

`rake sass:build` compiles each file in `app/stylesheets` to
`public/stylesheets`, and fails when a stylesheet has an error.
`rake sass:watch` does the same whenever a file changes, and making
`assets:precompile` depend on `sass:build` builds the stylesheets on deploys
that precompile assets. Last, the method adds a `css:` process that runs the
watcher to `Procfile.dev`, creating the file if the project has none. A
`css:` process the project already runs is left alone, with a note on how to
change it. The part left out (`...`) lists what an existing project still has
of an engine it replaces, such as Ruby Sass or Tailwind, so the user can
remove it.

## Tests

Let's also add a test to ensure the stylesheet engine component generates as
expected in
[padrino-gen/test/test\_project\_generator.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/test/test_project_generator.rb):

```ruby
# padrino-gen/test/test_project_generator.rb
describe 'the generator for stylesheet component' do
  %w[sass scss].each do |stylesheet|
    it "should set up Dart Sass with build and watch tasks for #{stylesheet}" do
      out, = capture_io { generate(:project, 'sample_project', "--root=#{@apptmp}", '--renderer=haml', '--script=none', "--stylesheet=#{stylesheet}") }
      project = "#{@apptmp}/sample_project"
      assert_match_in_file(/^gem 'sass-embedded', '~> 1\.63', require: false$/, "#{project}/Gemfile")
      assert_no_match_in_file(/^gem 'sass'/, "#{project}/Gemfile")
      assert_no_match_in_file(/Initializer/, "#{project}/app/app.rb")
      assert_no_file_exists("#{project}/config/initializers/#{stylesheet}.rb")
      assert_dir_exists("#{project}/app/stylesheets")
      assert_equal "web: bundle exec padrino start\ncss: bundle exec rake sass:watch\n", File.read("#{project}/Procfile.dev")
      assert_match(%r{Run `bundle exec rake sass:build` to compile app/stylesheets into public/stylesheets \(or run Procfile\.dev to rebuild on change\)\.}, out)
    end
  end
  ...
end
```

Since the component writes rake tasks, the same `describe` block also runs
`tasks/sass.rake` with a stand-in for the `sass` executable, checking the
arguments each task passes to it and that `sass:build` fails when Dart Sass
reports an error.

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
