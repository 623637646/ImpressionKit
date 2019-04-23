//
//  SHPExposureManager.h
//  SHPExposure
//
//  Created by Wang Ya on 26/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHPExposureMacro.h"
#import <SHPUtilityKit/SHPUtilityKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHPExposureManager : NSObject
SHP_MACRO_SINGLETON_H

- (void)addView:(UIView *)view;
- (void)removeView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
