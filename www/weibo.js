var exec = require("cordova/exec");

function Weibo() {
    this.accessToken = '';
}

Weibo.prototype.registerApp = function (appKey, success, error) {
               
    var self = this;
    exec(function (accessToken) {
        // save the access token
        if (accessToken) {
            self.accessToken = accessToken;
        }

        if (success) {
            success.call(null, accessToken);
        }
    }, error, 'Weibo', 'registerApp', [appKey]);
};

Weibo.prototype.showLoginDialog = function (redirect, scope, success, error) {
    if (this.accessToken) {
        if (success) {
            success.call(null, this.accessToken);
        }
    } else {
        exec(success, error, 'Weibo', 'showLoginDialog', [redirect]);
    }
};

var weibo = new Weibo;
module.exports = weibo;
