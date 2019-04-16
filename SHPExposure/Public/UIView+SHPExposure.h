//
//  UIView+SHPExposure.h
//  SHPExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const SHPExposureErrorDomin;

typedef NS_ENUM(NSUInteger, SHPExposureErrorCode) {
    SHPExposureErrorCodeParameterInvaild,
};


typedef void(^SHPExposureBlock)(CGFloat areaRatio);

@interface UIView (SHPExposure)

@property (nonatomic, assign, readonly) BOOL shpex_isExposured;

// block should not be nil, delay should >= 0, minAreaRatio should > 0 and <=1
- (BOOL)shpex_execute:(SHPExposureBlock)block delay:(NSTimeInterval)delay minAreaRatio:(CGFloat)minAreaRatio error:(NSError**)error;

// reset
- (void)shpex_resetExecute;

// cancel
- (void)shpex_cancelExecute;

#pragma mark - Helper

// is showed on screen
- (BOOL)shpex_showedOnScreen;

// get ratio on screen
- (CGFloat)shpex_ratioOnScreen;

@end
