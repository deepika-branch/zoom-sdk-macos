//
//  ZMSDKLoginWindowController.m
//  ZoomSDKSample
//
//  Created by derain on 2018/11/15.
//  Copyright © 2018年 zoom.us. All rights reserved.
//

#import "ZMSDKLoginWindowController.h"
#import "ZMSDKMainWindowController.h"
#import "ZMSDKAuthHelper.h"
#import "ZMSDKInitHelper.h"
#import "ZMSDKRestAPILogin.h"
#import "ZMSDKEmailLogin.h"
#import "ZMSDKSSOLogin.h"
#import "ZMSDKJoinOnly.h"
#import "ZMSDKCommonHelper.h"

#define kZoomSDKDomain      @""


@interface ZMSDKLoginWindowController ()

@end

@implementation ZMSDKLoginWindowController
@synthesize mainWindowController = _mainWindowController;
@synthesize  authHelper = _authHelper;
@synthesize  restAPIHelper = _restAPIHelper;
@synthesize  emailLoginHelper = _emailLoginHelper;
@synthesize  ssoLoginHelper = _ssoLoginHelper;
@synthesize  joinOnlyHelper = _joinOnlyHelper;

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}
-(void)awakeFromNib
{
    [self initUI];
}
- (id)init
{
    self = [super initWithWindowNibName:@"ZMSDKLoginWindowController" owner:self];
    if(self)
    {
        return self;
    }
    return nil;
}
- (void)initHelper
{
    self.authHelper = [[ZMSDKAuthHelper alloc] initWithWindowController:self];
    self.restAPIHelper = [[ZMSDKRestAPILogin alloc] initWithWindowController:self];
    self.emailLoginHelper = [[ZMSDKEmailLogin alloc] initWithWindowController:self];
    self.ssoLoginHelper = [[ZMSDKSSOLogin alloc] initWithWindowController:self];
    self.joinOnlyHelper = [[ZMSDKJoinOnly alloc] initWithWindowController:self];
}

- (void)cleanUp
{
    if (self.mainWindowController)
    {
        [self.mainWindowController cleanUp];
        [self.mainWindowController release];
        self.mainWindowController = nil;
    }
    if(self.authHelper)
    {
        [self.authHelper release];
        self.authHelper = nil;
    }
    if (self.restAPIHelper) {
        [self.restAPIHelper release];
        self.restAPIHelper = nil;
    }
    if(self.emailLoginHelper)
    {
        [self.emailLoginHelper release];
        self.emailLoginHelper = nil;
    }
    if(self.ssoLoginHelper)
    {
        [self.ssoLoginHelper release];
        self.ssoLoginHelper = nil;
    }
    if(self.joinOnlyHelper)
    {
        [self.joinOnlyHelper release];
        self.joinOnlyHelper = nil;
    }
    [self close];
}
-(void)dealloc
{
    [self cleanUp];
    [super dealloc];
}
- (void)initUI
{
    [_loadingProgressIndicator stopAnimation:self];
}
- (void)showSelf
{
    [self relayoutWindowPosition];
    [self.window makeKeyAndOrderFront:nil];
}
- (void)relayoutWindowPosition
{
    [self.window setLevel:NSPopUpMenuWindowLevel];
    [self.window center];
}
- (IBAction)onSetDomainClicked:(id)sender
{
    BOOL useCustomizedUI = NO;
    if(_setUseCustomizedUIButton.state == NSOnState)
        useCustomizedUI = YES;
    [ZMSDKInitHelper initSDK:useCustomizedUI];
    [self initHelper];
    //[ZMSDKInitHelper setDomain:kZoomSDKDomain];
    [ZMSDKInitHelper setDomain:_setDomainTextField.stringValue];
    [self switchToAuthTab];
}


