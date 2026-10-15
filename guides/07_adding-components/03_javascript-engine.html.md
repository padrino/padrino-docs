---
chapter: Adding Components
title: JavaScript Engine
---

# JavaScript Engine

Contributing an additional JavaScript library to Padrino is actually quite
straightforward. For this guide, let's look at how the `jquery` component is
integrated into Padrino; a new library follows the same steps.

## Generators

Every file in `padrino-gen/lib/padrino-gen/generators/components/scripts/` is a
choice for `--script`, named after the file. There's no list of components to
edit: adding `scripts/mylib.rb` is enough for `padrino g project --script=mylib`
and, in an existing project, `padrino g component --script=mylib`. Both read the
file and then
[call its `setup_script` method](https://github.com/padrino/padrino-framework/blob/0.17.0/padrino-gen/lib/padrino-gen/generators/actions.rb#L41-L46).

Here is the integration of jQuery into the generator, in
[padrino-gen/generators/components/scripts/jquery.rb](https://github.com/padrino/padrino-framework/blob/0.17.0/padrino-gen/lib/padrino-gen/generators/components/scripts/jquery.rb#L1-L10):

```ruby
# padrino-gen/lib/padrino-gen/generators/components/scripts/jquery.rb

def setup_script
  begin
    get('https://raw.githubusercontent.com/padrino/padrino-static/master/js/jquery.js',  destination_root('/public/javascripts/jquery.js'))
    get('https://raw.githubusercontent.com/padrino/padrino-static/master/ujs/jquery.js', destination_root('/public/javascripts/jquery-ujs.js'))
  rescue StandardError
    copy_file('templates/static/js/jquery.js',  destination_root('/public/javascripts/jquery.js'))
    copy_file('templates/static/ujs/jquery.js', destination_root('/public/javascripts/jquery-ujs.js'))
  end
  create_file(destination_root('/public/javascripts/application.js'), '// Put your application scripts here')
end
```

This downloads the latest version of the library and its unobtrusive JavaScript
adapter into the `public/javascripts` folder of the project, and constructs the
`application.js` file. Without a network connection, it copies the versions
that ship with the gem instead.

The library itself doesn't live in padrino-gen: it lives in
[padrino-static](https://github.com/padrino/padrino-static), in `js/` for the
library and `ujs/` for the adapter. padrino-gen includes padrino-static as a git
submodule at `padrino-gen/lib/padrino-gen/generators/templates/static`, which is
where the `templates/static/...` paths above point. So the first step for a new
library is a pull request to padrino-static that adds, for example,
`js/mylib.js`.

`padrino g component` also runs `setup_script` in existing projects, where
people have edited their files. For a file like `application.js`, pass
`skip: true` to `create_file` so that a re-run keeps it. The jquery component
doesn't, so a re-run asks whether to overwrite `application.js`.

## Tests

Let's also add a test to ensure the new JavaScript component generates as
expected in
[padrino-gen/test/test\_project\_generator.rb](https://github.com/padrino/padrino-framework/blob/0.17.0/padrino-gen/test/test_project_generator.rb#L585-L592):

```ruby
# padrino-gen/test/test_project_generator.rb
describe 'the generator for script component' do
  it 'should properly generate for jquery' do
    out, = capture_io { generate(:project, 'sample_project', "--root=#{@apptmp}", '--script=jquery') }
    assert_match(/applying.*?jquery.*?script/, out)
    assert_file_exists("#{@apptmp}/sample_project/public/javascripts/jquery.js")
    assert_file_exists("#{@apptmp}/sample_project/public/javascripts/jquery-ujs.js")
    assert_file_exists("#{@apptmp}/sample_project/public/javascripts/application.js")
  end
  ...
end
```

[padrino-gen/test/test\_component\_generator.rb](https://github.com/padrino/padrino-framework/blob/0.17.0/padrino-gen/test/test_component_generator.rb#L308-L317)
has tests for `padrino g component`, for example for running it again on a
project that already uses jquery.

The tests don't download anything: `stub_static_files` in
[padrino-gen/test/helper.rb](https://github.com/padrino/padrino-framework/blob/0.17.0/padrino-gen/test/helper.rb#L23)
answers the padrino-static URLs from a list of files, and any other request
fails the test. Add `js/mylib.js` and `ujs/mylib.js` to that list. Run the
tests with:

```shell
$ cd padrino-gen
$ bundle exec ruby -Ilib -Itest -I../padrino/test test/test_project_generator.rb -n '/script component/'
```

## README

Finally, let's update the README for `padrino-gen` to reflect the new component
in
[padrino-gen/README.rdoc](https://github.com/padrino/padrino-framework/blob/0.17.0/padrino-gen/README.rdoc#L45):

```ruby
# padrino-gen/README.rdoc
script::     none  (default), jquery, prototype, mootools, dojo, vite
```

## Unobtrusive JavaScript Adapter

Although optional, you can also provide a unobtrusive JavaScript (UJS) adapter
which provides 'remote' and 'method' support to a project using a particular
JavaScript framework. For more information about UJS, check out the
[UJS Helpers](/guides/application-helpers/ujs-helpers/)
guide.

To support UJS in a given JavaScript framework, simply create a new file such as
`ujs/mylib.js` in your [padrino-static](https://github.com/padrino/padrino-static)
fork and then follow the UJS
[adapter template](https://github.com/padrino/padrino-static/blob/7ebb439866507988b249e14179e50e8d93a1dd13/ujs/jquery.js)
used by the jQuery implementation. It listens on `document` with jQuery's `.on`,
so links and forms added to the page later are handled too:

```javascript
// ujs/jquery.js

/* Remote Form Support
 * form_for @user, '/user', :remote => true
**/

$(function(){
    $(document).on('submit', 'form', function(e) {
      // ...
    });

    /* Confirmation Support
     * link_to 'sign out', '/logout', :confirm => 'Log out?'
    **/
    $(document).on('click', 'a[data-confirm]', function(e) {
      // ...
    });

    /* Link Remote Support
     * link_to 'add item', '/create', :remote => true
    **/
    $(document).on('click', 'a[data-remote=true]', function(e) {
      // ...
    });

    /* Link Method Support
     * link_to 'delete item', '/destroy', :method => :delete
    **/
    $(document).on('click', 'a[data-method]:not([data-remote])', function(e) {
      // ...
    });

    /* JSAdapter */
    var JSAdapter = {
      // Sends an xhr request to the specified url with given verb and params
      // JSAdapter.sendRequest(element, { verb: 'put', url : '...', params: {} });
      sendRequest: function(element, options) {
        // ...
      },
      // Triggers a particular method verb to be triggered in a form posting to the url
      // JSAdapter.sendMethod(element);
      sendMethod: function(element) {
        // ...
      }
    };

    // Same-origin requests that change state are sent along with the CSRF token.
    $.ajaxPrefilter(function(options, originalOptions, xhr) {
      // ...
    });
});
```

Generally the only changes need to be made in the `JSAdapter` JavaScript module
specifically to implement the `sendRequest` and `sendMethod` functions that are
used by all the events to power the UJS functionality. Keep the CSRF handling:
`sendMethod` adds the token from the page's `csrf-param` and `csrf-token` meta
tags to the form it submits, and the adapter sends the `X-CSRF-Token` header
only on same-origin requests that change data.

Once that unobtrusive adapter has been implemented, copy it in `setup_script`
next to the library, as the jquery component does with `jquery-ujs.js`:

```ruby
# padrino-gen/lib/padrino-gen/generators/components/scripts/mylib.rb
def setup_script
  begin
    get('https://raw.githubusercontent.com/padrino/padrino-static/master/js/mylib.js',  destination_root('/public/javascripts/mylib.js'))
    get('https://raw.githubusercontent.com/padrino/padrino-static/master/ujs/mylib.js', destination_root('/public/javascripts/mylib-ujs.js'))
  rescue StandardError
    copy_file('templates/static/js/mylib.js',  destination_root('/public/javascripts/mylib.js'))
    copy_file('templates/static/ujs/mylib.js', destination_root('/public/javascripts/mylib-ujs.js'))
  end
  create_file(destination_root('/public/javascripts/application.js'), '// Put your application scripts here', skip: true)
end
```

and check for the adapter in the test, as the jquery test does with
`jquery-ujs.js`.

## Contribute to Padrino

This completes the full integration of a JavaScript library into Padrino. Once
all of this has been finished in your GitHub forks, send us pull requests (one
to padrino-static for the library and adapter, one to padrino-framework for
the component, its tests, the README, a line in `CHANGES.rdoc` and a bump of the
`templates/static` submodule to the padrino-static commit that adds the library)
and,
assuming you followed these instructions properly and the library actually
works when generated, we will include the component into the next Padrino
version crediting you for the contribution!

The [commit](https://github.com/padrino/padrino-framework/commit/2b2c1a0500ab2c07035e7be8b2d98bb03c3ebfd5)
that added the `vite` script component in 0.17.0 (from
[@osbre](https://github.com/osbre)'s
[#2334](https://github.com/padrino/padrino-framework/pull/2334)) is a recent
example: the component file, its project and component generator tests, the
README and the `CHANGES.rdoc` line.
