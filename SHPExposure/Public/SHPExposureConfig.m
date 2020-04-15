//
//  SHPExposureConfig.m
//  SHPExposure
//
//  Created by Wang Ya on 31/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "SHPExposureConfig.h"

NSString *const SHPExposureConfigNotificationIntervalChanged = @"SHPExposureConfigNotificationIntervalChanged";

@implementation SHPExposureConfig

MACRO_SINGLETON_PATTERN_M({
    self->_interval = 0.2;
})

- (void)setInterval:(NSTimeInterval)interval
{
    if (interval == _interval) {
        return;
    }
    _interval = interval;
    [[NSNotificationCenter defaultCenter] postNotificationName:SHPExposureConfigNotificationIntervalChanged object:@(_interval)];
}

@end
