//
//  UIView+ExposureKitPrivate.m
//  ExposureKit
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "UIView+ExposureKitPrivate.h"
#import <objc/runtime.h>

@implementation UIView (ExposureKitPrivate)

- (void)setEk_isExposed:(BOOL)ek_isExposed
{
    objc_setAssociatedObject(self, @selector(ek_isExposed), @(ek_isExposed), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)ek_isExposed
{
    return [objc_getAssociatedObject(self, @selector(ek_isExposed)) boolValue];
}

- (void)setEk_startAppearanceDate:(NSDate *)ek_startAppearanceDate
{
    objc_setAssociatedObject(self, @selector(ek_startAppearanceDate), ek_startAppearanceDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDate *)ek_startAppearanceDate
{
    return objc_getAssociatedObject(self, @selector(ek_startAppearanceDate));
}

- (void)setEk_startDisappearanceDate:(NSDate *)ek_startDisappearanceDate
{
    objc_setAssociatedObject(self, @selector(ek_startDisappearanceDate), ek_startDisappearanceDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSDate *)ek_startDisappearanceDate
{
    return objc_getAssociatedObject(self, @selector(ek_startDisappearanceDate));
}

- (void)setEk_exposureBlock:(ExposureKitBlock)ek_exposureBlock
{
    objc_setAssociatedObject(self, @selector(ek_exposureBlock), ek_exposureBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (ExposureKitBlock)ek_exposureBlock
{
    return objc_getAssociatedObject(self, @selector(ek_exposureBlock));
}

- (void)setEk_minDurationInWindow:(NSTimeInterval)ek_minDurationInWindow
{
    objc_setAssociatedObject(self, @selector(ek_minDurationInWindow), @(ek_minDurationInWindow), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSTimeInterval)ek_minDurationInWindow
{
    return [objc_getAssociatedObject(self, @selector(ek_minDurationInWindow)) doubleValue];
}

- (void)setEk_minAreaRatioInWindow:(CGFloat)ek_minAreaRatioInWindow
{
    objc_setAssociatedObject(self, @selector(ek_minAreaRatioInWindow), @(ek_minAreaRatioInWindow), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)ek_minAreaRatioInWindow
{
    return [objc_getAssociatedObject(self, @selector(ek_minAreaRatioInWindow)) floatValue];
}

- (void)setEk_retriggerWhenLeftScreen:(BOOL)ek_retriggerWhenLeftScreen
{
    objc_setAssociatedObject(self, @selector(ek_retriggerWhenLeftScreen), @(ek_retriggerWhenLeftScreen), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)ek_retriggerWhenLeftScreen
{
    return [objc_getAssociatedObject(self, @selector(ek_retriggerWhenLeftScreen)) boolValue];
}

- (void)setEk_retriggerWhenRemovedFromWindow:(BOOL)ek_retriggerWhenRemovedFromWindow
{
    objc_setAssociatedObject(self, @selector(ek_retriggerWhenRemovedFromWindow), @(ek_retriggerWhenRemovedFromWindow), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)ek_retriggerWhenRemovedFromWindow
{
    return [objc_getAssociatedObject(self, @selector(ek_retriggerWhenRemovedFromWindow)) boolValue];
}

- (void)setEk_token:(OCToken *)ek_token
{
    objc_setAssociatedObject(self, @selector(ek_token), ek_token, OBJC_ASSOCIATION_RETAIN);
}

- (OCToken *)ek_token
{
    return objc_getAssociatedObject(self, @selector(ek_token));
}

@end
