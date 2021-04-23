//
//  UIView+ExposureKit.h
//  ExposureKit
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const ExposureKitErrorDomain;

typedef NS_ENUM(NSUInteger, ExposureKitErrorCode) {
    ExposureKitErrorCodeParameterInvaild,
};


typedef void(^ExposureKitBlock)(CGFloat areaRatio);

@interface UIView (ExposureKit)

@property (nonatomic, assign, readonly) BOOL ek_isExposed;

#pragma mark - schedule

// block should not be nil, delay should >= 0, minAreaRatio should > 0 and <=1
- (BOOL)ek_scheduleExposure:(ExposureKitBlock)block
           minDurationInWindow:(NSTimeInterval)minDurationInWindow
          minAreaRatioInWindow:(CGFloat)minAreaRatioInWindow
                         error:(NSError **)error;

- (BOOL)ek_scheduleExposure:(ExposureKitBlock)block
           minDurationInWindow:(NSTimeInterval)minDurationInWindow
          minAreaRatioInWindow:(CGFloat)minAreaRatioInWindow
       retriggerWhenLeftScreen:(BOOL)retriggerWhenLeftScreen
retriggerWhenRemovedFromWindow:(BOOL)retriggerWhenRemovedFromWindow
                         error:(NSError **)error;

#pragma mark - reset
// reset
- (void)ek_resetSchedule;

#pragma mark - cancel
// cancel
- (void)ek_cancelSchedule;

#pragma mark - Helper

// get ratio on screen
- (CGFloat)ek_areaRatioOnScreen;

@end

NS_ASSUME_NONNULL_END
