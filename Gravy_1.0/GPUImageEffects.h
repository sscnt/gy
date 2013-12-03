//
//  GPUImageEffects.h
//  Gravy_1.0
//
//  Created by SSC on 2013/11/04.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "GPUImageChannelMixerFilter.h"
#import "GPUImageGradientColorGenerator.h"
#import "GPUImageSelectiveColorFilter.h"
#import "GPUImageColorBalanceFilter.h"
#import "GPUImageHueSaturationFilter.h"
#import "GPUImageGradientMapFilter.h"
#import "GPUImagePhotoFilter.h"
#import "GPUImageVividLightBlendFilter.h"
#import "GPUImageLinearDodgeBlendFilter.h"


typedef NS_ENUM(NSInteger, MergeBlendingMode){
    MergeBlendingModeNormal = 1,
    MergeBlendingModeDarken,
    MergeBlendingModeScreen,
    MergeBlendingModeMultiply,
    MergeBlendingModeSoftLight,
    MergeBlendingModeHardLight,
    MergeBlendingModeVividLight,
    MergeBlendingModeOverlay,
    MergeBlendingModeExclusion,
    MergeBlendingModeColorBurn,
    MergeBlendingModeColor,
    MergeBlendingModeColorDodge,
    MergeBlendingModeLinearDodge,
    MergeBlendingModeHue,
    MergeBlendingModeSaturation,
    MergeBlendingModeDifference
};

@interface GPUImageEffects : NSObject

@property (nonatomic, weak) UIImage* imageToProcess;

- (UIImage*)process;
- (UIImage*)mergeBaseImage:(UIImage*)baseImage overlayImage:(UIImage*)overlayImage opacity:(CGFloat)opacity blendingMode:(MergeBlendingMode)blendingMode;
- (UIImage*)mergeBaseImage:(UIImage*)baseImage overlayFilter:(GPUImageFilter*)overlayFilter opacity:(CGFloat)opacity blendingMode:(MergeBlendingMode)blendingMode;

@end
