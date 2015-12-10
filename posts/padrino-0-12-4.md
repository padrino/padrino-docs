---
date: 2014-10-16 22:21 UTC
author: Nathan Esquenazi
email: nesquena@gmail.com
categories: press ruby update
tags: padrino ruby
title: Padrino 0.12.4
---

Two months ago, we released 0.12.3 which introduced a number of improvements to the core codebase and put our 0.12.x branch into a solid place. Today, we are releasing the final iteration on the 0.12.x line which includes a ton of bug fixes and documentation cleanup. The details of this release can be found below. This release paves the road for our 0.13.0 release that will likely follow next with several substantial changes in place. The details of this 0.12.4 release can be found below.


## Mounter Supports Rack

The Padrino Mounter has always been one of the cores of our framework and allowed the flexible mounting of many different padrino apps within the same project. This functionality is at the heart of the light modular app architecture that powers Padrino. However, until recently the mounter only worked for Padrino apps. With this release, @namusyaka removed that restriction and now we can map any Rack, Grape or Sinatra app into a Padrino project:

~~~ ruby
# config/apps.rb
Padrino.mount('SinatraApp', app_file: Padrino.root('sinatra_app/app.rb'))
Padrino.mount('Sample::API', app_file: Padrino.root('api/app.rb'))
~~~

We are excited for our router to be that much more flexible going forward towards 1.0!


## Fixing Padrino Docs

A few months ago, we were honored to be brought onto the RubyRogues podcast to discuss the Padrino Framework and explain why we think Sinatra and Padrino are a great way to build modern and maintainable ruby web apps and APIs.

However, we recognize that our framework has a challenge. Our Padrino guides are almost all woefully outdated and unmaintained and our website is old and rusty. We are fortunate to have Matthias Gunther working tirelessly on the awesome Padrino Book but we recognize we need to do better. To get things going, we have merged all of our markdown docs into the main padrino code repository.

We realize this is only a small first step and we know that one of the biggest roadblocks to a real 1.0 release is a substantial refresh of our documentation and our website. More updates about this soon. If anyone is interested in helping with the documentation effort, please reach out to us.


## Bug Fixes and Miscellaneous

A few deprecation notices:

- There were issues with the implementation of button_to which require deprecating the old behavior and instead wrapping the content of a given block with the <button></button> tags

Lots of other bug fixes and code cleanup as usual:

- FIX #1744 Corrects color support for Windows (@tyabe)
- FIX #1736 Regression with textarea helper (@ujifgc)
- FIX #1743 Add a padrino-gen generator for creating new Helpers (@dariocravero)
- FIX #1746 Avoid reloading the file if its path is not started with Padrino.root (@namusyaka)
- DELETE deprecated build_object method (@namusyaka)
- FIX #1752 Don’t set the _use_format flag when provides method is called from inline (@namusyaka)
- FIX #48 Update mailer documentation and sample code (@postmodern)
- FIX #1752 Refactor routing code to avoid weird parameter (@namusyaka)
- FIX #1754 Adds end tags to admin erb template for index (@namusyaka)
- FIX #1749 Replace the AR::ConnectionManagement middleware with new middleware (@namusyaka)
- NEW #1756 Adds support for mysql2 gem in sql rake task helpers (@d6rkaiz)
- FIX #1761 Allow passing upcased string as the app name
- FIX #1776 improve params filtering for routes (@ujifgc)
- FIX #1778 Various YARD doc inconsistencies or errors (@claudiob)
- FIX #1765 Use controller’s base path instead of constant name at controller test (@namusyaka)
- FIX #1781 Removes the default_filters method setting incorrect content-type (@namusyaka)
- FIX Sinatra compatibility for passing options to the static! method
- FIX #1585 Update HAML to pass tests by upgrading versions (@ujifgc)
- FIX #1782 make padrino-gen detect absolute paths on Windows (@ujifgc)
- FIX #1779 Use expanded path to request controller’s content (@namusyaka)
- FIX Use yield and flatmap when possible to speed up performance (@ujifgc)
- FIX #1788 exception that occurs when the free regex route exists (@namusyaka)
- NEW Merges the padrino-docs guides and content directly into the main repository (@ujifgc)

Want to give a special thanks to the key contributors for this release, working tirelessly to make this Padrino release possible: @namusyaka, @ujifgc, @dariocravero and all the other contributors to this version!

Please do report any issues you have. We are working very actively on Padrino and want to make the framework as stable and reliable as possible. That concludes the changelog for this release. As always if you want to keep up with Padrino updates, be sure to follow us on twitter: @padrinorb, join us on IRC at “#padrino” on freenode or open an issue on GitHub.
