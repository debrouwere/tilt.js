(function() {
  var jade;

  jade = require('jade');

  module.exports = {
    extensions: ['jade'],
    mime: {
      source: 'text/jade',
      output: 'text/html',
      precompiledOutput: 'application/javascript'
    },
    compiler: function(file, context, send) {
      var tpl;
      tpl = jade.compile(file.content);
      return send(tpl(context));
    },
    precompiler: function(file, context, send) {
      var name, tpl;
      tpl = jade.compile(file.content, {
        client: true
      });
      name = file.name;
      return send("if (jade.templates === undefined) jade.templates = {};\njade.templates['" + name + "'] = " + tpl + ";");
    }
  };

}).call(this);
