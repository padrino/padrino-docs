---
chapter: Features
title: Padrino Cache
---

# Padrino Cache

This component enables caching of an application's response contents on both
page- and fragment-levels. Output cached in this manner is persisted, until it
expires or is actively expired, in a configurable store of your choosing. Most
popular key/value stores work out of the box. Take a look at the [Moneta
documentation](http://rubydoc.info/gems/moneta) for a list of all supported
stores.

## Caching Quickstart

Padrino-cache can reduce the processing load on your site very effectively
with minimal configuration.

By default, the component caches pages in a file store at
`tmp/<app name>/cache` within your project root (`tmp/demo/app/cache` for an
app class `Demo::App`). Each entry is keyed by the request path, with one cache
entry per path; the query string is not part of the key (see
[Page cache keys](#page-cache-keys) below).

This behavior is referred to as "page-level caching." If this strategy meets
your needs, you can enable it very easily:

```ruby
# Page-level caching
class SimpleApp < Padrino::Application
  register Padrino::Cache
  enable :caching

  get '/foo', cache: true do
    expires 30 # expire cached version at least every 30 seconds
    'Hello world'
  end
end
```

You can also cache on a controller-wide basis:

```ruby
# Controller-wide caching example
class SimpleApp < Padrino::Application
  register Padrino::Cache
  enable :caching

  get '/' do
    'Hello world'
  end

  # Requests to routes within '/admin'
  controller '/admin', :cache => true do
    expires 60

    get '/foo' do
      'Url is /admin/foo'
    end

    get '/bar' do
      'Url is /admin/bar'
    end

    post '/baz' do # We cache only GET and HEAD request
      'This will not be cached'
    end
  end
end
```

You can also provide a custom `cache_key` in any route:

```ruby
class SimpleApp < Padrino::Application
  register Padrino::Cache
  enable :caching

  get '/post/:id', :cache => true do
    @post = Post.find(params[:id])
    cache_key { "post-#{params[:id]}" }
    render 'posts/show'
  end
end
```

Each post then gets its own cache entry, and you can expire one manually with
`SimpleApp.cache.delete("post-#{post.id}")`, for example from the Post model
after an update. [Page cache keys](#page-cache-keys) below describes each form
of key and what the default key leaves out.

If you specify `:cache => true` but do not invoke `expires`, the response will
be cached indefinitely. Most of the time, you will want to specify the expiry
of a cache entry by `expires`. Even a relatively low value--1 or 2
seconds--can greatly increase application efficiency, especially when enabled
on a very active part of your domain.

## Helpers

When an application registers padrino-cache, it gains access to several helper
methods. These methods are used according to your caching strategy, so they
are explained here likewise--by functionality.

As with all code optimization, you may want to start simply (at "page level"),
and continue if necessary into sub-page (or "fragment level" ) caching. There
is no one way to approach caching, but it's always good to avoid complexity
until you need it. Start at the page level and see if it works for you.

The padrino-cache helpers are made available to your application thusly:

```ruby
# Enable caching
class CachedApp < Padrino::Application
  register Padrino::Cache  # includes helpers
  enable :caching          # turns on caching

  # ... controllers/routes ...
end
```

### Page Caching

As described above in the "Caching Quickstart" section, page caching is very
easy to integrate into your application. To turn it on, simply provide the
`:cache => true` option on either a controller or one of its routes. By
default, cached content is persisted with a "file store"--that is, in a
subdirectory of your application root.

#### `expires( seconds )`

This helper is used within a controller or route to indicate how often cached
*page-level* content should persist in the cache.

After `seconds` seconds have passed, content previously cached will be
discarded and re-rendered. Code associated with that route will *not* be
executed; rather, its previous output will be sent to the client with a 200 OK
status code.

```ruby
# Setting content expiry time
class CachedApp < Padrino::Application
  register Padrino::Cache  # includes helpers
  enable :caching          # turns on caching

  controller '/blog', :cache => true do
    expires 15

    get '/entries' do
      'just broke up eating twinkies lol'
    end
  end
end
```

Note that the "latest" method call to `expires` determines its value: if
called within a route, as opposed to a controller definition, the route's
value will be assumed.

#### Page cache keys

Each cached page is stored under one key. Without `cache_key`, the key is the
request path (`env['PATH_INFO']`). Nothing else about the request is part of
it:

*   the query string: `/posts?page=1` and `/posts?page=2` share one entry (see
    [Caching URLs with query strings](#caching-urls-with-query-strings));
*   cookies, the session and request headers such as `Accept` or `User-Agent`:
    a route that serves several formats (`provides: [:html, :json]`), or routes
    on one path told apart by `agent:`, share one entry, and the first response
    stored is sent to all of them;
*   the mount point: the path is relative to the app, so two mounted apps that
    share one store share entries for the same path. Each app gets its own store
    by default.

`GET` and `HEAD` requests share an entry; other verbs are never cached.

`cache_key` replaces the path with a key of your own, in one of three forms:

*   **A block**, `cache_key { "post-#{params[:id]}" }`, is evaluated before the
    route's code runs, to look the page up, and again after it on a miss, to
    store the new page. Build it from `params`, `request` or `session`, not from
    variables the route sets. The block must return a key for every request; if
    it returns nil, the request path is used.
*   **A Symbol**, `cache_key :about`, names one entry shared by every request of
    the route, whatever its params. Use it only on a route whose page is the same
    for everyone, and expire it with `CachedApp.cache.delete(:about)`.
*   **A String** set inside the route applies only to that request: the lookup
    has already happened by then, so it never produces a cache hit. Use the block
    form, or set the String in a `before` filter scoped to that route (such as
    `before(:show)` for a route named `:show` in its controller), since an
    app-wide filter would apply that key to every cached route.

Only the response body and its content type are stored. A cached page is sent
with status 200 to every request that maps to its key, without the other
headers the route set (such as `Set-Cookie`). A route that calls `halt` or
`redirect` is not cached, but one that sets `status 404` and returns a body is,
and is then served as 200.

So a page that shows anything specific to one visitor, such as the signed-in
user or a flash message, must not be cached under a key that leaves that out:
the first visitor's page would be sent to everyone else. Leave such pages
uncached, cache only their shared parts with [fragment
caching](#fragment-caching), or put what varies into the key:

```ruby
get :dashboard, cache: true do
  cache_key { "dashboard-#{session[:user_id]}" }
  render 'dashboard'
end

get :feed, cache: true, provides: [:html, :json] do
  cache_key { "#{request.path_info}.#{content_type}" }
  render 'feed'
end
```

After you add or change a route's `cache_key`, clear the store (for example
`Demo::App.cache.clear`, or delete `tmp/<app name>/cache`), so pages stored
under the old key aren't served.

`before` filters and route conditions still run for a cached page, because the
cache is checked after them, so a login check in a `before` filter also guards
the cached copy.

### Fragment Caching

Whereas page-level caching, described in the first section of this document,
works by grabbing the entire output of a route, fragment caching gives the
developer fine-grained control of what gets cached. This type of caching
occurs at whatever level you choose.

Possible uses for fragment caching might include:

*   a 'feed' of some items on a page
*   output fetched (by proxy) from an API on a third-party site
*   parts of your page which are largely static/do not need re-rendering every
    request
*   any output which is expensive to render


#### `cache( key, opts, &block )`

This helper is used anywhere in your application you would like to associate a
fragment to be cached. It can be used in within a route:

```ruby
# Caching a fragment
class MyTweets < Padrino::Application
  register Padrino::Cache  # includes helpers
  enable :caching          # turns on caching

  controller '/tweets' do
    get :feed, map: '/:username' do
      username = params[:username]

      @feed = cache("feed_for_#{username}", expires: 3) do
        @tweets = Tweet.all(username: username)
        render 'partials/feedcontent'
      end

      # Below outputs @feed somewhere in its markup
      render 'feeds/show'
    end
  end
end
```

This example adds a key to the cache of format `feed_for_#{username}` which
contains the contents of that user's feed. Any subsequent action within the
next 3 seconds will fetch the pre-rendered version of `feed_for_#{username}`
from the cache instead of re-rendering it. The rest of the page code will,
however, be re-executed.

Note that any other action will reference the same content if it uses the same
key:

```ruby
# Multiple routes sharing the same cached fragment
class MyTweets < Padrino::Application
  register Padrino::Cache  # includes helpers
  enable :caching          # turns on caching

  controller :tweets do
    get :feed, map: '/:username' do
      username = params[:username]

      @feed = cache("feed_for_#{username}", expires: 3) do
        @tweets = Tweet.all(username: username)
        render 'partials/feedcontent'
      end

      # Below outputs @feed somewhere in its markup
      render 'feeds/show'
    end

    get :mobile_feed, map: '/:username.iphone' do
      username = params[:username]

      @feed = cache("feed_for_#{username}", expires: 3) do
        @tweets = Tweet.all(username: username)
        render 'partials/feedcontent'
      end

      render 'feeds/show.iphone'
    end
  end
end
```

The `opts` argument is actually passed to the underlying store. The stores
support the `:expires` option out of the box or are enhanced by Moneta to
support it.

Finally, to DRY up things a bit, we might do:

```ruby
# Multiple routes sharing the same cached fragment
class MyTweets < Padrino::Application
  register Padrino::Cache  # includes helpers
  enable :caching          # turns on caching

  controller :tweets do
    # This works because all routes in this controller specify :username
    before do
      @feed = cache("feed_for_#{params[:username]}", expires: 3) do
        @tweets = Tweet.all(username: params[:username])
        render 'partials/feedcontent'
      end
    end

    get :feed, map: '/:username' do
      render 'feeds/show'
    end

    get :mobile_feed, map: '/:username.iphone' do
      render 'feeds/show.iphone'
    end
  end
end
```

Of course, this example assumes the markup generated by rendering
`partials/feedcontent` would be suitable for both feed formats. This may or
may not be the case in your application, but the principle applies: fragments
are shared between all code which accesses the cache using the same key.

### Caching URLs with query strings
Another use of `cache_key` is when you’d like to include query string parameters
as part of the key; for example when using `will_paginate`, you might want to
cache `url?page=1` separately from  `url?page=2`:

```ruby
cache_key { request.path_info + (params[:page] ? "?page=#{params[:page]}" : '') }
```

If you're using `ActiveSupport`, you can make this a bit more robust:

```ruby
cache_key { request.path_info + '?' + params.slice('page').to_param }
```

## Caching Store

You can set a global caching option or a per app caching options.

### Global Caching Options

```ruby
Padrino.cache = Padrino::Cache.new(:LRUHash) # in-memory, the default choice
Padrino.cache = Padrino::Cache.new(:File, dir: Padrino.root('tmp', app_name.to_s, 'cache')) # Keeps cached values in file
Padrino.cache = Padrino::Cache.new(:Memcached) # Uses default server at localhost
Padrino.cache = Padrino::Cache.new(:Memcached, server: '127.0.0.1:11211', exception_retry_limit: 1)
Padrino.cache = Padrino::Cache.new(:Memcached, backend: memcached_or_dalli_instance)
Padrino.cache = Padrino::Cache.new(:Redis) # Uses default server at localhost
Padrino.cache = Padrino::Cache.new(:Redis, host: '127.0.0.1', port: 6379, db: 0)
Padrino.cache = Padrino::Cache.new(:Redis, backend: redis_instance)
Padrino.cache = Padrino::Cache.new(:Mongo) # Uses default server at localhost
Padrino.cache = Padrino::Cache.new(:Mongo, backend: mongo_client_instance)
```

You can manage your cache from anywhere in your app:

```ruby
Padrino.cache['val'] = 'test'
Padrino.cache['val'] # => 'test'
Padrino.cache.delete('val')
Padrino.cache.clear
```

The Padrino cache constructor `Padrino::Cache.new` calls `Moneta.new` to
create a cache instance. Please refer to the [Moneta
documentation](http://rubydoc.info/gems/moneta) if you have special
requirements, for example if you want to configure the marshalling mechanism
or use a more exotic backend.

### Application Caching Options

```ruby
set :cache, Padrino::Cache.new(:LRUHash) # in-memory
set :cache, Padrino::Cache.new(:Memcached)
set :cache, Padrino::Cache.new(:Redis)
set :cache, Padrino::Cache.new(:File, dir: Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
```

You can manage your cache from anywhere in your app:

```ruby
MyApp.cache['val'] = 'test'
MyApp.cache['val'] # => 'test'
MyApp.cache.delete('val')
MyApp.cache.clear
```

## Expiring Cached Content

In certain circumstances, cached content becomes stale. The `expire` helper
removes content associated with a key or keys, which your app is then free to
re-generate.

### `expire( *key )`

#### Fragment-level expiration

Using the example above of a tweet server, let's suppose our users have a
tendency to post things they quickly regret. When we query our database for
new tweets, let's check to see if any have been deleted. If so, we'll do our
user a favor and instantly re-render the feed.

```ruby
# Expiring fragment-level cached content
class MyTweets < Padrino::Application
  register Padrino::Cache # includes helpers
  enable :caching         # turns on caching
  enable :session         # we'll use this to store last time visited

  COMPANY_FOUNDING = Time.utc(2010, 'April')

  controller :tweets do
    get :feed, map: '/:username' do
      last_visit = session[:last_visit] || params[:since] || COMPANY_FOUNDING

      username = params[:username]
      @tweets = Tweet.since(last_visit, username: username).limit(100)

      expire("feed since #{last_visit}") if @tweets.any? { |t| t.deleted_since?(last_visit) }

      session[:last_visit] = Time.now
      @feed = cache("feed since #{last_visit}", expires: 60) do
        @tweets = @tweets.find_all { |t| !t.deleted? }
        render 'partials/feedcontent'
      end

      render 'feeds/show'
    end
  end
end
```

Normally, this example will only re-cache feed content every 60 seconds, but
it will do so immediately if any tweets have been deleted.

#### Page-level expiration

Page-level expiration works exactly like the example above--by using `expire`
in your controller. The key is the request path (`env['PATH_INFO']`), or
the key the route gives `cache_key`.
