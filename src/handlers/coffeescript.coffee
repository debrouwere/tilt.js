module.exports =
    packages: ['coffee-script']
    extensions: ['coffee']
    mime:
        source: 'text/coffeescript'
        output: 'application/javascript'
    compiler: (file, context, send) ->
        coffee = require 'coffee-script'
        try
            javascript = coffee.compile file.content
        catch err
            send err

        send null, javascript
