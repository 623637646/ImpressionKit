//
//  YNEeposureTestingView.m
//  YNExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNEeposureTestingView.h"
#import <YNExposure/YNExposure.h>

static void *YNEeposureTestingViewContext = &YNEeposureTestingViewContext;

@interface YNEeposureTestingView()

@end

@implementation YNEeposureTestingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"ynex_isExposured" options:NSKeyValueObservingOptionNew context:YNEeposureTestingViewContext];
    }
    return self;
}

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"ynex_isExposured"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != YNEeposureTestingViewContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    if ([keyPath isEqualToString:@"ynex_isExposured"]) {
        BOOL isExposured = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        if (isExposured) {
            self.backgroundColor = [UIColor greenColor];
        } else {
            self.backgroundColor = [UIColor lightGrayColor];
        }
        return;
    }
}

@end
