//
//  EditorViewController.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>
#import "EditorViewModel.h"
#import "UIScreen+Gravy.h"
#import "UIView+Gravy.h"
#import "UIDockView.h"
#import "UIDockButtonBack.h"
#import "UIDockButtonNext.h"
#import "UIDockButtonSave.h"
#import "UIWrapperView.h"
#import "UIEditorTitleLabel.h"
#import "UIThumbnailView.h"
#import "UISliderView.h"
#import "UIScrollView+Gravy.h"
#import "SVProgressHUD.h"
#import "UIEffectSelectionView.h"

#import "GPUImage.h"
#import "GPUAdjustmentsWhiteBalance.h"
#import "GPULevelsImageFilter.h"
#import "GPUAdjustmentsSaturation.h"
#import "GPUAdjustmentsBrightness.h"

#import "GPUEffectHaze3.h"
#import "GPUEffectColorfulCandy.h"
#import "GPUEffectSoftPop.h"
#import "GPUEffectSweetFlower.h"

typedef NS_ENUM(NSInteger, EditorState){
    EditorStateLevels = 1,
    EditorStateWhiteBalance,
    EditorStateSaturation,
    EditorStateEffect,
    EditorStateSharing,
    EditorStateFinishedSaving
};

typedef NS_ENUM(NSInteger, KnobId){
    KnobIdWhiteBalance = 1,
    KnobIdLevels,
    KnobIdSaturation,
    KnobIdEffect
};

@interface EditorViewController : UIViewController <UIScrollViewDelegate, UIThumbnailViewDelegate, UIEffectSelectionViewDelegate>
{
    EditorViewModel* editor;    
    
    BOOL processingBrightness;
    BOOL processingWhiteBalance;
    BOOL processingSaturation;

    UIImage* effectSelectionPreviewImgae;
    UIEffectSelectionView* effectSelectionView;

    UIImageView* bgImageView;
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    UIThumbnailView* whitebalanceImageView;
    UIThumbnailView* levelsImageView;
    UIThumbnailView* saturationImageView;
    UIThumbnailView* effectImageView;
    EditorState state;
    UIDockButtonBack* backBtn;
    UIDockButtonNext* nextBtn;
    UIDockButtonSave* saveBtn;
    __strong UIImage** iad;
    UISliderView* whiteBalanceKnobView;
    UISliderView* levelsKnobView;
    UISliderView* saturationKnobView;
    UISliderView* effectKnobView;
    CGFloat knobDefaultCenterX;
    CGFloat knobDefaultCenterY;
    CGFloat screenWidth;
    CGFloat screenHeight;
    dispatch_queue_t processingQueue;
    
}

@property (nonatomic, strong) UIImage* originalImage;

- (void)didClickNextButton;
- (void)didClickBackButton;
- (void)didDragView:(UIPanGestureRecognizer *)sender;

- (void)goToNextPage;

- (void)layoutWhiteBalanceEditor;
- (void)layoutLevelsEditor;
- (void)layoutSaturationEditor;
- (void)layoutEffectEditor;
- (void)saveImage;

- (void)resizeOriginalImage;

@end
