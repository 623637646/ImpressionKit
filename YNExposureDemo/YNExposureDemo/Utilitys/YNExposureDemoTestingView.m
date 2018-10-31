//
//  YNExposureDemoTestingView.m
//  YNExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureDemoTestingView.h"
#import <YNExposure/YNExposure.h>

@interface UIView(YNExposureDemoTestingViewPrivate)
@property (nonatomic, assign) BOOL ynex_isExposured;
@end

@implementation UIView(YNExposureDemoTestingViewPrivate)
@dynamic ynex_isExposured;
@end

static void *YNExposureDemoTestingViewContext = &YNExposureDemoTestingViewContext;

@interface YNExposureDemoTestingView()
@end

@implementation YNExposureDemoTestingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        NSError *error = nil;
        [self ynex_execute:^(CGFloat areaRatio) {
            
        } delay:1 minAreaRatio:1 error:&error];
        NSAssert(error == nil, @"error is not nil");
    }
    return self;
}

- (void)reset
{
    [self ynex_resetExecute];
}

-(void)setYnex_isExposured:(BOOL)ynex_isExposured
{
    [super setYnex_isExposured:ynex_isExposured];
    if (self.ynex_isExposured) {
        self.backgroundColor = [UIColor greenColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
