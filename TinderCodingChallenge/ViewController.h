//
//  ViewController.h
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/8/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BigImageViewController.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIImageView *cellImageView;

- (IBAction)loginTapped:(UIBarButtonItem *)sender;

- (IBAction)refreshTapped:(UIBarButtonItem *)sender;

@end

