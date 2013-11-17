//
//  UIEffectSelectionView.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIEffectSelectionView.h"

@implementation UIEffectSelectionView

- (id)init
{
    CGRect frame = CGRectMake(0.0f, 0.0f, [UIScreen screenSize].width, 100.0f);
    self = [super initWithFrame:frame];
    if(self){
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, frame.size.height)];
        scrollView.contentSize = CGSizeMake(frame.size.width, frame.size.height);
        [self addSubview:scrollView];
        
    }
    return self;
}

- (void)setEffectPreviewImage:(UIImage *)effectPreviewImage
{
    buttonNone = [[UIEffectSelectionButton alloc] init];
    buttonNone.previewImage = effectPreviewImage;
    [scrollView addSubview:buttonNone];
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
