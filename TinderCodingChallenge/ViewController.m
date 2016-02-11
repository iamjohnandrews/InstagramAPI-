//
//  ViewController.m
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/8/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import "ViewController.h"
#import "InstagramKit.h"
#import "Instagram.h"

static NSString *CLIENT_ID = @"ae97b75b4af64898b7077cd7ecefd21d";
static NSString *CLIENT_SECRET = @"20fa3ad5d4934f94aaebc366244cc588";
static NSString *InstagramUserFeedBaseURL = @"https://api.instagram.com/v1/users/self/media/recent/?access_token=";

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *instagramPictures;
@property (nonatomic) BOOL isValidSession;
@property (strong, nonatomic) UIActivityIndicatorView *spinner;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.isValidSession = [[InstagramEngine sharedEngine] accessToken] ? YES : NO;
    if (self.isValidSession) {
        [self fetchInstagramPictures];
    } 
    self.collectionView.dataSource = self;
    self.instagramPictures = [NSMutableArray new];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpNavBarUI];
}

#pragma mark UI

- (void)updateCollectionView {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        [self.spinner stopAnimating];
        [self.collectionView reloadData];
    }];
}

- (void)displayAlert:(NSString *)alertMessage forMessageType:(NSString *)messageTpye {
    UIAlertController *alert= [UIAlertController alertControllerWithTitle:messageTpye
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
    self.spinner.color = [UIColor orangeColor];
    [self.collectionView addSubview: self.spinner];
    [self.collectionView bringSubviewToFront:self.spinner];
    self.spinner.hidesWhenStopped = YES;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
}

#pragma mark Networking

- (void)fetchInstagramPictures {
    if (self.isValidSession) {
        [self getUsersInstagramPictures];
    }
}

- (void)getUsersInstagramPictures {
    [self displaySpinner];
    NSString *link = [InstagramUserFeedBaseURL stringByAppendingString:[[InstagramEngine sharedEngine] accessToken]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:link]];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    [[session dataTaskWithRequest:request
                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
          if (!error && data) {
              NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:0
                                                                     error:nil];
              [self parseUsersResponse:dict];
            } else {
              NSLog(@"Error: %@", error.description);
              [self displayAlert:@"Failed to get Instagram Pictures" forMessageType:@"Error"];
          }
      }] resume];
}


- (void)parseUsersResponse:(NSDictionary *)responseDict {
    for (NSDictionary *imageObjects in responseDict[@"data"]) {
        NSDictionary *imageQuality = imageObjects[@"images"];
        
        Instagram *instagram = [[Instagram alloc] init];
        instagram.standardResolutionURL = [imageQuality[@"standard_resolution"] objectForKey:@"url"];
        instagram.lowResolutionURL = [imageQuality[@"low_resolution"] objectForKey:@"url"];
        
        [self.instagramPictures addObject:instagram];
    }
    [self updateCollectionView];
}

- (void)retrieveInstagramPicturesPostAuthorization {
    self.isValidSession = [[InstagramEngine sharedEngine] accessToken] ? YES : NO;
    [self fetchInstagramPictures];
    [self setUpNavBarUI];
}

#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.instagramPictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GramCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gram" forIndexPath:indexPath];

    Instagram *media = self.instagramPictures[indexPath.row];
    cell.imageURL = media.lowResolutionURL;
    cell.bigImageURL = media.standardResolutionURL;
    
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
    } else {
        [[InstagramEngine sharedEngine] logout];
        self.isValidSession = NO;
        [self setUpNavBarUI];
    }
}

- (IBAction)refreshTapped:(UIBarButtonItem *)sender {
    [self fetchInstagramPictures];
}


#pragma mark Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(GramCollectionViewCell *)senderCell {
    
    if ([segue.identifier isEqualToString:@"collectionToBigImageSegue"]) {
        BigImageViewController *bigImageVC = segue.destinationViewController;
        bigImageVC.bigImageURL = senderCell.bigImageURL;
    }
}
 

@end
