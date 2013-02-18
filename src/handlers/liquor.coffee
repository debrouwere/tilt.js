module.exports =
    packages: []
    extensions: []
    mime:
        source: 'text/liquor'
        output: 'text/html'
        precompiledOutput: 'application/javascript'
    compiler: (file, context, send) ->
    precompiler: (file, context, send) ->
        send null, 
            """
            if (tpllang.templates === undefined) tpllang.templates = {};
            tpllang.templates['#{name}'] = #{tpl};
            """