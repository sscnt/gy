//
//  ViewController.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/14.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "TopViewController.h"

@interface TopViewController ()

@end

@implementation TopViewController

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
	// Do any additional setup after loading the view, typically from a nib.
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    //// bg.png
    if([UIScreen height] >= 568){
        bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-568h.jpg"]];
    }else{
        bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.jpg"]];
    }
    [self.view addSubview:bgImageView];
    
    //// layout subviews
    //////// bottom buttons
    UIDockView* dockView  = [[UIDockView alloc] init:UIDockViewTypeLight];
    [dockView setY:[UIScreen screenSize].height - 50.0f];
    [self.view addSubview:dockView];
    //////////// camera button
    UIDockButtonCamera* cameraBtn = [[UIDockButtonCamera alloc] init];
    [cameraBtn setY:[UIScreen screenSize].height - 45.0f];
    [cameraBtn addTarget:self action:@selector(didClickCameraBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraBtn];
    //////////// photos button
    UIDockButtonPhotos* photoBtn = [[UIDockButtonPhotos alloc] init];
    [photoBtn setY:[UIScreen screenSize].height - 45.0f];
    [photoBtn setX:160.0f];
    [photoBtn addTarget:self action:@selector(didClickPhotosBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoBtn];
    //////////// settings button
    UISettingsButton* settingsBtn = [[UISettingsButton alloc] init];
    [settingsBtn setX:-2.0f];
    [settingsBtn setY:-2.0f];
    [settingsBtn addTarget:self action:@selector(didClickSettingsBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingsBtn];
    
    //////// labels
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 20.0f)];
    label.font = [UIFont fontWithName:@"rounded-mplus-1p-light" size:15.0f];
    label.alpha = 0.9f;
    label.text = NSLocalizedString(@"Subtitle", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    [label setY:[UIScreen screenSize].height - 150.0f];
    //[self.view addSubview:label];

    if([UIScreen height] >= 568){
        defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default-568h.png"]];
    }else{
        defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Default.png"]];
    }
    [self.view addSubview:defaultImageView];
    [UIView animateWithDuration:1.0f
                     animations:^{
                         [defaultImageView setAlpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         [defaultImageView removeFromSuperview];

                     }];

}
- (void)showErrorAlertWithMessage:(NSString *)message
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                                    message:NSLocalizedString(message, nil)
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

#pragma mark button events

- (void)didClickCameraBtn
{
    BOOL b = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if(!b){
        [self showErrorAlertWithMessage:@"Camera is not available."];
        return;
    }
    
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0f){;
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusNotDetermined){
            
        } else if (status == ALAuthorizationStatusRestricted){
            [self showErrorAlertWithMessage:@"no_access_due_to_parental_controls"];
            return;
        } else if (status == ALAuthorizationStatusDenied){
            [self showErrorAlertWithMessage:@"no_access_to_your_photos"];
            return;
        } else if (status == ALAuthorizationStatusAuthorized){

        }
    }
    
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [pickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    pickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)didClickPhotosBtn
{
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    [pickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    pickerController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:pickerController animated:YES completion:nil];
}

- (void)didClickSettingsBtn
{
    SettingsViewController* controller = [[SettingsViewController alloc] init];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(!originalImage){
        __weak TopViewController* _self = self;
        NSURL* imageurl = [info objectForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
        [library assetForURL:imageurl
                 resultBlock: ^(ALAsset *asset)
         {
             ALAssetRepresentation *representation;
             representation = [asset defaultRepresentation];
             originalImage = [[UIImage alloc] initWithCGImage:representation.fullResolutionImage];
             [_self prepareForEditor];
         }
                failureBlock:^(NSError *error)
         {
             NSLog(@"error:%@", error);
         }];
    } else {
        if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
            UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
        }
        //[picker.delegate performSelector:@selector(prepareForEditor) withObject:nil];
        [self prepareForEditor];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForEditor
{
    EditorViewController* controller = [[EditorViewController alloc] init];
    controller.originalImage = originalImage;
    originalImage = nil;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:controller animated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
