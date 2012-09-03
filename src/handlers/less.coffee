less = require 'less'

module.exports =
    extensions: ['less']
    mime:
        source: 'stylesheet/less'
        output: 'text/css'
    compiler: (file, variables, send) ->
        less.render file.content, (err, css) ->
            send err, css
