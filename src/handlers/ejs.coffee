module.exports =
    packages: []
    extensions: ['ejs']
    mime:
        source: 'text/ejs'
        output: 'text/html'
        precompiledOutput: 'application/javascript'
    compiler: (file, context, send) ->
    precompiler: (file, context, send) ->
        send null, 
            """
            if (tpllang.templates === undefined) tpllang.templates = {};
            tpllang.templates['#{name}'] = #{tpl};
            """