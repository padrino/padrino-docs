---
chapter: Adding Components
title: Rendering Engine
---

# Rendering Engine


Contributing a rendering engine to Padrino is actually quite straightforward. For this guide, let's assume we want to add `haml` as a rendering engine integrated into Padrino.


First let's add rendering engine into the generator in [padrino-gen/generators/components/renderers/haml.rb](http://github.com/padrino/padrino-framework/blob/master/padrino-gen/lib/padrino-gen/generators/components/renderers/haml.rb):


```ruby
# padrino-gen/lib/padrino-gen/generators/components/renderers/haml.rb
def setup_renderer
  require_dependencies 'haml'
end
```


Let's also add a test to ensure the new rendering component generates as expected in [padrino-gen/test/test\_project\_generator.rb](http://github.com/padrino/padrino-framework/blob/master/padrino-gen/test/test_project_generator.rb#L450):


```ruby
# padrino-gen/test/test_project_generator.rb
should "properly generate for haml" do
  buffer = silence_logger { @project.start(['sample_project', '--root=/tmp', '--renderer=haml','--script=none']) }
  assert_match /Applying.*?haml.*?renderer/, buffer
  assert_match_in_file(/gem 'haml'/, '/tmp/sample_project/Gemfile')
end
```


and finally let's update the README for `padrino-gen` to reflect the new component in [padrino-gen/README.rdoc](http://github.com/padrino/padrino-framework/blob/master/padrino-gen/README.rdoc):


```ruby
# padrino-gen/README.rdoc
renderer:: erb (default), haml
```


When adding support for a new rendering engine, you are highly encouraged to also include support for this engine within the `padrino-admin` gem. This admin gem constructs views and forms based on templates provided for each supported renderer.


When adding a new renderer, be sure to add templates for each of the necessary admin views. The necessary templates and structure can be found in the [padrino-admin/generators/templates/haml](http://github.com/padrino/padrino-framework/tree/master/padrino-admin/lib/padrino-admin/generators/templates/haml/) views folder. Be sure to implement all of these if you want the integrated rendering engine to work with the admin dashboard.


Finally, let's update the `padrino-admin` README file at [padrino-admin/README.rdoc](http://github.com/padrino/padrino-framework/blob/master/padrino-admin/README.rdoc) to reflect our newly support component:


```ruby
# padrino-admin/README.rdoc
Template Agnostic:: Erb and Haml Renderer
```


This completes the full integration of a rendering engine into Padrino. Once all of this has been finished in your github fork, send us a pull request and assuming you followed these instructions properly and the engine actually works when generated, we will include the component into the next Padrino version crediting you for the contribution!

