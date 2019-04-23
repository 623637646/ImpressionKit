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

- (BOOL)shpex_execute:(SHPExposureBlock)block delay:(NSTimeInterval)delay minAreaRatio:(CGFloat)minAreaRatio error:(NSError**)error
{
    // check parameter
    NSParameterAssert(block != nil);
    NSParameterAssert(delay >= 0);
    NSParameterAssert(minAreaRatio > 0 && minAreaRatio <=1);
    NSParameterAssert(*error == nil);
    if (block == nil || delay < 0 || (minAreaRatio <= 0 || minAreaRatio > 1) || *error != nil) {
        *error = [NSError errorWithDomain:SHPExposureErrorDomain code:SHPExposureErrorCodeParameterInvaild userInfo:nil];
        return NO;
    }
    
    // reset
    [self shpex_resetExecute];
    
    // property
    self.shpex_exposureBlock = block;
    self.shpex_delay = delay;
    self.shpex_minAreaRatio = minAreaRatio;
    
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
        if (*error != nil) {
            return NO;
        }
    }
    return YES;
}

- (void)shpex_resetExecute
{
    self.shpex_isExposured = NO;
    self.shpex_lastShowedDate = nil;
    if (self.window != nil) {
        [[SHPExposureManager sharedInstance] addView:self];
    }
}

- (void)shpex_cancelExecute
{
    self.shpex_exposureBlock = nil;
    self.shpex_delay = 0;
    self.shpex_minAreaRatio = 0;
    if (self.shpex_token != nil) {
        [self.shpex_token remove];
        self.shpex_token = nil;
    }
    [[SHPExposureManager sharedInstance] removeView:self];
}

#pragma mark - Helper

- (BOOL)shpex_isShowingOnScreen
{
    return [self shpex_ratioOnScreen] > 0;
}

- (CGFloat)shpex_ratioOnScreen
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
