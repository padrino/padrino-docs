---
date: 2016-01-17
author: Nathan Esquenazi
email: nesquena@gmail.com
categories: Ruby, Update
tags: padrino, sinatra, ruby, release
title: Padrino 0.13.1 - Router and Reloader Updates, Ruby Compatibility, and Bug Fixes
---

Padrino 0.13.0 was shipped 3 months ago on October 2015 and laid important groundwork towards our eventual 1.0 release. However, switching to an entirely new router and several other substantial updates caused some new hiccups to be introduced. After a few months of effort, we are excited to announce the release of Padrino 0.13.1! This version is filled with routing and reloader optimizations, compatibility updates, and bug fixes. Full details for this release are below. 

## Router and Reloader Updates

The biggest improvement in this release is a significant reduction in the memory usage of Padrino apps by changing the configuration of the underlying mustermann router. Full list of improvements to router and reloader include:

- FIX [#1975](https://github.com/padrino/padrino-framework/issues/1975) Improve routing memory usage and performance ([@namusyaka](https://github.com/namusyaka))
- FIX [#1982](https://github.com/padrino/padrino-framework/issues/1982) Support nested query for expanding path ([@namusyaka](https://github.com/namusyaka))
- FIX [#1978](https://github.com/padrino/padrino-framework/issues/1978) Enable reloading of custom dependencies ([@markglenfletcher](https://github.com/markglenfletcher))

## Ruby Compatibility

Padrino 0.13.1 has been fixed to be fully compatible with Ruby 2.3 thanks to [@tyabe](https://github.com/tyabe):

- FIX [#2000](https://github.com/padrino/padrino-framework/issues/2000) Fix mutex handling for Ruby 2.3 ([@tyabe](https://github.com/tyabe))

## Bug Fixes and Miscellaneous

There are also several bug fixes and other updates:

- FIX Remove use of ActiveSupport in tests ([@ujifgc](https://github.com/ujifgc))
- FIX [#1994](https://github.com/padrino/padrino-framework/issues/1994) Missing new line in mocha generator ([@peter50216](https://github.com/peter50216))
- FIX [#1995](https://github.com/padrino/padrino-framework/issues/1995) Invalid german dates ([@ujifgc](https://github.com/ujifgc))
- FIX [#1998](https://github.com/padrino/padrino-framework/issues/1998) Only output a warning message if the spec task is invoked ([@postmodern](https://github.com/postmodern))
- FIX [#1882](https://github.com/padrino/padrino-framework/issues/1882) test for selected values for select tag ([@ujifgc](https://github.com/ujifgc))
- FIX rendering exception for custom mime types ([@nesquena](https://github.com/nesquena))
- FIX relax mail gem dependency ([@ujifgc](https://github.com/ujifgc))
- FIX minor doc typos ([@lokyoung](https://github.com/lokyoung), [@markglenfletcher](https://github.com/markglenfletcher))

Please report any issues you encounter with this release! We are working very actively on Padrino and want to make the framework as stable and reliable as possible. That concludes the changelog for this release. As always if you want to keep up with Padrino updates, be sure to follow us on twitter: [@padrinorb](http://twitter.com/#!/padrinorb), join us on IRC at “#padrino” on freenode or [open an issue](https://github.com/padrino/padrino-framework/issues) on GitHub.
