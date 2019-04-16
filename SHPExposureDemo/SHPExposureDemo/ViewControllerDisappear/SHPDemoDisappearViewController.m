//
//  SHPDemoDisappearViewController.m
//  SHPExposureDemo
//
//  Created by Wang Ya on 10/1/19.
//  Copyright © 2019 Shopee. All rights reserved.
//

#import "SHPDemoDisappearViewController.h"

@interface SHPDemoDisappearViewController ()

@end

@implementation SHPDemoDisappearViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *resetButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextPageButtonClick:)];
    self.navigationItem.rightBarButtonItem = resetButtonItem;
}

- (void)nextPageButtonClick:(id)sender
{
    UIViewController *vc = [[UIViewController alloc] initWithNibName:nil bundle:nil];
    vc.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
