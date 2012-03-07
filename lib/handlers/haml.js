(function() {
  var haml;

  haml = require('haml');

  module.exports = {
    extensions: ['haml'],
    mime: {
      source: 'text/haml',
      output: 'text/html'
    },
    compiler: function(file, context, send) {
      return send(haml(file.content)(context));
    }
  };

}).call(this);
