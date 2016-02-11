//
//  LoginViewController.h
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/9/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FetchInstagramPicsAfterAuthorization <NSObject>

- (void)retrieveInstagramPicturesPostAuthorization;

@end

@interface LoginViewController : UIViewController <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) id<FetchInstagramPicsAfterAuthorization> fetchDelegate;

- (IBAction)backTapped:(UIButton *)sender;

@end
