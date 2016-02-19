---
chapter: Adding Components
title: JavaScript Engine
---

# JavaScript Engine

Contributing an additional JavaScript library to Padrino is actually quite
straightforward. For this guide, let’s assume we want to add `extcore` as a
JavaScript component integrated into Padrino.

## Generators

First, let’s add `extcore` to the
project generator’s available components in
[padrino-gen/generators/project.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/project.rb#L36):

```ruby
# padrino-gen/lib/padrino-gen/generators/project.rb

component_option :script, "javascript library", :choices => [:jquery, :prototype, :extcore]
```

Next, let’s define the actual integration of the javascript into the generator
in
[padrino-gen/generators/components/scripts/extcore.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/components/scripts/extcore.rb):

```ruby
# padrino-gen/lib/padrino-gen/generators/components/scripts/extcore.rb

def setup_script
  copy_file('templates/scripts/ext-core.js', destination_root("/public/javascripts/ext-core.js"))
  create_file(destination_root('/public/javascripts/application.js'), "// Put scripts here")
end
```

This will copy the script into the `public/javascripts` folder of a newly
generated project and construct the `application.js` file. Next, let’s copy the
latest version of the javascript library to the templates folder:

```javascript
// padrino-gen/lib/padrino-gen/generators/templates/scripts/ext-core.js

// ...truncated javascript library code here...
```

## Tests

Let’s also add a test to ensure the new JavaScript component generates as
expected in
[padrino-gen/test/test\_project\_generator.rb](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/test/test_project_generator.rb#L517):

```ruby
# padrino-gen/test/test_project_generator.rb

it 'should properly generate for ext-core' do
  out, err = capture_io { generate(:project, 'sample_project', "--root=#{@apptmp}", '--script=extcore') }
  assert_match(/applying.*?extcore.*?script/, out)
  assert_file_exists("#{@apptmp}/sample_project/public/javascripts/ext.js")
  assert_file_exists("#{@apptmp}/sample_project/public/javascripts/ext-ujs.js")
  assert_file_exists("#{@apptmp}/sample_project/public/javascripts/application.js")
end
```

## README

Finally, let’s update the README for `padrino-gen` to reflect the new component
in
[padrino-gen/README.rdoc](https://github.com/padrino/padrino-framework/blob/master/padrino-gen/README.rdoc):

```ruby
# padrino-gen/README.rdoc

script:: none  (default), jquery, prototype, mootools, rightjs, , dojo, extcore
```

## Unobtrusive JavaScript Adapter

Although optional, you can also provide a unobtrusive JavaScript (UJS) adapter
which provides ‘remote’ and ‘method’ support to a project using a particular
JavaScript framework. For more information about UJS, check out the
[UJS Helpers](https://www.padrinorb.com/guides/application-helpers#unobtrusive-javascript-helpers)
guide.

To support UJS in a given JavaScript framework, simply create a new file such as
‘jquery-ujs’ in your [padrino-static](https://github.com/padrino/padrino-static)
fork and then follow the UJS
[adapter template](https://github.com/padrino/padrino-static/blob/master/ujs/jquery.js)
used by the existing implementation.

```javascript
// ujs/jquery-ujs.js

/* Remote Form Support
 * form_for @user, '/user', :remote => true
**/
$("form[data-remote=true]").live('submit', function(e) {
  // ...
});
/* Confirmation Support
 * link_to 'sign out', '/logout', :confirm => "Log out?"
 * Link Remote Support
 * link_to 'add item', '/create', :remote => true
 * Link Method Support
 * link_to 'delete item', '/destroy', :method => :delete
**/

/* JSAdapter */
var JSAdapter = {
  // Sends an xhr request to the specified url with given verb and params
  // JSAdapter.sendRequest(element, { verb: 'put', url : '...', params: {} });
  sendRequest : function(element, options) {
    // ...
  },
  // Triggers a particular method verb to be triggered in a form posting to the url
  // JSAdapter.sendMethod(element);
  sendMethod : function(element) {
    // ...
  }
};
```

Generally the only changes need to be made in the `JSAdapter` JavaScript module
specifically to implement the `sendRequest` and `sendMethod` functions that are
used by all the events to power the UJS functionality.

Once that unobtrusive adapter has been implemented, you can finish by adding the
UJS file to the generator in Padrino:

```ruby
# padrino-gen/lib/padrino-gen/generators/components/scripts/extcore.rb

def setup_script
  get('https://github.com/padrino/padrino-static/raw/master/js/jquery.js',
     destination_root("/public/javascripts/jquery.js"))
  get('https://github.com/padrino/padrino-static/raw/master/ujs/jquery-ujs.js',
     destination_root("/public/javascripts/jquery-ujs.js"))
  create_file(destination_root('/public/javascripts/application.js'),
     "// Put your application scripts here")
end
```

and update the tests:

```ruby
# padrino-gen/test/test_project_generator.rb

context "the generator for script component" do
  should "properly generate for jquery" do
    # ...
    assert_match(/Applying.*?jquery.*?script/, buffer)
    assert_file_exists("#{@apptmp}/sample_project/public/javascripts/jquery.js")
    assert_file_exists("#{@apptmp}/sample_project/public/javascripts/jquery-ujs.js")
    assert_file_exists("#{@apptmp}/sample_project/public/javascripts/application.js")
  end
  # ...
end
```

## Contribute to Padrino

This completes the full integration of a JavaScript library into Padrino. Once
all of this has been finished in your GitHub fork, send us a pull request and
assuming you followed these instructions properly and the library actually works
when generated, we will include the component into the next Padrino version
crediting you for the contribution!

An example of the
[actual commit](https://github.com/padrino/padrino-framework/commit/43fb57dd39fa9d860873c14840e68281e314abb8)
of the `extcore` JavaScript library is a great example of how to contribute to
Padrino.
