//
//  YNExposureManager.m
//  YNExposure
//
//  Created by Wang Ya on 26/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureManager.h"
#import "UIView+YNExposurePrivate.h"
#import "YNExposureNotificationCenter.h"
#import "YNExposureConfig.h"

@interface YNExposureManager ()
@property (nonatomic, strong) NSHashTable<UIView *> *hashTable;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation YNExposureManager

MACRO_SINGLETON_PATTERN_M({
    self.queue = dispatch_get_main_queue();
    self.hashTable = [NSHashTable<UIView *> weakObjectsHashTable];
    
    __weak typeof(self) wself = self;
    [[YNExposureNotificationCenter sharedInstance] addObserverForName:YNExposureConfigNotificationIntervalChanged object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(self) self = wself;
        [self resetUpTimer];
    }];
})

- (void)dealloc
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
}

#pragma mark - Public

- (void)addView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    if ([self.hashTable containsObject:view]) {
        return;
    }
    NSAssert(view.ynex_lastShowedDate == nil, @"view.ynex_lastShowedDate should be nil");
    [self.hashTable addObject:view];
    [self updateTimerStatusWhenViewsTableChange];
}

- (void)removeView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    if (![self.hashTable containsObject:view]) {
        return;
    }
    view.ynex_lastShowedDate = nil;
    [self.hashTable removeObject:view];
    [self updateTimerStatusWhenViewsTableChange];
}

#pragma mark - Private

- (void)detectExposure
{
    NSDate *now = [NSDate date];
    NSArray *views = self.hashTable.allObjects;
    
    // log
    if ([YNExposureConfig sharedInstance].loggingEnabled) {
        static NSInteger indexForLog = 0;
        if (indexForLog == (NSInteger)(1 / [YNExposureConfig sharedInstance].interval)) {
            YNLog(@"YNExposureManager has %@ views", @(views.count));
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
        if (view.ynex_isExposured) {
            // has been exposured
            [self.hashTable removeObject:view];
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
        view.ynex_exposureBlock(ratioOnScreen);
        [self.hashTable removeObject:view];
    }
}

#pragma mark - Timer

- (void)updateTimerStatusWhenViewsTableChange
{
    NSArray *views = [self.hashTable allObjects];
    if (views.count > 0 && self.timer == nil) {
        [self startTimer];
    } else if (views.count == 0 && self.timer != nil){
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
    
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, self.queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, [YNExposureConfig sharedInstance].interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) wself= self;
    dispatch_source_set_event_handler(timer, ^{
        __strong typeof(self) self = wself;
        [self detectExposure];
    });
    dispatch_resume(timer);
    
    self.timer = timer;
    YNLog(@"YNExposureManager startTimer");
}

- (void)stopTimer
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        YNLog(@"YNExposureManager stopTimer");
    }
}

@end
