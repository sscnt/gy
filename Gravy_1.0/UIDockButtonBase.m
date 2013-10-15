//
//  UIDockButtonBase.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIDockButtonBase.h"

@implementation UIDockButtonBase

- (id)init
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 160.0f, 45.0f);
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //self.titleLabel.alpha = 0.75;
        self.titleLabel.font = [UIFont fontWithName:@"rounded-mplus-1p-medium" size:13.0f];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(1.5f, 0.0f, 0.0f, -6.0f)];
        NSArray *langs = [NSLocale preferredLanguages];
        NSString *currentLanguage = [langs objectAtIndex:0];
        if([currentLanguage compare:@"ja"] == NSOrderedSame) {
            [self setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, -6.0f)];
            
        }
        [self setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.75f] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithWhite:1.0f alpha:0.40f] forState:UIControlStateHighlighted];
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