- (IBAction)onAuthClicked:(id)sender
{
    if (_sdkKeyTextField.stringValue.length > 0) {
        
        [_authHelper newAuth:_sdkKeyTextField.stringValue];
    }
}
- (IBAction)onEmailLoginClicked:(id)sender
{
    if(_emailTextField.stringValue.length > 0)
    {
        BOOL rememberMe = NO;
        if(_emailRememerMeButton.state == NSOnState)
            rememberMe = YES;
        [_emailLoginHelper loginWithEmail:_emailTextField.stringValue Password:_emailPSWTextField.stringValue RememberMe:rememberMe];
        [ZMSDKCommonHelper sharedInstance].loginType = ZMSDKLoginType_Email;
    }
}
- (IBAction)onEmailRemeberMeClicked:(id)sender
{
    return;
}
- (IBAction)onSSORememberMeClicked:(id)sender
{
    return;
}
- (IBAction)onSSOLoginClicked:(id)sender
{
    BOOL rememberMe = NO;
    if(_ssoRememerMeButton.state == NSOnState)
        rememberMe = YES;
    if(_ssoTokenTextField.stringValue.length > 0)
       [_ssoLoginHelper loginSSO:_ssoTokenTextField.stringValue RememberMe:rememberMe];
    [ZMSDKCommonHelper sharedInstance].loginType = ZMSDKLoginType_SSO;
}
- (IBAction)onJoinOnlyClicked:(id)sender
{
    if(_joinOnlyMeetingIDTextField.stringValue.length > 0)
    {
        [_joinOnlyHelper joinMeetingOnly:_joinOnlyMeetingIDTextField.stringValue displayName:_joinOnlyUserNameTextField.stringValue meetingPSW:_joinOnlyMeetingPSWTextField.stringValue];
    }
}
- (IBAction)onErrorBackClicked:(id)sender
{
    [self switchToLoginTab];
}

- (IBAction)onApiLogin:(id)sender
{
    [_restAPIHelper loginRestApiWithUserID:_userIDField.stringValue zak:_zakString.stringValue];
}

- (void)switchToConnectingTab
{
    [_baseTabView selectTabViewItemWithIdentifier:@"loading"];
    [_loadingTextField setStringValue:@"Loading"];
    [_loadingProgressIndicator stopAnimation:self];
    [_loadingProgressIndicator startAnimation:self];
}
- (void)switchToLoginTab
{
    [_baseTabView selectTabViewItemWithIdentifier:@"login"];
    [_loadingProgressIndicator stopAnimation:self];
}
- (void)switchToErrorTab
{
    [_baseTabView selectTabViewItemWithIdentifier:@"error"];
    [_loadingProgressIndicator stopAnimation:self];
}
- (void)switchToAuthTab
{
    [_baseTabView selectTabViewItemWithIdentifier:@"auth"];
    [_loadingProgressIndicator stopAnimation:self];
}
- (void)switchToDomainTab
{
    [_baseTabView selectTabViewItemWithIdentifier:@"domain"];
    [_loadingProgressIndicator stopAnimation:self];
}
- (void)showErrorMessage:(NSString*)error
{
    _errorMessageTextField.stringValue = error;
}
- (void)removeEmailLoginTab
{
    NSTabViewItem* emailItem = nil;
    for(NSTabViewItem* item in _loginTabView.tabViewItems)
    {
        if([item.identifier isEqualToString:@"email login"])
            emailItem = item;
    }
    if(emailItem && [emailItem.identifier isEqualToString:@"email login"])
        [_loginTabView removeTabViewItem:emailItem];
}
- (void)createMainWindow
{
    if (self.mainWindowController)
    {
        [self.mainWindowController showWindow:nil];
        [self.mainWindowController updateUI];
        return;
    }
    self.mainWindowController = [[ZMSDKMainWindowController alloc] init] ;
    self.mainWindowController.loginWindowController = self;
    [self close];
    [self.mainWindowController.window makeKeyAndOrderFront:nil];
    [self.mainWindowController showWindow:nil];
}
- (void)updateUIWithLoginStatus:(BOOL)hasLogin
{
    [ZMSDKCommonHelper sharedInstance].hasLogin = hasLogin;
    BOOL isEmailLoginEnabled = NO;
    if([[[ZoomSDK sharedSDK] getAuthService] isEmailLoginEnabled:&isEmailLoginEnabled] == ZoomSDKError_Success && isEmailLoginEnabled)
    {
        if (_emailRememerMeButton.state == NSOnState && [ZMSDKCommonHelper sharedInstance].loginType == ZMSDKLoginType_Email)
        {
            [[NSUserDefaults standardUserDefaults] setBool:hasLogin forKey:kZMSDKLoginEmailRemember];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    else if(_ssoRememerMeButton.state == NSOnState && [ZMSDKCommonHelper sharedInstance].loginType == ZMSDKLoginType_SSO)
    {
        [[NSUserDefaults standardUserDefaults] setBool:hasLogin forKey:kZMSDKLoginSSORemember];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
- (void)logOut
{
    if ([ZMSDKCommonHelper sharedInstance].loginType == ZMSDKLoginType_Email)
    {
        [_emailLoginHelper logOutWithEmail];
    }
    else if([ZMSDKCommonHelper sharedInstance].loginType == ZMSDKLoginType_SSO)
    {
        [_ssoLoginHelper logOutWithSSO];
    }
    if(self.mainWindowController)
       [self.mainWindowController close];
    if([self.window isVisible])
        [self switchToLoginTab];
    else
    {
        [self showSelf];
        [self switchToLoginTab];
    }
}
@end
