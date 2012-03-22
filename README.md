# Tilt.js

[![Build Status](https://secure.travis-ci.org/stdbrouw/tilt.js.png)](http://travis-ci.org/stdbrouw/tilt.js)

Tilt.js is a generic interface to various JavaScript and CSS preprocessors, like LESS, Jade, CoffeeScript, HAML and so on, written in CoffeeScript for the node.js platform. Tilt.js autodetects file formats based on path and mimetype.

For template languages that support it, Tilt.js can also do precompilation, which parses the template and turns it into a JavaScript function for faster client-side rendering. Compile with `tilt.compile` and precompile with `tilt.preCompile`, both of which take a `tilt.File object`, a context object (mainly useful for templates languages) and a callback with the result.

When rendering a template, you can either pass Tilt.js a context object containing all the variables your template depends on, or Tilt.js can search for context in data files and make that context available to your templates. 

## Installation

Install with `npm install tilt`.

## Example

    var tilt = require('tilt');
    var file = new tilt.File({path: 'homepage.jade'});
    tilt.compile(file, {page_title: 'Hello world'}, function(template){
        // this is the rendered html template
        // (or css, or javascript)
        console.log(template);
    });

Tilt.js has a small, legible codebase, so feel free to browse through the code for more information.

## Handlers

### Supported formats

#### Templates

* [Jade](http://jade-lang.com/)
* [HAML](https://github.com/creationix/haml-js)
* [Django template language (using Plate)](https://github.com/chrisdickinson/plate)

#### Compile-to-JavaScript languages

* [CoffeeScript](http://coffeescript.org/)

#### CSS preprocessors

* [LESS](http://lesscss.org/)
* [Stylus](http://learnboost.github.com/stylus/)

#### Data 

* JSON
* [YAML](http://yaml.org/)
* CSV (soon)

#### Markup

* Markdown (soon)
* Textile (soon)

### Adding new handlers

Handlers are little wrappers for (pre)compilers, written in CoffeeScript. All handlers are in `src/handlers` and you can easily add your own.

A handler looks like this: 

    stylus = require 'stylus'

    module.exports =
        extensions: ['styl']
        mime:
            source: 'stylesheet/stylus'
            output: 'text/css'
        compiler: (file, context, send) ->
            stylus(file.content).render (err, css) ->
                if err
                    send err
                else
                    send css

The requested file (in its plain/uncompiled state) will be available to you in `file.content`, and the file path is accessible through `file.path`.

The second parameter, `context` includes data you should pass to your template as context. Of course, this only applies to template engines, not CSS preprocessors and the like.

The third parameter, `send`, is a function you should call with the compiled code.

Draughtsman automatically picks up any and all handlers in the `handlers` directory, though
you'll need to run `make` on the app to recompile the code to JavaScript to include your handlers.

Tilt.js is a library for node.js, but handlers' processing doesn't need to happen in node.js itself. Handlers can spawn child processes to do the heavy lifting. That way, you can make a handler for anything that has a command-line tool, regardless of the language it's implemented in. For example, here's an alternative implementation of a CoffeeScript handler: 

    exec = require('child_process').exec

    module.exports =
        extensions: ['coffee']
        mime:
            source: 'text/coffeescript'
            output: 'application/javascript'
        compiler: (file, context, send) ->
            exec 'coffee -cp #{file.path}', (error, stdout, stderr) ->
                if error
                    send error
                else
                    send stdout

Using `exec` is particularly useful for compilers that are intended to be used through the shell, such as for the SASS stylesheet preprocessor, or when you need to write your own precompiler, for example a Python script that renders a file using the [Jinja](http://jinja.pocoo.org/) or [Django template language](https://docs.djangoproject.com/en/dev/topics/templates/).

## Context from local data

Static site generation frameworks and prototyping tools often pass data along to templates by searching for context in a couple of predefined locations.

For example, the [Jekyll](https://github.com/mojombo/jekyll) blog engine will automatically make all your blog posts and other metadata available to your templates under `page`, `post` and `content`. And Middleman, a static site generator, looks for YAML data in a `/data` subdirectory and passes that on to templates.

Tilt.js helps you implement similar functionality in your own applications. Here's an example: 

    /* data/homepage.json */
    {
        "title": "Hello world"
    }

    /* homepage.jade */
    !!! 5
    html
        head
            title= title

    /* app.js */
    var tilt = require('tilt');
    tilt.context.findFor('homepage.jade', function(context) {
        console.log(context.data.title === 'Hello world');
    });

### Conventions (mostly implemented)

By default, Tilt.js its context finder works with conventions that are very similar to those [Middleman](http://middlemanapp.com/guides/local-yaml-data) uses for local YAML data, with a couple of added features.

Data is read from YAML, JSON, CSV and XML files in a `data` directory underneath the directory where your template resides. (CSV and XML support pending.)

`tilt.context.findFor` returns the data it found as a context hash. Data is available under the `data` key in the resulting context hash.

Context from `/data/test.json` will be available under `data.test`. If multiple data files are named "test" (e.g. `test.json` and `test.yml` then Tilt will merge the resulting context hashes, and resolve conflicting keys (for example if you specify a title in both the JSON and the YAML file) by picking the value from the last updated (newest) file.

While all context from a data directory is available under the `data` key, the context hash will also contain some shortcuts to data that's (likely to be) specific to a template or page. So if you're rendering index.haml, the `title` context value from an index.json file will be available under `data.index.title` but will also be expanded into the main namespace as just `title`.

Lastly, the context finder expands on Middleman's conventions through context sets. (Pending.) If you have subdirectories inside of your `/data` directory, Tilt will process those as `/data/<template>/<contextset>.json`. For a template called `homepage.dtl` and a data file that lives at `/data/homepage/alt.json`, the resulting `data` object will look like this:
  
    {
        "index": {
            "alt": {
                "key": "val"
            }
        }
    }

This is useful as a basic building block for applications that need to render the same template many times with different data, for example blogposts that all use the same template or a design prototype that you want to have a couple of variations of.

#### Using YAML files

YAML data files work a little bit differently from JSON and CSV. With YAML, your file can contain both data (often called "front matter") and free-form text in separate YAML documents, for example metadata for a blogpost and then the post itself. Documents in a YAML file are separated by a string of three dashes and a newline (`---`).

Here's an example of a YAML file with front matter and body documents: 

    ---
    type: quote
    language: en
    title: Eye-opening
    author: Emily Bell
    ---

    The opening of electronic ears and eyes is not a replacement for reporting. It should be at the heart of it.

The context finder can also parse YAML front matter inside of Markdown (`.md`) and Textile (`.textile`) files, which is very helpful when you're building a blog engine or static site generator.

Data from YAML files is under the `data` key in the context hash just like it would be for JSON or CSV. Front matter (the first YAML document) is under `data.meta` and free-form text (the second YAML document) is under `data.body`.

#### Using XML (soon)

Tilt.js has basic XML support. Anything that can be unambigously translated into JSON will work. Attributes or text nodes will be ignored.

This XML

    <root>
        <title for="document">Hello world</title>
        <authors>
            These are the authors: 
            <author>John</author>
            <author>Beth</author>            
    </root>

will result in this context object

    {
        "title": "Hello world", 
        "authors": [
            {"author": "John"},
            {"author": "Beth"}
        ]
    }

### Customization (soon)

The directory or file Tilt.js searches for context is customizable. You can change the default dir from `data` to something else, you can specify a regex files should match (e.g. prefixed with an underscore), or you can just specify that all context should come from e.g. `data.json` in the current directory.

Additionally, because finding context and rendering templates are separate steps (`tilt.context.findFor` and `tilt.compile`), your application can use and modify the context hash returned by the context finder however you want it to before passing on the context to the compiler.

    TODO: example

For example, you could make only a subset of the data available to the template. You could also loop over arrays in a context hash and render a separate page for each item.

    TODO: example

## Related projects

Tilt.js is a cousin of [Tilt](https://github.com/rtomayko/tilt), an unaffiliated but very similar library for Ruby.

Extracted from (and used in) the [Draughtsman](https://github.com/stdbrouw/draughtsman) front-end prototyping server.
