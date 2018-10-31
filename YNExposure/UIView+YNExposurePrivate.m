//
//  UIView+YNExposurePrivate.m
//  YNExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "UIView+YNExposurePrivate.h"
#import <objc/runtime.h>

@implementation UIView (YNExposurePrivate)

- (void)setYnex_isExposured:(BOOL)ynex_isExposured
{
    objc_setAssociatedObject(self, @selector(ynex_isExposured), @(ynex_isExposured), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)ynex_isExposured
{
    return [objc_getAssociatedObject(self, @selector(ynex_isExposured)) boolValue];
}

-(void)setYnex_lastShowedDate:(NSDate *)ynex_lastShowedDate
{
    objc_setAssociatedObject(self, @selector(ynex_lastShowedDate), ynex_lastShowedDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSDate *)ynex_lastShowedDate
{
    return objc_getAssociatedObject(self, @selector(ynex_lastShowedDate));
}

- (void)setYnex_exposureBlock:(YNExposureBlock)ynex_exposureBlock
{
    objc_setAssociatedObject(self, @selector(ynex_exposureBlock), ynex_exposureBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (YNExposureBlock)ynex_exposureBlock
{
    return objc_getAssociatedObject(self, @selector(ynex_exposureBlock));
}

-(void)setYnex_delay:(NSTimeInterval)ynex_delay
{
    objc_setAssociatedObject(self, @selector(ynex_delay), @(ynex_delay), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSTimeInterval)ynex_delay
{
    return [objc_getAssociatedObject(self, @selector(ynex_delay)) doubleValue];
}

- (void)setYnex_minAreaRatio:(CGFloat)ynex_minAreaRatio
{
    objc_setAssociatedObject(self, @selector(ynex_minAreaRatio), @(ynex_minAreaRatio), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)ynex_minAreaRatio
{
    return [objc_getAssociatedObject(self, @selector(ynex_minAreaRatio)) floatValue];
}

@end
