//
//  UIView+SHPExposure.h
//  SHPExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const SHPExposureErrorDomain;

typedef NS_ENUM(NSUInteger, SHPExposureErrorCode) {
    SHPExposureErrorCodeParameterInvaild,
};


typedef void(^SHPExposureBlock)(CGFloat areaRatio);

@interface UIView (SHPExposure)

@property (nonatomic, assign, readonly) BOOL shpex_isExposed;

#pragma mark - schedule

// block should not be nil, delay should >= 0, minAreaRatio should > 0 and <=1
- (BOOL)shpex_scheduleExposure:(SHPExposureBlock)block
           minDurationInWindow:(NSTimeInterval)minDurationInWindow
          minAreaRatioInWindow:(CGFloat)minAreaRatioInWindow
                         error:(NSError **)error;

- (BOOL)shpex_scheduleExposure:(SHPExposureBlock)block
           minDurationInWindow:(NSTimeInterval)minDurationInWindow
          minAreaRatioInWindow:(CGFloat)minAreaRatioInWindow
       retriggerWhenLeftScreen:(BOOL)retriggerWhenLeftScreen
retriggerWhenRemovedFromWindow:(BOOL)retriggerWhenRemovedFromWindow
                         error:(NSError **)error;

#pragma mark - reset
// reset
- (void)shpex_resetSchedule;

#pragma mark - cancel
// cancel
- (void)shpex_cancelSchedule;

#pragma mark - Helper

// get ratio on screen
- (CGFloat)shpex_areaRatioOnScreen;

@end

NS_ASSUME_NONNULL_END
