//
//  UIEditorTitleLabel.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/16.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIEditorTitleLabel.h"

@implementation UIEditorTitleLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.font = [UIFont fontWithName:@"rounded-mplus-1p-light" size:16.0f];
        self.alpha = 0.9f;
        self.text = NSLocalizedString(@"White Balance", nil);
        self.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor clearColor];
        self.textColor = [UIColor whiteColor];
        self.numberOfLines = 0;
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
