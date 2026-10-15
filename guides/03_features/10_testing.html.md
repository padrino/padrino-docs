---
chapter: Features
title: Testing
---

# Testing

Padrino apps are Rack apps, so you test them with
[rack-test](https://github.com/rack/rack-test): send a request, then check the
response. Choose a test framework, and optionally a mocking library, when you
generate the project:

```shell
$ padrino g project demo -t rspec
$ padrino g project demo -t minitest -m mocha
```

The [project generator](/guides/generators/projects/) lists every test and mock
component. The generated project has a test helper (`spec/spec_helper.rb` for
RSpec, `test/test_config.rb` for the others) and a rake task. The controller,
model and helper generators add a test file for what they create.

Run the suite, or a single file:

```shell
$ bundle exec rake spec    # RSpec
$ bundle exec rake test    # minitest, test-unit, shoulda and bacon
$ bundle exec rspec spec/app/controllers/posts_controller_spec.rb
$ bundle exec ruby -Itest test/app/controllers/posts_controller_test.rb
```

## Requests

The test helper includes `Rack::Test::Methods`, so a test can call `get`,
`post`, `put`, `delete` and the other verbs, then read `last_response`:

```ruby
# spec/app/controllers/posts_controller_spec.rb
require 'spec_helper'

RSpec.describe '/posts' do
  it 'lists the posts' do
    get '/posts'
    expect(last_response).to be_ok
    expect(last_response.body).to eq 'Hello World'
  end

  it 'creates a post' do
    post '/posts/create', title: 'Hi'
    expect(last_response.body).to eq 'created Hi'
  end
end
```

The same test with minitest:

```ruby
# test/app/controllers/posts_controller_test.rb
require File.expand_path("#{__dir__}/../../test_config.rb")

describe '/posts' do
  it 'lists the posts' do
    get '/posts'
    assert last_response.ok?
    assert_equal 'Hello World', last_response.body
  end
end
```

Requests go to the `app` method defined in the test helper. By default it
returns `Padrino.application`, which serves every mounted app at its mount
point, so a request to an app mounted at `/blog` starts with `/blog`. To test
one app on its own, return that app class instead. Its paths then don't include
the mount point:

```ruby
describe 'the blog' do
  def app
    Demo::Blog
  end

  it 'lists the posts' do
    get '/posts'
    assert last_response.ok?
  end
end
```

## The test environment

The test helper sets `RACK_ENV` to `test` before it loads `config/boot.rb`. The
generated `config/apps.rb` turns CSRF protection off in that environment:

```ruby
set :protect_from_csrf, Padrino.env != :test
```

So a test can `post` without an `authenticity_token`. To test the protection
itself, see [CSRF Protection](/guides/controllers/csrf-protection/#testing).

## Sessions

rack-test keeps cookies between the requests of one test, so a session started
by one request (a login, for example) is there for the next. To start a test
with values already in the session, pass them in the `rack.session` entry of
the request's Rack env, the third argument:

```ruby
it 'shows the posts of the signed-in user' do
  get '/posts/mine', {}, 'rack.session' => { user_id: 1 }
  expect(last_response.body).to eq 'posts of user 1'
end
```

To check what a request stored in the session, read it from `last_request`:

```ruby
post '/posts/create', title: 'Hi'
expect(last_request.env['rack.session'][:last_title]).to eq 'Hi'
```

## Stubbing helpers

Helpers are instance methods of the app, and each request runs on a new
instance of the app class. To stub a helper such as `current_user` in a
controller test, stub it on any instance of the app class that handles the
request.

With RSpec:

```ruby
it 'shows the posts of the current user' do
  allow_any_instance_of(Demo::App).to receive(:current_user).and_return('alice')
  get '/posts/mine'
  expect(last_response.body).to eq 'posts of alice'
end
```

With mocha (`-m mocha`):

```ruby
it 'shows the posts of the current user' do
  Demo::App.any_instance.stubs(:current_user).returns('alice')
  get '/posts/mine'
  assert_equal 'posts of alice', last_response.body
end
```

Both remove the stub when the test ends.
