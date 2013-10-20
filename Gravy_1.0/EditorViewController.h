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
#import "UIWrapperView.h"
#import "UIEditorTitleLabel.h"
#import "UIThumbnailView.h"
#import "UISliderView.h"


typedef NS_ENUM(NSInteger, EditorState){
    EditorStateWhiteBalance = 1,
    EditorStateLevels,
    EditorStateSaturation,
    EditorStateSharing
};

typedef NS_ENUM(NSInteger, KnobId){
    KnobIdWhiteBalance = 1,
    KnobIdLevels,
    KnobIdSaturation
};

@interface EditorViewController : UIViewController <UIScrollViewDelegate>
{
    int hist[256];
    int histLowestValue;
    int histHighestValue;
    int saturationSpline[256];
    int vibranceSpline[361];
    UIImageView* bgImageView;
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    UIThumbnailView* whitebalanceImageView;
    UIThumbnailView* levelsImageView;
    UIThumbnailView* saturationImageView;
    EditorState state;
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

- (void)cancelProcessing;
- (void)processWhiteBalance;
- (void)processLevels;
- (void)processSaturation;

- (void)resizeOriginalImage;
- (void)makeHistogram;

@end
