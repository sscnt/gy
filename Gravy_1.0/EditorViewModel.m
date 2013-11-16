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
    adjustmentsBrightness.shadowsRadius = -radius;
    if(amount > 0.0f){
        adjustmentsBrightness.contrastAmount = _amount * 0.10f;
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
    red *= -0.16f;
    blue *= -0.16f;
    adjustmentsWhiteBalance.redWeight = red;
    adjustmentsWhiteBalance.blueWeight = blue;
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
    
}

- (void)applySaturation
{
    
}

- (void)goToNext
{
    
}

- (void)backToPrev
{
    
}

@end
