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
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.delegate = self;
    
    [self makeButtonPretty];
    [self displaySpinner];
}

#pragma mark WebView Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSError *error;
    if ([[InstagramEngine sharedEngine] receivedValidAccessTokenFromURL:request.URL error:&error]) {
        [self.fetchDelegate retrieveInstagramPicturesPostAuthorization];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"TOKEN: %@\n Error %@", [[InstagramEngine sharedEngine] accessToken], error.description);
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.spinner stopAnimating];
}

#pragma mark Actions

- (IBAction)backTapped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Visual

- (void)makeButtonPretty {
    self.backButton.backgroundColor = [UIColor greenColor];
    self.backButton.layer.borderColor = [[UIColor blueColor] CGColor];
    self.backButton.layer.borderWidth = 2;
    self.backButton.layer.cornerRadius = 7;
}

- (void)displaySpinner {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = self.view.center;
    [self.webView addSubview: self.spinner];
    [self.webView bringSubviewToFront:self.spinner];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

@end
