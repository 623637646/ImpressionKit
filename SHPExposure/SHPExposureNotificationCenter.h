//
//  SHPExposureNotificationCenter.h
//  SHPExposure
//
//  Created by Wang Ya on 31/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SHPExposureMacro.h"
#import <SHPUtilityKit/SHPUtilityKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHPExposureNotificationCenter : NSNotificationCenter
SHP_MACRO_SINGLETON_H

@property (class, readonly, strong) NSNotificationCenter *defaultCenter NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
