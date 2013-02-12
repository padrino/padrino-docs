---
author: Foo Bar
tags: padrino, release, version
categories: Ruby, Update
title: Padrino 0.9.14 - Important Hotfixes
---

There are three major things fixed in this version. The biggest fix which has been causing a number of issues is the
failure of Padrino to properly camelize application names. This causes a number of uninitialized constant failures for
certain application names. This version re-factors the mounter so that this error no longer occurs and the correct
application class is found in those failing cases. This should fix a number of associated issues related to failing
migrations and scripts.


The next fix is we fixed a warning on `mongo_mapper` because `mongo_mapper` now requires `bson_ext` instead of
`mongo_ext`. The generator has been changed to address this. We also fixed other minor issues that were affecting our
users.


Here is a full list of changes in this version:

- Application generator should create public subfolder
- Refactored application mounter class
- updated mongomapper to use bson_ext
- use entity code instead of copyright symbol
- ensure app generation creates own public folder
- fix padrino g alias
- fixed `distance_of_time_in_words` helper (Thanks to Yannick Koechlin)


Please download this version as soon as you can to correct these important issue.

