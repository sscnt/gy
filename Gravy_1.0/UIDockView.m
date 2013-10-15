//
//  bottomButtons.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIDockView.h"

@implementation UIDockView

- (id)init
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 50.0f);
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setBackgroundColor:[UIColor clearColor]];
        UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBg.png"]];
        [bgView setAlpha:0.9f];
        [self addSubview:bgView];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    // Drawing code
}


@end
