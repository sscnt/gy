//
//  EditorViewController.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/CALayer.h>
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


typedef NS_ENUM(NSInteger, EditorState){
    EditorStateWhiteBalance = 1,
    EditorStateLevels,
    EditorStateSaturation,
    EditorStateSharing,
    EditorStateFinishedSaving
};

typedef NS_ENUM(NSInteger, KnobId){
    KnobIdWhiteBalance = 1,
    KnobIdLevels,
    KnobIdSaturation
};

@interface EditorViewController : UIViewController <UIScrollViewDelegate, UIThumbnailViewDelegate>
{
    int hist[256];
    int histLowestValue;
    int histHighestValue;
    int saturationSpline[256];
    float vibranceSpline[361];
    UIImageView* bgImageView;
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    UIThumbnailView* whitebalanceImageView;
    UIThumbnailView* levelsImageView;
    UIThumbnailView* saturationImageView;
    EditorState state;
    UIDockButtonBack* backBtn;
    UIDockButtonNext* nextBtn;
    UIDockButtonSave* saveBtn;
    __strong UIImage** iad;
    UIImage* originalImageResized;
    UIImage* whiteBalanceAppliedImage;
    UIImage* levelsAppliedImage;
    UIImage* saturationAppliedImage;
    UISliderView* whiteBalanceKnobView;
    UISliderView* levelsKnobView;
    UISliderView* saturationKnobView;
    CGFloat knobDefaultCenterX;
    CGFloat knobDefaultCenterY;
    CGFloat screenWidth;
    CGFloat screenHeight;
    
    NSInteger wbRedWeight;
    NSInteger wbBlueWeight;
    NSInteger lvHighWeight;
    NSInteger lvMidWeight;
    NSInteger lvLowWeight;
    NSInteger stSaturationWeight;
    NSInteger stVibranceWeight;
    
    BOOL processRunning;
    BOOL dragStarted;
}

@property (nonatomic, strong) UIImage* originalImage;

- (void)didClickNextButton;
- (void)didClickBackButton;
- (void)didDragView:(UIPanGestureRecognizer *)sender;

- (void)layoutWhiteBalanceEditor;
- (void)layoutLevelsEditor;
- (void)layoutSaturationEditor;

- (void)processWhiteBalanceAsync;
- (void)processWhiteBalance:(UIImage* __strong *)sourceImage applyTo:(UIImage* __strong *)destImage;
- (void)processLevelsAsync;
- (void)processLevels:(UIImage* __strong *)sourceImage applyTo:(UIImage* __strong *)destImage;
- (void)processSaturationAsync;
- (void)processSaturation:(UIImage* __strong *)sourceImage applyTo:(UIImage* __strong *)destImage;
- (void)saveImage;

- (void)resizeOriginalImage;
- (void)makeHistogram;

@end
