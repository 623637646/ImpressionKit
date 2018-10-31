//
//  UIView+YNExposure.m
//  YNExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "UIView+YNExposure.h"
#import "UIView+YNExposurePrivate.h"
#import <objc/runtime.h>
#import <Aspects/Aspects.h>
#import "YNExposureManager.h"

NSString *const YNExposureErrorDomin = @"com.shopee.yanni.YNExposure";

@implementation UIView (YNExposure)

- (BOOL)ynex_execute:(YNExposureBlock)block delay:(NSTimeInterval)delay minAreaRatio:(CGFloat)minAreaRatio error:(NSError**)error
{
    // check parameter
    NSParameterAssert(block != nil);
    NSParameterAssert(delay >= 0);
    NSParameterAssert(minAreaRatio > 0 && minAreaRatio <=1);
    NSParameterAssert(*error == nil);
    if (block == nil || delay < 0 || (minAreaRatio <= 0 || minAreaRatio > 1) || *error != nil) {
        *error = [NSError errorWithDomain:YNExposureErrorDomin code:YNExposureErrorCodeParameterInvaild userInfo:nil];
        return NO;
    }
    if (self.ynex_exposureBlock != nil) {
        *error = [NSError errorWithDomain:YNExposureErrorDomin code:YNExposureErrorCodeAlreadySignup userInfo:nil];
        return NO;
    }
    
    // property
    self.ynex_exposureBlock = block;
    self.ynex_delay = delay;
    self.ynex_minAreaRatio = minAreaRatio;
    
    // aspect
    __weak typeof(self) wself = self;
    [self aspect_hookSelector:@selector(didMoveToWindow) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        __strong typeof(self) self = wself;
        if (self.window == nil) {
            [[YNExposureManager sharedInstance] removeView:self];
        } else {
            [[YNExposureManager sharedInstance] addView:self];
        }
    } error:error];
    if (*error != nil) {
        return NO;
    }
    return YES;
}

- (void)ynex_resetExecute
{
    self.ynex_isExposured = NO;
    self.ynex_lastShowedDate = nil;
    if (self.window != nil) {
        [[YNExposureManager sharedInstance] addView:self];
    }
}

#pragma mark - Helper

- (BOOL)ynex_showedOnScreen
{
    return [self ynex_ratioOnScreen] > 0;
}

- (CGFloat)ynex_ratioOnScreen
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
