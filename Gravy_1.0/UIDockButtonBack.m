//
//  UIDockButtonBack.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/16.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIDockButtonBack.h"

@implementation UIDockButtonBack

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setImage:[UIImage imageNamed:@"icon_back.png"] forState:UIControlStateNormal];
        [self setTitle:NSLocalizedString(@"Back", nil) forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(self.titleEdgeInsets.top, -10.0f, self.titleEdgeInsets.bottom, self.titleEdgeInsets.left)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(1.0f, 0.0f, 0.0f, 20.0f)];
        NSArray *langs = [NSLocale preferredLanguages];
        NSString *currentLanguage = [langs objectAtIndex:0];
        if([currentLanguage compare:@"ja"] == NSOrderedSame) {
            [self setImageEdgeInsets:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 20.0f)];
        }

    }
    return self;
}

@end
