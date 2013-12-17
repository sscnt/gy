//
//  ViewController.h
//  Gravy_1.0
//
//  Created by SSC on 2013/10/14.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIScreen+Gravy.h"
#import "UIView+Gravy.h"
#import "UIDockView.h"
#import "UIDockButtonCamera.h"
#import "UIDockButtonPhotos.h"
#import "UISettingsButton.h"
#import "EditorViewController.h"
#import "SettingsViewController.h"

@interface TopViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIImageView* defaultImageView;
    UIImageView* bgImageView;
    UIImageView* editorBgView;
    UIImage* originalImage;
}

- (void)didClickCameraBtn;
- (void)didClickPhotosBtn;
- (void)didClickSettingsBtn;

- (void)prepareForEditor;

- (void)showErrorAlertWithMessage:(NSString*)message;

@end
