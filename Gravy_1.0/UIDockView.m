//
//  bottomButtons.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIDockView.h"

@implementation UIDockView

- (id)init:(UIDockViewType)type
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 50.0f);
    self = [super initWithFrame:rect];
    [self setBackgroundColor:[UIColor clearColor]];
    if(type == UIDockViewTypeLight){
        UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomBg.png"]];
        [bgView setAlpha:0.9f];
        [self addSubview:bgView];
    }
    else if(type == UIDockViewTypeDark){
        UIImageView* bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottomEditorBg.png"]];
        [self addSubview:bgView];
    }
    return self;
}

@end
