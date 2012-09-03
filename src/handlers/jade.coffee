module.exports =
    packages: ['jade']
    extensions: ['jade']
    mime:
        source: 'text/jade'
        output: 'text/html'
        precompiledOutput: 'application/javascript'
    compiler: (file, context, send) ->
        jade = require 'jade'
        fn = jade.compile file.content, {filename: file.path}
        try
            tpl = fn context
        catch err
            send err

        send null, tpl

    precompiler: (file, context, send) ->
        jade = require 'jade'
        try
            tpl = jade.compile file.content, {filename: file.path, client: yes}
        catch err
            return send err

        name = file.name
        send null, 
            """
            if (jade.templates === undefined) jade.templates = {};
            jade.templates['#{name}'] = #{tpl};
            """