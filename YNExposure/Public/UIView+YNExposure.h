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
    YNExposureErrorCodeAlreadySignup,
} YNExposureErrorCode;


typedef void(^YNExposureBlock)(CGFloat areaRatio);

@interface UIView (YNExposure)

@property (nonatomic, assign, readonly) BOOL ynex_isExposured;

// The detect interval, default is 0.5s
@property (nonatomic, assign) NSTimeInterval ynex_interval;

// block should not be nil, delay should >= 0, minAreaRatio should > 0 and <=1
- (BOOL)ynex_execute:(YNExposureBlock)block delay:(NSTimeInterval)delay minAreaRatio:(CGFloat)minAreaRatio error:(NSError**)error;

// reset
- (void)ynex_resetExecute;

@end
