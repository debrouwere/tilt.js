context = require '../src/context'
should = require 'should'
path = require 'path'

file = path.join __dirname, 'fixtures/index.jade'

it 'can find context related to a template', (done) ->
    context.findFor file, (c) ->
        c.data.index.title.should.equal 'Hello world'
        done()

it 'can create shortcuts for context in files that have the same basename as the template', (done) ->
    context.findFor file, (c) ->
        c.data.index.title.should.equal c.title
        done()

it 'merges conflicting context on a newest-stays basis'

it 'can process multi-document YAML files'

it 'can work with custom search paths: a file'

it 'can work with custom search paths: a directory'

it 'can work with custom search paths: a regex'
