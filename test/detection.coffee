should = require 'should'
tilt = require '../src'

module.exports =
    'can find a handler based on a file object': ->
        file = new tilt.File
            path: '/exampledir/examplefile.coffee'
    
        tilt.hasHandler(file).should.be.true

    'can find a handler based on a mimetype': ->
        should.exist tilt.getHandlerByMime('stylesheet/less')

    'can compile and precompile from file objects': (done) ->
        file = new tilt.File
            path: '/exampledir/examplefile.jade'
            content: 'h1 Hello world!'

        tilt.preCompile file, undefined, (template) ->
            template.should.match /buf\.join/
            done()
