//
//  ExposureKitConfig.m
//  ExposureKit
//
//  Created by Wang Ya on 31/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "ExposureKitConfig.h"

NSString *const ExposureKitConfigNotificationIntervalChanged = @"ExposureKitConfigNotificationIntervalChanged";

@implementation ExposureKitConfig

MACRO_SINGLETON_PATTERN_M({
    self->_interval = 0.2;
})

- (void)setInterval:(NSTimeInterval)interval
{
    if (interval == _interval) {
        return;
    }
    _interval = interval;
    [[NSNotificationCenter defaultCenter] postNotificationName:ExposureKitConfigNotificationIntervalChanged object:@(_interval)];
}

@end
