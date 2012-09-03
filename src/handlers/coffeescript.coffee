coffee = require 'coffee-script'

module.exports =
    extensions: ['coffee']
    mime:
        source: 'text/coffeescript'
        output: 'application/javascript'
    compiler: (file, context, send) ->
        try
            javascript = coffee.compile file.content
        catch err
            send err

        send null, javascript
