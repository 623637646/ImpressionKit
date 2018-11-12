//
//  YNExposureTestOutsideWithReuseViewController.m
//  YNExposureDemo
//
//  Created by Wang Ya on 2/11/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureTestOutsideWithReuseViewController.h"
#import <YNExposure/YNExposure.h>
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "YNExposureTestOutsideWithReuseCollectionViewCell.h"

@interface YNExposureTestOutsideWithReuseViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, strong) NSMutableSet<NSIndexPath *> *exposuredIndexPaths;
@end

@implementation YNExposureTestOutsideWithReuseViewController

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
    [collectionView registerClass:YNExposureTestOutsideWithReuseCollectionViewCell.class forCellWithReuseIdentifier:[YNExposureTestOutsideWithReuseCollectionViewCell description]];
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
    YNExposureTestOutsideWithReuseCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNExposureTestOutsideWithReuseCollectionViewCell description] forIndexPath:indexPath];
    
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
