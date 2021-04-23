//
//  UIView+ExposureKit.m
//  ExposureKit
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "UIView+ExposureKit.h"
#import "UIView+ExposureKitPrivate.h"
#import <objc/runtime.h>
#import "ExposureKitManager.h"

NSString *const ExposureKitErrorDomain = @"com.shopee.ExposureKit";

@implementation UIView (ExposureKit)


- (BOOL)ek_scheduleExposure:(ExposureKitBlock)block
           minDurationInWindow:(NSTimeInterval)minDurationInWindow
          minAreaRatioInWindow:(CGFloat)minAreaRatioInWindow
                         error:(NSError **)error
{
    return [self ek_scheduleExposure:block minDurationInWindow:minDurationInWindow minAreaRatioInWindow:minAreaRatioInWindow retriggerWhenLeftScreen:NO retriggerWhenRemovedFromWindow:NO error:error];
}

- (BOOL)ek_scheduleExposure:(ExposureKitBlock)block
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
        EKLog(@"ExposureKit: %@", @"parameter invaild");
        if (error) {
            *error = [NSError errorWithDomain:ExposureKitErrorDomain code:ExposureKitErrorCodeParameterInvaild userInfo:@{NSLocalizedDescriptionKey: @"parameter invaild"}];
        }
        return NO;
    }
    
    // property
    self.ek_exposureBlock = block;
    self.ek_minDurationInWindow = minDurationInWindow;
    self.ek_minAreaRatioInWindow = minAreaRatioInWindow;
    self.ek_retriggerWhenLeftScreen = retriggerWhenLeftScreen;
    self.ek_retriggerWhenRemovedFromWindow = retriggerWhenRemovedFromWindow;
    
    // reset
    [self ek_resetSchedule];
    
    // aspect
    if (self.ek_token == nil) {
        __weak typeof(self) wself = self;
        self.ek_token = [self sh_hookAfterSelector:@selector(didMoveToWindow) error:error closure:^{
            __strong typeof(self) self = wself;
            if (self.window == nil) {
                [[ExposureKitManager sharedInstance] removeView:self];
                if (self.ek_retriggerWhenRemovedFromWindow) {
                    self.ek_isExposed = NO;
                }
            } else {
                [[ExposureKitManager sharedInstance] addView:self];
            }
        }];
        if (error && *error != nil) {
            return NO;
        }
    }
    return YES;
}

- (void)ek_resetSchedule
{
    self.ek_isExposed = NO;
    if (self.window != nil) {
        [[ExposureKitManager sharedInstance] addView:self];
    }
}

- (void)ek_cancelSchedule
{
    self.ek_exposureBlock = nil;
    self.ek_minDurationInWindow = 0;
    self.ek_minAreaRatioInWindow = 0;
    if (self.ek_token != nil) {
        [self.ek_token cancelHook];
        self.ek_token = nil;
    }
    [[ExposureKitManager sharedInstance] removeView:self];
}

#pragma mark - Helper

- (CGFloat)ek_areaRatioOnScreen
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
        return [self fixRatioPrecision:(intersection.size.width * intersection.size.height) / (self.bounds.size.width * self.bounds.size.height)];
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
        return [self fixRatioPrecision:(intersection.size.width * intersection.size.height) / (self.bounds.size.width * self.bounds.size.height)];
    }
}

- (CGFloat)fixRatioPrecision:(CGFloat)floatNumber
{
    // As long as the different ratios on screen is within 0.01% (0.0001), then we can consider two ratios as equal. It's sufficient for this case.
    CGFloat offset = 0.0001;
    if (floatNumber < offset) {
        floatNumber = 0;
    } else if (floatNumber > 1 - offset){
        floatNumber = 1;
    }
    return floatNumber;
}

@end
