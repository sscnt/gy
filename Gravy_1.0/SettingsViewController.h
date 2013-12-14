//
//  SettingsViewController.h
//  Gravy_1.0
//
//  Created by SSC on 2013/12/14.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PurchaseManager.h"
#import "UIShareButton.h"
#import "UIEditorTitleLabel.h"
#import "SVProgressHUD.h"
#import "UICloseButton.h"
#import "UIView+Gravy.h"

@interface SettingsViewController : UIViewController <PurchaseManagerDelegate>
{
    PurchaseManager* _purchaseManager;
    UIShareButton* restoreButton;
}
- (void)restore;
- (void)close;

@end
