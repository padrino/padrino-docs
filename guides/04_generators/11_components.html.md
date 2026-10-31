---
chapter: Generators
title: Components
---

# Components

The available components and their default options are same as the Project
Generator.

Options | Default | Aliases | Description
------- | ------- | ------- | ------------------------------------------------------------------
app     |         | -n      | the application name
root    | .       | -r      | the root destination path for the project
adapter | sqlite  | -a      | specify orm db adapter (sqlite, mysql, mysql2, mysql-gem, postgres)

## Examples

Show help and selected components:

```shell
$ padrino g component
```

Add to `activerecord` with `mysql` and `rspec` in your project:

```shell
$ padrino g component -d activerecord -a mysql2 -t rspec
```
