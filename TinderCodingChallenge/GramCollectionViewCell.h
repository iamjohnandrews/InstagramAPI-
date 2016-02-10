//
//  GramCollectionViewCell.h
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/9/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GramCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *instagramImageView;
@property (strong, nonatomic) NSURL *imageURL;
@property (strong, nonatomic) NSURL *bigImageURL;
@property (strong, nonatomic) NSString *location;

@end
