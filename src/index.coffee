_ = require 'underscore'
handlers = require './handlers'
context = require './context'

module.exports = _.extend \
    handlers.registry, 
    handlers.File,
    handlers,
    context
