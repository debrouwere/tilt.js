module.exports =
    extensions: ['md']
    mime:
        source: 'text/markdown'
        output: null
        precompiledOutput: null
    mixed: yes
    compiler: (file, context, send) ->
        html = require("markdown").markdown.toHTML(file.content)
        send {meta: file.metadata, body: html}