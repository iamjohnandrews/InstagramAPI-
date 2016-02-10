//
//  LoginViewController.m
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/9/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import "LoginViewController.h"
#import "InstagramKit.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
    [self makeButtonPretty];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error]) {
        NSLog(@"use delegation to call fetch Instagram pics");
        [self.fetchDelegate retrieveInstagramPicturesPostAuthorization];
    } else {
        NSLog(@"TOKEN: %@\n Error %@", [[InstagramEngine sharedEngine] accessToken], error.description);
    }
    
    return YES;
}

- (IBAction)backTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)makeButtonPretty {
    self.backButton.backgroundColor = [UIColor greenColor];
    self.backButton.layer.borderColor = [[UIColor blueColor] CGColor];
    self.backButton.layer.borderWidth = 2;
    self.backButton.layer.cornerRadius = 7;
}

@end
