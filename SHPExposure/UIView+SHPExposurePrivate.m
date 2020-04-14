//
//  UIView+SHPExposurePrivate.m
//  SHPExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "UIView+SHPExposurePrivate.h"
#import <objc/runtime.h>

@implementation UIView (SHPExposurePrivate)

- (void)setShpex_isExposed:(BOOL)shpex_isExposed
{
    objc_setAssociatedObject(self, @selector(shpex_isExposed), @(shpex_isExposed), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)shpex_isExposed
{
    return [objc_getAssociatedObject(self, @selector(shpex_isExposed)) boolValue];
}

- (void)setShpex_startAppearanceDate:(NSDate *)shpex_startAppearanceDate
{
    objc_setAssociatedObject(self, @selector(shpex_startAppearanceDate), shpex_startAppearanceDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDate *)shpex_startAppearanceDate
{
    return objc_getAssociatedObject(self, @selector(shpex_startAppearanceDate));
}

- (void)setShpex_startDisappearanceDate:(NSDate *)shpex_startDisappearanceDate
{
    objc_setAssociatedObject(self, @selector(shpex_startDisappearanceDate), shpex_startDisappearanceDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDate *)shpex_startDisappearanceDate
{
    return objc_getAssociatedObject(self, @selector(shpex_startDisappearanceDate));
}

- (void)setShpex_exposureBlock:(SHPExposureBlock)shpex_exposureBlock
{
    objc_setAssociatedObject(self, @selector(shpex_exposureBlock), shpex_exposureBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SHPExposureBlock)shpex_exposureBlock
{
    return objc_getAssociatedObject(self, @selector(shpex_exposureBlock));
}

- (void)setShpex_minDurationInWindow:(NSTimeInterval)shpex_minDurationInWindow
{
    objc_setAssociatedObject(self, @selector(shpex_minDurationInWindow), @(shpex_minDurationInWindow), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSTimeInterval)shpex_minDurationInWindow
{
    return [objc_getAssociatedObject(self, @selector(shpex_minDurationInWindow)) doubleValue];
}

- (void)setShpex_minAreaRatioInWindow:(CGFloat)shpex_minAreaRatioInWindow
{
    objc_setAssociatedObject(self, @selector(shpex_minAreaRatioInWindow), @(shpex_minAreaRatioInWindow), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)shpex_minAreaRatioInWindow
{
    return [objc_getAssociatedObject(self, @selector(shpex_minAreaRatioInWindow)) floatValue];
}

- (void)setShpex_retriggerWhenLeftScreen:(BOOL)shpex_retriggerWhenLeftScreen
{
    objc_setAssociatedObject(self, @selector(shpex_retriggerWhenLeftScreen), @(shpex_retriggerWhenLeftScreen), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)shpex_retriggerWhenLeftScreen
{
    return [objc_getAssociatedObject(self, @selector(shpex_retriggerWhenLeftScreen)) boolValue];
}

- (void)setShpex_retriggerWhenRemovedFromWindow:(BOOL)shpex_retriggerWhenRemovedFromWindow
{
    objc_setAssociatedObject(self, @selector(shpex_retriggerWhenRemovedFromWindow), @(shpex_retriggerWhenRemovedFromWindow), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)shpex_retriggerWhenRemovedFromWindow
{
    return [objc_getAssociatedObject(self, @selector(shpex_retriggerWhenRemovedFromWindow)) boolValue];
}

- (void)setShpex_token:(id<AspectToken>)shpex_token
{
    objc_setAssociatedObject(self, @selector(shpex_token), shpex_token, OBJC_ASSOCIATION_RETAIN);
}

- (id<AspectToken>)shpex_token
{
    return objc_getAssociatedObject(self, @selector(shpex_token));
}

@end
