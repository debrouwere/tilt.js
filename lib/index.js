(function() {
  var fs, handler, handler_file, handler_path, here, path, _, _i, _len, _ref,
    __slice = Array.prototype.slice,
    __indexOf = Array.prototype.indexOf || function(item) { for (var i = 0, l = this.length; i < l; i++) { if (i in this && this[i] === item) return i; } return -1; };

  path = require('path');

  fs = require('fs');

  _ = require('underscore');

  here = function() {
    var segments;
    segments = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    return path.join.apply(path, [__dirname].concat(__slice.call(segments)));
  };

  exports.File = (function() {

    function File(options) {
      var key, val;
      for (key in options) {
        val = options[key];
        this[key] = val;
      }
      if (!this.path) throw new Error("You must specify a file path.");
      if (!this.extension) {
        this.extension = path.extname(this.path).replace('.', '');
      }
      if (!this.basename) this.basename = path.basename(this.path);
      if (!this.name) {
        this.name = this.basename.substr(0, this.basename.length - this.extension.length - 1);
      }
    }

    File.prototype.load = function() {
      return require(this.path);
    };

    return File;

  })();

  exports.getHandlerByExtension = function(extension) {
    var handler, name, _ref;
    _ref = exports.handlers;
    for (name in _ref) {
      handler = _ref[name];
      if (__indexOf.call(handler.extensions, extension) >= 0) return handler;
    }
    return;
  };

  exports.getHandlerByMime = function(mime) {
    var handler, name, _ref;
    _ref = exports.handlers;
    for (name in _ref) {
      handler = _ref[name];
      if (handler.mime.source === mime) return handler;
    }
    return;
  };

  exports.getHandlerByName = function(name) {
    return exports.handlers[name];
  };

  exports.getHandler = function(type) {
    var handler;
    handler = exports.getHandlerByExtension(type || exports.getHandlerByMime(type || exports.getHandlerByName(type)));
    return handler;
  };

  exports.findHandler = function(file) {
    if (file.mime) {
      return exports.getHandlerByMime(file.mime);
    } else if (file.type) {
      return exports.getHandlerByName(file.type);
    } else {
      return exports.getHandlerByExtension(file.extension);
    }
  };

  exports.hasHandler = function(file) {
    return exports.findHandler(file) != null;
  };

  exports.compile = function(file, context, send) {
    var handler;
    handler = exports.findHandler(file);
    if (handler) {
      return handler.compiler(file, context, send);
    } else {
      throw new Error("Didn't find a a preprocessor for this filetype or extension.");
    }
  };

  exports.preCompile = function(file, context, send) {
    var handler;
    handler = exports.findHandler(file);
    if (handler) {
      if (handler.precompiler != null) {
        return handler.precompiler(file, context, send);
      } else {
        throw new Error("Found a handler for this filetype, but it doesn't have a precompiler.");
      }
    } else {
      throw new Error("Didn't find a a preprocessor for this filetype or extension.");
    }
  };

  exports.handlers = {};

  _ref = fs.readdirSync(here("handlers"));
  for (_i = 0, _len = _ref.length; _i < _len; _i++) {
    handler_path = _ref[_i];
    handler_file = new exports.File({
      path: here("handlers", handler_path)
    });
    handler = handler_file.load();
    _.extend(handler, handler_file);
    exports.handlers[handler.name] = handler;
  }

}).call(this);
