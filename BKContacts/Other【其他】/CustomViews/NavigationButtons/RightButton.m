//
//  RightButton.m
//  BackItemButton
//
//  Created by apple on 15/6/4.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "RightButton.h"

static CGFloat const rightBtnRatio = 1.0;

// 相关宏定义
#define kRightBtnWidth self.bounds.size.width
#define kRightBtnHeight self.bounds.size.height

@implementation RightButton
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // set property of imageView
        [self.imageView setContentMode:UIViewContentModeCenter];
        
        // set property of titleLabel
        [self.titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
        
        [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
        
        // set property of highlighted
        [self setAdjustsImageWhenHighlighted:NO];
    }
    
    return self;
}

#pragma mark - reload methods
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0.0f;
    
    CGFloat imageY = 0.0f;
    
    CGFloat imageWidth = kRightBtnWidth;
    
    CGFloat imageHeight = kRightBtnHeight * rightBtnRatio;
    
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0.0f;
    
    CGFloat titleY = kRightBtnHeight * rightBtnRatio;
    
    CGFloat titleWidth = kRightBtnWidth;
    
    CGFloat titleHeight = kRightBtnHeight * (1 - rightBtnRatio);
    
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

@end
