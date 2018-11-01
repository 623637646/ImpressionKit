//
//  YNExposureMacro.h
//  YNExposure
//
//  Created by Wang Ya on 26/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#ifndef YNExposureMacro_h
#define YNExposureMacro_h

// Singleton pattern
#define MACRO_SINGLETON_PATTERN_H \
+ (instancetype)sharedInstance;\
- (instancetype)init NS_UNAVAILABLE;\
+ (instancetype)new NS_UNAVAILABLE;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone NS_UNAVAILABLE;\
- (id)copy NS_UNAVAILABLE;\
- (id)mutableCopy NS_UNAVAILABLE;\
+ (id)copyWithZone:(struct _NSZone *)zone NS_UNAVAILABLE;\
+ (id)mutableCopyWithZone:(struct _NSZone *)zone NS_UNAVAILABLE;\

#define MACRO_SINGLETON_PATTERN_M(MACRO_SINGLETON_PATTERN_INTT)\
static id _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+ (instancetype)sharedInstance\
{\
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
}\
- (id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
\
- (id)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
- (instancetype)init\
{\
self = [super init];\
if (self) {\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
MACRO_SINGLETON_PATTERN_INTT\
});\
}\
return self;\
}

// log
#define YNLog(...) do {\
if ([YNExposureConfig sharedInstance].log) {\
NSLog(__VA_ARGS__);\
}\
}while(0)



#endif /* YNExposureMacro_h */
