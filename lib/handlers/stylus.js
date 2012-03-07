(function() {
  var stylus;

  stylus = require('stylus');

  module.exports = {
    extensions: ['styl'],
    mime: {
      source: 'stylesheet/stylus',
      output: 'text/css'
    },
    compiler: function(file, context, send) {
      return stylus(file.content).render(function(err, css) {
        if (err) {
          return send(err);
        } else {
          return send(css);
        }
      });
    }
  };

}).call(this);
