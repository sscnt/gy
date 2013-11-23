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


typedef NS_ENUM(NSInteger, MergeBlendingMode){
    MergeBlendingModeNormal = 1,
    MergeBlendingModeMultiply,
    MergeBlendingModeSoftLight,
    MergeBlendingModeOverlay,
    MergeBlendingModeExclusion,
    MergeBlendingModeHue
};

@interface GPUImageEffects : NSObject

@property (nonatomic, weak) UIImage* imageToProcess;

- (UIImage*)process;
- (UIImage*)mergeBaseImage:(UIImage*)baseImage overlayFilter:(GPUImageFilter*)overlayFilter opacity:(CGFloat)opacity blendingMode:(MergeBlendingMode)blendingMode;

@end
