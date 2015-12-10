---
date: 2015-09-10 10:54 UTC
author: Nathan Esquenazi
email: nesquena@gmail.com
categories: press ruby update
tags: padrino ruby
title: Padrino 0.12.5
---

Almost six months ago, we released 0.12.4 which introduced a number of improvements to the rack mounter, improving documentation and releasing bug fixes. Today, we are releasing the a small update on the 0.12.x line which includes a few of bug fixes. The details of this release can be found below.

## Bug Fixes and Miscellaneous

* FIX [#1794][1794] inheritance of global prereqs ([@ujifgc][ujifgc])
* FIX [#1798][1798] handling non-array `with` statement for params ([@ujifgc][ujifgc])
* FIX Russian translation for password ([@harrykiselev][harrykiselev])
* FIX Prevent Padrino from overriding cache settings ([@dariocravero][dariocravero])
* FIX sequence of execution for configuration methods in application ([@namusyaka][namusyaka])
* FIX translations for admin for cs ([@ortiga][ortiga])
* FIX exception raised when running the controller generator ([@namusyaka][namusyaka])
* FIX [#1875][1875] lock down rack to < 1.6.0 because of sinatra conflict ([@ujifgc][ujifgc])

Please do report any issues you have. We are working very actively on Padrino and want to make the framework as stable and reliable as possible. That concludes the changelog for this release. As always if you want to keep up with Padrino updates, be sure to follow us on twitter: [@padrinorb][padrinorb], join us on IRC at “#padrino” on freenode or [open an issue][open_issue] on GitHub.

[1794]: https://github.com/padrino/padrino-framework/issues/1794
[1798]: https://github.com/padrino/padrino-framework/issues/1798
[1875]: https://github.com/padrino/padrino-framework/issues/1875

[ujifgc]: https://github.com/ujifgc
[harrykiselev]: https://github.com/harrykiselev
[dariocravero]: https://github.com/dariocravero
[namusyaka]: https://github.com/namusyaka
[ortiga]: https://github.com/ortiga

[padrinorb]: http://twitter.com/#!/padrinorb
[open_issue]: https://github.com/padrino/padrino-framework/issues
