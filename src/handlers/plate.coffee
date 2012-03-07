plate = require 'plate'

module.exports =
    extensions: ['dtl', 'plate']
    # we don't support multiple matching yet
    # match: [/^(.*\.plate)$/, /^(.*\.dtl)$/]
    mime:
        source: 'text/plate'
        output: 'text/html'
    compiler: (file, variables, send) ->
        template = new plate.Template file.content
        template.render variables, (err, html) ->
            send html
