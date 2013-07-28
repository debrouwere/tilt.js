module.exports =
    packages: ['textile-js']
    extensions: ['textile']
    mime:
        source: 'text/textile'
        output: 'text/html'
        precompiledOutput: null
    mixed: yes
    compiler: (file, context, send) ->
        try
            html = (require 'textile-js').parse(file.content)
        catch err
            return send err
        
        send null, {meta: file.meta, content: html}