---
chapter: Adding Components
title: Persistence Engine
---

# Persistence Engine

Contributing an object persistence library is probably the most involved
component to integrate with Padrino. For this guide, let us pretend that we
would like to integrate [Datamapper](http://datamapper.org) into Padrino.

## Generators

First, let's add Datamapper to the project generator's available components in
[padrino-gen/generators/project.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/project.rb):

```ruby
# padrino-gen/lib/padrino-gen/generators/project.rb
component_option :orm, "database engine", choices: [:activerecord, :datamapper]
```

Here, we needed to append `:datamapper` as an option for the `:orm`
`component_option` in the project generator. Once we have defined Datamapper as
an option for the ORM component, let's actually define the specific integration
tasks for the generator in
[padrino-gen/generators/components/orms/datamapper.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/components/orms/datamapper.rb):

```ruby
# padrino-gen/lib/padrino-gen/generators/components/orms/datamapper.rb

# These are the steps to setup the persistence layer in the initial project such
# as requiring certain gems, constructing the database.rb configuration file and
# creating the models folder for the application
def setup_orm
  require_dependencies 'data_objects', 'do_sqlite3', 'datamapper'
  create_file('config/database.rb', DM)
  empty_directory('app/models')
end

# These are the steps to generate the actual model file
# when the model generator is executed.
#
# e.g. create_model_file("account", ["username:string", "password:string"])
def create_model_file(name, fields)
  # ...truncated...
  create_file(model_path, model_contents)
end

# These are the steps to generate the model migration file
# when the model generator is executed.
#
# e.g. create_model_migration("create_accounts", "account", ["username:string"])
def create_model_migration(migration_name, name, columns)
  # ...truncated...
end

# These are the steps to generate the db migration file
# when the migration generator is executed.
#
# e.g. create_migration_file("AddEmailToAccount", "AddEmailToAccount", ["email:string"])
def create_migration_file(migration_name, name, columns)
  # ...truncated...
end
```

## Rake Tasks

Next, if the persistence engine needs to include useful rake tasks (to migrate
or modify the database for instance), you can add these to the `padrino-tasks`
folder in the `padrino-gen` gem. For Datamapper, there are a number of tasks
that should be available in
[padrino-tasks/datamapper.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/padrino-tasks/datamapper.rb):

```ruby
# padrino-gen/lib/padrino-gen/padrino-tasks/datamapper.rb

if defined?(DataMapper)
  namespace :dm do
    namespace :migrate do
      task load: :environment do
        # ...truncated...
      end

      desc 'Migrate up using migrations'
      task :up, :version, needs: :load do |t, args|
        # ...truncated...
      end
    end
  end
end
```

## Unit Tests

Next, let's add the appropriate unit tests to ensure our new component works as
intended in
[padrino-gen/test/test_project_generator.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/test/test_project_generator.rb#L359):

```ruby
# padrino-gen/test/test_project_generator.rb
...
it 'should properly generate default' do
  out, err = capture_io { generate(:project, 'project.com', "--root=#{@apptmp}", '--orm=datamapper', '--script=none') }
  assert_match(/applying.*?datamapper.*?orm/, out)
  assert_match_in_file(/gem 'dm-core'/, "#{@apptmp}/project.com/Gemfile")
  assert_match_in_file(/gem 'dm-sqlite-adapter'/, "#{@apptmp}/project.com/Gemfile")
  assert_match_in_file(/DataMapper.setup/, "#{@apptmp}/project.com/config/database.rb")
  assert_match_in_file(/project_com/, "#{@apptmp}/project.com/config/database.rb")
end
...
```

## README

Finally for the generator integration, we should add the available option to the
[generator README file](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/README.rdoc):

```ruby
# padrino-gen/README.rdoc

orm:: none  (default), mongomapper, mongoid, activerecord, sequel, couchrest, datamapper
```

With that update to the README, persistence support for the generator is
complete. However, to be fully compliant, support for Padrino Admin should also
be added. This will allow the admin dashboard to work properly with your
persistence engine of choice and is **highly** recommended.

## Padrino Admin Support

Adding `padrino-admin` support for your persistence engine is actually fairly
straightforward. First, let's add Datamapper to the set of supported admin ORM
engines in
[padrino-admin/generators/actions.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-admin/lib/padrino-admin/generators/actions.rb#L29):

```ruby
# padrino-admin/lib/padrino-admin/generators/actions.rb

def supported_orm
  [:activerecord, :mongomapper, :mongoid, :couchrest, :datamapper]
end
```

Next, we need to define the interaction methods available by our persistence
engine on our models in
[padrino-admin/generators/orm.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-admin/lib/padrino-admin/generators/orm.rb):

```ruby
# padrino-admin/lib/padrino-admin/generators/orm.rb

module Padrino
  module Admin
    module Generators
      class OrmError < StandardError; end
      class Orm
        attr_reader :klass_name, :klass, :name_plural, :name_singular, :orm

        def initialize(name, orm, columns = nil, column_fields = nil)
          # ...truncated...
        end

        # Defines access to a model's columns
        def columns
          @columns ||= case orm
            when :activerecord then @klass.columns
            when :datamapper   then @klass.properties
            else raise OrmError, "Adapter #{orm} is not yet supported!"
          end
        end

        # Defines access to retrieving all existing records for a model.
        def all
          "#{klass_name}.all"
        end

        # Defines access for querying records for a model.
        def find(params = nil)
          case orm
            when :activerecord then "#{klass_name}.find(#{params})"
            when :datamapper   then "#{klass_name}.get(#{params})"
            else raise OrmError, "Adapter #{orm} is not yet supported!"
          end
        end

        # Defines how to build a new record for a model.
        def build(params = nil)
          if params
            "#{klass_name}.new(#{params})"
          else
            "#{klass_name}.new"
          end
        end

        # Defines how to save a new record for a model.
        def save
          "#{name_singular}.save"
        end

        # Defines how to update attributes of a record for a model.
        def update_attributes(params = nil)
          case orm
            when :activerecord then "#{name_singular}.update_attributes(#{params})"
            when :datamapper then "#{name_singular}.update(#{params})"
            else raise OrmError, "Adapter #{orm} is not yet supported!"
          end
        end

        # Defines how to destroy a record for a model.
        def destroy
          "#{name_singular}.destroy"
        end
      end # Orm
    end # Generators
  end # Admin
end # Padrino
```

Next, we need to describe how the `Account` model should be defined for our
persistence engine within
[padrino-admin/generators/templates/account/datamapper.rb.tt](https://github.com/padrino/padrino-framework/blob/master/padrino-admin/lib/padrino-admin/generators/templates/account/datamapper.rb.tt):

```ruby
# padrino-admin/lib/padrino-admin/generators/templates/account/datamapper.rb.tt

class Account
  include DataMapper::Resource
  include DataMapper::Validate
  attr_accessor :password, :password_confirmation

  # Define Properties
  property :id,               Serial
  property :name,             String
  # ...truncated...

  # Define Validations
  validates_present      :email, :role
  # ...truncated...

  # Callbacks
  before :save, :generate_password

  #
  # This method is for authentication purpose
  #
  def self.authenticate(email, password)
    account = first(conditions: { email: email }) if email.present?
    account && account.password_clean == password ? account : nil
  end

  #
  # This method is used from AuthenticationHelper
  #
  def self.find_by_id(id)
    get(id) rescue nil
  end

  #
  # This method is used for retrieve the original password.
  #
  def password_clean
    crypted_password.decrypt(salt)
  end

  private
    def generate_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{email}--") if new?
      self.crypted_password = password.encrypt(self.salt)
    end

    def password_required
      crypted_password.blank? || !password.blank?
    end
end
```

Finally, let's update the `padrino-admin` README file at
[padrino-admin/README.rdoc](https://github.com/padrino/padrino-framework/blob/master/padrino-admin/README.rdoc)
to reflect our newly support component:

```ruby
# padrino-admin/README.rdoc

Orm Agnostic:: Data Adapters for Datamapper, Activerecord, Mongomapper, Mongoid, Couchrest, Dynamoid
```

## Contribute to Padrino

This completes the full integration of a persistence engine into Padrino. Once
all of this has been finished in your GitHub fork, send us a pull request and
assuming you followed these instructions properly and the engine actually works
when generated, we will include the component into the next Padrino version
crediting you for the contribution!
