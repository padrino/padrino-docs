---
author: Foo Bar
tags: padrino, sinatra, ruby
categories: Update
title: Padrino 0.9.28 - Reloader, Compatibility and Bug Fixes
---

Two very small additions:

- Added an alias to `padrino start` as `padrino s` for convenience
  [here](https://github.com/padrino/padrino-framework/commit/ef47900afffc1ff0743fc3aa723639efd4975d06)
- Added an easy way to generate a Rakefile
  [here](https://github.com/padrino/padrino-framework/commit/81e54b116d54ee791ccd44e7156ee4156f16034c). This allows
  you to stop using `padrino rake` and use `rake` directly.  Especially useful for Heroku deployed apps! Simply run
  `$ padrino rake gen`.


This is a simple bug fix release with these being the major fixes:


- Development reloader hangs during reload fixed
  [here](https://github.com/padrino/padrino-framework/commit/054c2795600d2ce7e220dd1cef2cbe2755b273d2)
- Updated `couch_rest` models and dependencies
  [here](https://github.com/padrino/padrino-framework/commit/d6d053965511fb170cf5befc89bbeeefa7cd24e9) and
  [here](https://github.com/padrino/padrino-framework/commit/a836741cf6017ae955f90d44a743c4a0b226e1d7)
- Fixed mongoid and mongomapper deps
  [here](https://github.com/padrino/padrino-framework/commit/e5cff99646e50b6f44d1bb7b07e63090a688b551) and
  [here](https://github.com/padrino/padrino-framework/commit/ff320862bfbf76ff3c46e70aa519672039ad1604). Thanks to
  RoryO for the pull request.

