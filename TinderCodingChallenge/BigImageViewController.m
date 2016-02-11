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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.bigImageView setImageWithURL:[NSURL URLWithString:self.bigImageURL]];
//    [self.bigImageView setImageWithURL:[NSURL URLWithString:@"https://scontent.cdninstagram.com/t51.2885-15/e15/11377500_1581138258815108_1395502027_n.jpg?ig_cache_key=MTAwMjU5NjY1Mzc2Njg1NzY0Nw%3D%3D.2"]];
}

@end
