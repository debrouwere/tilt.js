fs = require 'fs'
fs.path = require 'path'
_ = require 'underscore'
yaml = require './parsers/yaml'

here = (segments...) ->
    fs.path.join __dirname, segments...

class exports.File
    constructor: (options) ->
        for key, val of options
            @[key] = val

        if not @path then throw new Error "You must specify a file path."
        if not @extension then @extension = fs.path.extname(@path).replace('.', '')
        if not @basename then @basename = fs.path.basename(@path)
        if not @name then @name = @basename.substr 0, (@basename.length - @extension.length - 1)
        if not @context then @context = no

    eval: ->
        require @path

    load: (callback) ->
        if @content?
            callback @
        else
            fs.readFile @path, 'utf8', (errors, @content) =>
                callback @

    extractFrontMatter: (callback) ->
        if @content.match /^---\s*/
            documents = _.compact @content.split /---\s*/g
            [meta, @content] = documents
        else
            @meta = {}
            return callback null

        yaml.compiler {content: meta}, null, (err, @meta) =>
            callback err

class exports.Registry
    constructor: (path) ->
        @path = path
        @handlers = {}

        for handler_path in fs.readdirSync here @path
            handler_file = new exports.File path: here @path, handler_path
            handler = handler_file.eval()
            _.extend handler, handler_file
            @handlers[handler.name] = handler

        @packages = _.compact _.flatten _.pluck @handlers, 'packages'

    getHandlerByExtension: (extension) ->
        for name, handler of @handlers
            return handler if extension in handler.extensions
        undefined

    getHandlerByMime: (mime) ->
        for name, handler of @handlers
            return handler if handler.mime.source is mime
        undefined

    getHandlerByName: (name) ->
        return @handlers[name]

    # Get a handler by its type (either extension, mime or name)
    getHandler: (type) ->
        handler =
            (@getHandlerByExtension type) or
            (@getHandlerByMime type) or
            (@getHandlerByName type)

        return handler

    # Find a handler based on a file object
    findHandler: (file) ->
        if file.mime
            return @getHandlerByMime file.mime
        else if file.type
            return @getHandlerByName file.type
        else
            return @getHandlerByExtension file.extension

    hasHandler: (file) ->
        @findHandler(file)?

    compile: (file, context, send) ->
        file.load =>
            handler = @findHandler file
            #compile = -> handler.compiler file, context, send

            if handler
                # mixed means a file format can contain YAML front matter
                # in addition to the main format
                if handler.mixed is yes
                    file.extractFrontMatter -> handler.compiler file, context, send
                else
                    handler.compiler file, context, send
            else
                send new Error \
                    "Didn't find a a preprocessor for this filetype or extension."

    # an alias to `compile`
    parse: ->
        @compile arguments...

    preCompile: (file, context, send) ->
        file.load =>
            handler = @findHandler file
            if handler
                if handler.precompiler?
                    handler.precompiler file, context, send
                else
                    send new Error "Found a handler for this filetype, but it doesn't have a precompiler."
            else
                send new Error \
                    "Didn't find a a preprocessor for this filetype or extension."

    noop: (file, context, send) ->
        file.load =>
            send null, file.content

exports.handlers = new exports.Registry "handlers"
exports.parsers = new exports.Registry "parsers"
