//
//  UIDockButtonPhotos.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIDockButtonPhotos.h"

@implementation UIDockButtonPhotos

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"icon_photos.png"] forState:UIControlStateNormal];
        [self setTitle:NSLocalizedString(@"Photos", nil) forState:UIControlStateNormal];
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
