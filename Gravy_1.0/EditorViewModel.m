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

    if(radius < 0.0f){  // Top
        adjustmentsBrightness.highlightsAmount = -radius * 0.20f;
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
    adjustmentsSaturation.vibrance = (amount < 0.0) ? -amount : amount;
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
        GPUEffectSweetFlower* effect = [[GPUEffectSweetFlower alloc] init];
        effect.imageToProcess = self.appliedImageSaturation;
        self.effectedRightTopImage = [effect process];
    }
    @autoreleasepool {
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:self.appliedImageSaturation];
    }
}

@end
