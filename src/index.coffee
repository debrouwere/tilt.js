_ = require 'underscore'
handlers = require './handlers'

module.exports = _.extend \
    handlers.registry, 
    handlers.File,
    handlers
