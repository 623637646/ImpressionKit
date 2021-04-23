//
//  UIView+ExposureKitExamplePrivate.h
//  ExposureKitExample
//
//  Created by Wang Ya on 12/11/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ExposureKitExamplePrivate)
@property (nonatomic, assign) BOOL ek_isExposed;
@property (nonatomic, copy, nullable) NSDate *ek_startAppearanceDate;
@property (nonatomic, assign) NSTimeInterval ek_minDurationInWindow;
@end
