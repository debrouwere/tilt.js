_ = require 'underscore'

module.exports =
    packages: ['js-yaml']
    extensions: ['yaml', 'yml']
    mime:
        source: 'text/yaml'
        output: null
        precompiledOutput: null
    compiler: (file, context, send) ->
        yaml = require 'js-yaml'
        if file.content.match /^---\s*/
            documents = file.content.split /---\s*/g
        else
            documents = [file.content]
        
        try
            documents = _.compact documents
            documents = documents.map (doc) -> yaml.load doc
        catch err
            return send err

        if documents.length > 1
            send null, documents
        else
            send null, documents[0]