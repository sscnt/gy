//
//  ViewController.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/14.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

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
    UIDockView* bottomButtonsView  = [[UIDockView alloc] init];
    [bottomButtonsView setY:[UIScreen screenSize].height - 50.0f];
    [self.view addSubview:bottomButtonsView];
    //////////// camera button
    UIDockButtonCamera* cameraBtn = [[UIDockButtonCamera alloc] init];
    [cameraBtn setY:[UIScreen screenSize].height - 45.0f];
    [self.view addSubview:cameraBtn];
    //////////// photos button
    UIDockButtonPhotos* photoBtn = [[UIDockButtonPhotos alloc] init];
    [photoBtn setY:[UIScreen screenSize].height - 45.0f];
    [photoBtn setX:160.0f];
    [self.view addSubview:photoBtn];
    
    //////// labels
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 20.0f)];
    label.font = [UIFont fontWithName:@"rounded-mplus-1p-light" size:16.0f];
    label.alpha = 0.9f;
    label.text = NSLocalizedString(@"Subtitle", nil);
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    label.numberOfLines = 0;
    [label setY:[UIScreen screenSize].height - 150.0f];
    [self.view addSubview:label];
    
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
