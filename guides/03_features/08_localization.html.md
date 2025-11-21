---
chapter: Features
title: Localization
---

# Localization

Padrino supports full localization in:

- padrino-core (date formats, time formats etc ...)
- padrino-admin (admin language, orm fields, orm errors, etc ...)
- padrino-helpers (currency, percentage, precision, duration etc ...)

At the moment we support the following list of languages:

- Czech
- Danish
- German
- English
- Spanish
- French
- Italian
- Dutch
- Norwegian
- Russian
- Polish
- Brazilian Portuguese
- Turkish
- Ukrainian
- Traditional Chinese
- Simplified Chinese
- Japanese

--------------------------------------------------------------------------------

## Provide your translations

Download and translate these files:

- [padrino-core.yml](https://raw.github.com/padrino/padrino-framework/master/padrino-support/lib/padrino-support/locale/en.yml)
- [padrino-admin.yml](http://raw.github.com/padrino/padrino-framework/master/padrino-admin/lib/padrino-admin/locale/admin/en.yml)
- [padrino-admin-orm.yml](http://raw.github.com/padrino/padrino-framework/master/padrino-admin/lib/padrino-admin/locale/orm/en.yml)
- [padrino-helper.yml](http://raw.github.com/padrino/padrino-framework/master/padrino-helpers/lib/padrino-helpers/locale/en.yml)

zip your files and send it to [padrinorb@gmail.com](mailto:padrinorb@gmail.org)

--------------------------------------------------------------------------------

## How to localize your app

The request's locale can be set in a [route filter](http://padrinorb.com/guides/controllers/route-filters/):

```ruby
# Route filter
before do
  I18n.locale = :de
end
```

Or within a route:

```ruby
get "/" do
  I18n.locale = :de
end
```

By default Padrino will search for all `.yml` or `.rb` files located in
`app/locale`; as an example try to add the following to your
`app/locale/de.yml`:

```yml
de:
  foo: Bar
```

in your view or controller or wherever you prefer add:

```ruby
I18n.t('foo')
```

you will get:

```
=> "Bar"
```

For more ways to configure the locale see [Sinatra's I18n recipe](http://recipes.sinatrarb.com/p/development/i18n).

--------------------------------------------------------------------------------

## Translate Models (ActiveRecord)

Translating models via Padrino requires few seconds thanks to a built-in rake
task!

Assuming the following Account model:

```ruby
create_table :accounts do |t|
  t.string :surname
  t.string :name
  t.string :email
  t.string :salt
  t.string :crypted_password
  t.string :role
end
```

add this to your `boot.rb` (or anywhere else):

```ruby
Padrino.before_load do
  I18n.locale = :it
end
```

run padrino rake task for localizing your model:

```shell
$ padrino rake ar:translate
```

A new `it.yml` file will be created into `/app/locale/models/account/it.yml`
with the following:

```yml
it:
  models:
    account:
      name: Account
      attributes:
        id: Id
        name: Name
        surname: Surname
        email: Email
        salt: Salt
        crypted_password: Crypted password
        role: Role
```

You can now edit your generated `it.yml` file to reflect your current locale
(Italian):

```yml
it:
  models:
    account:
      name: Account
      attributes:
        id: Id
        name: Nome
        surname: Cognome
        email: Email
        salt: Salt
        crypted_password: Crypted password
        role: Role
```

padrino-admin will now use your newly created yml file for translating the
column names of grids, forms, error_messages etc ...

--------------------------------------------------------------------------------

## Form Builders

[Form builder](http://padrinorb.com/guides/application-helpers/form-builders/) labels are
automatically translated:

```haml
-form_for :account, url(:accounts_create, :format => :js), :remote => true do |f|
  %table
    %tr
      %td=f.label :name
      %td=f.text_field :name
    %tr
      %td=f.label :surname
      %td=f.text_field :surname
    %tr
      %td=f.label :role
      %td=f.select :role, :options => access_control.roles
```

It looks for translations with a key of `MODEL.attributes.ATTRIBUTE` where `MODEL` is
the name of the model passed to `form_for` and `ATTRIBUTE` is the given attribute name.
