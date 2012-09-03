module.exports =
    packages: ['less']
    extensions: ['less']
    mime:
        source: 'stylesheet/less'
        output: 'text/css'
    compiler: (file, variables, send) ->
        less = require 'less'
        less.render file.content, (err, css) ->
            send err, css
