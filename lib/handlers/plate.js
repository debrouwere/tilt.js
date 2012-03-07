(function() {
  var plate;

  plate = require('plate');

  module.exports = {
    extensions: ['dtl', 'plate'],
    mime: {
      source: 'text/plate',
      output: 'text/html'
    },
    compiler: function(file, variables, send) {
      var template;
      template = new plate.Template(file.content);
      return template.render(variables, function(err, html) {
        return send(html);
      });
    }
  };

}).call(this);
