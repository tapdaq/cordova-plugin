var exec = require('child_process').execSync;


module.exports = function(context) {
    var path = context.requireCordovaModule('path');

    var platformRoot = path.join(context.opts.projectRoot, 'platforms/ios');
    exec('pod repo update && pod install', {
        cwd: platformRoot
    });
};
