//
//  UIEffectSelectionButton.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/17.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "UIEffectSelectionButton.h"

@implementation UIEffectSelectionButton

- (id)initWithEffectId:(EffectId)effectId previewImageBase:(UIImage *)baseImage
{
    CGRect frame = CGRectMake(0.0f, 0.0f, 80.0f, 100.0f);
    self = [super initWithFrame:frame];
    if(self){
        self.selected = NO;
        self.effectId = effectId;
        previewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, 70.0f, 70.0f)];
        CALayer* l = [previewImageView layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:4.0];
        [l setBorderWidth:4.0];
        [l setBorderColor:[[UIColor clearColor] CGColor]];
        [self addSubview:previewImageView];
        
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 83.0f, 70.0f, 14.0f)];
        titleLabel.font = [UIFont fontWithName:@"rounded-mplus-1p-regular" size:11.0f];
        titleLabel.alpha = 0.9f;
        titleLabel.text = [self titleFromEffectId:effectId];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.numberOfLines = 0;
        [self addSubview:titleLabel];

        if(effectId != EffectIdNone){
            if(effectId == EffectIdBloom){
                if (![PurchaseManager didPurchaseBloomEffect]) {
                    [self displayLockedImageView];
                }
            } else if(effectId == EffectIdVintage){
                if (![PurchaseManager didPurchaseVintageEffect]) {
                    [self displayLockedImageView];
                }
            } else if(effectId == EffectIdSunset){
                if (![PurchaseManager didPurchaseSunsetEffect]) {
                    [self displayLockedImageView];
                }
            } else if(effectId == EffectIdFlare){
                if (![PurchaseManager didPurchaseFlareEffect]) {
                    [self displayLockedImageView];
                }
            } else if(effectId == EffectIdVivid){
                if (![PurchaseManager didPurchaseVividEffect]) {
                    [self displayLockedImageView];
                }
            }
        }
        
        [self initPreviewImageView:baseImage];
        [self addTarget:self action:@selector(didPress) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)displayLockedImageView
{
    previewImageView.hidden = YES;
    lockedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview_locked"]];
    lockedImageView.center = previewImageView.center;
    CALayer* l = [lockedImageView layer];
    [l setMasksToBounds:YES];
    [l setCornerRadius:4.0];
    [l setBorderWidth:4.0];
    [l setBorderColor:[[UIColor clearColor] CGColor]];
    [self addSubview:lockedImageView];
}
- (void)unlock
{
    previewImageView.hidden = NO;
    lockedImageView.hidden = YES;
    [lockedImageView removeFromSuperview];
    lockedImageView = nil;
    [self setSelected:_selected];
}

- (void)initPreviewImageView:(UIImage *)baseImage
{
    if(self.effectId == EffectIdNone){
        previewImageView.image = baseImage;
        self.selected = YES;
        return;
    }
    
    if(self.effectId == EffectIdCreamy){
        GPUEffectCreamyNoon* effect = [[GPUEffectCreamyNoon alloc] init];
        effect.imageToProcess = baseImage;
        previewImageView.image = [effect process];
        return;
    }
    
    if(self.effectId == effectidCake){
        GPUEffectMarshmallow* effect = [[GPUEffectMarshmallow alloc] init];
        effect.imageToProcess = baseImage;
        previewImageView.image = [effect process];
        return;
    }
    
    if(self.effectId == EffectIdBloom){
        GPUEffectColorfulCandy* effect = [[GPUEffectColorfulCandy alloc] init];
        effect.imageToProcess = baseImage;
        previewImageView.image = [effect process];
        return;
    }
    
    if(self.effectId == EffectIdVintage){
        GPUEffectVintageFilm* effect = [[GPUEffectVintageFilm alloc] init];
        effect.imageToProcess = baseImage;
        previewImageView.image = [effect process];
        return;
    }
    
    if(self.effectId == EffectIdSunset){
        GPUEffectGoodMorning* effect = [[GPUEffectGoodMorning alloc] init];
        effect.imageToProcess = baseImage;
        previewImageView.image = [effect process];
        return;
    }
    
    if(self.effectId == EffectIdFlare){
        GPUEffectMysticGlow* effect = [[GPUEffectMysticGlow alloc] init];
        effect.imageToProcess = baseImage;
        previewImageView.image = [effect process];
        return;
    }
    
    if(self.effectId == EffectIdVivid){
        GPUEffectVividVintage* effect = [[GPUEffectVividVintage alloc] init];
        effect.imageToProcess = baseImage;
        previewImageView.image = [effect process];
        return;
    }
}
- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    CALayer* l;
    if(lockedImageView){
        l = [lockedImageView layer];
    } else {
        l = [previewImageView layer];
    }
    if(_selected){
        [l setBorderColor:[[UIColor colorWithRed:41.0f/255.0f green:128.0f/255.0f blue:185.0f/255.0f alpha:1.0f] CGColor]];
    } else{
        [l setBorderColor:[[UIColor clearColor] CGColor]];
    }

}

- (NSString*)titleFromEffectId:(EffectId)effectId
{
    if(effectId == EffectIdCreamy){
        return NSLocalizedString(@"Cream", nil);
    }
    if(effectId == effectidCake){
        return NSLocalizedString(@"Cake", nil);
    }
    if(effectId == EffectIdBloom){
        return NSLocalizedString(@"Bloom", nil);
    }
    if(effectId == EffectIdVintage){
        return NSLocalizedString(@"Vintage", nil);
    }
    if(effectId == EffectIdSunset){
        return NSLocalizedString(@"Sunset", nil);
    }
    if(effectId == EffectIdFlare){
        return NSLocalizedString(@"Flare", nil);
    }
    if(effectId == EffectIdVivid){
        return NSLocalizedString(@"Vivid", nil);
    }
    
    return NSLocalizedString(@"None", nil);
}

- (void)didPress;
{
    [self.delegate buttonPressed:self];
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
