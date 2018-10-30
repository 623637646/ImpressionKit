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
@property (nonatomic, copy) NSDate *ynex_lastShowedDate;
@property (nonatomic, assign) NSTimeInterval ynex_delay;
@end

@implementation UIView(YNExposureDemoTestingViewPrivate)
@dynamic ynex_lastShowedDate;
@dynamic ynex_delay;
@end

static void *YNExposureDemoTestingViewContext = &YNExposureDemoTestingViewContext;

@interface YNExposureDemoTestingView()
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNExposureDemoTestingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) wself = self;
        // TODO: 消除Demo的性能影响（主要是这里，刷新UI的Timer）
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 repeats:YES block:^(NSTimer * _Nonnull timer) {
            __strong typeof(self) self = wself;
            [self updateUI];
        }];

        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)updateUI
{
    if (self.ynex_isExposured) {
        self.backgroundColor = [UIColor greenColor];
        self.label.text = nil;
    } else {
        self.backgroundColor = [UIColor lightGrayColor];
        if (self.ynex_lastShowedDate == nil) {
            self.label.text = nil;
        } else {
            NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:self.ynex_lastShowedDate];
            self.label.text = [NSString stringWithFormat:@"%.1f", self.ynex_delay - interval];
        }
    }
}

@end
