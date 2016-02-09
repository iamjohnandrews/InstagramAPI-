//
//  ViewController.m
//  TinderCodingChallenge
//
//  Created by John Andrews on 2/8/16.
//  Copyright © 2016 John Andrews. All rights reserved.
//

#import "ViewController.h"

static NSString *CLIENT_ID = @"ae97b75b4af64898b7077cd7ecefd21d";
static NSString *CLIENT_SECRET = @"20fa3ad5d4934f94aaebc366244cc588";

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *instagramPictures;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    self.title = @"Your Instagram";
}

#pragma mark Networking

#pragma mark CollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.instagramPictures.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GramCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gram" forIndexPath:indexPath];

    
    return cell;
}

#pragma mark CollectionView Delegate


#pragma mark Button Actions

- (IBAction)loginTapped:(UIBarButtonItem *)sender {
}

- (IBAction)refreshTapped:(UIBarButtonItem *)sender {
}


#pragma mark Navigation
 
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(GramCollectionViewCell *)senderCell {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"collectionToBigImageSegue"]) {
        BigImageViewController *bigImageVC = [[BigImageViewController alloc] init];
        bigImageVC.bigImageView = senderCell.instagramImageView;
        bigImageVC.imageTitle;
    }
    
}
 

@end
