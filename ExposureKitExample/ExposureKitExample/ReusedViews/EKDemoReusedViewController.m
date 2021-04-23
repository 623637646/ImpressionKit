//
//  EKDemoReusedViewController.m
//  ExposureKitExample
//
//  Created by Wang Ya on 2/11/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "EKDemoReusedViewController.h"
#import <CHTCollectionViewWaterfallLayout/CHTCollectionViewWaterfallLayout.h>
#import "EKDemoReusedCollectionViewCell.h"
#import "ExposureKitExample-Swift.h"
#import "UIView+ExposureKitExamplePrivate.h"
@import EasyExposureKit;

@interface EKDemoReusedViewController ()<UICollectionViewDataSource, CHTCollectionViewDelegateWaterfallLayout>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableSet<NSIndexPath *> *exposuredIndexPaths;
@end

@implementation EKDemoReusedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *resetButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonClick:)];
    self.navigationItem.rightBarButtonItem = resetButtonItem;

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
    [collectionView registerClass:EKDemoReusedCollectionViewCell.class forCellWithReuseIdentifier:[EKDemoReusedCollectionViewCell description]];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (void)resetButtonClick:(id)sender
{
    [self.exposuredIndexPaths removeAllObjects];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionTop animated:NO];
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
    EKDemoReusedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[EKDemoReusedCollectionViewCell description] forIndexPath:indexPath];
    BOOL isExposuredByIndex = [self.exposuredIndexPaths containsObject:indexPath];
    if (isExposuredByIndex) {
        [cell ek_cancelSchedule];
        cell.ek_isExposed = YES;
    } else {
        NSError *error = nil;
        __weak typeof(self) wself = self;
        [cell ek_scheduleExposure:^(CGFloat areaRatio) {
            __strong typeof(self) self = wself;
            if (!EKDemoViewController.retriggerWhenLeftScreen) {
                [self.exposuredIndexPaths addObject:indexPath];
            }
        }
                 minDurationInWindow:EKDemoViewController.minDurationInWindow
                minAreaRatioInWindow:EKDemoViewController.minAreaRatioInWindow
             retriggerWhenLeftScreen:EKDemoViewController.retriggerWhenLeftScreen
      retriggerWhenRemovedFromWindow:EKDemoViewController.retriggerWhenRemovedFromWindow
                               error:&error];
        NSAssert(error == nil, @"error is not nil");
        cell.ek_isExposed = NO;
    }
    return cell;
}
@end
