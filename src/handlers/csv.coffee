# TODO

module.exports =
    extensions: ['csv']
    mime:
        source: 'text/csv'
        output: null
        precompiledOutput: null
    mixed: yes
    compiler: (file, context, send) ->
        send null
        #send {meta: file.metadata, body: html}