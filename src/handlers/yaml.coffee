module.exports =
    packages: ['yaml']
    extensions: ['yaml', 'yml']
    mime:
        source: 'text/yaml'
        output: null
        precompiledOutput: null
    compiler: (file, context, send) ->
        yaml = require 'yaml'
        documents = file.content.split(/---\s+/)
        documents.shift()
        
        try
            documents = documents.map (doc) -> yaml.eval doc
        catch err
            return send err

        if documents.length > 1
            send null, documents
        else
            send null, documents[0]