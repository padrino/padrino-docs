---
chapter: Generators
title: Tasks
---

# Tasks

Padrino provides generator for quickly generating new task for your app.

Options     | Default | Aliases | Description
----------- | ------- | ------- | ------------------------------------------------
root        | .       | -r      | the root destination path for the project
description | nil     | -d      | specify the description of your application task
namespace   | nil     | -n      | specify the namespace of your application task

## Examples

Show help:

```shell
$ padrino g task
```

Using the task generator is as simple as:

```shell
$ padrino g task foo
```

Generate the task file with namespace and description options:

```shell
$ padrino g task bar --namespace=sample --description="This\ is\ a\ sample"
```
