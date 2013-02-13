---
author: Foo Bar
title: Drop-in Admin
label: Home Feature
---

Padrino ships with an Admin Interface that includes the following features:


| *Adapter*          | *Description*                                                                                 |
|--------------------|-----------------------------------------------------------------------------------------------|
| Orm Agnostic       | Adapters for datamapper, activerecord, sequel, mongomapper, mongoid                           |
| Authentication     | Account authentication support and permission management                                      |
| Template Agnostic  | View support for Erb and Haml rendering engines                                               |
| Scaffold           | Create a model “admin interface” by invoking a command                                        |
| Multilanguage      | Translated into 10 languages including English, Spanish, and Italian                          |


Example:


    $ padrino-gen project cool -orm activerecord
    $ cd cool
    $ padrino-gen admin
    $ padrino-gen admin_page post


For usage information, check out our detailed [admin guide](/guides/padrino-admin).

