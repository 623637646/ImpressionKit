//
//  ExposureKitManager.m
//  ExposureKit
//
//  Created by Wang Ya on 26/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "ExposureKitManager.h"
#import "UIView+ExposureKitPrivate.h"
#import "ExposureKitConfig.h"

@interface ExposureKitManager ()
@property (nonatomic, strong) NSHashTable<UIView *> *exposureViewHashTable;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) dispatch_queue_t queue;
@end

@implementation ExposureKitManager

MACRO_SINGLETON_PATTERN_M({
                          self.queue = dispatch_get_main_queue();
                          self.exposureViewHashTable = [NSHashTable<UIView *> weakObjectsHashTable];
                          
                          __weak typeof(self) wself = self;
                          [[NSNotificationCenter defaultCenter] addObserverForName:ExposureKitConfigNotificationIntervalChanged object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
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
    view.ek_startAppearanceDate = nil;
    view.ek_startDisappearanceDate = nil;
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
    view.ek_startAppearanceDate = nil;
    view.ek_startDisappearanceDate = nil;
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
    if (EKLoggingEnabled) {
        static NSInteger indexForLog = 0;
        if (indexForLog == (NSInteger)(1 / [ExposureKitConfig sharedInstance].interval)) {
            EKLog(@"ExposureKitManager has %@ views", @(views.count));
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
        if (view.ek_isExposed && !view.ek_retriggerWhenLeftScreen) {
            // has been exposured and don't need to tetrigger when left screen
            [self.exposureViewHashTable removeObject:view];
            continue;
        }
        
        CGFloat ratioOnScreen = [view ek_areaRatioOnScreen];
        if (view.ek_startAppearanceDate) {
            if (ratioOnScreen <= 0) {
                // from appearance to disappearance
                view.ek_startAppearanceDate = nil;
                view.ek_startDisappearanceDate = now;
                view.ek_isExposed = NO;
            } else if (ratioOnScreen < view.ek_minAreaRatioInWindow) {
                // from appearance to partial appearance
                view.ek_startAppearanceDate = nil;
            } else {
                // keep appearance
                [self triggerExposureIfNeed:view now:now ratioOnScreen:ratioOnScreen];
            }
        } else if (view.ek_startDisappearanceDate){
            if (ratioOnScreen <= 0) {
                // keep disappearance
            } else if (ratioOnScreen < view.ek_minAreaRatioInWindow) {
                // from disappearance to partial appearance
                view.ek_startDisappearanceDate = nil;
            } else {
                // from disappearance to appearance
                view.ek_startAppearanceDate = now;
                view.ek_startDisappearanceDate = nil;
            }
        } else {
            if (ratioOnScreen <= 0) {
                // from partial appearance to disappearance
                view.ek_startDisappearanceDate = now;
                view.ek_isExposed = NO;
            } else if (ratioOnScreen < view.ek_minAreaRatioInWindow) {
                // keep partial appearance
            } else {
                // from partial appearance to appearance
                view.ek_startAppearanceDate = now;
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
    if (view.ek_isExposed) {
        return;
    }
    NSDate *lastShowDate = view.ek_startAppearanceDate;
    NSAssert(lastShowDate, @"lastShowDate is nil");
    if (!lastShowDate) {
        return;
    }
    NSTimeInterval interval = [now timeIntervalSinceDate:lastShowDate];
    if (interval < view.ek_minDurationInWindow) {
        // not enough for exposuree
        return;
    }
    // exposuree
    view.ek_isExposed = YES;
    view.ek_exposureBlock(ratioOnScreen);
    if (!view.ek_retriggerWhenLeftScreen) {
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
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, [ExposureKitConfig sharedInstance].interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) wself= self;
    dispatch_source_set_event_handler(timer, ^{
        __strong typeof(self) self = wself;
        [self detectExposure];
    });
    dispatch_resume(timer);
    
    self.timer = timer;
    EKLog(@"ExposureKitManager startTimer");
}

- (void)stopTimer
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
        EKLog(@"ExposureKitManager stopTimer");
    }
}

@end
