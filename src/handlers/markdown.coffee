module.exports =
    packages: ['markdown']
    extensions: ['md']
    mime:
        source: 'text/markdown'
        output: 'text/html'
        precompiledOutput: null
    mixed: yes
    compiler: (file, context, send) ->
        try
            html = (require 'markdown').markdown.toHTML(file.content)
        catch err
            return send err
        
        send null, {meta: file.meta, content: html}