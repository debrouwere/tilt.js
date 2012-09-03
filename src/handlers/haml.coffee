module.exports =
    packages: ['haml']
    extensions: ['haml']
    mime:
        source: 'text/haml'
        output: 'text/html'
    compiler: (file, context, send) ->
        haml = require 'haml'
        try
            tpl = haml(file.content)
        catch err
            return send err

        send null, tpl(context)
