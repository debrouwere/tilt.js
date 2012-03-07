coffee = require 'coffee-script'

module.exports =
    extensions: ['coffee']
    mime:
        source: 'text/coffeescript'
        output: 'application/javascript'
    compiler: (file, context, send) ->
        javascript = coffee.compile file.content
        send javascript
