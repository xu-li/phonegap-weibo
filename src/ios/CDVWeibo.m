//
//  CDVWeibo.m
//  Hello
//
//  Created by xu.li on 9/25/13.
//
//

#import "CDVWeibo.h"

#define kCDVWeiboDefaultKey @"CDVWeiboDefaultKey"

@interface CDVWeibo()

@property (nonatomic, strong) CDVInvokedUrlCommand *pendingLoginCommand;

@end

@implementation CDVWeibo

- (void)registerApp:(CDVInvokedUrlCommand* )command
{
    CDVPluginResult *result;
    NSString *message;
    NSString* appKey = [command.arguments objectAtIndex:0];
    
    if (!appKey)
    {
        message = @"App key was null.";
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return ;
    }
    
    [WeiboSDK registerApp:appKey];
    
    // get the saved token
    NSDictionary *token = [self loadToken];
    if (token)
    {
        message = [token objectForKey:@"accessToken"];
    }
    else
    {
        message = @"";
    }
    
    result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:message];
    [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
}

- (void)showLoginDialog:(CDVInvokedUrlCommand* )command
{
    CDVPluginResult *result;
    NSString *message;
    
    if ([command.arguments count] == 0)
    {
        message = @"Redirect URI was null.";
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:message];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return ;
    }
    
    NSString *redirectURI = [command.arguments objectAtIndex:0];
    NSString *scope;
    if ([command.arguments count] > 1)
    {
        scope = [command.arguments objectAtIndex:1];
    }
    else
    {
        scope = @"all";
    }
    
    // send request
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = redirectURI;
    request.scope = scope;
    [WeiboSDK sendRequest:request];
    
    self.pendingLoginCommand = command;
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    // do nothing 
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]])
    {
        NSLog(@"Return from send message: %d", response.statusCode);
    }
    else if ([response isKindOfClass:[WBAuthorizeResponse class]])
    {
        WBAuthorizeResponse *authResponse = (WBAuthorizeResponse *)response;
        [self saveToken:authResponse];
        
        // send back
        CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:authResponse.accessToken];
        
        [self.commandDelegate sendPluginResult:result
                                    callbackId:self.pendingLoginCommand.callbackId];

        // clean up
        self.pendingLoginCommand = nil;
    }
}

- (NSDictionary *)loadToken
{
    NSDictionary *token = [[NSUserDefaults standardUserDefaults] objectForKey:kCDVWeiboDefaultKey];
    if (token)
    {
        // check expiration
        NSDate *expirationDate = [token objectForKey:@"expirationDate"];
        if([[NSDate date] timeIntervalSinceDate:expirationDate] > 0)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:nil forKey:kCDVWeiboDefaultKey];
            [defaults synchronize];
            
            return nil;
        }
    }
    return token;
}

- (void)saveToken:(WBAuthorizeResponse *)response
{
    NSDictionary *token = @{
        @"userID": response.userID,
        @"accessToken": response.accessToken,
        @"expirationDate": response.expirationDate
    };
    
    // save token to user defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:token forKey:kCDVWeiboDefaultKey];
    [defaults synchronize];
}



@end
