(function() {
  var coffee;

  coffee = require('coffee-script');

  module.exports = {
    extensions: ['coffee'],
    mime: {
      source: 'text/coffeescript',
      output: 'application/javascript'
    },
    compiler: function(file, context, send) {
      var javascript;
      javascript = coffee.compile(file.content);
      return send(javascript);
    }
  };

}).call(this);
