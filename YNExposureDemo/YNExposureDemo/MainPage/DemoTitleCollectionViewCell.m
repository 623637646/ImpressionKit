//
//  DemoTitleCollectionViewCell.m
//  YNExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "DemoTitleCollectionViewCell.h"

@interface DemoTitleCollectionViewCell()
@property (nonatomic, weak) UILabel *label;
@end

@implementation DemoTitleCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor blackColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        self.label = label;
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    self.label.text = title;
}

-(NSString *)title
{
    return self.label.text;
}

@end
