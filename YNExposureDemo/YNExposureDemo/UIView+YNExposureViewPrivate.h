//
//  UIView+YNExposureViewPrivate.h
//  YNExposureDemo
//
//  Created by Wang Ya on 12/11/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (YNExposureViewPrivate)
@property (nonatomic, assign) BOOL ynex_isExposured;
@property (nonatomic, copy) NSDate *ynex_lastShowedDate;
@property (nonatomic, assign) NSTimeInterval ynex_delay;
@end
