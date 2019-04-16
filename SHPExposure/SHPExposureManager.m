//
//  SHPExposureManager.m
//  SHPExposure
//
//  Created by Wang Ya on 26/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "SHPExposureManager.h"
#import "UIView+SHPExposurePrivate.h"
#import "SHPExposureNotificationCenter.h"
#import "SHPExposureConfig.h"

@interface SHPExposureManager()
@property (nonatomic, strong) NSHashTable<UIView *> *shpExposureViewHashTable;
@end

@implementation SHPExposureManager{
    dispatch_source_t _timer;
    dispatch_queue_t _queue;
}

MACRO_SINGLETON_PATTERN_M({
//    self->_queue = dispatch_queue_create("com.shopee.yanni.SHPExposure.timer_queue", NULL);
    self->_queue = dispatch_get_main_queue();
    self.shpExposureViewHashTable = [NSHashTable<UIView *> weakObjectsHashTable];
    
    __weak typeof(self) wself = self;
    [[SHPExposureNotificationCenter sharedInstance] addObserverForName:SHPExposureConfigNotificationIntervalChanged object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(self) self = wself;
        [self resetUpTimer];
    }];
})

-(void)dealloc
{
    if (self->_timer) {
        dispatch_source_cancel(self->_timer);
        self->_timer = nil;
    }
}

#pragma mark - Public

- (void)addView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    if ([self.shpExposureViewHashTable containsObject:view]) {
        return;
    }
    NSAssert(view.shpex_lastShowedDate == nil, @"view.shpex_lastShowedDate should be nil");
    [self.shpExposureViewHashTable addObject:view];
    [self updateTimerStatusWhenViewsTableChange];
}

- (void)removeView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    if (![self.shpExposureViewHashTable containsObject:view]) {
        return;
    }
    view.shpex_lastShowedDate = nil;
    [self.shpExposureViewHashTable removeObject:view];
    [self updateTimerStatusWhenViewsTableChange];
}

#pragma mark - Private

- (void)detectExposure
{
    NSDate *now = [NSDate date];
    NSArray *views = self.shpExposureViewHashTable.allObjects;
    
    // log
    if ([SHPExposureConfig sharedInstance].log) {
        static NSInteger indexForLog = 0;
        if (indexForLog == (NSInteger)(1 / [SHPExposureConfig sharedInstance].interval)) {
            SHPLog(@"SHPExposureManager has %@ views", @(views.count));
            indexForLog = 0;
        } else {
            indexForLog ++;
        }
    }
    
    if (views.count == 0) {
        [self stopTimer];
        return;
    }
    
    for (UIView *view in views) {
        if (view.shpex_isExposured) {
            // has been exposured
            [self.shpExposureViewHashTable removeObject:view];
            continue;
        }
        
        CGFloat ratioOnScreen = [view shpex_ratioOnScreen];
        if (ratioOnScreen < view.shpex_minAreaRatio) {
            // this view is gone
            view.shpex_lastShowedDate = nil;
            continue;
        }
        
        if (view.shpex_lastShowedDate == nil) {
            // first detected
            view.shpex_lastShowedDate = now;
        }
        NSDate *lastShowDate = view.shpex_lastShowedDate;
        NSTimeInterval interval = [now timeIntervalSinceDate:lastShowDate];
        if (interval < view.shpex_delay) {
            // not enough for exposuree
            continue;
        }
        // exposuree
        view.shpex_lastShowedDate = nil;
        view.shpex_isExposured = YES;
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            view.shpex_exposureBlock(ratioOnScreen);
//        });
        view.shpex_exposureBlock(ratioOnScreen);
        [self.shpExposureViewHashTable removeObject:view];
    }
}

#pragma mark - Timer

- (void)updateTimerStatusWhenViewsTableChange
{
    NSArray *views = [self.shpExposureViewHashTable allObjects];
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
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, [SHPExposureConfig sharedInstance].interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) wself= self;
    dispatch_source_set_event_handler(timer, ^{
        __strong typeof(self) self = wself;
        [self detectExposure];
    });
    dispatch_resume(timer);
    
    self->_timer = timer;
    SHPLog(@"SHPExposureManager startTimer");
}

- (void)stopTimer
{
    if (self->_timer) {
        dispatch_source_cancel(self->_timer);
        self->_timer = nil;
        SHPLog(@"SHPExposureManager stopTimer");
    }
}

@end
