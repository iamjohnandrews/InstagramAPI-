//
//  ViewController.h
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/8/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "BigImageViewController.h"
#import "GramCollectionViewCell.h"
#import "LoginViewController.h"

@interface ViewController : UIViewController <UICollectionViewDataSource, CLLocationManagerDelegate, FetchInstagramPicsAfterAuthorization>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *loginButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *refreshButton;
@property (strong, nonatomic) CLLocationManager *locationManager;

- (IBAction)loginTapped:(UIBarButtonItem *)sender;

- (IBAction)refreshTapped:(UIBarButtonItem *)sender;

@end

