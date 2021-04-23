//
//  EKDemoNonReusedView.m
//  ExposureKitExample
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "EKDemoNonReusedView.h"
#import "UIView+ExposureKitExamplePrivate.h"
#import "ExposureKitExample-Swift.h"
@import EasyExposureKit;

@interface EKDemoNonReusedView()
@property (nonatomic, weak) UILabel *label;
@end

@implementation EKDemoNonReusedView

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
        [self ek_scheduleExposure:^(CGFloat areaRatio) {
            __strong typeof(self) self = wself;
            self.label.text = [NSString stringWithFormat:@"%0.1f%%", areaRatio * 100];
        }
                 minDurationInWindow:EKDemoViewController.minDurationInWindow
                minAreaRatioInWindow:EKDemoViewController.minAreaRatioInWindow
             retriggerWhenLeftScreen:EKDemoViewController.retriggerWhenLeftScreen
      retriggerWhenRemovedFromWindow:EKDemoViewController.retriggerWhenRemovedFromWindow
                               error:&error];
        NSAssert(error == nil, @"error is not nil");
    }
    return self;
}

- (void)reset
{
    [self ek_resetSchedule];
    [self.layer removeAllAnimations];
    self.label.text = nil;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setEk_startAppearanceDate:(NSDate *)ek_startAppearanceDate
{
    [super setEk_startAppearanceDate:ek_startAppearanceDate];
    [self updateBackendColor];
}

- (void)setEk_isExposed:(BOOL)ek_isExposed
{
    [super setEk_isExposed:ek_isExposed];
    [self updateBackendColor];
}

- (void)updateBackendColor
{
    if (self.ek_isExposed) {
        self.backgroundColor = [UIColor greenColor];
        return;
    }
    if (self.ek_startAppearanceDate) {
        self.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:self.ek_minDurationInWindow delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.backgroundColor = [UIColor redColor];
        } completion:nil];
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
    self.label.text = nil;
}

@end
