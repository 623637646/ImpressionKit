//
//  YNExposureTestOutsideViewController.m
//  YNExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureTestOutsideViewController.h"

@interface YNExposureTestOutsideViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@end

@implementation YNExposureTestOutsideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, 44);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:YNExposureDemoTitleCollectionViewCell.class forCellWithReuseIdentifier:[YNExposureDemoTitleCollectionViewCell description]];
    [self.view addSubview:collectionView];
    
    
//    YNExposureDemoTestingView *view = [[YNExposureDemoTestingView alloc] initWithFrame:CGRectMake(50, scrollView.frame.size.height + 50, 50, 50)];
//    view.backgroundColor = [UIColor redColor];
//    [scrollView addSubview:view];
//
//    NSError *error = nil;
//    [view ynex_execute:^(CGFloat areaRatio) {
//
//    } delay:5 minAreaRatio:1 error:&error];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.demos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.demos objectAtIndex:indexPath.row];
    YNExposureDemoTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNExposureDemoTitleCollectionViewCell description] forIndexPath:indexPath];
    cell.title = array[0];
    return cell;
}
@end
