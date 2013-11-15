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

- (void)applyWhiteBalanceAmountRed:(float)red Blue:(float)blue
{
    red *= -0.3;
    blue *= -0.3f;
    adjustmentsWhiteBalance.redWeight = red;
    adjustmentsWhiteBalance.blueWeight = blue;
    [self applyWhiteBalance];
}

- (void)applyWhiteBalance
{
    if(!_pictureWhiteBalance){
        _pictureWhiteBalance = [[GPUImagePicture alloc] initWithImage:_originalImageResized];
        [_pictureWhiteBalance addTarget:adjustmentsWhiteBalance];
    }
    [_pictureWhiteBalance processImage];
    self.appliedImageWhiteBalancee = [adjustmentsWhiteBalance imageFromCurrentlyProcessedOutput];
}

- (void)applyBrightnessHighlightAmount:(float)amount Radius:(float)radius
{
    
}

- (void)applyBrightnessShadowAmount:(float)amount Radius:(float)radius
{
    amount = amount * 1.5f + 1.5f;
    adjustmentsBrightness.shadowsAmount = amount;
    [self applyBrightnessShadowAmount];
}

- (void)applyBrightnessShadowAmount
{
    if(!_pictureBrightness){
        _pictureBrightness = [[GPUImagePicture alloc] initWithImage:self.appliedImageWhiteBalancee];
        [_pictureBrightness addTarget:adjustmentsBrightness];
    }
    [_pictureBrightness processImage];
    self.appliedImageBrightness = [adjustmentsBrightness imageFromCurrentlyProcessedOutput];
}

- (void)applySaturationAmount:(float)amount Radius:(float)radius
{
    
}

- (void)goToNext
{
    
}

- (void)backToPrev
{
    
}

@end
