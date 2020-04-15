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

@interface SHPExposureManager ()
@property (nonatomic, strong) NSHashTable<UIView *> *exposureViewHashTable;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation SHPExposureManager

MACRO_SINGLETON_PATTERN_M({
                          self.queue = dispatch_get_main_queue();
                          self.exposureViewHashTable = [NSHashTable<UIView *> weakObjectsHashTable];
                          
                          __weak typeof(self) wself = self;
                          [[SHPExposureNotificationCenter sharedInstance] addObserverForName:SHPExposureConfigNotificationIntervalChanged object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
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
    view.shpex_startAppearanceDate = nil;
    view.shpex_startDisappearanceDate = nil;
    if ([self.exposureViewHashTable containsObject:view]) {
        return;
    }
    [self.exposureViewHashTable addObject:view];
    [self updateTimerStatusWhenViewsTableChange];
}

- (void)removeView:(UIView *)view
{
    if (view == nil) {
        return;
    }
    view.shpex_startAppearanceDate = nil;
    view.shpex_startDisappearanceDate = nil;
    if (![self.exposureViewHashTable containsObject:view]) {
        return;
    }
    [self.exposureViewHashTable removeObject:view];
    [self updateTimerStatusWhenViewsTableChange];
}

#pragma mark - Private

- (void)detectExposure
{
    NSDate *now = [NSDate date];
    NSArray *views = self.exposureViewHashTable.allObjects;
    
    // log
    if (SHPLoggingEnabled) {
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
        if (view.shpex_isExposed && !view.shpex_retriggerWhenLeftScreen) {
            // has been exposured and don't need to tetrigger when left screen
            [self.exposureViewHashTable removeObject:view];
            continue;
        }
        
        CGFloat ratioOnScreen = [view shpex_areaRatioOnScreen];
        if (view.shpex_startAppearanceDate) {
            if (ratioOnScreen <= 0) {
                // from appearance to disappearance
                view.shpex_startAppearanceDate = nil;
                view.shpex_startDisappearanceDate = now;
                view.shpex_isExposed = NO;
            } else if (ratioOnScreen < view.shpex_minAreaRatioInWindow) {
                // from appearance to partial appearance
                view.shpex_startAppearanceDate = nil;
            } else {
                // keep appearance
                [self triggerExposureIfNeed:view now:now ratioOnScreen:ratioOnScreen];
            }
        } else if (view.shpex_startDisappearanceDate){
            if (ratioOnScreen <= 0) {
                // keep disappearance
            } else if (ratioOnScreen < view.shpex_minAreaRatioInWindow) {
                // from disappearance to partial appearance
                view.shpex_startDisappearanceDate = nil;
            } else {
                // from disappearance to appearance
                view.shpex_startAppearanceDate = now;
                view.shpex_startDisappearanceDate = nil;
            }
        } else {
            if (ratioOnScreen <= 0) {
                // from partial appearance to disappearance
                view.shpex_startDisappearanceDate = now;
                view.shpex_isExposed = NO;
            } else if (ratioOnScreen < view.shpex_minAreaRatioInWindow) {
                // keep partial appearance
            } else {
                // from partial appearance to appearance
                view.shpex_startAppearanceDate = now;
            }
        }
    }
}

- (void)triggerExposureIfNeed:(UIView *)view now:(NSDate *)now ratioOnScreen:(CGFloat)ratioOnScreen
{
    if (!view || !now || ratioOnScreen <= 0 || ratioOnScreen > 1) {
        NSParameterAssert(NO);
        return;
    }
    if (view.shpex_isExposed) {
        return;
    }
    NSDate *lastShowDate = view.shpex_startAppearanceDate;
    NSAssert(lastShowDate, @"lastShowDate is nil");
    if (!lastShowDate) {
        return;
    }
    NSTimeInterval interval = [now timeIntervalSinceDate:lastShowDate];
    if (interval < view.shpex_minDurationInWindow) {
        // not enough for exposuree
        return;
    }
    // exposuree
    view.shpex_isExposed = YES;
    view.shpex_exposureBlock(ratioOnScreen);
    if (!view.shpex_retriggerWhenLeftScreen) {
        [self.exposureViewHashTable removeObject:view];
    }
}

#pragma mark - Timer

- (void)updateTimerStatusWhenViewsTableChange
{
    NSArray *views = [self.exposureViewHashTable allObjects];
    if (views.count > 0 && self.timer == nil) {
        [self startTimer];
    } else if (views.count == 0 && self.timer != nil) {
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
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, [SHPExposureConfig sharedInstance].interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) wself= self;
    dispatch_source_set_event_handler(timer, ^{
        __strong typeof(self) self = wself;
        [self detectExposure];
    });
    dispatch_resume(timer);
    
    self.timer = timer;
    SHPLog(@"SHPExposureManager startTimer");
}

- (void)stopTimer
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        SHPLog(@"SHPExposureManager stopTimer");
    }
}

@end
