//
//  YNExposureDemoTestingView.m
//  YNExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureDemoTestingView.h"
#import <YNExposure/YNExposure.h>

@interface UIView(YNExposureDemoTestingViewPrivate)
@property (nonatomic, assign) BOOL ynex_isExposured;
@property (nonatomic, copy) NSDate *ynex_lastShowedDate;
@property (nonatomic, assign) NSTimeInterval ynex_delay;

@end

@implementation UIView(YNExposureDemoTestingViewPrivate)
@dynamic ynex_isExposured;
@dynamic ynex_lastShowedDate;
@dynamic ynex_delay;
@end

static void *YNExposureDemoTestingViewContext = &YNExposureDemoTestingViewContext;

@interface YNExposureDemoTestingView()
@end

@implementation YNExposureDemoTestingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSError *error = nil;
        [self ynex_execute:^(CGFloat areaRatio) {
            
        } delay:2 minAreaRatio:1 error:&error];
        NSAssert(error == nil, @"error is not nil");
    }
    return self;
}

- (void)reset
{
    [self ynex_resetExecute];
}

-(void)setYnex_lastShowedDate:(NSDate *)ynex_lastShowedDate
{
    [super setYnex_lastShowedDate:ynex_lastShowedDate];
    [self updateBackendColor];
}

-(void)setYnex_isExposured:(BOOL)ynex_isExposured
{
    [super setYnex_isExposured:ynex_isExposured];
    [self updateBackendColor];
}

-(void) updateBackendColor
{
    [self.layer removeAllAnimations];
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
