stylus = require 'stylus'

module.exports =
    extensions: ['styl']
    mime:
        source: 'stylesheet/stylus'
        output: 'text/css'
    compiler: (file, context, send) ->
        stylus(file.content).render (err, css) ->
            if err
                send err
            else
                send css
