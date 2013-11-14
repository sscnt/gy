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
    red *= 0.00098039215;
    blue *= 0.00098039215;
    red = MAX(-1.0f, MIN(1.0f, red));
    blue = MAX(-1.0f, MIN(1.0f, blue));
    adjustmentsWhiteBalance.redWeight = red;
    adjustmentsWhiteBalance.blueWeight = blue;
    if(!pictureWhiteBalance){
        pictureWhiteBalance = [[GPUImagePicture alloc] initWithImage:_originalImageResized];
        [pictureWhiteBalance addTarget:adjustmentsWhiteBalance];
    }
    [pictureWhiteBalance processImage];
    self.appliedImageWhiteBalancee = [adjustmentsWhiteBalance imageFromCurrentlyProcessedOutput];
}

- (void)applyBrightnessHighlightAmount:(float)amount Weight:(float)weight
{
    
}

- (void)applyBrightnessShadowAmount:(float)amount Weight:(float)weight
{
    
}

- (void)applySaturationAmount:(float)amount Weight:(float)weight
{
    
}

- (void)goToNext
{
    
}

- (void)backToPrev
{
    
}

@end
