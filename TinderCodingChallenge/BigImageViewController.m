//
//  BigImageViewController.m
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/9/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import "BigImageViewController.h"
#import "UIImageView+AFNetworking.h"

@interface BigImageViewController ()

@end

@implementation BigImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)setBigImageURL:(NSURL *)bigImageURL {
    [self.bigImageView setImageWithURL:bigImageURL];
}

@end
