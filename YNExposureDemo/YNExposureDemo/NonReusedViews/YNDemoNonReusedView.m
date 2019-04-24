//
//  YNDemoNonReusedView.m
//  YNExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNDemoNonReusedView.h"
#import <YNExposure/YNExposure.h>
#import "UIView+YNExposureViewPrivate.h"

@interface YNDemoNonReusedView()
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNDemoNonReusedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5;
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
        
        NSError *error = nil;
        __weak typeof(self) wself = self;
        [self ynex_executeExposureDetection:^(CGFloat areaRatio) {
            __strong typeof(self) self = wself;
            self.label.text = [NSString stringWithFormat:@"%0.1f%%", areaRatio * 100];
        } delay:2 minAreaRatio:0.5 error:&error];
        NSAssert(error == nil, @"error is not nil");
    }
    return self;
}

- (void)reset
{
    [self ynex_resetExecution];
    [self.layer removeAllAnimations];
    self.label.text = nil;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setYnex_lastShowedDate:(NSDate *)ynex_lastShowedDate
{
    [super setYnex_lastShowedDate:ynex_lastShowedDate];
    [self updateBackendColor];
}

- (void)setYnex_isExposureDetected:(BOOL)ynex_isExposureDetected
{
    [super setYnex_isExposureDetected:ynex_isExposureDetected];
    [self updateBackendColor];
}

- (void)updateBackendColor
{
    if (self.ynex_isExposureDetected) {
        self.backgroundColor = [UIColor greenColor];
        return;
    }
    if (self.ynex_lastShowedDate != nil) {
        self.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:self.ynex_delay delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.backgroundColor = [UIColor redColor];
        } completion:nil];
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
}

@end
