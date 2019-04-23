//
//  SHPExposureConfig.h
//  SHPExposure
//
//  Created by Wang Ya on 31/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHPExposureMacro.h"
#import <SHPUtilityKit/SHPUtilityKit.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const SHPExposureConfigNotificationIntervalChanged;

@interface SHPExposureConfig : NSObject
SHP_MACRO_SINGLETON_H

// The detect interval, default is 0.2s
@property (nonatomic, assign) NSTimeInterval interval;

// print log
@property (nonatomic, assign) BOOL loggingEnabled;

@end

NS_ASSUME_NONNULL_END
