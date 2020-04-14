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

NSString *const SHPExposureErrorDomain = @"com.shopee.SHPExposure";

@implementation UIView (SHPExposure)


- (BOOL)shpex_scheduleExposure:(SHPExposureBlock)block
           minDurationInWindow:(NSTimeInterval)minDurationInWindow
          minAreaRatioInWindow:(CGFloat)minAreaRatioInWindow
                         error:(NSError **)error
{
    return [self shpex_scheduleExposure:block minDurationInWindow:minDurationInWindow minAreaRatioInWindow:minAreaRatioInWindow retriggerWhenLeftScreen:NO retriggerWhenRemovedFromWindow:NO error:error];
}

- (BOOL)shpex_scheduleExposure:(SHPExposureBlock)block
           minDurationInWindow:(NSTimeInterval)minDurationInWindow
          minAreaRatioInWindow:(CGFloat)minAreaRatioInWindow
       retriggerWhenLeftScreen:(BOOL)retriggerWhenLeftScreen
retriggerWhenRemovedFromWindow:(BOOL)retriggerWhenRemovedFromWindow
                         error:(NSError **)error
{
    // check parameter
    NSParameterAssert(block != nil);
    NSParameterAssert(minDurationInWindow >= 0);
    NSParameterAssert(minAreaRatioInWindow > 0 && minAreaRatioInWindow <=1);
    if (block == nil || minDurationInWindow < 0 || (minAreaRatioInWindow <= 0 || minAreaRatioInWindow > 1)) {
        SHPLog(@"SHPExposure: %@", @"parameter invaild");
        if (error) {
            *error = [NSError errorWithDomain:SHPExposureErrorDomain code:SHPExposureErrorCodeParameterInvaild userInfo:@{NSLocalizedDescriptionKey: @"parameter invaild"}];
        }
        return NO;
    }
    
    // property
    self.shpex_exposureBlock = block;
    self.shpex_minDurationInWindow = minDurationInWindow;
    self.shpex_minAreaRatioInWindow = minAreaRatioInWindow;
    self.shpex_retriggerWhenLeftScreen = retriggerWhenLeftScreen;
    self.shpex_retriggerWhenRemovedFromWindow = retriggerWhenRemovedFromWindow;
    
    // reset
    [self shpex_resetSchedule];
    
    // aspect
    if (self.shpex_token == nil) {
        __weak typeof(self) wself = self;
        self.shpex_token = [self aspect_hookSelector:@selector(didMoveToWindow) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
            __strong typeof(self) self = wself;
            if (self.window == nil) {
                [[SHPExposureManager sharedInstance] removeView:self];
                if (self.shpex_retriggerWhenRemovedFromWindow) {
                    self.shpex_isExposed = NO;
                }
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

- (CGFloat)shpex_areaRatioOnScreen
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
        return [self fixFloatPrecision:(intersection.size.width * intersection.size.height) / (self.bounds.size.width * self.bounds.size.height)];
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
        return [self fixFloatPrecision:(intersection.size.width * intersection.size.height) / (self.bounds.size.width * self.bounds.size.height)];
    }
}

- (CGFloat)fixFloatPrecision:(CGFloat)floatNumber
{
    // fix float precision
    if (floatNumber < 0.0001) {
        floatNumber = 0;
    } else if (floatNumber > 1 - 0.0001){
        floatNumber = 1;
    }
    return floatNumber;
}

@end
