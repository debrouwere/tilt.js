###
- supports the Middleman data format: http://middlemanapp.com/guides/local-yaml-data
- extends that format by allowing for other data than .yml
- supports YAML front matter in non-YAML files: splits up the file into 
  `meta` and `body` keys, or if no front-matter is found, just `body`
- uses regular handlers to parse markdown, textile et cetera
  (but strips out frontmatter before doing so)
- if multiple files are appropriate (e.g. index.json and index.json), merges 
  the resulting context hashes; conflicting hashes are resolved on a newest-first
  basis
- all context from a data directory is available under the `data` key, but
  we also provide easy access to data specific to a page, so if you're viewing 
  index.haml, the `title` context value from an index.json file will be available 
  under `data.index.title` but will also be expanded into the main namespace as
  just `title`.
- data directory or file is customizable through programmatic access: you can
  change the default dir from `data` to something else, you can specify a regex
  files should match (e.g. prefixed with an underscore), or you can just specify
  that all context should come from e.g. `data.json` in the current directory.
###

###
MM+ conventions

- looks for data in /data
- all data in the directory is available under `data`
- page-specific data is additionally available in the top-level namespace, 
  so context.data.index.title == context.title when loading data for `index.haml`
- when you have an index.json and an index.yaml, their context sets will be merged, 
  with the last edited file overriding identical values in older files (if applicable)
- assumes /data/index/alt.json refers to /data/<template>/<contextset>.json and will process it as:
  
{
    "index": {
        "alt": {
            "key": "val"
        }
    }
}

Because all of this is returned as JSON and decoupled from the rendering process, 
an application like a static site generator can do whatever it wants with this
information, e.g. only making a subset of it available to the template or 
cycling though all applicable context sets one by one to render them to separate
pages and so on.
###

# tries to find context variables for templates
# e.g. when evaluating hello.jade tries to find hello.json
# and pass on what it finds there to the rendering step

_ = require 'underscore'
fs = require 'fs'
path = require 'path'
async = require 'async'
parsers = require './parsers'
handlers = require './handlers'

name = (file) ->
    extlen = -(path.extname file).length
    (path.basename file).slice(0, extlen)

# find data files for a template file and return them in order (latest changed first)
exports.findFilesFor = (template, src = 'data', callback) ->
    dir = path.dirname template
    src = path.join dir, src
    fs.readdir src, (errors, files) ->
        files = files
            .filter (file) ->
                # TODO: a better way to get supported formats
                # (data-centric ones like json, yaml and txt + compilers flagged as 
                # markup languages in the handlers?)
                # SEE parsers.coffee
                (path.extname file) in ['.yaml', '.yml', '.json', '.txt']
            .map (file) ->
                path.join src, file

        callback files

exports.getDocument = (file, callback) ->
    ext = (path.extname file)

    fs.readFile file, 'utf8', (errors, str) ->
        if errors then new Error "Couldn't get document"

        # TODO: a better way to get all markup languages (because those are
        # the only ones that can be prefaced with frontmatter)
        # SEE parsers.coffee
        if ext in ['.yaml', '.yml', '.txt', '.md', '.markdown']
            doc = YAML.parse str
            if doc instanceof String
                callback {meta: {}, body: doc}
            else
                callback {meta: doc[0], body: doc[1]}
        else if ext is '.json'
            callback JSON.parse str

exports.parse = (file, callback) ->
    exports.getDocument file, (document) ->
        context = {}
        context[name file] = document
        callback null, context

        ###
        SEE NOTES ABOVE
        
        handlers.compile (handlers.File path: file, content: body), undefined, (body) ->

            
        ###

# find context for a template file
# TODO: make asynchronous
exports.findFor = ->
    if arguments.length is 3
        [template, src, callback] = arguments
    else if arguments.length is 2
        src = 'data'
        [template, callback] = arguments
    else
        throw new Error "Wrong arguments for Registry#findFor."

    exports.findFilesFor template, src, (files) ->
        async.map files.reverse(), exports.parse, (errors, context) ->
            # merge different context objects together
            context = _.extend {}, context...
            # create a shortcut for data with the same source as the template
            # (make it global)
            context = {data: context}
            _.extend context, context.data[name template]
            callback context
