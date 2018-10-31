//
//  YNExposureConfig.m
//  YNExposure
//
//  Created by Wang Ya on 31/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureConfig.h"
#import "YNExposureNotificationCenter.h"

NSString *const YNExposureConfigNotificationIntervalChanged = @"YNExposureConfigNotificationIntervalChanged";

@implementation YNExposureConfig

MACRO_SINGLETON_PATTERN_M({
    self->_interval = 0.2;
})

- (void)setInterval:(NSTimeInterval)interval
{
    if (interval == _interval) {
        return;
    }
    _interval = interval;
    [[YNExposureNotificationCenter sharedInstance] postNotificationName:YNExposureConfigNotificationIntervalChanged object:@(_interval)];
}

@end
