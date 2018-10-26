//
//  UIView+YNExposure.h
//  YNExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YNExposureBlock)(CGFloat areaRatio);

@interface UIView (YNExposure)

@property (nonatomic, assign, readonly) BOOL ynex_isExposured;

- (void)ynex_execute:(YNExposureBlock)block delay:(NSTimeInterval)delay minAreaRatio:(CGFloat)minAreaRatio;

- (void)ynex_resetExecute;

@end
