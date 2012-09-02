jade = require 'jade'

module.exports =
    extensions: ['jade']
    mime:
        source: 'text/jade'
        output: 'text/html'
        precompiledOutput: 'application/javascript'
    compiler: (file, context, send) ->
        tpl = jade.compile file.content, {filename: file.path}
        send tpl context
    precompiler: (file, context, send) ->
        tpl = jade.compile file.content, {filename: file.path, client: yes}
        name = file.name
        send \
            """
            if (jade.templates === undefined) jade.templates = {};
            jade.templates['#{name}'] = #{tpl};
            """
