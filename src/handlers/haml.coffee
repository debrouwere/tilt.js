haml = require 'haml'

module.exports =
    extensions: ['haml']
    mime:
        source: 'text/haml'
        output: 'text/html'
    compiler: (file, context, send) ->
        send haml(file.content)(context)
