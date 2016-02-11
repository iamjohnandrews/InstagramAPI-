//
//  SpinnerView.m
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/11/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import "SpinnerView.h"

@implementation SpinnerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        self.color = [UIColor orangeColor];
        self.hidesWhenStopped = YES;
        self.hidden = NO;
    }
    return self;
}

@end
