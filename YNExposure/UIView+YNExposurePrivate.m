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
