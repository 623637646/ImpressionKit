//
//  UIView+YNExposurePrivate.h
//  YNExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+YNExposure.h"
#import <Aspects/Aspects.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (YNExposurePrivate)

@property (nonatomic, assign) BOOL ynex_isExposured;
@property (nonatomic, copy, nullable) NSDate *ynex_lastShowedDate;

@property (nonatomic, copy, nullable) YNExposureBlock ynex_exposureBlock;
@property (nonatomic, assign) NSTimeInterval ynex_delay;
@property (nonatomic, assign) CGFloat ynex_minAreaRatio;
@property (atomic, strong, nullable) id<AspectToken> ynex_token;

@end

NS_ASSUME_NONNULL_END
