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
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [UIScreen screenSize].width, frame.size.height)];
        scrollView.contentSize = CGSizeMake(frame.size.width + 80.0f, frame.size.height);
        scrollView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        
    }
    return self;
}

- (void)setEffectPreviewImage:(UIImage *)effectPreviewImage
{
    CGFloat left = [UIScreen screenRect].size.width / 2.0f - 35.0f;
    // None
    buttonNone = [[UIEffectSelectionButton alloc] initWithEffectId:EffectIdNone previewImageBase:effectPreviewImage];
    [buttonNone setX:left];
    buttonNone.delegate = self;
    [scrollView addSubview:buttonNone];
    
    // Candy
    left += 80.0f;
    buttonCandy = [[UIEffectSelectionButton alloc] initWithEffectId:EffectIdCandy previewImageBase:effectPreviewImage];
    [buttonCandy setX:left];
    buttonCandy.delegate = self;
    [scrollView addSubview:buttonCandy];
}

- (void)buttonPressed:(UIEffectSelectionButton *)button
{
    buttonNone.selected = NO;
    buttonCandy.selected = NO;
    button.selected = YES;
    [self.delegate effectSelected:button.effectId];
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