//
//  DemoTestOutsideWithReuseViewController.m
//  YNExposureDemo
//
//  Created by Wang Ya on 2/11/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "DemoTestOutsideWithReuseViewController.h"
#import <YNExposure/YNExposure.h>
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "DemoTestOutsideWithReuseCollectionViewCell.h"

@interface DemoTestOutsideWithReuseViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) NSMutableSet<NSIndexPath *> *exposuredIndexPaths;
@end

@implementation DemoTestOutsideWithReuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.exposuredIndexPaths = [[NSMutableSet<NSIndexPath *> alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.columnCount = 4;
    layout.minimumColumnSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:DemoTestOutsideWithReuseCollectionViewCell.class forCellWithReuseIdentifier:[DemoTestOutsideWithReuseCollectionViewCell description]];
    [self.view addSubview:collectionView];
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100 + arc4random() % (int)100);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 200;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DemoTestOutsideWithReuseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[DemoTestOutsideWithReuseCollectionViewCell description] forIndexPath:indexPath];
    
    NSError *error = nil;
    __weak typeof(self) wself = self;
    __weak typeof(cell) wcell = cell;
    [cell ynex_execute:^(CGFloat areaRatio) {
        __strong typeof(self) self = wself;
        __strong typeof(cell) cell = wcell;
        [self.exposuredIndexPaths addObject:indexPath];
        cell.isExposuredByIndex = YES;
    } delay:2 minAreaRatio:0.5 error:&error];
    NSAssert(error == nil, @"error is not nil");
    
    cell.isExposuredByIndex = [self.exposuredIndexPaths containsObject:indexPath];
    return cell;
}
@end
