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

- (void)setShpex_isExposed:(BOOL)shpex_isExposed
{
    [super setShpex_isExposed:shpex_isExposed];
    [self updateBackendColor];
}

- (void)setShpex_startAppearanceDate:(NSDate *)shpex_startAppearanceDate
{
    [super setShpex_startAppearanceDate:shpex_startAppearanceDate];
    [self updateBackendColor];
}

- (void)updateBackendColor
{
    if (self.shpex_isExposed) {
        self.backgroundColor = [UIColor greenColor];
        return;
    }
    if (self.shpex_startAppearanceDate) {
        self.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:self.shpex_minDurationInWindow delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.backgroundColor = [UIColor redColor];
        } completion:nil];
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
}

@end
