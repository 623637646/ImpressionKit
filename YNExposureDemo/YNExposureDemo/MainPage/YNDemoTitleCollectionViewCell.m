//
//  YNDemoTitleCollectionViewCell.m
//  YNExposureDemo
//
//  Created by Wang Ya on 30/10/18.
//  Copyright © 2018 Shopee. All rights reserved.
//

#import "YNDemoTitleCollectionViewCell.h"

@interface YNDemoTitleCollectionViewCell()
@property (nonatomic, weak) UILabel *label;
@end

@implementation YNDemoTitleCollectionViewCell

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
        [self.contentView addSubview:label];
        self.label = label;
        
        UIView *dividingView = [[UIView alloc] initWithFrame:CGRectMake(20, frame.size.height - 0.5, frame.size.width - 20, 0.5)];
        dividingView.backgroundColor = [UIColor lightGrayColor];
        dividingView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.contentView addSubview:dividingView];
        
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
