//
//  DemoTestOutsideWithReuseCollectionViewCell.m
//  YNExposureDemo
//
//  Created by Wang Ya on 12/11/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "DemoTestOutsideWithReuseCollectionViewCell.h"
#import "UIView+YNExposureViewPrivate.h"

@implementation DemoTestOutsideWithReuseCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.layer.borderColor = [UIColor grayColor].CGColor;
        self.contentView.layer.borderWidth = 0.5;
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.layer removeAllAnimations];
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setIsExposuredByIndex:(BOOL)isExposuredByIndex
{
    _isExposuredByIndex = isExposuredByIndex;
    [self updateBackendColor];
}

- (void)setYnex_lastShowedDate:(NSDate *)ynex_lastShowedDate
{
    [super setYnex_lastShowedDate:ynex_lastShowedDate];
    [self updateBackendColor];
}

- (void)updateBackendColor
{
    if (self.isExposuredByIndex) {
        self.backgroundColor = [UIColor greenColor];
        return;
    }
    if (self.ynex_lastShowedDate != nil) {
        self.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:self.ynex_delay delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.backgroundColor = [UIColor redColor];
        } completion:nil];
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
}

@end
