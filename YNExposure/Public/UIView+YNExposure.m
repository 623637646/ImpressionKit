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

@implementation UIView (YNExposure)

- (void)ynex_execute:(YNExposureBlock)block delay:(NSTimeInterval)delay minAreaRatio:(CGFloat)minAreaRatio
{
    self.ynex_exposureBlock = block;
    self.ynex_delay = delay;
    self.ynex_minAreaRatio = minAreaRatio;
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

@end
