//
//  SHPExposureConfig.h
//  SHPExposure
//
//  Created by Wang Ya on 31/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHPExposureMacro.h"

extern NSString *const SHPExposureConfigNotificationIntervalChanged;

@interface SHPExposureConfig : NSObject
MACRO_SINGLETON_PATTERN_H

// The detect interval, default is 0.2s
@property (nonatomic, assign) NSTimeInterval interval;

// print log
@property (nonatomic, assign) BOOL log;

@end
