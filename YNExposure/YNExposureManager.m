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
@end

@implementation YNExposureManager{
    dispatch_source_t _timer;
    dispatch_queue_t _queue;
}

MACRO_SINGLETON_PATTERN_M({
    self->_queue = dispatch_queue_create("com.shopee.yanni.YNExposure.timer_queue", NULL);
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
    NSLog(@"%@", [NSThread currentThread]);
}

#pragma mark - Timer

- (void)updateTimerStatusWhenViewsTableChange
{
    NSArray *views = [self.ynExposureViewHashTable allObjects];
    if (views.count > 0 && self->_timer == nil) {
        [self startTimer];
    } else if(views.count == 0 && self->_timer != nil){
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
    NSAssert(self->_timer == nil, @"self->_timer must be nil when call startTimer");
    if (self->_timer) {
        return;
    }
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self->_queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, self.interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        [self detectExposure];
    });
    dispatch_resume(timer);
    
    self->_timer = timer;
}

- (void)stopTimer
{
    if (self->_timer) {
        dispatch_source_cancel(self->_timer);
        self->_timer = nil;
    }
}

@end
