//
//  SHPDemoNonReusedView.m
//  SHPExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "SHPDemoNonReusedView.h"
#import <SHPExposure/SHPExposure.h>
#import "UIView+SHPExposureViewPrivate.h"
#import "SHPExposureDemo-Swift.h"

@interface SHPDemoNonReusedView()
@property (nonatomic, weak) UILabel *label;
@end

@implementation SHPDemoNonReusedView

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
        [self shpex_scheduleExposure:^(CGFloat areaRatio) {
            __strong typeof(self) self = wself;
            self.label.text = [NSString stringWithFormat:@"%0.1f%%", areaRatio * 100];
        }
                 minDurationInWindow:SHPDemoViewController.minDurationInWindow
                minAreaRatioInWindow:SHPDemoViewController.minAreaRatioInWindow
             retriggerWhenLeftScreen:SHPDemoViewController.retriggerWhenLeftScreen
      retriggerWhenRemovedFromWindow:SHPDemoViewController.retriggerWhenRemovedFromWindow
                               error:&error];
        NSAssert(error == nil, @"error is not nil");
    }
    return self;
}

- (void)reset
{
    [self shpex_resetSchedule];
    [self.layer removeAllAnimations];
    self.label.text = nil;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setShpex_startAppearanceDate:(NSDate *)shpex_startAppearanceDate
{
    [super setShpex_startAppearanceDate:shpex_startAppearanceDate];
    [self updateBackendColor];
}

- (void)setShpex_isExposed:(BOOL)shpex_isExposed
{
    [super setShpex_isExposed:shpex_isExposed];
    [self updateBackendColor];
}

- (void)updateBackendColor
{
    if (self.shpex_isExposed) {
        self.backgroundColor = [UIColor greenColor];
        return;
    }
    if (self.shpex_startAppearanceDate) {
        self.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:self.shpex_minDurationInWindow delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.backgroundColor = [UIColor redColor];
        } completion:nil];
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
    self.label.text = nil;
}

@end
