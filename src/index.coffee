_ = require 'underscore'
{File, parsers, handlers} = require './handlers'

exports.File = File
exports.parsers = parsers
exports.handlers = handlers

normalize = (file) ->
    if typeof file is 'string'
        file = new File path: file
    file

exports.findHandlerType = findType = (file) ->
    if parsers.hasHandler file
        'parsers'
    else if handlers.hasHandler file
        'handlers'
    else
        false

exports.findHandler = (file) ->
    file = normalize file
    type = findType file
    return false unless type
    exports[type].findHandler file

exports.getHandler = (file) ->
    file = normalize file
    type = findType file
    return false unless type
    exports[type].getHandler file

exports.hasHandler = (file) ->
    file = normalize file
    type = findType file
    return false unless type
    exports[type].hasHandler file

exports.compile = (file, context, send) ->
    file = normalize file
    type = findType file
    # console.log "about to compile #{file.path} of type #{type}"
    exports[type].compile file, context, send

exports.parse = ->
    exports.compile arguments...