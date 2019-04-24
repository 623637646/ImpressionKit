//
//  SHPDemoReusedCollectionViewCell.m
//  SHPExposureDemo
//
//  Created by Wang Ya on 12/11/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "SHPDemoReusedCollectionViewCell.h"
#import "UIView+SHPExposureViewPrivate.h"

@implementation SHPDemoReusedCollectionViewCell

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

- (void)setShpex_lastShowedDate:(NSDate *)shpex_lastShowedDate
{
    [super setShpex_lastShowedDate:shpex_lastShowedDate];
    [self updateBackendColor];
}

- (void)updateBackendColor
{
    if (self.isExposuredByIndex) {
        self.backgroundColor = [UIColor greenColor];
        return;
    }
    if (self.shpex_lastShowedDate != nil) {
        self.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:self.shpex_minDurationOnScreen delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.backgroundColor = [UIColor redColor];
        } completion:nil];
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
}

@end
