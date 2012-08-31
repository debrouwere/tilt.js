module.exports =
    extensions: ['json']
    mime:
        source: 'application/json'
        output: null
        precompiledOutput: null
    compiler: (file, context, send) ->
        send JSON.parse file.content