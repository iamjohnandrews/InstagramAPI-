//
//  GramCollectionViewCell.m
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/9/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import "GramCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation GramCollectionViewCell

- (void)setImageURL:(NSString *)imageURL {
    [self.instagramImageView setImageWithURL:[NSURL URLWithString:imageURL]];
}

@end
