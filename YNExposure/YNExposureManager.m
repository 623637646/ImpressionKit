//
//  YNExposureManager.m
//  YNExposure
//
//  Created by Wang Ya on 26/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureManager.h"

@interface YNExposureManager()
@property (nonatomic, strong) NSHashTable<UIView *> *ynExposureViewHashTable;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation YNExposureManager

MACRO_SINGLETON_PATTERN_M({
    self.ynExposureViewHashTable = [NSHashTable<UIView *> weakObjectsHashTable];
    self.interval = 0.5;
})

#pragma setter getter
-(void)setInterval:(NSTimeInterval)interval
{
    if (interval == _interval) {
        return;
    }
    _interval = interval;
    [self resetUpTimer];
}

#pragma mark - Public

- (void)addView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    [self.ynExposureViewHashTable addObject:view];
    [self updateTimerStatusWhenViewsTableChange];
}

- (void)removeView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    [self.ynExposureViewHashTable removeObject:view];
    [self updateTimerStatusWhenViewsTableChange];
}

#pragma mark - Private

- (void)detectExposure
{
    
}

#pragma mark - Timer

- (void)updateTimerStatusWhenViewsTableChange
{
    NSArray *views = [self.ynExposureViewHashTable allObjects];
    if (views.count > 0 && self.timer == nil) {
        [self startTimer];
    } else if(views.count == 0 && self.timer != nil){
        [self stopTimer];
    }
}

- (void)resetUpTimer
{
    [self stopTimer];
    [self startTimer];
}

- (void)startTimer
{
    NSAssert(self.timer == nil, @"self.timer must be nil when call startTimer");
    if (self.timer) {
        return;
    }
    self.timer = [NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(detectExposure) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
}

- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
