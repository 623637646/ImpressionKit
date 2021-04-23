//
//  EKDemoReusedCollectionViewCell.m
//  ExposureKitExample
//
//  Created by Wang Ya on 12/11/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "EKDemoReusedCollectionViewCell.h"
#import "UIView+ExposureKitExamplePrivate.h"

@implementation EKDemoReusedCollectionViewCell

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

- (void)setEk_isExposed:(BOOL)ek_isExposed
{
    [super setEk_isExposed:ek_isExposed];
    [self updateBackendColor];
}

- (void)setEk_startAppearanceDate:(NSDate *)ek_startAppearanceDate
{
    [super setEk_startAppearanceDate:ek_startAppearanceDate];
    [self updateBackendColor];
}

- (void)updateBackendColor
{
    if (self.ek_isExposed) {
        self.backgroundColor = [UIColor greenColor];
        return;
    }
    if (self.ek_startAppearanceDate) {
        self.backgroundColor = [UIColor whiteColor];
        [UIView animateWithDuration:self.ek_minDurationInWindow delay:0 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.backgroundColor = [UIColor redColor];
        } completion:nil];
        return;
    }
    self.backgroundColor = [UIColor whiteColor];
}

@end
