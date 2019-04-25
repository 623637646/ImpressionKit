//
//  UIView+SHPExposure.m
//  SHPExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "UIView+SHPExposure.h"
#import "UIView+SHPExposurePrivate.h"
#import <objc/runtime.h>
#import <Aspects/Aspects.h>
#import "SHPExposureManager.h"
#import "SHPExposureConfig.h"

NSString *const SHPExposureErrorDomain = @"com.shopee.SHPExposure";

@implementation UIView (SHPExposure)

- (BOOL)shpex_scheduleExposure:(SHPExposureBlock)block
           minDurationInWindow:(NSTimeInterval)minDurationInWindow
          minAreaRatioInWindow:(CGFloat)minAreaRatioInWindow
                         error:(NSError **)error
{
    // check parameter
    NSParameterAssert(block != nil);
    NSParameterAssert(minDurationInWindow >= 0);
    NSParameterAssert(minAreaRatioInWindow > 0 && minAreaRatioInWindow <=1);
    if (block == nil || minDurationInWindow < 0 || (minAreaRatioInWindow <= 0 || minAreaRatioInWindow > 1)) {
        SHPError(error, SHPExposureErrorCodeParameterInvaild, @"parameter invaild");
        return NO;
    }
    
    // reset
    [self shpex_resetSchedule];
    
    // property
    self.shpex_exposureBlock = block;
    self.shpex_minDurationInWindow = minDurationInWindow;
    self.shpex_minAreaRatioInWindow = minAreaRatioInWindow;
    
    // aspect
    if (self.shpex_token == nil) {
        __weak typeof(self) wself = self;
        self.shpex_token = [self aspect_hookSelector:@selector(didMoveToWindow) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            __strong typeof(self) self = wself;
            if (self.window == nil) {
                [[SHPExposureManager sharedInstance] removeView:self];
            } else {
                [[SHPExposureManager sharedInstance] addView:self];
            }
        } error:error];
        if (error && *error != nil) {
            return NO;
        }
    }
    return YES;
}

- (void)shpex_resetSchedule
{
    self.shpex_isExposed = NO;
    self.shpex_lastShowedDate = nil;
    if (self.window != nil) {
        [[SHPExposureManager sharedInstance] addView:self];
    }
}

- (void)shpex_cancelSchedule
{
    self.shpex_exposureBlock = nil;
    self.shpex_minDurationInWindow = 0;
    self.shpex_minAreaRatioInWindow = 0;
    if (self.shpex_token != nil) {
        [self.shpex_token remove];
        self.shpex_token = nil;
    }
    [[SHPExposureManager sharedInstance] removeView:self];
}

#pragma mark - Helper

- (CGFloat)shpex_areaRatioInWindow
{
    if (self.hidden || self.alpha <= 0) {
        return 0;
    }
    
    if ([self isKindOfClass:UIWindow.class] && self.superview == nil) {
        // Used as a window!
        UIScreen *screen = ((UIWindow *)self).screen;
        if (screen == nil) {
            return 0;
        }
        CGRect intersection = CGRectIntersection(self.frame, screen.bounds);
        return (intersection.size.width * intersection.size.height) / (self.bounds.size.width * self.bounds.size.height);
    } else {
        // Used as a view!
        UIWindow *window = self.window;
        if (window == nil || window.hidden == YES || window.alpha <= 0) {
            return 0;
        }
        
        // If super view hidden or alpha <= 0, self can't show
        UIView *superView = self.superview;
        NSAssert(superView != nil, @"superview is nil");
        while (superView != nil) {
            if (superView.hidden || superView.alpha <= 0) {
                return 0;
            }
            superView = superView.superview;
        }
        
        // Calculation
        CGRect frameInWindow = [self convertRect:self.bounds toView:window];
        CGRect frameInScreen = CGRectMake(frameInWindow.origin.x + window.frame.origin.x, frameInWindow.origin.y + window.frame.origin.y, frameInWindow.size.width, frameInWindow.size.height);
        CGRect intersection = CGRectIntersection(frameInScreen, window.screen.bounds);
        return (intersection.size.width * intersection.size.height) / (self.bounds.size.width * self.bounds.size.height);
    }
}

@end
