---
chapter: Introduction
title: Why Learn Padrino?
---

# Why Learn Padrino?

This guide will give an overview the various other guides, resources and steps
towards becoming a Sinatra + Padrino aficionado.

--------------------------------------------------------------------------------

## Advantages

Let's take a second to briefly enumerate three major advantages of learning
Padrino:

### Easy to Learn

The most interesting aspect of the Padrino stack (Rack, Sinatra, et. al.) in
comparison to other web development tools is how modular and standalone each
individual piece of the stack is. This makes learning each part much easier, and
allows people to be productive right away, organically building up their
knowledge of different aspects as they become necessary within a system. This
concept of genuine graduated complexity within a web development stack is
relatively unique to Sinatra and Padrino in the Ruby web world.

### Fast

Sinatra and Padrino are **very fast** relative to other full stack frameworks.
The Padrino stack is lightweight and slim which can be demonstrated in our
[performance benchmarks](https://github.com/DAddYE/web-frameworks-benchmark/wiki
"performance benchmarks"). While all benchmarks should be taken with a grain of
salt, over the course of developing hundreds of applications, we have found that
the memory usage, stability and requests per second speak for themselves.

### Extensible

The other benefit of Sinatra and Padrino is the rich ecosystem of extensions
that can be applied at any level of the stack. For rack, there is a
[wealth of middlewares](https://github.com/rack/rack/wiki/List-of-Middleware
"wealth of middlewares") that can help do almost anything. For Sinatra, there is
also a [large base](http://www.sinatrarb.com/extensions-wild.html "large base")
of extensions to add most any functionality you might need. Best of all, these
are all 100% compatible with Padrino, and using our
[Recipe Box](http://github.com/padrino/padrino-recipes "Recipe Box") and our use
of [Bundler](http://bundler.io "Bundler"), you can enable nearly any library or
functionality you will need with a single command.

--------------------------------------------------------------------------------

## Getting to Know Ruby

A detailed overview of Ruby is beyond the scope of our documentation, but this
guide is intended to point you in the right direction and get you familiarized
with the important terms. The Padrino web framework is built in the
[Ruby programming language](http://www.ruby-lang.org/en/ "Ruby programming
language"). The Padrino codebase is a set of modular libraries for Ruby which
are packaged using [RubyGems](https://rubygems.org/ "RubyGems").

In order to use Ruby and Padrino, you need to
[install the Ruby interpreter](http://www.ruby-lang.org/en/downloads "install
the Ruby interpreter") onto your local machine and setup
[RubyGems](https://rubygems.org/pages/download "RubyGems") so you can install
ruby packages.

You should now be able to execute the following commands in the terminal:

```shell
$ ruby -v
$ gem -v
```

These should return with version numbers and no errors if everything is
installed correctly. Once you have Ruby and Rubygems installed locally, you
should become familiar with the Ruby syntax. We recommend a few resources below
to get yourself familiar with Ruby:

- [TryRuby](http://tryruby.org/levels/1/challenges/0 "TryRuby") – This is an
  interactive tutorial that takes you step by step through learning Ruby. This
  is highly recommended. Visit the site and type "help" to get started.
- [Learn to Program](https://pine.fm/LearnToProgram "Learn to Program") by Chris
  Pines – Excellent first Ruby tutorial, straightforward and excellent overview
  of the language.
- [Learn Ruby the Hard Way](http://learnrubythehardway.org/book/ "Learn Ruby the
  Hard Way") – Newest addition to the group, based off of Zed's excellent Python
  tutorial. Set of exercises that teaches Ruby to you in a rigorous but simple
  approach.
- [Why's Poignant Guide](http://poignant.guide/book/chapter-1.html "Why's
  Poignant Guide") - Definitely the most unorthodox way to learn Ruby, but must
  be mentioned.

Through these guides, learning Ruby the language should be fairly painless and
hopefully you come to appreciate the elegance and simplicity of the syntax. If
you enjoy Ruby and want to continue, the next step is to get familiar with
Sinatra, the ruby DSL for the web.

--------------------------------------------------------------------------------

## Learning to Love Sinatra

Padrino is a framework which builds on the existing functionality of the
[Sinatra](http://sinatrarb.com "Sinatra") Ruby web DSL and provides a variety of
additional tools and helpers to extend this foundation. To use Padrino, one
should be familiar with the basic usage of Sinatra itself.

First, let's install Sinatra through RubyGems:

```shell
$ gem install sinatra
```

Thankfully, Sinatra is probably the easiest to learn tool for making web apps
you have yet encountered. Here is an example of a Sinatra application:

```ruby
# app.rb
require 'sinatra'
get '/hi' do
  "Hello World!"
end
```

and then you can start the application with this in your terminal:

```shell
$ ruby -rubygems app.rb
== Sinatra has taken the stage ...
>> Listening on 0.0.0.0:4567
```

and then visit <http://localhost:4567/hi> in your web browser. It really is that
easy, but there's a lot more to learn!

Resources for Sinatra are listed below:

- [Sinatra Introduction](http://www.sinatrarb.com/intro.html "Sinatra
  Introduction")
- [Sinatra Book](https://github.com/sinatra/sinatra-book "Sinatra Book")
- [Sinatra Github Repo](https://github.com/sinatra/sinatra "Sinatra Github
  Repo")

There are several good Sinatra tutorials as well:

- [Just Do It, Learn Sinatra](http://www.sitepoint.com/just-do-it-learn-sinatra-i/
  "Just Do It, Learn Sinatra")
  – Great step by step 3 part tutorial on Sinatra.
- [Singing with Sinatra](http://code.tutsplus.com/tutorials/singing-with-sinatra--net-18965
  "Singing with Sinatra")
  – Excellent beginners guide to learning Sinatra.
- [Sinatra Usage Examples](http://blog.maxaller.name/2010/01/a-brief-introduction-to-ruby-sinatra-and-haml
  "Sinatra Usage Examples")
  – Great set of examples for how to use Sinatra in code snippets.

Read through these tutorials to understand routes, helpers, and the
request/response cycle that is exposed through Sinatra. The most comprehensive
resource is probably the [Sinatra Book](https://github.com/sinatra/sinatra-book
"Sinatra Book") so make sure to skim through that and familiarize yourself with
the concepts before continuing to Padrino.

--------------------------------------------------------------------------------

## Scalable Sinatra using Padrino

Once you have a solid understanding of Sinatra then you can also already
understand the simplest functionality of Padrino. This is because Padrino acts
as a super-set of Sinatra.

First, check out the [Installation](/guides/getting-started/installation "Installation") guide
to get Padrino setup on your computer through RubyGems.

Padrino itself is a set of modular extensions for Sinatra. These extensions are
actually fairly standalone and you can actually use many Padrino modules in your
existing Sinatra apps through the
[Standalone Usage](/guides/advanced-usage/standalone-usage-in-sinatra "Standalone Usage")
guide. This usage is intended for applications that have already been built that
would benefit from a particular aspect of Padrino such as a mailer or view
helpers. Check out
[our api docs](http://www.rubydoc.info/github/padrino/padrino-framework "our api
docs") for more information about the individual modules.

If you are able to convert your project to Padrino or start a new application
from scratch, we recommend using the full Padrino stack which makes starting a
new project much easier. The best way to get familiar with Padrino is to first
check out the [Blog Tutorial](/guides/getting-started/blog-tutorial "Blog Tutorial") which takes
you step by step through creating a blog in Padrino with an accompanying
screencast. You may also want to checkout the
[Why Padrino (broken)](http://www.padrinorb.com/pages/why "Why Padrino") guide
to understand the benefits of using Padrino.

You should also take time to familiarize yourself with the various "components"
Padrino allows you to use for your application. To make things simple, if you
are new to the Ruby community and want to create a Padrino application with a
good default set of components, generate your project with this command:

```shell
$ padrino g project my_project -d datamapper -t riot -s jquery -e haml -m mocha
```

And then read up on these components:

- [DataMapper](http://datamapper.org/docs/ "DataMapper") – Great Object
  Relational Mapper for interacting with data
- [Haml](http://haml.info/ "Haml") – Solid templating choice for views
- [jQuery](http://jquery.com/ "jQuery") – Excellent javascript framework for
  frontend development
- [Riot](https://github.com/thumblemonks/riot "Riot") – Popular unit testing
  framework for ruby
- [Mocha](http://www.rubydoc.info/github/floehopper/mocha/Mocha/Mock "Mocha") –
  Popular mocking and stubbing for tests

There are also a few important guides that cover the vast majority of Padrino's functionality. These are definitely recommended reading:

- [Blog Tutorial](/guides/getting-started/blog-tutorial "Blog Tutorial") – Step by step blog
  tutorial using Padrino
- [Generators](/guides/generators/overview "Generators") – A reference guide for the
  generator and the various components
- [Project Types](/guides/getting-started/basic-projects "Project Types") – Overview of the
  various project types
- [Application Helpers](/guides/application-helpers/overview "Application Helpers") – A
  reference guide for the view helpers available
- [Controllers and Routing](/guides/controllers/overview "Controllers and Routing") – An
  overview of the enhanced routing system
- [Delivering Mail](/guides/features/padrino-mailer "Delivering Mails") – Overview of how
  to deliver mail in Padrino applications
- [Admin and Authentication](/guides/features/padrino-admin "Admin and Authentication") –
  Admin dashboard and authentication system
- [Caching](/guides/features/padrino-cache) – Page and fragment caching system
- [Mounting Sub-applications](/guides/features/mounting-applications "Mounting
  Sub-applications") – Explanation of the "application" mounting process
- [Development and Terminal Commands](/guides/features/development-commands "Development
  and Terminal Commands") – Important notes about development

These guides should shed light on the various aspects that make Padrino helpful
while developing Sinatra-based applications.
