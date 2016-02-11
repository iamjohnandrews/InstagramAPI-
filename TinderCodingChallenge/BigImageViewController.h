//
//  BigImageViewController.h
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/9/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BigImageViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;
@property (strong, nonatomic) NSString *bigImageURL;
@end
