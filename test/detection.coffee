should = require 'should'
tilt = require '../src'

it 'can find a handler based on a file object', ->
    file = new tilt.File
        path: '/exampledir/examplefile.coffee'

    tilt.hasHandler(file).should.be.true

it 'can find a handler based on a mimetype', ->
    should.exist tilt.getHandlerByMime('stylesheet/less')

it 'can compile and precompile from file objects', (done) ->
    file = new tilt.File
        path: '/exampledir/examplefile.jade'
        content: 'h1 Hello world!'

    tilt.preCompile file, undefined, (errors, template) ->
        template.should.match /buf\.join/
        done()
