---
author: Foo Bar
tags: ruby, updates
categories: Ruby, Update
title: Padrino 0.9.22 - Quick Followup Release
---

## Locked Padrino to Sinatra 1.1

Padrino will soon be fully compatible with Sinatra 1.2.0. Until then, we locked Padrino to Sinatra < 1.2.0 in order to
guarantee proper functioning in this release.


## Performance Improvements

Padrino is always striving to be faster and to give more throughput.  After all a big advantage of Padrino is that it
require less memory and resources than other frameworks as well as providing higher requests per second. There has been
a recent push to [update our benchmarks](https://github.com/DAddYE/web-frameworks-benchmark/wiki/achiu) to be as correct
and relevant as possible. Thanks to judofyr for his help with making the benchmarks more accurate. See [the
results](https://github.com/DAddYE/web-frameworks-benchmark/wiki/achiu) or fork us and help improve them.


In that vein we also made to small changes to improve performance:


- Padrino now subclasses from Sinatra::Base rather than Sinatra::Application. This is faster and doesn't remove any
  functionality we require.
- Padrino now supports the `set :padrino_logging, false` option to stop Padrino from logging and improve speed
  significantly in return.


There will be a stronger performance push soon as we work to keep Padrino as lightweight as possible.


## HTTP Fixes

Patrick Lef has been kind enough to point out multiple failing http specs in our core handling, so we
[made](https://github.com/padrino/padrino-framework/commit/8f5d1b5104427482ffd16146fb22e30f5dc6ee60") a
[few](https://github.com/padrino/padrino-framework/commit/25042a6c734bbfb97a893fa898d4c9d8924aa810)
[fixes](https://github.com/padrino/padrino-framework/commit/7127017840e8adaee85c345d8fa02655b0fff4f2). Thanks to core
Padrino member Florian for putting those all together so quickly!


Major changes were:

- Set status to 406 on non-provided ACCEPTS
- Return first provided mime-type on ACCEPT = **/**
- Assume **/** if no ACCEPT header is given


Being a web server, Padrino desires to fully respect the standard behaviors specified and we are getting closer each
release :) If you know of any outstanding bugs please
[open an issue](https://github.com/padrino/padrino-framework/issues).


## Japanese Translations

[udzura](https://github.com/udzura) recently sent us Japanese translations to Padrino. We have really gotten quite a lot
of internationalization support for admin and every new language is great to be able to include.  Are we missing a
localization for your language? Be sure to let us know or [submit a patch](http://www.padrinorb.com/pages/contribute) to
help us include that.


## Compatibility fixes

- Fixes mongoid locking it to correct dependency
- Fixes password encryption in the account model
- Fixes mongomapper template in admin

