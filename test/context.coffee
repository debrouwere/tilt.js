context = require '../src/context'
should = require 'should'
path = require 'path'

file = path.join __dirname, 'fixtures/index.jade'

module.exports =
    'can find context related to a template': (done) ->
        context.findFor file, (c) ->
            c.data.index.title.should.equal 'Hello world'
            done()

    'can create shortcuts for context in files that have the same basename as the template': (done) ->
        context.findFor file, (c) ->
            c.data.index.title.should.equal c.title
            done()

    'merges conflicting context on a newest-stays basis': undefined

    'can process multi-document YAML files': undefined
