# Tilt.js

Tilt.js is a generic interface to various JavaScript and CSS preprocessors, like LESS, Jade, CoffeeScript, HAML and so on, written in CoffeeScript for the node.js platform. Tilt.js autodetects file formats based on path and mimetype.

For template languages that support it, Tilt.js can also do precompilation, which parses the template and turns it into a JavaScript function for faster client-side rendering. Compile with `tilt.compile` and precompile with `tilt.preCompile`, both of which take a `tilt.File object`, a context object (mainly useful for templates languages) and a callback with the result.

When rendering a template, you pass Tilt.js a context object containing all the variables your template depends on and you get rendered html (or precompiled JavaScript, so you desire) in return.

## Status

Tilt.js is **not actively maintained** anymore. For a general-purpose template language consolidation library in node.js, see @visionmedia's [consolidate.js](https://github.com/visionmedia/consolidate.js) library instead.

If you find yourself in need of a template rendering module that can guess the necessary templating engine from the template extension (one of Tilt.js's features), take a look at [Render](https://github.com/stdbrouw/render), which is a wrapper on top of consolidate. Render also comes with a pretty great command-line tool.

The original raison d'être for Tilt.js was usage in the now-abandoned [Draughtsman](https://github.com/stdbrouw/draughtsman) prototyping server, where it would take care of automatically compiling templates, CoffeeScript, LESS and many other things in need of preprocessing. Based on the file extension, Tilt.js and Draughtsman would determine which preprocessor to apply. The result is something similar to `mod_php` in Apache, where whenever you browse to a `.php` file, you don't see raw PHP, but instead the evaluated code.

A more robust though less featureful take on this idea can be found in the [Harp server](http://harpjs.com/) and the related [Harp hosting platform](https://www.harp.io/):

    Harp serves Jade, Markdown, EJS, CoffeeScript, Sass, LESS and Stylus as HTML, CSS & JavaScript—no configuration necessary.

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

## Related projects

Tilt.js is a cousin of [Tilt](https://github.com/rtomayko/tilt), an unaffiliated but very similar library for Ruby.

Extracted from (and used in) the [Draughtsman](https://github.com/stdbrouw/draughtsman) front-end prototyping server.

Tilt.js works really well together with [Espy](https://github.com/stdbrouw/espy), a context finder which is a useful building block for static site generators and is also useful if you need to prototype without a database.
