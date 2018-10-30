//
//  YNEeposureTestingView.m
//  YNExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNEeposureTestingView.h"
#import <YNExposure/YNExposure.h>

@interface UIView(YNEeposureTestingViewPrivate)
@property (nonatomic, copy) NSDate *ynex_lastShowedDate;
@property (nonatomic, assign) NSTimeInterval ynex_delay;
@end

@implementation UIView(YNEeposureTestingViewPrivate)
@dynamic ynex_lastShowedDate;
@dynamic ynex_delay;
@end

static void *YNEeposureTestingViewContext = &YNEeposureTestingViewContext;

@interface YNEeposureTestingView()
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNEeposureTestingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        __weak typeof(self) wself = self;
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
