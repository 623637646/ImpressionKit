//
//  YNExposureManager.m
//  YNExposure
//
//  Created by Wang Ya on 26/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureManager.h"
#import "UIView+YNExposure.h"
#import "UIView+YNExposurePrivate.h"

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

-(void)dealloc
{
    if (self->_timer) {
        dispatch_source_cancel(self->_timer);
        self->_timer = nil;
    }
}

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
    if ([self.ynExposureViewHashTable containsObject:view]) {
        return;
    }
    NSAssert(view.ynex_lastShowedDate == nil, @"view.ynex_lastShowedDate should be nil");
    [self.ynExposureViewHashTable addObject:view];
    [self updateTimerStatusWhenViewsTableChange];
}

- (void)removeView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    if (![self.ynExposureViewHashTable containsObject:view]) {
        return;
    }
    view.ynex_lastShowedDate = nil;
    [self.ynExposureViewHashTable removeObject:view];
    [self updateTimerStatusWhenViewsTableChange];
}

#pragma mark - Private

- (void)detectExposure
{
    NSDate *now = [NSDate date];
    NSArray *views = self.ynExposureViewHashTable.allObjects;
    for (UIView *view in views) {
        if (view.ynex_isExposured) {
            // has been exposured
            [self.ynExposureViewHashTable removeObject:view];
            continue;
        }
        
        CGFloat ratioOnScreen = [view ynex_ratioOnScreen];
        if (ratioOnScreen < view.ynex_minAreaRatio) {
            // this view is gone
            view.ynex_lastShowedDate = nil;
            continue;
        }
        
        if (view.ynex_lastShowedDate == nil) {
            // first detected
            view.ynex_lastShowedDate = now;
        }
        NSDate *lastShowDate = view.ynex_lastShowedDate;
        NSTimeInterval interval = [now timeIntervalSinceDate:lastShowDate];
        if (interval < view.ynex_delay) {
            // not enough for exposuree
            continue;
        }
        // exposuree
        view.ynex_lastShowedDate = nil;
        view.ynex_isExposured = YES;
        dispatch_sync(dispatch_get_main_queue(), ^{
            view.ynex_exposureBlock(ratioOnScreen);
        });
        [self.ynExposureViewHashTable removeObject:view];
    }
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
    __weak typeof(self) wself= self;
    dispatch_source_set_event_handler(timer, ^{
        __strong typeof(self) self = wself;
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
