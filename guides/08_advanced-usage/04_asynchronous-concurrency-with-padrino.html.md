---
chapter: Advanced Usage
title: Concurrency
---

# Concurrency

A Padrino app handles several requests at once when its web server runs them
on threads, processes or fibers. You choose the model by choosing the server.
Pick it when you generate the project:

```bash
$ padrino g project my_app --server=puma
$ padrino g project my_app --server=falcon
```

This adds the server gem to the `Gemfile`. In an existing project, add the gem
yourself.

## Puma: threads and workers

[Puma](https://puma.io/) runs each request on a thread from a pool. It can also
fork worker processes, each with its own thread pool. Configure both in
`config/puma.rb` (the generator does not create this file):

```ruby
# config/puma.rb
threads 5, 5  # min, max threads per process
workers 2     # forked processes; leave out to run a single process
```

Puma reads this file whether you start it with `padrino start -a puma` or
`bundle exec puma`. With `padrino start`, the address comes from `-h` and `-p`
(default `127.0.0.1:3000`), so any `bind` or `port` in `config/puma.rb` is
ignored. You can also set the thread pool on the command line:

```bash
$ padrino start -a puma -O Threads=1:8
```

Threads in one process take turns running Ruby code, but they overlap while a
request waits on the database or another service. Workers are separate
processes, so they can use more than one CPU core.

## Falcon: fibers

[Falcon](https://github.com/socketry/falcon) runs each request in its own fiber
on Ruby's fiber scheduler. While one request waits on IO, the others keep
running in the same thread.

When the project uses Falcon, the ORM generators add a fiber setting to
`config/database.rb`, both for `padrino g project --server=falcon` and when you
add an ORM later with `padrino g component`:

ORM                       | Setting
------------------------- | -------------------------------------------------------------
Sequel                    | `Sequel.extension :fiber_concurrency`
Active Record, MiniRecord | `ActiveSupport::IsolatedExecutionState.isolation_level = :fiber`
Mongoid                   | `Mongoid::Config.isolation_level = :fiber` (Mongoid 9.1+, Ruby 3.2+)

This keeps database connections and ORM state per request instead of per
thread.

`padrino start -a falcon` runs a single process. To run several, use Falcon's
own command:

```bash
$ bundle exec falcon serve --bind http://0.0.0.0:3000 --count 4
```

Fibers don't preempt each other. CPU-heavy work, or a library call that does
not yield to the fiber scheduler, holds up every other request in that process.

## Thread safety

Each request gets its own instance of your app, so instance variables set in a
route, filter or helper belong to that request. Anything shared between
requests is shared by every thread: constants, class variables, globals,
settings changed at runtime and class-level caches. Don't change them while
serving requests, or guard them with a `Mutex`.

Give the database pool at least as many connections as you have threads: the
`pool` option in Active Record (default 5) or `max_connections` in Sequel
(default 4).

If some code can't be made thread safe, `enable :lock` makes the app handle one
request at a time in each process.
