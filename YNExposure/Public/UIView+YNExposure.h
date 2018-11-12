//
//  UIView+YNExposure.h
//  YNExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const YNExposureErrorDomin;

typedef enum : NSUInteger {
    YNExposureErrorCodeParameterInvaild,
} YNExposureErrorCode;


typedef void(^YNExposureBlock)(CGFloat areaRatio);

@interface UIView (YNExposure)

@property (nonatomic, assign, readonly) BOOL ynex_isExposured;

// block should not be nil, delay should >= 0, minAreaRatio should > 0 and <=1
- (BOOL)ynex_execute:(YNExposureBlock)block delay:(NSTimeInterval)delay minAreaRatio:(CGFloat)minAreaRatio error:(NSError**)error;

// reset
- (void)ynex_resetExecute;

#pragma mark - Helper

// is showed on screen
- (BOOL)ynex_showedOnScreen;

// get ratio on screen
- (CGFloat)ynex_ratioOnScreen;

@end
