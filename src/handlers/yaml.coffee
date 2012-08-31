yaml = require 'yaml'

module.exports =
    extensions: ['yaml', 'yml']
    mime:
        source: 'text/yaml'
        output: null
        precompiledOutput: null
    compiler: (file, context, send) ->
        documents = file.content.split(/---\s+/)
        documents.shift()
        documents = documents.map (doc) -> yaml.eval doc
        if documents.length > 1
            send documents
        else
            send documents[0]