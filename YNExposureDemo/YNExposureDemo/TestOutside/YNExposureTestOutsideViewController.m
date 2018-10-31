//
//  YNExposureTestOutsideViewController.m
//  YNExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureTestOutsideViewController.h"
#import "YNExposureDemoTestingCollectionViewCell.h"

@interface YNExposureTestOutsideViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation YNExposureTestOutsideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(88, 88);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:YNExposureDemoTestingCollectionViewCell.class forCellWithReuseIdentifier:[YNExposureDemoTestingCollectionViewCell description]];
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 300;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YNExposureDemoTestingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNExposureDemoTestingCollectionViewCell description] forIndexPath:indexPath];
    return cell;
}
@end
