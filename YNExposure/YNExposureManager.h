//
//  YNExposureManager.h
//  YNExposure
//
//  Created by Wang Ya on 26/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YNExposureMacro.h"

@interface YNExposureManager : NSObject
MACRO_SINGLETON_PATTERN_H

@property (nonatomic, assign) NSTimeInterval interval;

- (void)addView:(UIView *)view;
- (void)removeView:(UIView *)view;

@end
