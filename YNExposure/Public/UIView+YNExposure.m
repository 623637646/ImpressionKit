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
    [self aspect_hookSelector:@selector(didMoveToWindow) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
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
    
}

#pragma mark - setter getter

-(void)setYnex_isExposured:(BOOL)ynex_isExposured
{
    objc_setAssociatedObject(self, @selector(ynex_isExposured), @(ynex_isExposured), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(BOOL)ynex_isExposured
{
    return [objc_getAssociatedObject(self, @selector(ynex_isExposured)) boolValue];
}

- (void)setYnex_interval:(NSTimeInterval)ynex_interval
{
    [YNExposureManager sharedInstance].interval = ynex_interval;
}

-(NSTimeInterval)ynex_interval
{
    return [YNExposureManager sharedInstance].interval;
}

@end
