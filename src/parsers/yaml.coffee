yaml = require 'yaml'

module.exports =
    extensions: ['yaml', 'yml']
    mime:
        source: 'text/yaml'
    compiler: (file, context, send) ->
        documents = file.content.split("---\n")
        if documents.length > 1
            send yaml.eval documents[1]
        else
            send yaml.eval documents
