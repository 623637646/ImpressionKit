//
//  SHPExposureMacro.h
//  SHPExposure
//
//  Created by Wang Ya on 26/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#ifndef SHPExposureMacro_h
#define SHPExposureMacro_h


// log
#define SHPLog(...) do {\
if ([SHPExposureConfig sharedInstance].loggingEnabled) {\
NSLog(__VA_ARGS__);\
}\
}while(0)


#endif /* SHPExposureMacro_h */
