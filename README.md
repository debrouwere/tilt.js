Tilt.js is a generic interface to various JavaScript and CSS preprocessors, like LESS, Jade, CoffeeScript, HAML and so on, written in CoffeeScript for the node.js platform. Tilt.js autodetects file formats based on path and mimetype.

Tilt.js is a cousin of [Tilt](https://github.com/rtomayko/tilt), an unaffiliated but very similar library for Ruby.

For template languages that support it, Tilt.js can also do precompilation, which parses the template and turns it into JavaScript for faster client-side rendering. Compile with `tilt.compile` and precompile with `tilt.preCompile`, both of which take a `tilt.File object`, a context object (mainly useful for templates languages) and a callback with the result.

Install with `npm install tilt`.

Example:

    var tilt = require('tilt');
    var file = new tilt.File({path: 'homepage.jade'});
    tilt.compile(file, {page_title: 'Hello world'}, function(template){
        // this is the rendered html template
        // (or css, or javascript)
        console.log(template);
    });

Less than a 100 lines of code if you don't count the handlers for each individual format, so browse through the code for more information. Extracted from (and used in) the [Draughtsman](https://github.com/stdbrouw/draughtsman) front-end prototyping server.
