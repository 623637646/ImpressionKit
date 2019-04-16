//
//  SHPDemoNonReusedView.m
//  SHPExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "SHPDemoNonReusedView.h"
#import <SHPExposure/SHPExposure.h>
#import "UIView+SHPExposureViewPrivate.h"

@interface SHPDemoNonReusedView()
@property (nonatomic, weak) UILabel *label;
@end

@implementation SHPDemoNonReusedView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 0.5;
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
        
        NSError *error = nil;
        __weak typeof(self) wself = self;
        [self shpex_execute:^(CGFloat areaRatio) {
            __strong typeof(self) self = wself;
            self.label.text = [NSString stringWithFormat:@"%0.1f%%", areaRatio * 100];
        } delay:2 minAreaRatio:0.5 error:&error];
        NSAssert(error == nil, @"error is not nil");
    }
    return self;
}

- (void)reset
{
    [self shpex_resetExecute];
    [self.layer removeAllAnimations];
    self.label.text = nil;
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setShpex_lastShowedDate:(NSDate *)shpex_lastShowedDate
{
    [super setShpex_lastShowedDate:shpex_lastShowedDate];
    [self updateBackendColor];
}

- (void)setShpex_isExposured:(BOOL)shpex_isExposured
{
    [super setShpex_isExposured:shpex_isExposured];
    [self updateBackendColor];
}

- (void)updateBackendColor
{
    if (self.shpex_isExposured) {
        self.backgroundColor = [UIColor greenColor];
        return;
    }
    if (self.shpex_lastShowedDate != nil) {
        self.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:self.shpex_delay delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.backgroundColor = [UIColor redColor];
        } completion:nil];
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
}

@end
