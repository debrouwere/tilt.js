# parse JSON, CSV, YAML etc. in a unified way, autodetect
# type based on extension and/or mime just like we do for 
# handlers
# 
# compilers for template languages and css preprocessors 
# live under `handlers` instead

exports.parse = (file) ->
    # TODO
