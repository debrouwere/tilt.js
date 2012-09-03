module.exports =
    packages: ['plate']
    extensions: ['dtl', 'plate']
    mime:
        source: 'text/plate'
        output: 'text/html'
    compiler: (file, variables, send) ->
        plate = require 'plate'
        template = new plate.Template file.content
        template.render variables, (err, html) ->
            send err, html
