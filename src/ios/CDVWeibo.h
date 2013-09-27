//
//  CDVWeibo.h
//  Hello
//
//  Created by xu.li on 9/25/13.
//
//

#import <Cordova/CDV.h>
#import "WeiboSDK.h"

@interface CDVWeibo : CDVPlugin <WeiboSDKDelegate>

- (void)registerApp:(CDVInvokedUrlCommand* )command;
- (void)showLoginDialog:(CDVInvokedUrlCommand* )command;

@end
