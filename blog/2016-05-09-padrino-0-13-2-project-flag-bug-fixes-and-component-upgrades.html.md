---
date: 2016-05-09
author: Nathan Esquenazi
email: nesquena@gmail.com
categories: ruby update
tags: padrino, sinatra, ruby, release
title: Padrino 0.13.2 - New Project Flag, Component Upgrades and Bug Fixes
---

Padrino 0.13.1 was shipped just over 3 months ago in January 2016 and since then we have had many issues reported and fixed. After a few months of effort, we are excited to announce the release of Padrino 0.13.2! This version is filled with a new project generator flag, minimizing dependence on AS, upgrading a few components and a number of other bug fixes.

## New API Project Generator Flag

In this release, we've introduced a new project generator flag of `--api`. When this flag is used during project generation, the following changes are applied to the new project:

 * Project only has `padrino-core` and `padrino-gen` listed as dependencies in the Gemfile.
 * `Padrino::Mailer` and `Padrino::Helpers` are not registered or referenced in the project.
 * Automatically sets `:renderer`, `:scripts`, and `:stylesheet` to `none` in `.components`.

You can see more about this in [pull request #1921](https://github.com/padrino/padrino-framework/issues/1921). Thanks to [@ujifgc](https://github.com/ujifgc) for implementing this.

## Simplified Initializers

Many apps have configuration code that needs to run first as the project starts up before the application is loaded. Padrino has always supported this with initializers in `lib/NAME_initializer.rb`. However, there were no guarantees that this code would run before other project code leading to dependency issues due to loading order. In this release, we have introduced the `config/initializers` folder which get loaded once during startup before any other app code is loaded. Initializers look like this:

```ruby
# config/initializers/some_useful.rb
# code run once after Padrino.before_load before Padrino.after_load
# good place to define some plugin-related constants
module SomeUsefulInitializer
  def self.registered(app)
    # this is where we setup components or configuration for the project
  end
end
```

In your app code, for example `app/app.rb`, we can register this with:

```ruby
register SomeUsefulInitializer
```

You can see more about this in [pull request #2032](https://github.com/padrino/padrino-framework/pull/2032). Thanks to [@ujifgc](https://github.com/ujifgc) for implementing this.

## Minimize ActiveSupport Dependence

Over the last few releases, we have been working to minimize our dependency on `ActiveSupport`. Note that at this time the library is still a required dependency. However, we are incrementally removing all uses of this library from the internals of Padrino whenever possible.

For those interested, we've removed many ActiveSupport methods from internal usage including but not limited to:

 * [active_support/time](https://github.com/padrino/padrino-framework/commit/39514ce8fbb02207e0833a69d2b89eed6457c2f4)
 * [active_support/time_with_zone](https://github.com/padrino/padrino-framework/commit/83462d3cf6961308dbb9dbb511b64f6d6aa189d0)
 * [array#prepend](https://github.com/padrino/padrino-framework/commit/c2602739630f1c4681b004d6684c6e0f083feecd)
 * [hash#except](https://github.com/padrino/padrino-framework/commit/6443dd254dbca3c29f6624a710a2ca71f2551027)
 * [hash#with_options](https://github.com/padrino/padrino-framework/commit/193e7755cf988f6cbd7b5574793a72232a5c0b8b)
 * [cattr_accessor](https://github.com/padrino/padrino-framework/commit/af177cc2aebb73961ae47c40b853b7601d4c88e3)
 * [hash#reverse_merge](https://github.com/padrino/padrino-framework/commit/a335e0d8328d841e5481a9bc567ed3ad928e8eba)
 * [alias_method_chain](https://github.com/padrino/padrino-framework/commit/da54bef74d48db154ca1c1a5150aac4391165217)

Thanks to [@ujifgc](https://github.com/ujifgc) for leading these efforts.

## Component Upgrades

We've upgraded or fixed a few components:

- FIX [#1789](https://github.com/padrino/padrino-framework/issues/1789) Relax Tilt version to allow Tilt 2 (>= 1.4.1, < 3) ([@ujifgc](https://github.com/ujifgc))
- FIX [#2011](https://github.com/padrino/padrino-framework/issues/2011) Update mongoid database configuration ([@serradura](https://github.com/serradura))

## Bug Fixes and Miscellaneous

There are several bug fixes and other updates:

- WARN [#1989](https://github.com/padrino/padrino-framework/issues/1989) Warn about coming behavior change ([@ujifgc](https://github.com/ujifgc))
- NEW [#1987](https://github.com/padrino/padrino-framework/issues/1987) Generator now fails with invalid namespace ([@ujifgc](https://github.com/ujifgc))
- FIX [#2007](https://github.com/padrino/padrino-framework/issues/2007) Respect Regexp#names at the time of route search ([@namusyaka](https://github.com/namusyaka))
- FIX [#2004](https://github.com/padrino/padrino-framework/issues/2004) Set default alt attribute for image_tag ([@namusyaka](https://github.com/namusyaka))
- FIX [#2008](https://github.com/padrino/padrino-framework/issues/2008) Login button on the admin app now looks as expected ([@namusyaka](https://github.com/namusyaka))
- FIX Remove empty rows and cols from textarea tag ([@ujifgc](https://github.com/ujifgc))
- FIX [#2015](https://github.com/padrino/padrino-framework/issues/2015) Update broken links in the README and docs ([@mariozig](https://github.com/mariozig))
- FIX [#2023](https://github.com/padrino/padrino-framework/issues/2023) Preserve `default_builder` set in configure_apps ([@ujifgc](https://github.com/ujifgc))
- FIX [#2025](https://github.com/padrino/padrino-framework/issues/2025) Match plugin names with dashes in their names ([@wikimatze](https://github.com/wikimatze))
- FIX [#2029](https://github.com/padrino/padrino-framework/issues/2029) Don't set a value attribute on label tags ([@sshaw](https://github.com/sshaw))
- WARN Notice about removing ObjectSpace.classes and ObjectSpace.new_classes in 0.14 ([@ujifgc](https://github.com/ujifgc))
- FIX [#2027](https://github.com/padrino/padrino-framework/issues/2027) Use Module#name instead of Module#to_s ([@namusyaka](https://github.com/namusyaka))
- NEW Logger option :sanitize_encoding ([@ujifgc](https://github.com/ujifgc))
- FIX [#2006](https://github.com/padrino/padrino-framework/issues/2006) load missing AR models before calling seeds.rb ([@ujifgc](https://github.com/ujifgc))

