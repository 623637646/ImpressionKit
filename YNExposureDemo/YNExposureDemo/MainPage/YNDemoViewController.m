//
//  YNDemoViewController.m
//  YNExposureDemo
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNDemoViewController.h"
#import "YNDemoNonReusedViewController.h"
#import "YNDemoTitleCollectionViewCell.h"
#import "YNDemoReusedViewController.h"
#import "YNDemoDisappearViewController.h"
#import "YNDemoCoverViewController.h"

@interface YNDemoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, copy) NSArray<NSArray *> *demos;
@end

@implementation YNDemoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Exposure Demo";
        self.demos = @[
                       @[@"non-reused views", YNDemoNonReusedViewController.class],
                       @[@"reused views", YNDemoReusedViewController.class],
                       @[@"view controller disappear", YNDemoDisappearViewController.class],
                       @[@"cover view", YNDemoCoverViewController.class]
                    ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, 44);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:YNDemoTitleCollectionViewCell.class forCellWithReuseIdentifier:[YNDemoTitleCollectionViewCell description]];
    [self.view addSubview:collectionView];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.demos.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.demos objectAtIndex:indexPath.row];
    YNDemoTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[YNDemoTitleCollectionViewCell description] forIndexPath:indexPath];
    cell.title = array[0];
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *array = [self.demos objectAtIndex:indexPath.row];
    UIViewController *vc = [[(Class)array[1] alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
