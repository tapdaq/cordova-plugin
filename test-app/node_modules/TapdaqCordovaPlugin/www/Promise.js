(function() {
    "use strict";

    var Promise;

    if (typeof(window) !== 'undefined') {
        Promise = window.Promise;
    }

    if (!Promise) {
        Promise = require('cordova-plugin-tapdaq.vendor.promise').Promise;
    }

    module.exports = Promise;

})();