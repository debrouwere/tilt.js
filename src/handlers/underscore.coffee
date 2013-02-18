module.exports =
    packages: ['underscore']
    extensions: ['']
    mime:
        source: 'text/whiskers'
        output: 'text/html'
        precompiledOutput: 'application/javascript'
    compiler: (file, context, send) ->