//
//  UIDockButtonSave.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/21.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIDockButtonSave.h"

@implementation UIDockButtonSave

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"icon_download.png"] forState:UIControlStateNormal];
        [self setTitle:NSLocalizedString(@"Save", nil) forState:UIControlStateNormal];
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
