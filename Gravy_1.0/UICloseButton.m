//
//  UICloseButton.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/14.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UICloseButton.h"

@implementation UICloseButton

- (id)init
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 48.0f, 48.0f);
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"close_test3.png"] forState:UIControlStateNormal];
        
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
