//
//  EKDemoCoverViewController.m
//  ExposureKitExample
//
//  Created by Wang Ya on 10/1/19.
//  Copyright © 2019 Shopee. All rights reserved.
//

#import "EKDemoCoverViewController.h"

@interface EKDemoCoverViewController ()

@end

@implementation EKDemoCoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(20, 100, 200, 200)];
    coverView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:coverView];
}

@end
