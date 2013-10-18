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
#import "UIKnobView.h"


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
    UIKnobView* whiteBalanceKnob;
    UIKnobView* levelsKnobView;
    UIKnobView* saturationKnobView;
    UIPanGestureRecognizer* recognizer;
}

@property (nonatomic, strong) UIImage* originalImage;

- (void)didClickNextButton;
- (void)didClickBackButton;
- (void)didDragView:(UIPanGestureRecognizer *)sender;

- (void)layoutWhiteBalanceEditor;
- (void)layoutLevelsEditor;
- (void)layoutSaturationEditor;

- (void)resizeOriginalImage;

@end
