//
//  YNExposureTestOutsideWithReuseViewController.m
//  YNExposureDemo
//
//  Created by Wang Ya on 2/11/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureTestOutsideWithReuseViewController.h"
#import "YNExposureDemoTestingCollectionViewCell.h"

@interface YNExposureTestOutsideWithReuseViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation YNExposureTestOutsideWithReuseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(44, 44);
    
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
    return 600;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YNExposureDemoTestingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNExposureDemoTestingCollectionViewCell description] forIndexPath:indexPath];
    return cell;
}
@end
