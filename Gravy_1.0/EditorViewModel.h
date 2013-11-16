//
//  EditorViewModel.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/14.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "GPUAdjustmentsWhiteBalance.h"
#import "GPUAdjustmentsSaturation.h"
#import "GPUAdjustmentsBrightness.h"

#import "GPUEffectHaze3.h"
#import "GPUEffectColorfulCandy.h"
#import "GPUEffectSoftPop.h"
#import "GPUEffectSweetFlower.h"

typedef NS_ENUM(NSInteger, EditorViewState){
    EditorViewStateWhiteBalance = 1,
    EditorViewStateBrightness,
    EditorViewStateSaturation,
    EditorViewStateEffect,
    EditorViewStateFinishedSaving,
    EditorViewStateSharing
};

@interface EditorViewModel : NSObject
{
    GPUAdjustmentsWhiteBalance* adjustmentsWhiteBalance;
    GPUAdjustmentsBrightness* adjustmentsBrightness;
    GPUAdjustmentsSaturation* adjustmentsSaturation;
}

@property (nonatomic, assign) EditorViewState state;

@property(nonatomic, strong) UIImage* originalImageResized;
@property(nonatomic, strong) UIImage* appliedImageWhiteBalancee;
@property(nonatomic, strong) UIImage* appliedImageBrightness;
@property(nonatomic, strong) UIImage* appliedImageSaturation;
@property(nonatomic, strong) UIImage* appliedImageEffect;

@property(nonatomic, strong) UIImage* effectedRightTopImage;
@property(nonatomic, strong) UIImage* effectedRightBottomImage;
@property(nonatomic, strong) UIImage* effectedLeftTopImage;
@property(nonatomic, strong) UIImage* effectedLeftBottomImage;

@property (nonatomic, strong) GPUImagePicture* pictureWhiteBalance;
@property (nonatomic, strong) GPUImagePicture* pictureBrightness;
@property (nonatomic, strong) GPUImagePicture* pictureSaturation;
@property (nonatomic, strong) GPUImagePicture* pictureEffect;

@property (nonatomic, assign) float effectCandySweetFlower;
@property (nonatomic, assign) float effectCandySoftPop;
@property (nonatomic, assign) float effectCandyColorfulCandy;
@property (nonatomic, assign) float effectCandyHaze3;

- (void)applyWhiteBalanceAmountRed:(float)red Blue:(float)blue;
- (void)applyWhiteBalance;
- (void)applyBrightnessShadowAmount:(float)amount Radius:(float)radius;
- (void)applyBrightnessShadowAmount;
- (void)applyBrightnessHighlightAmount:(float)amount Radius:(float)radius;
- (void)applySaturationAmount:(float)amount Radius:(float)radius;
- (void)applySaturation;

- (void)applyEffectCandy;

@end