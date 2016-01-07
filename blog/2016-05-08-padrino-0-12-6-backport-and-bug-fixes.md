---
date: 2016-05-08
author: Nathan Esquenazi
email: nesquena@gmail.com
categories: ruby update
tags: padrino, sinatra, ruby, release
title: Padrino 0.12.6 - Backporting and Bug Fixes
---

About 8 month ago, we released Padrino 0.12.5 in September 2015. Today, we are releasing 0.12.6 which backports a number of important bug fixes back to the 0.12.x release line.

## Bug Fixes and Miscellaneous

There are many important bug fixes and other updates:

- FIX properly reload classes without instances ("@ujifgc":https://github.com/ujifgc)
- FIX do not pollute original Minitest::Benchmark ("@ujifgc":https://github.com/ujifgc)
- FIX "#2027":https://github.com/padrino/padrino-framework/issues/2027 Use Module#name instead of Module#to_s ("@namusyaka":https://github.com/namusyaka)
- FIX Remove empty rows and cols from textarea tag ("@ujifgc":https://github.com/ujifgc)
- FIX "#2029":https://github.com/padrino/padrino-framework/issues/2029 Don't set a value attribute on label tags ("@sshaw":https://github.com/sshaw)
- FIX allow Padrino::Rendering on stdlib ERB ("@ujifgc":https://github.com/ujifgc)
- FIX "#1880":https://github.com/padrino/padrino-framework/issues/1880 Use proper file extention when resolving template for content_type ("@ujifgc":https://github.com/ujifgc)
- FIX "#1796":https://github.com/padrino/padrino-framework/issues/1796 save and restore layout setting ("@ujifgc":https://github.com/ujifgc)

Please report any issues you encounter with this release! We are working very actively on Padrino and want to make the framework as stable and reliable as possible. That concludes the changelog for this release. As always if you want to keep up with Padrino updates, be sure to follow us on twitter: [@padrinorb](http://twitter.com/#!/padrinorb), join us on IRC at “#padrino” on freenode or [open an issue](https://github.com/padrino/padrino-framework/issues) on GitHub.
