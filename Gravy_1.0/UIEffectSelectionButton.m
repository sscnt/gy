//
//  UIEffectSelectionButton.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIEffectSelectionButton.h"

@implementation UIEffectSelectionButton

- (id)init
{
    self = [super init];
    if(self){
        self.selected = NO;
        previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
        [self addSubview:previewImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 85.0f, 80.0f, 16.0f)];
        titleLabel.font = [UIFont fontWithName:@"rounded-mplus-1p-light" size:15.0f];
        titleLabel.alpha = 0.9f;
        titleLabel.text = NSLocalizedString(@"Subtitle", nil);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];
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
