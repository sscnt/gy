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
    _currentSelectedEffectId = EffectIdNone;
    
    _brShadowAmount = 0.0f;
    _brShadowRadius = 0.0f;
    _brDec = 0;
    
    _wbBlueAmount = 0.0f;
    _wbRedAmount = 0.0f;
    
    _stAmount = 0.0f;
    _stRadius = 0.0f;
    
}

- (void)setOriginalImageResized:(UIImage *)originalImageResized
{
    _originalImageResized = originalImageResized;
    _pictureBrightness = nil;
    _pictureWhiteBalance = nil;
    _pictureSaturation = nil;
    
    _adjustmentsBrightness = nil;
    _adjustmentsWhiteBalance = nil;
    _adjustmentsSaturation = nil;
}


- (void)applyBrightnessHighlightAmount:(float)amount Radius:(float)radius
{
     
}

- (void)applyBrightnessShadowAmount:(float)amount Radius:(float)radius
{
    float _amount = (amount < 0.0f) ? -amount : amount;
    
    _brShadowAmount = _amount;
    _brShadowRadius = (radius > 0.0f) ? -radius : radius;
    _brDec = (radius < 0.0f);

    if(radius < 0.0f){  // Top
        //adjustmentsBrightness.highlightsAmount = -radius * 0.20f;
        if(amount < 0.0f){  // Top Left
            _adjustmentsBrightness.contrastAmount = _amount * 0.20f;
        }
    } else{ // Bottom
        if(amount > 0.0f){  // Bottom Right
            _adjustmentsBrightness.contrastAmount = _amount * 0.10f;
        }
    }
    [self applyBrightnessShadowAmount];
}

- (void)applyBrightnessShadowAmount
{
    self.appliedImageBrightness = [self executeBrightnessShadow:self.originalImageResized];
}

- (UIImage*)executeBrightnessShadow:(UIImage *)inputImage
{
    GPUAdjustmentsBrightness* adjustment = [[GPUAdjustmentsBrightness alloc] init];
    
    GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:inputImage];
    [picture addTarget:adjustment];
    
    adjustment.shadowsAmount = _brShadowAmount * (1.0f - _avarageLuminosity * _avarageLuminosity) * 3.0f;
    adjustment.shadowsRadius = _brShadowRadius * (1.0f - _avarageLuminosity * _avarageLuminosity);
    adjustment.decreaseSaturationEnabled = _brDec;
    adjustment.avarageLuminosity = _avarageLuminosity;
    
    [picture processImage];
    return [adjustment imageFromCurrentlyProcessedOutput];
    
}

- (void)applyWhiteBalanceAmountRed:(float)red Blue:(float)blue
{
    red *= -0.1f;
    blue *= 0.1f;
    _wbBlueAmount = blue;
    _wbRedAmount = red;
    [self applyWhiteBalance];
}

- (void)applyWhiteBalance
{
    self.appliedImageWhiteBalancee = [self executeWhiteBalance:self.appliedImageBrightness];
}

- (UIImage*)executeWhiteBalance:(UIImage *)inputImage
{
    
    GPUAdjustmentsWhiteBalance*  adjustment = [[GPUAdjustmentsWhiteBalance alloc] init];
    
    GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:inputImage];
    [picture addTarget:adjustment];
    
    adjustment.redWeight = _wbBlueAmount;
    adjustment.blueWeight = _wbRedAmount;
    [picture processImage];
    return [adjustment imageFromCurrentlyProcessedOutput];
    
}

- (void)applySaturationAmount:(float)amount Radius:(float)radius
{
    _stRadius = radius;
    _stAmount = amount;
    [self applySaturation];
}

- (void)applySaturation
{
    self.appliedImageSaturation = [self executeSaturation:self.appliedImageWhiteBalancee];
    
}

