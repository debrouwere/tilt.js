path = require 'path'
fs = require 'fs'
_ = require 'underscore'

here = (segments...) ->
    path.join __dirname, segments...

class exports.File
    constructor: (options) ->
        for key, val of options
            @[key] = val

        if not @path then throw new Error "You must specify a file path."
        if not @extension then @extension = path.extname(@path).replace('.', '')
        if not @basename then @basename = path.basename(@path)
        if not @name then @name = @basename.substr 0, (@basename.length - @extension.length - 1)

    load: ->
        require @path

exports.getHandlerByExtension = (extension) ->
    for name, handler of exports.handlers
        return handler if extension in handler.extensions
    undefined

exports.getHandlerByMime = (mime) ->
    for name, handler of exports.handlers
        return handler if handler.mime.source is mime
    undefined

exports.getHandlerByName = (name) ->
    return exports.handlers[name]

# Get a handler by its type (either extension, mime or name)
exports.getHandler = (type) ->
    handler =
        exports.getHandlerByExtension type or
        exports.getHandlerByMime type or
        exports.getHandlerByName type

    return handler

# Find a handler based on a file object
exports.findHandler = (file) ->
    if file.mime
        return exports.getHandlerByMime file.mime
    else if file.type
        return exports.getHandlerByName file.type
    else
        return exports.getHandlerByExtension file.extension

exports.hasHandler = (file) ->
    exports.findHandler(file)?

exports.compile = (file, context, send) ->
    handler = exports.findHandler file
    if handler
        return handler.compiler file, context, send
    else
        throw new Error "Didn't find a a preprocessor for this filetype or extension."

exports.preCompile = (file, context, send) ->
    handler = exports.findHandler file
    if handler
        if handler.precompiler?
            handler.precompiler file, context, send
        else
            throw new Error "Found a handler for this filetype, but it doesn't have a precompiler."
    else
        throw new Error "Didn't find a a preprocessor for this filetype or extension."

# setup

exports.handlers = {}

for handler_path in fs.readdirSync here "handlers"
    handler_file = new exports.File path: here "handlers", handler_path
    handler = handler_file.load()
    _.extend handler, handler_file
    exports.handlers[handler.name] = handler
