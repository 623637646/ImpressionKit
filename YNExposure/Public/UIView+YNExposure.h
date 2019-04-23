//
//  UIView+YNExposure.h
//  YNExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const YNExposureErrorDomain;

typedef NS_ENUM(NSUInteger, YNExposureErrorCode) {
    YNExposureErrorCodeParameterInvaild,
};


typedef void(^YNExposureBlock)(CGFloat areaRatio);

@interface UIView (YNExposure)

@property (nonatomic, assign, readonly) BOOL ynex_isExposured;

// block should not be nil, delay should >= 0, minAreaRatio should > 0 and <=1
- (BOOL)ynex_execute:(YNExposureBlock)block delay:(NSTimeInterval)delay minAreaRatio:(CGFloat)minAreaRatio error:(NSError**)error;

// reset
- (void)ynex_resetExecute;

// cancel
- (void)ynex_cancelExecute;

#pragma mark - Helper

// is showed on screen
- (BOOL)ynex_isShowingOnScreen;

// get ratio on screen
- (CGFloat)ynex_ratioOnScreen;

@end

NS_ASSUME_NONNULL_END
