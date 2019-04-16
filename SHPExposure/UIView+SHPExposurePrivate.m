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

- (void)setShpex_isExposured:(BOOL)shpex_isExposured
{
    objc_setAssociatedObject(self, @selector(shpex_isExposured), @(shpex_isExposured), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (BOOL)shpex_isExposured
{
    return [objc_getAssociatedObject(self, @selector(shpex_isExposured)) boolValue];
}

-(void)setShpex_lastShowedDate:(NSDate *)shpex_lastShowedDate
{
    objc_setAssociatedObject(self, @selector(shpex_lastShowedDate), shpex_lastShowedDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSDate *)shpex_lastShowedDate
{
    return objc_getAssociatedObject(self, @selector(shpex_lastShowedDate));
}

- (void)setShpex_exposureBlock:(SHPExposureBlock)shpex_exposureBlock
{
    objc_setAssociatedObject(self, @selector(shpex_exposureBlock), shpex_exposureBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (SHPExposureBlock)shpex_exposureBlock
{
    return objc_getAssociatedObject(self, @selector(shpex_exposureBlock));
}

-(void)setShpex_delay:(NSTimeInterval)shpex_delay
{
    objc_setAssociatedObject(self, @selector(shpex_delay), @(shpex_delay), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSTimeInterval)shpex_delay
{
    return [objc_getAssociatedObject(self, @selector(shpex_delay)) doubleValue];
}

- (void)setShpex_minAreaRatio:(CGFloat)shpex_minAreaRatio
{
    objc_setAssociatedObject(self, @selector(shpex_minAreaRatio), @(shpex_minAreaRatio), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGFloat)shpex_minAreaRatio
{
    return [objc_getAssociatedObject(self, @selector(shpex_minAreaRatio)) floatValue];
}

-(void)setShpex_token:(id<AspectToken>)shpex_token
{
    objc_setAssociatedObject(self, @selector(shpex_token), shpex_token, OBJC_ASSOCIATION_RETAIN);
}

-(id<AspectToken>)shpex_token
{
    return objc_getAssociatedObject(self, @selector(shpex_token));

}

@end
