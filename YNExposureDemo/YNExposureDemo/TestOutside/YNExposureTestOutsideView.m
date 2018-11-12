//
//  YNExposureTestOutsideView.m
//  YNExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureTestOutsideView.h"
#import <YNExposure/YNExposure.h>
#import "UIView+YNExposureViewPrivate.h"

static void *YNExposureTestOutsideViewContext = &YNExposureTestOutsideViewContext;

@interface YNExposureTestOutsideView()
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNExposureTestOutsideView

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
        [self ynex_execute:^(CGFloat areaRatio) {
            __strong typeof(self) self = wself;
            self.label.text = [NSString stringWithFormat:@"%0.1f%%", areaRatio * 100];
        } delay:2 minAreaRatio:0.5 error:&error];
        NSAssert(error == nil, @"error is not nil");
    }
    return self;
}

- (void)reset
{
    [self ynex_resetExecute];
    [self.layer removeAllAnimations];
    self.label.text = nil;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setYnex_lastShowedDate:(NSDate *)ynex_lastShowedDate
{
    [super setYnex_lastShowedDate:ynex_lastShowedDate];
    [self updateBackendColor];
}

- (void)setYnex_isExposured:(BOOL)ynex_isExposured
{
    [super setYnex_isExposured:ynex_isExposured];
    [self updateBackendColor];
}

- (void)updateBackendColor
{
    if (self.ynex_isExposured) {
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
