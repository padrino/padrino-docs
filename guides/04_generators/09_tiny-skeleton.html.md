---
chapter: Generators
title: Tiny Skeleton
---

# Tiny Skeleton

Both the Project Generator and Sub App Generator allow you to create an even
smaller project skeleton. Instead of the default skeleton, the tiny option
removes the need for a controllers, helpers, and mailers folder and instead
generates `controllers.rb`, `helpers.rb`, and `mailers.rb` in its place.

To use the tiny skeleton generator for project run:

```shell
$ padrino g project tiny_app -d mongoid --tiny
```

To use the tiny skeleton generator for app run in your project:

```shell
$ padrino g app tiny_app --tiny
```
