### Installation

```bash
npm install -g cordova
cordova platform add android
cordova plugin add https://github.com/tapdaq/cordova-plugin.git 
```

File `www/js/index.js` contains example of plugin usage

### Build and Run

To build application run the following command

```bash
cordova build android
```

To build application and run it on device:

```bash
cordova run android --device
```