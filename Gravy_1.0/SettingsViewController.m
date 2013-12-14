//
//  SettingsViewController.m
//  Gravy_1.0
//
//  Created by SSC on 2013/12/14.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithWhite:0.15f alpha:1.0f];
    _purchaseManager = [[PurchaseManager alloc] init];
    _purchaseManager.delegate = self;
    
    // Close
    UICloseButton* closeBtn = [[UICloseButton alloc] init];
    [closeBtn setX:-2.0f];
    [closeBtn setY:-2.0f];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 50.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"In-App Purchase", nil);
    [self.view addSubview:label];
    
    // Buttons
    CGFloat bottom = 80.0f;
    restoreButton = [UIShareButton restore:CGRectMake(40.0f, bottom, 240.0f, 44.0f)];
    restoreButton.type = ButtonTypeTwitter;
    [restoreButton addTarget:self action:@selector(restore) forControlEvents:UIControlEventTouchUpInside];
    [restoreButton setTitle:NSLocalizedString(@"Restore Purchase", nil) forState:UIControlStateNormal];
    [self.view addSubview:restoreButton];
}

- (void)restore
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    [_purchaseManager restore];
}

- (void)close
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void)didRestoreEffect:(EffectId)effectId
{
    
}

- (void)didAllRestorationsFinish
{
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"Done", nil)
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];

}

- (void)didFailToPurchaseWithError:(PurchaseManagerError)error
{
    [SVProgressHUD dismiss];
    NSString* message;
    switch (error) {
        case PurchaseManagerErrorClientInvalid:
            message = NSLocalizedString(@"You are not allowed to perform the attempted action.", nil);
            break;
        case PurchaseManagerErrorIAPNotAllowed:
            message = NSLocalizedString(@"In-App Purchase is not allowed.", nil);
            break;
        case PurchaseManagerErrorInvalidProduct:
            message = NSLocalizedString(@"Invalid product. Please try again.", nil);
            break;
        case PurchaseManagerErrorPaymentCancelled:
            message = NSLocalizedString(@"Cancelled.", nil);
            break;
        case PurchaseManagerErrorPaymentFailed:
            message = NSLocalizedString(@"Purchase failed.", nil);
            break;
        case PurchaseManagerErrorPaymentInvalid:
            message = NSLocalizedString(@"Invalid payment.", nil);
            break;
        case PurchaseManagerErrorPaymentNotAllowed:
            message = NSLocalizedString(@"This device is not allowed to make the payment.", nil);
            break;
        case PurchaseManagerErrorUnknown:
            message = NSLocalizedString(@"Unknown error.", nil);
            break;
        default:
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(message, nil)
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)didFailToRestore
{
    [SVProgressHUD dismiss];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:NSLocalizedString(@"Failed to restore purchase.", nil)
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
