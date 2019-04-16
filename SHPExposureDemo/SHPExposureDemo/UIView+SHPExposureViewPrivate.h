//
//  UIView+SHPExposureViewPrivate.h
//  SHPExposureDemo
//
//  Created by Wang Ya on 12/11/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SHPExposureViewPrivate)
@property (nonatomic, assign) BOOL shpex_isExposured;
@property (nonatomic, copy) NSDate *shpex_lastShowedDate;
@property (nonatomic, assign) NSTimeInterval shpex_delay;
@end
