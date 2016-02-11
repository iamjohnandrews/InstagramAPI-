//
//  ViewController.m
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/8/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import "ViewController.h"
#import "InstagramKit.h"

static NSString *CLIENT_ID = @"ae97b75b4af64898b7077cd7ecefd21d";
static NSString *CLIENT_SECRET = @"20fa3ad5d4934f94aaebc366244cc588";
static NSInteger feedCount = 20;

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *instagramPictures;
@property (nonatomic) BOOL isValidSession;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;
@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) NSString *nextMaxId;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isValidSession = [[InstagramEngine sharedEngine] isSessionValid];
    [self setUpLocationManager];
    
    self.collectionView.dataSource = self;
    self.instagramPictures = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavBarUI];
    if (!self.title) {
        [self displaySpinner];
    }
}

#pragma mark UI

- (void)displayAlert:(NSString *)alertMessage {
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:@"Error"
                                                                  message:alertMessage
                                                           preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action) {
                                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                               }];
    
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setUpNavBarUI {
    if (self.isValidSession) {
        self.loginButton.title = @"Log Out";
        self.title = @"My Instagram";
        self.refreshButton.enabled = YES;
    } else {
        self.loginButton.title = @"Log In";
        self.title = nil;
        self.refreshButton.enabled = NO;
    }
}

- (void)displaySpinner {
    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.spinner.center = self.view.center;
    [self.collectionView addSubview: self.spinner];
    [self.collectionView bringSubviewToFront:self.spinner];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

#pragma mark Networking

- (void)fetchInstagramPictures {
    if (self.isValidSession) {
        [self getUsersInstagramPictures:self.nextMaxId];
    } else {
        [self getInstagramPicturesNearBy:self.currentLocation.coordinate with:self.nextMaxId];
    }
}

- (void)getInstagramPicturesNearBy:(CLLocationCoordinate2D)coordinate with:(NSString *)maxID {
    ViewController *__weak weakSelf = self;
    
    [[InstagramEngine sharedEngine] getMediaAtLocation:coordinate
                                                 count:feedCount
                                                 maxId:maxID
                                              distance:100
                                           withSuccess:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
                                               if (media) {
                                                   [weakSelf.spinner stopAnimating];
                                                   weakSelf.nextMaxId = paginationInfo.nextMaxId;
                                                   [self.instagramPictures addObjectsFromArray:media];
                                                   [self.collectionView reloadData];
                                               }
                                           } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                                               if (error) {
                                                   NSLog(@"Error %@\n serverStatusCode %ld", error.description, (long)serverStatusCode);
                                               }
                                               [weakSelf.spinner stopAnimating];
                                               [self displayAlert:@"Failed to get Instagram Pictures"];
                                           }];
}

- (void)getUsersInstagramPictures:(NSString *)maxID {

    if ([[InstagramEngine sharedEngine] accessToken]) {
        ViewController *__weak weakSelf = self;

        [[InstagramEngine sharedEngine] getSelfFeedWithCount:feedCount
                                                       maxId:maxID
                                                     success:^(NSArray<InstagramMedia *> * _Nonnull media, InstagramPaginationInfo * _Nonnull paginationInfo) {
                                                           weakSelf.nextMaxId = paginationInfo.nextMaxId;
                                                           [self.instagramPictures addObjectsFromArray:media];
                                                           [self.collectionView reloadData];
                                                       } failure:^(NSError * _Nonnull error, NSInteger serverStatusCode) {
                                                           if (error) {
                                                               NSLog(@"FUCK %@\n serverStatusCode %ld", error.description, (long)serverStatusCode);
                                                           }
                                                           [self displayAlert:@"Failed to get Instagram Pictures"];
                                                       }];
    } else {
        [self displayAlert:@"Please Log In again"];
    }

}

- (void)retrieveInstagramPicturesPostAuthorization {
    [self fetchInstagramPictures];
    [self setUpNavBarUI];
}

#pragma mark - CLLocation Manager Delegate

- (void)setUpLocationManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
        //assumes, for this demo app, that user always accepts so no delegate method didChangeAuthorizationStatus:
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [self.locationManager startUpdatingLocation];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self.spinner stopAnimating];
    [self displayAlert:@"Failed to Get Your Location"];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    if (newLocation) {
        self.currentLocation = newLocation;
        [self fetchInstagramPictures];
        
        [self.locationManager stopUpdatingLocation];
        self.locationManager = nil;
    }
}


#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.instagramPictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GramCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gram" forIndexPath:indexPath];

    InstagramMedia *media = self.instagramPictures[indexPath.row];
    cell.imageURL = media.thumbnailURL;
    cell.bigImageURL = media.standardResolutionImageURL;
    cell.location = media.locationName;
    
    return cell;
}

#pragma mark Button Actions

- (IBAction)loginTapped:(UIBarButtonItem *)sender {
    if (!self.isValidSession) {
        LoginViewController *loginVC  = [self.storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
        loginVC.fetchDelegate = self;
        [self presentViewController:loginVC animated:YES completion:^{
            [loginVC.webView loadRequest:[NSURLRequest requestWithURL:[[InstagramEngine sharedEngine] authorizationURL]]];
        }];
    }
}

- (IBAction)refreshTapped:(UIBarButtonItem *)sender {
    [self fetchInstagramPictures];
}


#pragma mark Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(GramCollectionViewCell *)senderCell {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"collectionToBigImageSegue"]) {
        BigImageViewController *bigImageVC = [[BigImageViewController alloc] init];
        bigImageVC.bigImageURL = senderCell.bigImageURL;
        bigImageVC.title = senderCell.location;
    }
    
}
 

@end
