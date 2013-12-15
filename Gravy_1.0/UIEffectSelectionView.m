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
        scrollView.contentSize = CGSizeMake(frame.size.width + 450.0f, frame.size.height);
        scrollView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:scrollView];
        
    }
    return self;
}

- (void)setEffectPreviewImage:(UIImage *)effectPreviewImage
{
    if(buttonNone){
        buttonNone.delegate = nil;
        [buttonNone removeFromSuperview];
    }
    if(buttonCreamy){
        buttonCreamy.delegate = nil;
        [buttonCreamy removeFromSuperview];
    }
    if(buttonBloom){
        buttonBloom.delegate = nil;
        [buttonBloom removeFromSuperview];
    }
    if(buttonSunset){
        buttonSunset.delegate = nil;
        [buttonSunset removeFromSuperview];
    }
    if(buttonVintage){
        buttonVintage.delegate = nil;
        [buttonVintage removeFromSuperview];
    }
    if(buttonFlare){
        buttonFlare.delegate = nil;
        [buttonFlare removeFromSuperview];
    }
    if(buttonVivid){
        buttonVivid.delegate = nil;
        [buttonVivid removeFromSuperview];
    }
    if(buttonCake){
        buttonCake.delegate = nil;
        [buttonCake removeFromSuperview];
    }

    CGFloat left = [UIScreen screenRect].size.width / 2.0f - 35.0f;
    // None
    buttonNone = [[UIEffectSelectionButton alloc] initWithEffectId:EffectIdNone previewImageBase:effectPreviewImage];
    [buttonNone setX:left];
    buttonNone.delegate = self;
    [scrollView addSubview:buttonNone];
    
    // Creamy
    left += 80.0f;
    buttonCreamy = [[UIEffectSelectionButton alloc] initWithEffectId:EffectIdCreamy previewImageBase:effectPreviewImage];
    [buttonCreamy setX:left];
    buttonCreamy.delegate = self;
    [scrollView addSubview:buttonCreamy];
    
    // Cake
    left += 80.0f;
    buttonCake = [[UIEffectSelectionButton alloc] initWithEffectId:effectidCake previewImageBase:effectPreviewImage];
    [buttonCake setX:left];
    buttonCake.delegate = self;
    [scrollView addSubview:buttonCake];
    
    // Bloom
    left += 80.0f;
    buttonBloom = [[UIEffectSelectionButton alloc] initWithEffectId:EffectIdBloom previewImageBase:effectPreviewImage];
    [buttonBloom setX:left];
    buttonBloom.delegate = self;
    [scrollView addSubview:buttonBloom];
    
    // Flare
    left += 80.0f;
    buttonFlare = [[UIEffectSelectionButton alloc] initWithEffectId:EffectIdFlare previewImageBase:effectPreviewImage];
    [buttonFlare setX:left];
    buttonFlare.delegate = self;
    [scrollView addSubview:buttonFlare];
    
    // Vivid
    left += 80.0f;
    buttonVivid = [[UIEffectSelectionButton alloc] initWithEffectId:EffectIdVivid previewImageBase:effectPreviewImage];
    [buttonVivid setX:left];
    buttonVivid.delegate = self;
    [scrollView addSubview:buttonVivid];

    // Vintage
    left += 80.0f;
    buttonVintage = [[UIEffectSelectionButton alloc] initWithEffectId:EffectIdVintage previewImageBase:effectPreviewImage];
    [buttonVintage setX:left];
    buttonVintage.delegate = self;
    [scrollView addSubview:buttonVintage];
    
    // Sunset
    left += 80.0f;
    buttonSunset = [[UIEffectSelectionButton alloc] initWithEffectId:EffectIdSunset previewImageBase:effectPreviewImage];
    [buttonSunset setX:left];
    buttonSunset.delegate = self;
    [scrollView addSubview:buttonSunset];
}

- (void)buttonPressed:(UIEffectSelectionButton *)button
{
    [self highlightButton:button.effectId];
    [self.delegate effectSelected:button.effectId];
}

- (void)highlightButton:(EffectId)effectId
{
    buttonNone.selected = NO;
    buttonCreamy.selected = NO;
    buttonCake.selected = NO;
    buttonBloom.selected = NO;
    buttonFlare.selected = NO;
    buttonVivid.selected = NO;
    buttonVintage.selected = NO;
    buttonSunset.selected = NO;
    
    if(effectId == EffectIdNone){
        buttonNone.selected = YES;
        return;
    }
    if(effectId == EffectIdCreamy){
        buttonCreamy.selected = YES;
        return;
    }
    if(effectId == effectidCake){
        buttonCake.selected = YES;
        return;
    }
    if(effectId == EffectIdBloom){
        buttonBloom.selected = YES;
        return;
    }
    if(effectId == EffectIdFlare){
        buttonFlare.selected = YES;
        return;
    }
    if(effectId == EffectIdVivid){
        buttonVivid.selected = YES;
        return;
    }
    if(effectId == EffectIdVintage){
        buttonVintage.selected = YES;
        return;
    }
    if(effectId == EffectIdSunset){
        buttonSunset.selected = YES;
        return;
    }

}

- (void)unlockButtonByEffectId:(EffectId)effectId
{
    if(effectId == EffectIdBloom){
        [buttonBloom unlock];return;
    }
    if(effectId == EffectIdVintage){
        [buttonVintage unlock];return;
    }
    if(effectId == EffectIdVintage){
        [buttonVintage unlock];return;
    }
    if(effectId == EffectIdSunset){
        [buttonSunset unlock];return;
    }
    if(effectId == EffectIdFlare){
        [buttonFlare unlock];return;
    }
    if(effectId == EffectIdVivid){
        [buttonVivid unlock];return;
    }
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
