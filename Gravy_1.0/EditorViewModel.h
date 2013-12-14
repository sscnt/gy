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

#import "GPUImageEffectsImport.h"

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
    float _wbRedAmount;
    float _wbBlueAmount;
    float _brShadowAmount;
    float _brShadowRadius;
    int _brDec;
    float _stAmount;
    float _stRadius;
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

@property (nonatomic, strong) GPUAdjustmentsWhiteBalance* adjustmentsWhiteBalance;
@property (nonatomic, strong) GPUAdjustmentsBrightness* adjustmentsBrightness;
@property (nonatomic, strong) GPUAdjustmentsSaturation* adjustmentsSaturation;

@property (nonatomic, assign) float weightRightTop;
@property (nonatomic, assign) float weightRightBottom;
@property (nonatomic, assign) float weightLeftTop;
@property (nonatomic, assign) float weightLeftBottom;

@property (nonatomic, assign) float avarageLuminosity;

@property (nonatomic, assign) EffectId currentSelectedEffectId;

- (void)initialize;
- (void)applyWhiteBalanceAmountRed:(float)red Blue:(float)blue;
- (void)applyWhiteBalance;
- (UIImage*)executeWhiteBalance:(UIImage*)inputImage;

- (void)applyBrightnessShadowAmount:(float)amount Radius:(float)radius;
- (void)applyBrightnessShadowAmount;
- (UIImage*)executeBrightnessShadow:(UIImage*)inputImage;

- (void)applyBrightnessHighlightAmount:(float)amount Radius:(float)radius;

- (void)applySaturationAmount:(float)amount Radius:(float)radius;
- (void)applySaturation;
- (UIImage*)executeSaturation:(UIImage*)inputImage;

- (UIImage*)merge2pictureBase:(GPUImagePicture*)basePicture overlay:(GPUImagePicture*)overlayPicture opacity:(CGFloat)opacity;

- (void)applyCurrentSelectedEffect;
- (void)adjustCurrentSelectedEffect;

- (UIImage*)executeCurrentSelectedEffectWithWeight:(UIImage*)inputImage;

- (void)applyEffectCreamy;
- (UIImage*)executeEffectCreamyWithWeight:(UIImage*)inputImage;
- (void)applyEffectBloom;
- (UIImage*)executeEffectBloomWithWeight:(UIImage*)inputImage;
- (void)applyEffectVintage;
- (UIImage*)executeEffectVintageWithWeight:(UIImage*)inputImage;
- (void)applyEffectSunset;
- (UIImage*)executeEffectSunsetWithWeight:(UIImage*)inputImage;

@end
