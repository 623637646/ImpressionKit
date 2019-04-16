//
//  SHPDemoNonReusedViewController.m
//  SHPExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "SHPDemoNonReusedViewController.h"
#import "SHPDemoNonReusedView.h"

#define column 4

@interface SHPDemoNonReusedViewController ()
@property (nonatomic, strong) NSArray *testViews;
@end

@implementation SHPDemoNonReusedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *resetButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Reset" style:UIBarButtonItemStylePlain target:self action:@selector(resetButtonClick:)];
    self.navigationItem.rightBarButtonItem = resetButtonItem;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:scrollView];
    
    NSMutableArray<UIView *> *views = [[NSMutableArray<UIView *> alloc] init];
    CGRect frames[column];
    for (int i = 0; i < column; i++) {
        frames[i] = CGRectMake((i % column) * (self.view.bounds.size.width / column), 0, self.view.bounds.size.width / column, 0);
    }
    
    for (int i = 0; i < 99; i++) {
        int index = 0;
        for (int j = 1; j < column; j++) {
            CGRect frame1 = frames[index];
            CGRect frame2 = frames[j];
            
            if (frame2.origin.y + frame2.size.height < frame1.origin.y + frame1.size.height) {
                index = j;
            }
        }
        CGRect topFrame = frames[index];
        CGFloat x = topFrame.origin.x;
        CGFloat y = topFrame.origin.y + topFrame.size.height;
        CGFloat width = topFrame.size.width;
        CGFloat height = width + arc4random() % (int)width;
        CGRect frame = CGRectMake(x, y, width, height);
        frames[index] = frame;
        SHPDemoNonReusedView *view = [[SHPDemoNonReusedView alloc] initWithFrame:frame];
        [views addObject:view];
        [scrollView addSubview:view];
    }
    
    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, views.lastObject.frame.origin.y + views.lastObject.frame.size.height);
    
    self.testViews = views;
}

- (void)resetButtonClick:(id)sender
{
    for (SHPDemoNonReusedView *view in self.testViews) {
        [view reset];
    }
}


@end
