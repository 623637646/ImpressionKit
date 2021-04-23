//
//  UIView+ExposureKitPrivate.h
//  ExposureKit
//
//  Created by Wang Ya on 24/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+ExposureKit.h"
@import EasySwiftHook;

NS_ASSUME_NONNULL_BEGIN

@interface UIView (ExposureKitPrivate)

@property (nonatomic, assign) BOOL ek_isExposed;
@property (nonatomic, copy, nullable) NSDate *ek_startAppearanceDate;
@property (nonatomic, copy, nullable) NSDate *ek_startDisappearanceDate;

@property (nonatomic, copy, nullable) ExposureKitBlock ek_exposureBlock;
@property (nonatomic, assign) NSTimeInterval ek_minDurationInWindow;
@property (nonatomic, assign) CGFloat ek_minAreaRatioInWindow;
@property (nonatomic, assign) BOOL ek_retriggerWhenLeftScreen;
@property (nonatomic, assign) BOOL ek_retriggerWhenRemovedFromWindow;
@property (atomic, strong, nullable) OCToken *ek_token;

@end

NS_ASSUME_NONNULL_END
