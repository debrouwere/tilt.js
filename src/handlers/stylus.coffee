module.exports =
    packages: ['stylus']
    extensions: ['styl']
    mime:
        source: 'stylesheet/stylus'
        output: 'text/css'
    compiler: (file, context, send) ->
        stylus = require 'stylus'
        stylus(file.content).render (err, css) ->
            send err, css