//
//  EditorViewModel.m
//  Gravy_1.0
//
//  Created by SSC on 2013/11/14.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "EditorViewModel.h"

@implementation EditorViewModel

- (void)initialize
{
    _state = EditorViewStateWhiteBalance;

    adjustmentsWhiteBalance = [[GPUAdjustmentsWhiteBalance alloc] init];
    adjustmentsBrightness = [[GPUAdjustmentsBrightness alloc] init];
    adjustmentsSaturation = [[GPUAdjustmentsSaturation alloc] init];
    
}

- (void)setOriginalImageResized:(UIImage *)originalImageResized
{
    _originalImageResized = originalImageResized;
    [self initialize];
}


- (void)applyBrightnessHighlightAmount:(float)amount Radius:(float)radius
{
     
}

- (void)applyBrightnessShadowAmount:(float)amount Radius:(float)radius
{
    float _amount = (amount < 0.0f) ? -amount : amount;
    adjustmentsBrightness.shadowsAmount = _amount;
    adjustmentsBrightness.shadowsRadius = (radius > 0.0f) ? -radius : radius;
    adjustmentsBrightness.decreaseSaturationEnabled = (radius < 0.0f);

    if(radius < 0.0f){  // Top
        //adjustmentsBrightness.highlightsAmount = -radius * 0.20f;
        if(amount < 0.0f){  // Top Left
            adjustmentsBrightness.contrastAmount = _amount * 0.20f;
        }
    } else{ // Bottom
        if(amount > 0.0f){  // Bottom Right
            adjustmentsBrightness.contrastAmount = _amount * 0.10f;
        }
    }
    [self applyBrightnessShadowAmount];
}

- (void)applyBrightnessShadowAmount
{
    if(!_pictureBrightness){
        _pictureBrightness = [[GPUImagePicture alloc] initWithImage:self.originalImageResized];
        [_pictureBrightness addTarget:adjustmentsBrightness];
    }
    [_pictureBrightness processImage];
    self.appliedImageBrightness = [adjustmentsBrightness imageFromCurrentlyProcessedOutput];
}

- (void)applyWhiteBalanceAmountRed:(float)red Blue:(float)blue
{
    red *= -0.1f;
    blue *= 0.1f;
    adjustmentsWhiteBalance.redWeight = blue;
    adjustmentsWhiteBalance.blueWeight = red;
    [self applyWhiteBalance];
}

- (void)applyWhiteBalance
{
    if(!_pictureWhiteBalance){
        _pictureWhiteBalance = [[GPUImagePicture alloc] initWithImage:self.appliedImageBrightness];
        [_pictureWhiteBalance addTarget:adjustmentsWhiteBalance];
    }
    [_pictureWhiteBalance processImage];
    self.appliedImageWhiteBalancee = [adjustmentsWhiteBalance imageFromCurrentlyProcessedOutput];
}
- (void)applySaturationAmount:(float)amount Radius:(float)radius
{
    adjustmentsSaturation.saturation = radius;
    adjustmentsSaturation.vibrance = amount;
    [self applySaturation];
}

- (void)applySaturation
{
    if(!_pictureSaturation){
        _pictureSaturation = [[GPUImagePicture alloc] initWithImage:self.appliedImageWhiteBalancee];
        [_pictureSaturation addTarget:adjustmentsSaturation];
    }
    [_pictureSaturation processImage];
    self.appliedImageSaturation = [adjustmentsSaturation imageFromCurrentlyProcessedOutput];
}

- (UIImage*)merge2pictureBase:(GPUImagePicture *)basePicture overlay:(GPUImagePicture *)overlayPicture opacity:(CGFloat)opacity
{
    GPUImageNormalBlendFilter* normalBlend = [[GPUImageNormalBlendFilter alloc] init];
    [basePicture addTarget:normalBlend];
    
    GPUImageOpacityFilter* opacityFilter = [[GPUImageOpacityFilter alloc] init];
    opacityFilter.opacity = opacity;
    
    [opacityFilter addTarget:normalBlend atTextureLocation:1];
    [overlayPicture addTarget:opacityFilter];
    [basePicture processImage];
    [overlayPicture processImage];
    return [normalBlend imageFromCurrentlyProcessedOutput];
}

- (void)applyCurrentSelectedEffect
{
    self.appliedImageEffect = self.appliedImageSaturation;
    
    if(self.currentSelectedEffectId == EffectIdCandy){
        [self applyEffectCandy];
        return;
    }
    
    if(self.currentSelectedEffectId == EffectIdVintage){
        [self applyEffectVintage];
        return;
    }
    
    if(self.currentSelectedEffectId == EffectIdSunset){
        [self applyEffectSunset];
        return;
    }
}

- (void)adjustCurrentSelectedEffect
{
    if(self.currentSelectedEffectId == EffectIdNone){
        self.appliedImageEffect = self.appliedImageSaturation;
        return;
    }
    
    UIImage* resultImage = self.appliedImageSaturation;
    
    if(self.weightLeftBottom > 0.0f){
        @autoreleasepool {
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:self.effectedLeftBottomImage];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftBottom];
        }
    }
    
    if(self.weightLeftTop > 0.0f){
        @autoreleasepool {
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:self.effectedLeftTopImage];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftTop];
        }
    }
    
    if(self.weightRightBottom > 0.0f){
        @autoreleasepool {
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:self.effectedRightBottomImage];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightBottom];
        }
    }

    if(self.weightRightTop > 0.0f){
        @autoreleasepool {
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:self.effectedRightTopImage];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightTop];
        }
    }
    self.appliedImageEffect = resultImage;

}

- (void)applyEffectCandy
{
    @autoreleasepool {
        GPUEffectColorfulCandy* effect = [[GPUEffectColorfulCandy alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectHaze3* effect = [[GPUEffectHaze3 alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftTopImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectSoftPop* effect = [[GPUEffectSoftPop alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectFaerieBloom* effect = [[GPUEffectFaerieBloom alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightTopImage = [effect process];
    }
}

- (void)applyEffectVintage
{
    @autoreleasepool {
        GPUEffectVintageFilm* effect = [[GPUEffectVintageFilm alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectHazelnut* effect = [[GPUEffectHazelnut alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftTopImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectOldTone* effect = [[GPUEffectOldTone alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectVintage2* effect = [[GPUEffectVintage2 alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightTopImage = [effect process];
    }
}

- (void)applyEffectSunset
{
    @autoreleasepool {
        GPUEffectGoodMorning* effect = [[GPUEffectGoodMorning alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectWeekend* effect = [[GPUEffectWeekend alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftTopImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectWarmAutumn* effect = [[GPUEffectWarmAutumn alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectJoyful* effect = [[GPUEffectJoyful alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightTopImage = [effect process];
    }
}


@end
