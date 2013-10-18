//
//  UIKnobView.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/18.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIKnobView.h"

@implementation UIKnobView

- (id)init
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f];
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
