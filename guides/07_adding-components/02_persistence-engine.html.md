---
chapter: Adding Components
title: Persistence Engine
---

# Persistence Engine

Contributing an object persistence library is probably the most involved
component to integrate with Padrino. It touches the generators, the rake tasks
and the admin dashboard. For this guide, let's pretend we want to add a new ORM
called `myorm`, and use the existing
[Sequel](https://sequel.jeremyevans.net/) component as the working reference at
each step.

You don't need a generator component to use an ORM with Padrino. Any library
without one (ROM, for example) can be added to your `Gemfile` and set up by hand
in `config/database.rb`, like any other gem.

## Generators

The available ORM choices are not listed anywhere by hand. Padrino builds them
from the files in `padrino-gen/lib/padrino-gen/generators/components/orms/`, in
[padrino-gen/generators/actions.rb](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-gen/lib/padrino-gen/generators/actions.rb#L573-L585):

```ruby
# padrino-gen/lib/padrino-gen/generators/actions.rb

def defines_component_options(options = {})
  [
    [:orm,        'database engine',    { aliases: '-d', default: :none }],
    # ...truncated...
  ].each do |name, caption, opts|
    opts[:default] = '' if options[:default] == false
    component_option name, caption, opts.merge(choices: Dir["#{__dir__}/components/#{name.to_s.pluralize}/*.rb"].map { |lib| File.basename(lib, '.rb').to_sym })
  end
end
```

So adding a file named `components/orms/myorm.rb` is enough to make
`padrino g project demo --orm=myorm` (or `-d myorm`) a valid choice. The file
name is the component name everywhere else too: in the project's `.components`
file, in the generated `Rakefile` and in the admin generator.

The component file is not a class. The generator reads it and runs it with
`instance_eval`, so the methods it defines become methods of the running
generator.

An ORM component defines four methods:

- `setup_orm` runs when a project is generated with `--orm=myorm`, or when the
  ORM is added later with `padrino g component --orm=myorm`.
- `create_model_file(name, options)` runs from `padrino g model`.
- `create_model_migration(migration_name, name, columns)` also runs from
  `padrino g model`, unless `--skip-migration` is given.
- `create_migration_file(migration_name, name, columns)` runs from
  `padrino g migration`.

The model and migration generators call all of these, so define each one. An
ORM without migrations leaves the last two empty, as the Mongoid and Ohm
components do.

Here is the Sequel component,
[padrino-gen/generators/components/orms/sequel.rb](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-gen/lib/padrino-gen/generators/components/orms/sequel.rb):

```ruby
# padrino-gen/lib/padrino-gen/generators/components/orms/sequel.rb

SEQUEL = <<~SEQUEL unless defined?(SEQUEL)
  Sequel::Model.raise_on_save_failure = false # Do not throw exceptions on failure
  Sequel::Model.db = case Padrino.env
    when :development then Sequel.connect(!DB_DEVELOPMENT!, loggers: [logger])
    when :production  then Sequel.connect(!DB_PRODUCTION!,  loggers: [logger])
    when :test        then Sequel.connect(!DB_TEST!,        loggers: [logger])
  end
SEQUEL

def setup_orm
  sequel = SEQUEL
  db = @project_name.underscore
  require_dependencies 'sequel'

  begin
    case adapter ||= options[:adapter]
    # ...truncated: mysql-gem, mysql/mysql2 and postgres...
    when 'sqlite'
      sequel.gsub!(/!DB_DEVELOPMENT!/, "\"sqlite://db/#{db}_development.db\"")
      sequel.gsub!(/!DB_PRODUCTION!/, "\"sqlite://db/#{db}_production.db\"")
      sequel.gsub!(/!DB_TEST!/,       "\"sqlite://db/#{db}_test.db\"")
      require_dependencies 'sqlite3'
    else
      say "Failed to generate `config/database.rb` for ORM adapter `#{options[:adapter]}`", :red
      raise ArgumentError
    end
  rescue ArgumentError
    adapter = ask('Please, choose a proper adapter:', limited_to: %w[mysql mysql2 mysql-gem postgres sqlite])
    retry
  end

  create_file('config/database.rb', sequel)
  empty_directory('db/migrate')
end

SQ_MODEL = <<~MODEL unless defined?(SQ_MODEL)
  class !NAME! < Sequel::Model

  end
MODEL

# options => { fields: ['title:string', 'body:string'], app: 'app' }
def create_model_file(name, options = {})
  model_path = destination_root(options[:app], 'models', "#{name.to_s.underscore}.rb")
  model_contents = SQ_MODEL.gsub(/!NAME!/, name.to_s.underscore.camelize)
  create_file(model_path, model_contents)
end

# ...truncated: SQ_MIGRATION, SQ_MODEL_UP_MG, SQ_MODEL_DOWN_MG...

def create_model_migration(migration_name, name, columns)
  output_model_migration(
    migration_name, name, columns,
    column_format: proc { |field, kind| "#{kind.underscore.camelize} :#{field}" },
    base: SQ_MIGRATION,
    up: SQ_MODEL_UP_MG,
    down: SQ_MODEL_DOWN_MG
  )
end

# ...truncated: SQ_CHANGE_MG...

def create_migration_file(migration_name, name, columns)
  output_migration_file(
    migration_name, name, columns,
    base: SQ_MIGRATION, change_format: SQ_CHANGE_MG,
    add: proc { |field, kind| "add_column :#{field}, #{kind.underscore.camelize}" },
    remove: proc { |field, _kind| "drop_column :#{field}" }
  )
end
```

A few things to note:

- `require_dependencies` adds gems to the project's `Gemfile`.
- `options[:adapter]` is the project generator's `--adapter` option (`sqlite`
  by default). Only SQL ORMs need it.
- The model generator passes `fields: [...]` and `app: ...` to
  `create_model_file`. Write the model into `destination_root(options[:app],
  'models', ...)` so that `padrino g model` with `-a` puts it in the right app.
- The `SQ_*` constants are text templates with `!PLACEHOLDER!` markers. The shared
  helpers `output_model_migration` and `output_migration_file`, in
  [padrino-gen/generators/components/actions.rb](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-gen/lib/padrino-gen/generators/components/actions.rb#L24-L86),
  fill in `!UP!`, `!DOWN!`, `!TABLE!`, `!FIELDS!` and `!COLUMNS!`, number the
  file and write it to `db/migrate`. If `myorm` has migrations, reuse these
  helpers rather than writing your own.

## Rake Tasks

If the ORM needs rake tasks (to create or migrate the database, for instance),
add them in `padrino-gen/lib/padrino-gen/padrino-tasks/myorm.rb`. Every file in
that folder is registered automatically. For Sequel, see
[padrino-tasks/sequel.rb](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-gen/lib/padrino-gen/padrino-tasks/sequel.rb):

```ruby
# padrino-gen/lib/padrino-gen/padrino-tasks/sequel.rb

if PadrinoTasks.load?(:sequel, defined?(Sequel))
  namespace :sq do
    namespace :migrate do
      # ...truncated: auto, to, up and down...
    end

    desc 'Perform migration up to latest migration available'
    task migrate: 'sq:migrate:up'

    desc 'Create the database'
    task create: :skeleton do
      # ...truncated...
    end

    # ...truncated: drop, reset and seed...
  end

  task 'db:create' => 'sq:create'
  task 'db:migrate' => 'sq:migrate'
  task 'db:reset' => 'sq:reset'
end
```

The generated project's `Rakefile` calls `PadrinoTasks.use(:myorm)`, using the
component's file name, so pass the same symbol to `PadrinoTasks.load?`. Keep the
tasks in their own namespace and alias the common `db:*` names to them, so
`rake db:migrate` works whatever the ORM. `rake db:seed` is shared and already
provided by `padrino-tasks/database.rb`.

## Unit Tests

Next, add tests for the new component in `padrino-gen/test`, next to the
existing Sequel ones. The project generator tests check the `Gemfile` and
`config/database.rb`, in
[padrino-gen/test/test\_project\_generator.rb](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-gen/test/test_project_generator.rb#L285-L331):

```ruby
# padrino-gen/test/test_project_generator.rb

it 'should properly generate postgres' do
  capture_io { generate(:project, 'sample_project', "--root=#{@apptmp}", '--orm=sequel', '--adapter=postgres') }
  assert_match_in_file(/gem 'pg'/, "#{@apptmp}/sample_project/Gemfile")
  assert_match_in_file(%r{"postgres://}, "#{@apptmp}/sample_project/config/database.rb")
  assert_match_in_file(/sample_project_development/, "#{@apptmp}/sample_project/config/database.rb")
end
```

The model generator tests generate a project and then a model inside it, in
[padrino-gen/test/test\_model\_generator.rb](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-gen/test/test_model_generator.rb#L268-L295):

```ruby
# padrino-gen/test/test_model_generator.rb

it 'should generate migration file with given properties' do
  stop_time_for_test
  capture_io { generate(:project, 'sample_project', "--root=#{@apptmp}", '--script=none', '-d=sequel') }
  capture_io { generate(:model, 'friend', 'name:string', 'age:integer', 'created:datetime', "-r=#{@apptmp}/sample_project") }
  migration_file_path = "#{@apptmp}/sample_project/db/migrate/001_create_friends.rb"
  assert_match_in_file(/class Friend < Sequel::Model/m, "#{@apptmp}/sample_project/models/friend.rb")
  assert_match_in_file(/Sequel\.migration do/m,  migration_file_path)
  assert_match_in_file(/create_table :friends/m, migration_file_path)
  assert_match_in_file(/String :name/m,          migration_file_path)
  assert_match_in_file(/Integer :age/m,          migration_file_path)
  assert_match_in_file(/DateTime :created/m,     migration_file_path)
  assert_match_in_file(/drop_table :friends/m,   migration_file_path)
end
```

If `myorm` has migrations, also cover `padrino g migration` the same way, like
the `the migration generator for sequel` block in
[padrino-gen/test/test\_migration\_generator.rb](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-gen/test/test_migration_generator.rb#L173-L207).

## README

Add the new choice to the `orm::` line of the
[padrino-gen README](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/README.rdoc).

With that, the generator side is done. To be fully supported, the ORM should
also work with Padrino Admin, so that `padrino g admin` and
`padrino g admin_page` generate a working dashboard. This is **highly** recommended.

## Padrino Admin Support

First, add `:myorm` to the list returned by `supported_orm` in
[padrino-admin/generators/actions.rb](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-admin/lib/padrino-admin/generators/actions.rb#L29-L31).
`padrino g admin` refuses to run for an ORM that isn't in this list.

Next, teach the `Orm` class in
[padrino-admin/generators/orm.rb](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-admin/lib/padrino-admin/generators/orm.rb)
how to talk to your models. The admin controller and view templates call its
methods to get the Ruby code they write out. Most of them branch on the ORM
name. These are the Sequel branches:

```ruby
# padrino-admin/lib/padrino-admin/generators/orm.rb

def columns
  @columns ||=
    case orm
    # ...truncated...
    when :sequel       then @klass.db_schema.map { |k, v| v[:type] = :text if v[:db_type] =~ /^text/i; Column.new(k, v[:type]) }
    # ...truncated...
    else raise OrmError, "Adapter #{orm} is not yet supported!"
    end
end

def find(params = nil)
  case orm
  # ...truncated...
  when :sequel, :ohm then "#{klass_name}[#{params}]"
  else raise OrmError, "Adapter #{orm} is not yet supported!"
  end
end

def save
  orm == :sequel ? "(@#{name_singular}.save rescue false)" : "@#{name_singular}.save"
end

def update_attributes(params = nil)
  case orm
  # ...truncated...
  when :sequel then "@#{name_singular}.modified! && @#{name_singular}.update(#{params})"
  else raise OrmError, "Adapter #{orm} is not yet supported!"
  end
end
```

`columns`, `find` and `update_attributes` raise an error for an unknown ORM, so
`myorm` needs a branch in each. `columns` must return objects that respond to
`name` and `type`; the `Column` struct defined in the same file works. The
other methods have a default branch that suits ActiveRecord-like libraries.
Check each one and add a branch where the default is wrong for `myorm`:

- `save`, `destroy`;
- `find_by_ids`, `multiple_destroy` (bulk delete on the index page);
- `has_error` (form field errors).

`all` and `build` are the same for every ORM.

Next, add the `Account` model template that `padrino g admin` writes to
`models/account.rb`:
`padrino-admin/lib/padrino-admin/generators/templates/account/myorm.rb.tt`.
Use
[account/sequel.rb.tt](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-admin/lib/padrino-admin/generators/templates/account/sequel.rb.tt)
as the model to follow. The rest of the admin expects the template to provide:

- the `name`, `surname`, `email`, `crypted_password` and `role` fields (the
  admin generator also runs `padrino g model` with these, which creates the
  migration);
- `password` and `password_confirmation` accessors, with validations, and a
  callback that stores a hash of the password in `crypted_password` (the
  existing templates use BCrypt, which the admin generator adds to the
  `Gemfile`);
- `self.authenticate(email, password)`, used by the admin sessions controller;
- `self.find_by_id(id)`, used to load the logged-in account;
- `new`, `valid?`, `save` and `errors.full_messages`, used by the generated
  `db/seeds.rb`.

`padrino-admin/lib/padrino-admin/generators/admin_app.rb` also has a few
optional per-ORM touches: extra middleware (ActiveRecord adds
`ConnectionPoolManagement`) and the "next steps" message, which adds
`rake db:create` and `rake db:migrate` for the SQL ORMs it lists.

Add a test to
[padrino-admin/test/generators/test\_account\_model\_generator.rb](https://github.com/padrino/padrino-framework/blob/0.16.1/padrino-admin/test/generators/test_account_model_generator.rb#L85-L95):

```ruby
# padrino-admin/test/generators/test_account_model_generator.rb

describe 'sequel' do
  before do
    capture_io { generate(:project, 'sample_project', '-e=slim', "--root=#{@apptmp}", '-d=sequel') }
    capture_io { generate(:admin_app, "--root=#{@apptmp}/sample_project") }
    @model = "#{@apptmp}/sample_project/models/account.rb"
  end

  it 'should be a sequel model instance' do
    assert_match_in_file(/class Account < Sequel::Model/m, @model)
  end
end
```

Finally, add the ORM to the `Orm Agnostic` line of the
[padrino-admin README](https://github.com/padrino/padrino-framework/blob/master/padrino-admin/README.rdoc),
and to the adapter list in the dashboard's `base/index` templates (one per
renderer, under `padrino-admin/lib/padrino-admin/generators/templates`).

On master, `orm.rb` also has a `MODEL_BASES` table, which maps each ORM to its
model base class (`sequel: 'Sequel::Model'`). `padrino g admin_page` uses it to
check that a model belongs to the project's ORM. Add an entry for `myorm` there
too.

## Contribute to Padrino

Before sending the pull request, generate a real project with
`--orm=myorm`, add a model and run `padrino g admin`, then boot it and log in
to the dashboard. Once that works and the tests pass, send us a pull request
from your GitHub fork. If everything works when generated, we will include the
component in the next Padrino version and credit you for the contribution!
