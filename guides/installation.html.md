---
date: 2010-03-01
update: 2015-12-15
author: Nathan
email: nesquena@gmail.com
title: Installation
---

# Installation

In order to use Padrino, you need a few prerequisite libraries.

---


## Ruby & RubyGems

First, you need to have a ruby interpreter installed. You can verify if you have
the interpreter installed by typing `which ruby` into the terminal and ensuring
a result. If not, we recommend installing
[RVM](https://rvm.io/ "RVM") on most platforms which manages
your ruby interpreter installation and configuration. Once RVM is installed, be
sure to install Ruby 1.9.2 (recommended) or any other ruby such as 1.8.7,
[Rubinius](http://rubini.us/ "Rubinius"), or
[JRuby](http://jruby.org/ "JRuby") according to your needs.


Once you have ruby, you need to make sure you have
[RubyGems](https://rubygems.org "RubyGems") which is the standard Ruby package management
method. You can ensure you have ruby gems by typing `gem -v` in the terminal and
ensuring a version result. If not, then be sure to
[download and install](https://rubygems.org/pages/download "download and install") before continuing.


### Windows

A caveat: If you are on Windows, we recommend the
[RubyInstaller](http://rubyinstaller.org "RubyInstaller") project which takes care of the above
steps for you.

---


## Padrino

Once you have ruby and rubygems installed properly, you just need to install the
Padrino framework with the `padrino` gem:


~~~ sh
$ gem install padrino
~~~


This will install all the necessary padrino dependencies to get you started
creating applications. Now you are ready to use this gem to
[enhance your Sinatra projects](/guides/standalone-usage-in-sinatra "enhance your Sinatra projects") or to
create new Padrino applications. If you are new to Ruby or Sinatra, be sure to
check out the [Getting Started](/guides/getting-started "Getting Started") guide for more
information.

[Next Section &ndash; Basic Projects](/guides/basic-projects){: .button}
{: .excerpt}

