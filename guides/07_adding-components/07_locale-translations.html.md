---
chapter: Adding Components
title: Locale Translations
---

# Locale Translations

In addition to components, we also encourage developers to send us their locale
translations allowing Padrino to support a wide variety of different languages.

In order to add locale translations, simply port the following YAML files to
your favorite language. For this example, let's port over Padrino to Russian.
The following YAML files must be translated:

- [padrino-helpers/locale/ru.yml](https://github.com/padrino/padrino-framework/blob/master/padrino-helpers/lib/padrino-helpers/locale/ru.yml)
- [padrino-admin/locale/admin/ru.yml](https://github.com/padrino/padrino-framework/blob/master/padrino-admin/lib/padrino-admin/locale/admin/ru.yml)
- [padrino-admin/locale/orm/ru.yml](https://github.com/padrino/padrino-framework/blob/master/padrino-admin/lib/padrino-admin/locale/orm/ru.yml)

## Contribute to Padrino

This completes the full integration of a new locale into Padrino. Once all of
this has been finished in your GitHub fork, send us a pull request and assuming
you followed these instructions properly and the language has proper
translations, we will include the locale into the next Padrino version crediting
you for the contribution!

An example of the
[actual commit](https://github.com/padrino/padrino-framework/commit/64465d1835cf32996bc36bb14ed9fd1c21e3cd76)
of the Russian locale translations are a great example of how to contribute to
Padrino.
