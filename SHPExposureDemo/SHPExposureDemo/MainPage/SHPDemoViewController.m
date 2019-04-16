//
//  SHPDemoViewController.m
//  SHPExposureDemo
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "SHPDemoViewController.h"
#import "SHPDemoNonReusedViewController.h"
#import "SHPDemoTitleCollectionViewCell.h"
#import "SHPDemoReusedViewController.h"
#import "SHPDemoDisappearViewController.h"
#import "SHPDemoCoverViewController.h"

@interface SHPDemoViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, copy) NSArray<NSArray *> *demos;
@end

@implementation SHPDemoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Exposure Demo";
        self.demos = @[
                       @[@"non-reused views", SHPDemoNonReusedViewController.class],
                       @[@"reused views", SHPDemoReusedViewController.class],
                       @[@"view controller disappear", SHPDemoDisappearViewController.class],
                       @[@"cover view", SHPDemoCoverViewController.class]
                    ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(self.view.bounds.size.width, 44);
    layout.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:SHPDemoTitleCollectionViewCell.class forCellWithReuseIdentifier:[SHPDemoTitleCollectionViewCell description]];
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
    SHPDemoTitleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[SHPDemoTitleCollectionViewCell description] forIndexPath:indexPath];
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
