//
//  UIDockButtonNext.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/16.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIDockButtonNext.h"

@implementation UIDockButtonNext

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"icon_next.png"] forState:UIControlStateNormal];
        [self setTitle:NSLocalizedString(@"Next", nil) forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.titleEdgeInsets.top, self.titleEdgeInsets.right, self.titleEdgeInsets.bottom, -10.0f)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(1.0f, -44.0f, 0.0f, 0.0f)];
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super imageRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMaxX(contentRect) - CGRectGetWidth(frame) -  self.imageEdgeInsets.right + self.imageEdgeInsets.left;
    return frame;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGRect frame = [super titleRectForContentRect:contentRect];
    frame.origin.x = CGRectGetMinX(frame) - CGRectGetWidth([self imageRectForContentRect:contentRect]);
    return frame;
}

@end
