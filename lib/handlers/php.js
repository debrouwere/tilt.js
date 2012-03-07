(function() {
  var exec;

  exec = require('child_process').exec;

  module.exports = {
    extensions: ['php'],
    mime: {
      source: 'application/php',
      output: 'text/html'
    },
    compiler: function(file, context, send) {
      console.log("compiling php");
      return exec("php " + file.path, function(error, stdout, stderr) {
        console.log(error);
        console.log(stdout);
        console.log(stderr);
        if (error) {
          return send(error);
        } else {
          return send(stdout);
        }
      });
    }
  };

}).call(this);
