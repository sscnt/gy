//
//  UIWrapperView.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/16.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIWrapperView.h"

@implementation UIWrapperView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.clipsToBounds = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
