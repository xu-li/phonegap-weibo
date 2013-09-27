phonegap-weibo
========
A simple wrapper for [weibo sdk](http://open.weibo.com/)

HOW TO INSTALL(iOS)
========
1. Download the [weibo sdk](http://open.weibo.com/wiki/SDK#iOS_SDK)
2. Add the `libWeiboSDK` folder into your project
3. Add "wb[YOUR_APP_KEY]" Url schema into `Info.plist`. See `微博IOS平台SDK文档V2.3.0.pdf`.
4. Add `bundle ID` to `http://open.weibo.com/apps/[YOUR_APP_KEY]/info/basic`. See `微博IOS平台SDK文档V2.3.0.pdf`.
5. Add following code snippet into `AppDelegate.m`
```Objective C
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    CDVWeibo *weiboPlugin = [self.viewController.pluginObjects objectForKey:@"CDVWeibo"];
    return [WeiboSDK handleOpenURL:url delegate:weiboPlugin];
}
```
6. Install the plugin, `phonegap local plugin add https://github.com/xu-li/phonegap-weibo.git`
7. In xcode, add `<feature>` in the `config.xml`
8. Done.

HOW TO USE
========
```Javascript
// register app
// e.g. cordova.plugins.Weibo.registerApp("2582532934");
cordova.plugins.Weibo.registerApp(YOUR_APP_KEY);

// show login dialog
// e.g. cordova.plugins.Weibo.showLoginDialog("https://api.weibo.com/oauth2/default.html", "all"
cordova.plugins.Weibo.showLoginDialog(YOUR_REDIRECT_URI, SCOPE);

// get the access token
cordova.plugins.Weibo.accessToken;

// share a message, using jQuery
$.post("https://api.weibo.com/2/statuses/update.json", {
    status: "This is a test message.",
    access_token: cordova.plugins.Weibo.accessToken
});
```

feature Example
========
```XML
<feature name="Weibo">
  <param name="ios-package" value="CDVWeibo" />
</feature>
```
