---
chapter: Features
title: Rake Tasks
---

# Rake Tasks

A generated Padrino project has a `Rakefile` that loads Padrino's tasks, so you
can run them with `padrino rake` or `bundle exec rake`:

```shell
# for a list of tasks
$ padrino rake -T
```

If you need custom tasks you can add those to:

- `your_project_/**lib/tasks**`
- `your_project_/**tasks**`
- `your_project_/**test**`
- `your_project_/**spec**`

Padrino loads every `*.rake` file in `lib/tasks` and `tasks` (including their
subdirectories) and in `test` and `spec`.

Padrino by default has some useful tasks.

--------------------------------------------------------------------------------

## Basic

Like other frameworks we have an `:environment` task that loads our
`environment` and `apps`. Example:

```ruby
# This is a custom task
# tasks/version.rake
task version: :environment do
  puts Padrino.version
end
```

--------------------------------------------------------------------------------

## Routes

We have support for retrieving a list of named routes within your application
for easy access.

```shell
$ padrino rake routes
```

which will return all the named routes for your project:

```shell
Application: SampleBlogUpdated::Admin
    URL                           REQUEST  PATH
    (:sessions, :new)               GET    /admin/sessions/new
    (:sessions, :create)           POST    /admin/sessions/create
    (:sessions, :destroy)         DELETE   /admin/sessions/destroy
    (:base, :index)                 GET    /admin/
    (:accounts, :index)             GET    /admin/accounts
    (:accounts, :new)               GET    /admin/accounts/new
    (:accounts, :create)           POST    /admin/accounts/create
    (:accounts, :edit)              GET    /admin/accounts/edit/:id
    (:accounts, :update)            PUT    /admin/accounts/update/:id
    (:accounts, :destroy)         DELETE   /admin/accounts/destroy/:id
    (:accounts, :destroy_many)    DELETE   /admin/accounts/destroy_many
    (:posts, :index)                GET    /admin/posts
    (:posts, :new)                  GET    /admin/posts/new
    (:posts, :create)              POST    /admin/posts/create
    (:posts, :edit)                 GET    /admin/posts/edit/:id
    (:posts, :update)               PUT    /admin/posts/update/:id
    (:posts, :destroy)            DELETE   /admin/posts/destroy/:id
    (:posts, :destroy_many)       DELETE   /admin/posts/destroy_many

Application: SampleBlogUpdated::App
    URL                 REQUEST  PATH
    (:about)              GET    /about_us
    (:posts, :index)      GET    /posts(.:format)?
    (:posts, :show)       GET    /posts/show/:id
```

--------------------------------------------------------------------------------

## Testing

When testing with Padrino you have a built-in `padrino rake test` or for rspec
`padrino rake spec`.

```shell
$ padrino rake test # => for bacon, shoulda
$ padrino rake spec # => for rspec
```

you can customize `test/test.rake` or `spec/spec.rake`

--------------------------------------------------------------------------------

## I18n

You can auto generate a _yml_ file for localizing your models using this
command (`mi:translate` with Mongoid):

```shell
$ padrino rake ar:translate
```

See [Localization](/guides/features/localization "Localization") for detailed instructions.

--------------------------------------------------------------------------------

## ORM

Padrino has rake tasks for _ActiveRecord_, _Sequel_, and _Mongoid_ with some
**bonuses**.

**NOTE**: we have a **namespace** for each orm, because of this, Padrino can
  mount several applications and each of them can use different orms without
  conflict, so that you can have multiple applications living together and one
  of them can use ActiveRecord, while another uses Sequel or Mongoid
  instead. In this way we prevent
  collisions.

--------------------------------------------------------------------------------

## ActiveRecord Tasks

