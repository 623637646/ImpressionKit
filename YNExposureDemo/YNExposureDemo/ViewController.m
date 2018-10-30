//
//  ViewController.m
//  YNExposureDemo
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "ViewController.h"
#import <YNExposure/YNExposure.h>
#import "YNEeposureTestingView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, scrollView.frame.size.height * 2);
    [self.view addSubview:scrollView];
    
    YNEeposureTestingView *view = [[YNEeposureTestingView alloc] initWithFrame:CGRectMake(50, scrollView.frame.size.height + 50, 50, 50)];
    view.backgroundColor = [UIColor redColor];
    [scrollView addSubview:view];
    
    NSError *error = nil;
    [view ynex_execute:^(CGFloat areaRatio) {
        NSLog(@"execute!!!");
    } delay:1 minAreaRatio:1 error:&error];
}


@end
