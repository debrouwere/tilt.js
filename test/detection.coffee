should = require 'should'
preprocessor = require '../src'

module.exports =
    'can find a handler based on a file object': ->
        file = new preprocessor.File
            path: '/exampledir/examplefile.coffee'
    
        preprocessor.hasHandler(file).should.be.true

    'can find a handler based on a mimetype': ->
        should.exist preprocessor.getHandlerByMime('stylesheet/less')

    'can compile and precompile from file objects': (done) ->
        file = new preprocessor.File
            path: '/exampledir/examplefile.jade'
            content: 'h1 Hello world!'

        preprocessor.preCompile file, undefined, (template) ->
            template.should.match /buf\.join/
            done()
