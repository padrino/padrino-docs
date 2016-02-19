---
chapter: Generators
title: Components
---

# Components

The available components and their default options are same as the Project
Generator.

>
  Options|Default|Aliases|Description
  :------|:------|:------|:----------
  root|.|-r|the root destination path for the project
  adapter|sqlite|-a|specify orm db adapter (mysql, sqlite, postgres)
{: .excerpt--small }

## Examples

Show help and selected components:

```shell
$ padrino g component
```

Add to `minirecord` with `mysql` and `rspec` in your project:

```shell
$ padrino g component -d minirecord -a mysql2 -t rspec
```
