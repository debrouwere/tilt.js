haml = require 'haml'

module.exports =
    extensions: ['haml']
    mime:
        source: 'text/haml'
        output: 'text/html'
    compiler: (file, context, send) ->
        try
            tpl = haml(file.content)
        catch err
            return send err

        send null, tpl(context)