- (UIImage*)executeSaturation:(UIImage *)inputImage
{
    GPUAdjustmentsSaturation* adjustment = [[GPUAdjustmentsSaturation alloc] init];
    
    GPUImagePicture* picutre = [[GPUImagePicture alloc] initWithImage:inputImage];
    [picutre addTarget:adjustment];
    
    adjustment.saturation = _stRadius;
    adjustment.vibrance = _stAmount;
    [picutre processImage];
    return [adjustment imageFromCurrentlyProcessedOutput];
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
    
    if(self.currentSelectedEffectId == EffectIdCreamy){
        [self applyEffectCreamy];
        return;
    }
    
    if(self.currentSelectedEffectId == effectidCake){
        [self applyEffectCake];
        return;
    }

    if(self.currentSelectedEffectId == EffectIdBloom){
        [self applyEffectBloom];
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
    
    if(self.currentSelectedEffectId == EffectIdFlare){
        [self applyEffectFlare];
        return;
    }
    
    if(self.currentSelectedEffectId == EffectIdVivid){
        [self applyEffectVivid];
        return;
    }
    
    if(self.currentSelectedEffectId == EffectIdSummer){
        [self applyEffectSummer];
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

- (UIImage*)executeCurrentSelectedEffectWithWeight:(UIImage *)inputImage
{
    
    if(self.currentSelectedEffectId == EffectIdCreamy){
        return [self executeEffectCreamyWithWeight:inputImage];
    }
    
    if(self.currentSelectedEffectId == effectidCake){
        return [self executeEffectCakeWithWeight:inputImage];
    }

    if(self.currentSelectedEffectId == EffectIdBloom){
        return [self executeEffectBloomWithWeight:inputImage];
    }
    
    if(self.currentSelectedEffectId == EffectIdVintage){
        return [self executeEffectVintageWithWeight:inputImage];
    }
    
    if(self.currentSelectedEffectId == EffectIdSunset){
        return [self executeEffectSunsetWithWeight:inputImage];
    }
    
    if(self.currentSelectedEffectId == EffectIdFlare){
        return [self executeEffectFlareWithWeight:inputImage];
    }
    
    if(self.currentSelectedEffectId == EffectIdVivid){
        return [self executeEffectVividWithWeight:inputImage];
    }
    
    if(self.currentSelectedEffectId == EffectIdSummer){
        return [self executeEffectSummerWithWeight:inputImage];
    }
    return nil;
}

- (void)applyEffectCreamy
{
    @autoreleasepool {
        GPUEffectCreamyNoon* effect = [[GPUEffectCreamyNoon alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectGentleMemories* effect = [[GPUEffectGentleMemories alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftTopImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectVanilla* effect = [[GPUEffectVanilla alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectSpringLight* effect = [[GPUEffectSpringLight alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightTopImage = [effect process];
    }
}

- (UIImage*)executeEffectCreamyWithWeight:(UIImage *)inputImage
{
    
    UIImage* resultImage = inputImage;
    
    if(self.weightLeftBottom > 0.0f){
        @autoreleasepool {
            GPUEffectCreamyNoon* effect = [[GPUEffectCreamyNoon alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftBottom];
        }
    }
    
    if(self.weightLeftTop > 0.0f){
        @autoreleasepool {
            GPUEffectGentleMemories* effect = [[GPUEffectGentleMemories alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftTop];
        }
    }
    
    if(self.weightRightBottom > 0.0f){
        @autoreleasepool {
            GPUEffectVanilla* effect = [[GPUEffectVanilla alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightBottom];
        }
    }
    
    if(self.weightRightTop > 0.0f){
        @autoreleasepool {
            GPUEffectSpringLight* effect = [[GPUEffectSpringLight alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightTop];
        }
    }
    return resultImage;
}

- (void)applyEffectCake
{
    @autoreleasepool {
        GPUEffectMarshmallow* effect = [[GPUEffectMarshmallow alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectPinkBubbleTea* effect = [[GPUEffectPinkBubbleTea alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftTopImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectFaerieVintage* effect = [[GPUEffectFaerieVintage alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectBeachVintage* effect = [[GPUEffectBeachVintage alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightTopImage = [effect process];
    }
}

- (UIImage*)executeEffectCakeWithWeight:(UIImage *)inputImage
{
    
    UIImage* resultImage = inputImage;
    
    if(self.weightLeftBottom > 0.0f){
        @autoreleasepool {
            GPUEffectMarshmallow* effect = [[GPUEffectMarshmallow alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftBottom];
        }
    }
    
    if(self.weightLeftTop > 0.0f){
        @autoreleasepool {
            GPUEffectPinkBubbleTea* effect = [[GPUEffectPinkBubbleTea alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftTop];
        }
    }
    
    if(self.weightRightBottom > 0.0f){
        @autoreleasepool {
            GPUEffectFaerieVintage* effect = [[GPUEffectFaerieVintage alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightBottom];
        }
    }
    
    if(self.weightRightTop > 0.0f){
        @autoreleasepool {
            GPUEffectBeachVintage* effect = [[GPUEffectBeachVintage alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightTop];
        }
    }
    return resultImage;
}

- (void)applyEffectBloom
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

- (UIImage*)executeEffectBloomWithWeight:(UIImage *)inputImage
{
    
    UIImage* resultImage = inputImage;
    
    if(self.weightLeftBottom > 0.0f){
        @autoreleasepool {
            GPUEffectColorfulCandy* effect = [[GPUEffectColorfulCandy alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftBottom];
        }
    }
    
    if(self.weightLeftTop > 0.0f){
        @autoreleasepool {
            GPUEffectHaze3* effect = [[GPUEffectHaze3 alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftTop];
        }
    }
    
    if(self.weightRightBottom > 0.0f){
        @autoreleasepool {
            GPUEffectSoftPop* effect = [[GPUEffectSoftPop alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightBottom];
        }
    }
    
    if(self.weightRightTop > 0.0f){
        @autoreleasepool {
            GPUEffectFaerieBloom* effect = [[GPUEffectFaerieBloom alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightTop];
        }
    }
    return resultImage;
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

- (UIImage*)executeEffectVintageWithWeight:(UIImage *)inputImage
{
    
    UIImage* resultImage = inputImage;
    
    if(self.weightLeftBottom > 0.0f){
        @autoreleasepool {
            GPUEffectVintageFilm* effect = [[GPUEffectVintageFilm alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftBottom];
        }
    }
    
    if(self.weightLeftTop > 0.0f){
        @autoreleasepool {
            GPUEffectHazelnut* effect = [[GPUEffectHazelnut alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftTop];
        }
    }
    
    if(self.weightRightBottom > 0.0f){
        @autoreleasepool {
            GPUEffectOldTone* effect = [[GPUEffectOldTone alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightBottom];
        }
    }
    
    if(self.weightRightTop > 0.0f){
        @autoreleasepool {
            GPUEffectVintage2* effect = [[GPUEffectVintage2 alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightTop];
        }
    }
    return resultImage;
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


- (UIImage*)executeEffectSunsetWithWeight:(UIImage *)inputImage
{
    
    UIImage* resultImage = inputImage;
    
    if(self.weightLeftBottom > 0.0f){
        @autoreleasepool {
            GPUEffectGoodMorning* effect = [[GPUEffectGoodMorning alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftBottom];
        }
    }
    
    if(self.weightLeftTop > 0.0f){
        @autoreleasepool {
            GPUEffectWeekend* effect = [[GPUEffectWeekend alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftTop];
        }
    }
    
    if(self.weightRightBottom > 0.0f){
        @autoreleasepool {
            GPUEffectWarmAutumn* effect = [[GPUEffectWarmAutumn alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightBottom];
        }
    }
    
    if(self.weightRightTop > 0.0f){
        @autoreleasepool {
            GPUEffectJoyful* effect = [[GPUEffectJoyful alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightTop];
        }
    }
    return resultImage;
}

- (void)applyEffectFlare
{
    @autoreleasepool {
        GPUEffectMysticGlow* effect = [[GPUEffectMysticGlow alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectFilmLightLeak* effect = [[GPUEffectFilmLightLeak alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftTopImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectLeakLight* effect = [[GPUEffectLeakLight alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectSunkissed* effect = [[GPUEffectSunkissed alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightTopImage = [effect process];
    }
}


- (UIImage*)executeEffectFlareWithWeight:(UIImage *)inputImage
{
    
    UIImage* resultImage = inputImage;
    
    if(self.weightLeftBottom > 0.0f){
        @autoreleasepool {
            GPUEffectMysticGlow* effect = [[GPUEffectMysticGlow alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftBottom];
        }
    }
    
    if(self.weightLeftTop > 0.0f){
        @autoreleasepool {
            GPUEffectFilmLightLeak* effect = [[GPUEffectFilmLightLeak alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftTop];
        }
    }
    
    if(self.weightRightBottom > 0.0f){
        @autoreleasepool {
            GPUEffectLeakLight* effect = [[GPUEffectLeakLight alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightBottom];
        }
    }
    
    if(self.weightRightTop > 0.0f){
        @autoreleasepool {
            GPUEffectSunkissed* effect = [[GPUEffectSunkissed alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightTop];
        }
    }
    return resultImage;
}


- (void)applyEffectVivid
{
    @autoreleasepool {
        GPUEffectVividVintage* effect = [[GPUEffectVividVintage alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectSunsetCarnevale* effect = [[GPUEffectSunsetCarnevale alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftTopImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectDreamyVintage* effect = [[GPUEffectDreamyVintage alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectCavalleriaRusticana* effect = [[GPUEffectCavalleriaRusticana alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightTopImage = [effect process];
    }
}


- (UIImage*)executeEffectVividWithWeight:(UIImage *)inputImage
{
    
    UIImage* resultImage = inputImage;
    
    if(self.weightLeftBottom > 0.0f){
        @autoreleasepool {
            GPUEffectVividVintage* effect = [[GPUEffectVividVintage alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftBottom];
        }
    }
    
    if(self.weightLeftTop > 0.0f){
        @autoreleasepool {
            GPUEffectSunsetCarnevale* effect = [[GPUEffectSunsetCarnevale alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftTop];
        }
    }
    
    if(self.weightRightBottom > 0.0f){
        @autoreleasepool {
            GPUEffectDreamyVintage* effect = [[GPUEffectDreamyVintage alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightBottom];
        }
    }
    
    if(self.weightRightTop > 0.0f){
        @autoreleasepool {
            GPUEffectCavalleriaRusticana* effect = [[GPUEffectCavalleriaRusticana alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightTop];
        }
    }
    return resultImage;
}


- (void)applyEffectSummer
{
    @autoreleasepool {
        GPUEffectMiami* effect = [[GPUEffectMiami alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectGirder* effect = [[GPUEffectGirder alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedLeftTopImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectSummers* effect = [[GPUEffectSummers alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightBottomImage = [effect process];
    }
    @autoreleasepool {
        GPUEffectCavalleriaRusticana* effect = [[GPUEffectCavalleriaRusticana alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightTopImage = [effect process];
    }
}


- (UIImage*)executeEffectSummerWithWeight:(UIImage *)inputImage
{
    
    UIImage* resultImage = inputImage;
    
    if(self.weightLeftBottom > 0.0f){
        @autoreleasepool {
            GPUEffectMiami* effect = [[GPUEffectMiami alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftBottom];
        }
    }
    
    if(self.weightLeftTop > 0.0f){
        @autoreleasepool {
            GPUEffectGirder* effect = [[GPUEffectGirder alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightLeftTop];
        }
    }
    
    if(self.weightRightBottom > 0.0f){
        @autoreleasepool {
            GPUEffectSummers* effect = [[GPUEffectSummers alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightBottom];
        }
    }
    
    if(self.weightRightTop > 0.0f){
        @autoreleasepool {
            GPUEffectCavalleriaRusticana* effect = [[GPUEffectCavalleriaRusticana alloc] init];
            effect.imageToProcess = inputImage;
            GPUImagePicture* base = [[GPUImagePicture alloc] initWithImage:resultImage];
            GPUImagePicture* overlay = [[GPUImagePicture alloc] initWithImage:[effect process]];
            resultImage = [self merge2pictureBase:base overlay:overlay opacity:self.weightRightTop];
        }
    }
    return resultImage;
}



@end
