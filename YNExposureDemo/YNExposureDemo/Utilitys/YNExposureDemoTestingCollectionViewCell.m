//
//  YNExposureDemoTestingCollectionViewCell.m
//  YNExposureDemo
//
//  Created by Wang Ya on 31/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNExposureDemoTestingCollectionViewCell.h"
#import "YNExposureDemoTestingView.h"

@interface YNExposureDemoTestingCollectionViewCell()
@property (nonatomic, weak) YNExposureDemoTestingView *testingView;
@end

@implementation YNExposureDemoTestingCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        YNExposureDemoTestingView *testingView = [[YNExposureDemoTestingView alloc] initWithFrame:self.bounds];
        testingView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:testingView];
        self.testingView = testingView;
    }
    return self;
}

- (void)prepareForReuse
{
    [self.testingView reset];
}

@end
