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

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    [settingsBtn setX:10.0f];
    [settingsBtn setY:10.0f];
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

#pragma mark button events

- (void)didClickCameraBtn
{
    BOOL b = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if(!b){
        return;
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

#pragma mark delegates

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(originalImage, nil, nil, nil);
    }
    [picker.delegate performSelector:@selector(prepareForEditor) withObject:nil];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForEditor
{
    EditorViewController* controller = [[EditorViewController alloc] init];
    controller.originalImage = originalImage;
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:controller animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}
@end
