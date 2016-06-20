var exec = require('child_process').exec;

module.exports = function(context) {
  var pluginDir = context.opts.plugin.dir;
  var iosLibDir = pluginDir + '/src/ios/lib/';

  exec('rm -rf ' + iosLibDir + ' && git clone https://github.com/tapdaq/tapdaq-ios-sdk ' + iosLibDir + ' && rm -rf ' + iosLibDir + '/.git');
};
