---
chapter: Getting Started
title: Installation
updated: 2016-02-21
---

# Installation

In order to use Padrino, you need a few prerequisite libraries.

--------------------------------------------------------------------------------

## Ruby & RubyGems

First, you need to have a ruby interpreter installed. You can verify if you have
the interpreter installed by typing `which ruby` into the terminal and ensuring
a result. If not, we recommend installing [RVM](https://rvm.io/ "RVM") on most
platforms which manages your ruby interpreter installation and configuration.
Once RVM is installed, be sure to install Ruby 2.3.0 (recommended) or any other
ruby such as 2.0.0, [Rubinius](http://rubini.us/ "Rubinius"), or
[JRuby](http://jruby.org/ "JRuby") according to your needs.

Once you have ruby, you need to make sure you have
[RubyGems](https://rubygems.org "RubyGems") which is the standard Ruby package
management method. You can ensure you have ruby gems by typing `gem -v` in the
terminal and ensuring a version result. If not, then be sure to
[download and install](https://rubygems.org/pages/download "download and
install") before continuing.

### Windows

A caveat: If you are on Windows, we recommend the
[RubyInstaller](http://rubyinstaller.org "RubyInstaller") project which takes
care of the above steps for you.

--------------------------------------------------------------------------------

## Padrino

Once you have ruby and rubygems installed properly, you just need to install the
Padrino framework with the `padrino` gem:

```shell
$ gem install padrino
```

This will install all the necessary padrino dependencies to get you started
creating applications. Now you are ready to use this gem to
[enhance your Sinatra projects](/guides/advanced-usage/standalone-usage-in-sinatra "enhance
your Sinatra projects") or to create new Padrino applications. If you are new to
Ruby or Sinatra, be sure to check out the
[Why Learn Padrino?](/guides/introduction/why-learn-padrino "Why Learn Padrino?") guide for more
information.
