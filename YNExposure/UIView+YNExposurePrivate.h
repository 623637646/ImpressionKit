//
//  UIView+YNExposurePrivate.h
//  YNExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YNExposure.h"

@interface UIView (YNExposurePrivate)

@property (nonatomic, assign) BOOL ynex_isExposured;
@property (nonatomic, copy) YNExposureBlock ynex_exposureBlock;
@property (nonatomic, assign) NSTimeInterval ynex_delay;
@property (nonatomic, assign) CGFloat ynex_minAreaRatio;
@property (nonatomic, copy) NSDate *ynex_lastShowedDate;
@end
