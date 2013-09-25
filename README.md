phonegap-flurry
========
A simple wrapper for [flurry sdk](http://www.flurry.com)

HOW TO INSTALL(iOS)
========
1. Download the [flurry sdk](http://www.flurry.com)
2. Add the `Flurry` folder into your project
3. Install the plugin, `phonegap local plugin add https://github.com/xu-li/phonegap-flurry.git`
4. In xcode, add `<feature>` in the `config.xml`
5. Done.

HOW TO USE
========
```Javascript
// start session
cordova.plugins.Flurry.startSession("YOUR_API_KEY");

// log event
cordova.plugins.Flurry.logEvent("EVENT_NAME");
```

feature Example
========
```XML
<feature name="Flurry">
  <param name="ios-package" value="CDVFlurry" />
</feature>
```
