module.exports =
    packages: []
    extensions: ['json']
    mime:
        source: 'application/json'
        output: null
        precompiledOutput: null
    compiler: (file, context, send) ->
        try
            json = JSON.parse file.content
            send null, json
        catch err
            send err