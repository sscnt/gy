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

typedef NS_ENUM(NSInteger, EditorState){
    EditorStateWhiteBalance = 1,
    EditorStateLevels,
    EditorStateSaturation,
    EditorStateSharing
};

@interface EditorViewController : UIViewController <UIScrollViewDelegate>
{
    UIImageView* bgImageView;
    UIScrollView* scrollView;
    UIPageControl* pageControl;
    UIImageView* whitebalanceImageView;
    UIImageView* levelsImageView;
    UIImageView* saturationImageView;
    EditorState state;
}

@property (nonatomic, strong) UIImage* originalImage;

- (void)didClickNextButton;
- (void)didClickBackButton;

- (void)layoutWhiteBalanceEditor;
- (void)layoutLevelsEditor;
- (void)layoutSaturationEditor;

@end
