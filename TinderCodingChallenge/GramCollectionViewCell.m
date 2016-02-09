//
//  GramCollectionViewCell.m
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/9/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import "GramCollectionViewCell.h"

@implementation GramCollectionViewCell

- (void)setImageURL:(NSString *)imageURL {
    self.instagramImageView.image = [self loadImagefrom:imageURL];
}

- (UIImage *)loadImagefrom:(NSString *)urlString {
    __block UIImage *returnImage;
    
    NSOperationQueue *loadQueue = [[NSOperationQueue alloc] init];
    [loadQueue addOperationWithBlock:^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
        UIImage *img = [[UIImage alloc] initWithData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            returnImage = img;
        }];
    }];
    
    return returnImage;
}

@end
