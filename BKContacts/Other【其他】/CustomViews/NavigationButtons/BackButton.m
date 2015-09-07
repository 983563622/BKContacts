//
//  BackButton.m
//  CallBar
//
//  Created by apple on 15/6/3.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "BackButton.h"

// 相关宏定义
//#define kBackButtonRatio 0.4
static CGFloat const backBtnRatio = 0.4;

#define kBackBtnWidth self.bounds.size.width
#define kBackBtnHeight self.bounds.size.height

@implementation BackButton
#pragma mark - life cycle
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        // set property of imageView
        [self.imageView setContentMode:UIViewContentModeRight];
        
        // set property of titleLabel
        [self.titleLabel setFont:[UIFont systemFontOfSize:17]];
        
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        
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
    
    CGFloat imageWidth = kBackBtnWidth * backBtnRatio;
    
    CGFloat imageHeight = kBackBtnHeight;
    
    return CGRectMake(imageX, imageY, imageWidth, imageHeight);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 30;
    
    CGFloat titleY = 0.0f;
    
    CGFloat titleWidth = kBackBtnWidth * (1 - backBtnRatio);
    
    CGFloat titleHeight = kBackBtnHeight;
    
    return CGRectMake(titleX, titleY, titleWidth, titleHeight);
}

@end
