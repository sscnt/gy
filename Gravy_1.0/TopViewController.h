//
//  ViewController.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/14.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScreen+Gravy.h"
#import "UIView+Gravy.h"
#import "UIDockView.h"
#import "UIDockButtonCamera.h"
#import "UIDockButtonPhotos.h"
#import "UISettingsButton.h"
#import "EditorViewController.h"

@interface TopViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImageView* defaultImageView;
    UIImageView* bgImageView;
    UIImageView* editorBgView;
    __weak UIImage* originalImage;
}

- (void)didClickCameraBtn;
- (void)didClickPhotosBtn;

- (void)prepareForEditor;

@end
