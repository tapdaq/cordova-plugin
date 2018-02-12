'use strict';

const exec = require('child_process').exec;

var hook = function(context){
    console.log("install node-xcode...");

    exec('npm install xcode@latest', (error, stdout, stderr) => {
        console.log("node-xcode installed");
    });
    
};

module.exports = hook;