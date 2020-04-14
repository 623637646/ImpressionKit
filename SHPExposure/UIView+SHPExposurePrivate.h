//
//  UIView+SHPExposurePrivate.h
//  SHPExposure
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+SHPExposure.h"
#import <Aspects/Aspects.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (SHPExposurePrivate)

@property (nonatomic, assign) BOOL shpex_isExposed;
@property (nonatomic, copy, nullable) NSDate *shpex_startAppearanceDate;
@property (nonatomic, copy, nullable) NSDate *shpex_startDisappearanceDate;

@property (nonatomic, copy, nullable) SHPExposureBlock shpex_exposureBlock;
@property (nonatomic, assign) NSTimeInterval shpex_minDurationInWindow;
@property (nonatomic, assign) CGFloat shpex_minAreaRatioInWindow;
@property (nonatomic, assign) BOOL shpex_retriggerWhenLeftScreen;
@property (nonatomic, assign) BOOL shpex_retriggerWhenRemovedFromWindow;
@property (atomic, strong, nullable) id<AspectToken> shpex_token;

@end

NS_ASSUME_NONNULL_END