```shell
rake ar:abort_if_pending_migrations # Raises an error if there are pending migrations
rake ar:charset                     # Retrieves the charset for the current environment's database
rake ar:collation                   # Retrieves the collation for the current environment's database
rake ar:create                      # Creates the database defined in config/database.yml for the current Padrino.env
rake ar:create:all                  # Create all the local databases defined in config/database.yml
rake ar:drop                        # Drops the database for the current Padrino.env
rake ar:drop:all                    # Drops all the local databases defined in config/database.yml
rake ar:dump                        # Dump the database data to a SQL file (FILE=path, default tmp/<env>_dump.sql)
rake ar:forward                     # Pushes the schema to the next version
rake ar:migrate                     # Migrate the database through scripts in db/migrate and update db/schema.rb by invoking ar:schema:dump
rake ar:migrate:down                # Runs the 'down' for a given MIGRATION_VERSION
rake ar:migrate:redo                # Rollbacks the database one migration and re migrate up
rake ar:migrate:reset               # Resets your database using your migrations for the current environment
rake ar:migrate:up                  # Runs the 'up' for a given MIGRATION_VERSION
rake ar:reset                       # Drops and recreates the database from db/schema.rb for the current environment and loads the seeds
rake ar:rollback                    # Rolls the schema back to the previous version
rake ar:schema:dump                 # Create a db/schema.rb file that can be portably used against any DB supported by AR
rake ar:schema:load                 # Load a schema.rb file into the database
rake ar:setup                       # Create the database, load the schema, and initialize with the seed data
rake ar:structure:dump              # Dump the database structure to a SQL file
rake ar:translate                   # Generates .yml files for I18n translations
rake ar:version                     # Retrieves the current schema version number
```

--------------------------------------------------------------------------------

## Sequel Tasks

```shell
rake sq:create              # Create the database
rake sq:drop                # Drop the database (postgres and mysql only)
rake sq:dump                # Dump the database data to a SQL file (FILE=path, default tmp/<env>_dump.sql)
rake sq:migrate             # Perform migration up to latest migration available
rake sq:migrate:auto        # Perform automigration (reset your db data)
rake sq:migrate:down        # Perform migration down (erase all data)
rake sq:migrate:to[version] # Perform migration up/down to MIGRATION_VERSION
rake sq:migrate:up          # Perform migration up to latest migration available
rake sq:reset               # Drop the database, migrate from scratch and initialize with the seed data
```

--------------------------------------------------------------------------------

## Mongoid Tasks

```shell
rake mi:cleanup_old_collections # Clean up old collections backed up by objectid_convert
rake mi:create_indexes          # Create the indexes defined on your mongoid models
rake mi:drop                    # Drops all the collections for the database for the current Padrino.env
rake mi:objectid_convert        # Convert string objectids in mongo database to ObjectID type
rake mi:translate               # Generates .yml files for I18n translations
```

--------------------------------------------------------------------------------

## Dumping Data

`db:dump` (`ar:dump` with ActiveRecord, `sq:dump` with Sequel) writes the schema
and data of the current `Padrino.env` database to `tmp/<env>_dump.sql`, using the
database's own tool: `pg_dump` for Postgres, `mysqldump` for MySQL and `sqlite3`
for SQLite. That tool must be on your `PATH`. When the database server runs in a
container, run the tool inside the container instead.

```shell
$ padrino rake db:dump                      # => tmp/development_dump.sql
$ padrino rake db:dump -e production        # => tmp/production_dump.sql
$ padrino rake db:dump FILE=backups/blog.sql
```

Generated projects ignore `tmp/` in `.gitignore`, so a dump is not committed by
accident. The password reaches the tool through `PGPASSWORD` or `MYSQL_PWD`, not
the command line. A dump that fails leaves no partial file and keeps an earlier
dump at the same path. When an ActiveRecord environment has several databases,
each one goes to `tmp/<env>_<name>_dump.sql`, and `FILE=` is refused. Mongoid
projects have no dump task yet.

--------------------------------------------------------------------------------

## Seed

Like in Rails we can populate our db using `db/seeds.rb` here's an example (from
our [padrino-admin](/guides/features/padrino-admin "Padrino Admin")):

```ruby
email     = shell.ask 'Which email do you want use for logging into admin?'
password  = shell.ask 'Tell me the password to use:'

shell.say ''

account = Account.create(email: email, password: password,
                         password_confirmation: password, role: 'admin')

if account.valid?
  shell.say 'Perfect! Your account was created.'
  shell.say ''
  shell.say 'Now you can start your server with padrino start and then login into /admin with:'
  shell.say "   email: #{email}"
  shell.say "   password: #{password}"
  shell.say ''
  shell.say "That's all!"
else
  shell.say 'Sorry but some thing went wrong!'
  shell.say ''
  account.errors.full_messages.each { |m| shell.say "   - #{m}" }
end
```
