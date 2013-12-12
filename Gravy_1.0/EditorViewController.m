//
//  EditorViewController.m
//  Gravy_1.0
//
//  Created by SSC on 2013/10/15.
//  Copyright (c) 2013年 SSC. All rights reserved.
//

#import "EditorViewController.h"

@interface EditorViewController ()

@end

@implementation EditorViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    editor = [[EditorViewModel alloc] init];
    
    _originalImage = [self fixOrientationOfImage:_originalImage];
    [self resizeOriginalImage];
    [editor applyBrightnessShadowAmount];
    
    processingQueue = dispatch_queue_create("jp.ssctech.gravy.processing", 0);
    state = EditorStateLevels;
    screenHeight = [UIScreen height];
    screenWidth = [UIScreen width];
    
    imageCenterX = [UIScreen screenSize].width / 2.0f;
    imageCenterY = [UIScreen screenSize].height / 2.0f - 25.0f;
    
    //// bg.png
    if(screenHeight >= 568){
        bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"editor_bg-568h.jpg"]];
    }else{
        bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"editor_bg.jpg"]];
    }
    [self.view addSubview:bgImageView];
    
    // layout subviews
    //// scrollview
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(320.0f * 5.0f, self.view.bounds.size.height);
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    //// page control
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, [UIScreen screenSize].height - 80.0f, 320.0f, 20.0f)];
    pageControl.numberOfPages = 5;
    pageControl.currentPage = 0;
    if([UIPageControl instancesRespondToSelector:@selector(currentPageIndicatorTintColor)]){
        pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.7f alpha:1.0f];
    }else{
        pageControl.alpha = 0.7f;
    }
    pageControl.enabled = NO;
    [self.view addSubview:pageControl];
    //// bottom buttons
    UIDockView* dockView  = [[UIDockView alloc] init:UIDockViewTypeDark];
    [dockView setY:[UIScreen screenSize].height - 50.0f];
    [self.view addSubview:dockView];
    ////// camera button
    backBtn = [[UIDockButtonBack alloc] init];
    [backBtn setY:[UIScreen screenSize].height - 45.0f];
    [backBtn addTarget:self action:@selector(didClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setAlpha:0.90f];
    [self.view addSubview:backBtn];
    ////// photos button
    nextBtn = [[UIDockButtonNext alloc] init];
    [nextBtn setY:[UIScreen screenSize].height - 45.0f];
    [nextBtn setX:160.0f];
    [nextBtn setAlpha:0.90f];
    [nextBtn addTarget:self action:@selector(didClickNextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    saveBtn = [[UIDockButtonSave alloc] init];
    [saveBtn setY:[UIScreen screenSize].height - 45.0f];
    [saveBtn setX:160.0f];
    [saveBtn setAlpha:0.90f];
    [saveBtn setHidden:YES];
    [saveBtn addTarget:self action:@selector(didClickNextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
    
    [self layoutLevelsEditor];
    [self layoutWhiteBalanceEditor];
    [self layoutSaturationEditor];
    [self layoutEffectEditor];
    [self layoutShareScreen];
}

#pragma mark layout

- (void)layoutLevelsEditor
{
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    // place original image
    levelsImageView = [[UIThumbnailView alloc] initWithImage:editor.originalImageResized];
    [levelsImageView setCenter:CGPointMake(imageCenterX, imageCenterY)];
    levelsImageView.delegate = self;
    levelsImageView.userInteractionEnabled = YES;
    levelsImageView.thumbnailId = ThumbnailViewIdLevels;
    [wrapper addSubview:levelsImageView];
    
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"Brightness", nil);
    [wrapper addSubview:label];
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    levelsKnobView = [[UISliderView alloc] init];
    levelsKnobView.tag = KnobIdLevels;
    [levelsKnobView addGestureRecognizer:recognizer];
    [levelsKnobView setCenter:levelsImageView.center];
    [wrapper addSubview:levelsKnobView];
        
    [scrollView addSubview:wrapper];
    
    /*
    GPUEffectSpringLight* effect = [[GPUEffectSpringLight alloc] init];
    effect.imageToProcess = editor.originalImageResized;
    levelsImageView.image = [effect process];
     */
    
    
}

- (void)layoutWhiteBalanceEditor
{
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    
    // place original image
    whitebalanceImageView = [[UIThumbnailView alloc] initWithImage:editor.originalImageResized];
    [whitebalanceImageView setCenter:CGPointMake(imageCenterX, imageCenterY)];
    whitebalanceImageView.thumbnailId = ThumbnailViewIdWhiteBalance;
    whitebalanceImageView.delegate = self;
    whitebalanceImageView.userInteractionEnabled = YES;
    [wrapper addSubview:whitebalanceImageView];
    [wrapper setX:[UIScreen screenSize].width];
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"White Balance", nil);
    [wrapper addSubview:label];
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    whiteBalanceKnobView = [[UISliderView alloc] init];
    whiteBalanceKnobView.tag = KnobIdWhiteBalance;
    [whiteBalanceKnobView addGestureRecognizer:recognizer];
    whiteBalanceKnobView.center = whitebalanceImageView.center;
    [wrapper addSubview:whiteBalanceKnobView];
    
    [scrollView addSubview:wrapper];


}


- (void)layoutSaturationEditor
{
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    // place original image
    saturationImageView = [[UIThumbnailView alloc] initWithImage:editor.originalImageResized];
    [saturationImageView setCenter:CGPointMake(imageCenterX, imageCenterY)];
    saturationImageView.delegate = self;
    saturationImageView.userInteractionEnabled = YES;
    saturationImageView.thumbnailId = ThumbnailViewIdSaturation;
    [wrapper addSubview:saturationImageView];
    [wrapper setX:[UIScreen screenSize].width * 2.0f];
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"Saturation", nil);
    [wrapper addSubview:label];

    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    saturationKnobView = [[UISliderView alloc] init];
    saturationKnobView.tag = KnobIdSaturation;
    [saturationKnobView addGestureRecognizer:recognizer];
    saturationKnobView.center = saturationImageView.center;
    [wrapper addSubview:saturationKnobView];
    
    [scrollView addSubview:wrapper];
}

- (void)layoutEffectEditor
{
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    // place original image
    effectImageView = [[UIThumbnailView alloc] initWithImage:editor.originalImageResized];
    [effectImageView setCenter:CGPointMake(imageCenterX, imageCenterY)];
    [effectImageView setCenter:CGPointMake(imageCenterX, imageCenterY)];
    if(effectImageView.center.y + effectImageView.frame.size.height / 2.0f > [UIScreen screenSize].height - 205.0f){
        [effectImageView setY:[UIScreen screenSize].height - 205.0f - effectImageView.bounds.size.height];
    }
    effectImageView.delegate = self;
    effectImageView.userInteractionEnabled = YES;
    effectImageView.thumbnailId = ThumbnailViewIdEffect;
    [wrapper addSubview:effectImageView];
    
    // Libon
    libonImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"libon_test3"]];
    libonImageView.frame = CGRectMake(effectImageView.frame.size.width - 68.0f, 0.0f, libonImageView.frame.size.width, libonImageView.frame.size.height);
    libonImageView.hidden = YES;
    [effectImageView addSubview:libonImageView];
    
    [wrapper setX:[UIScreen screenSize].width * 3.0f];
    
    // Selection Vier
    CGFloat bottom = [UIScreen screenSize].height - 195.0f;
    effectSelectionView = [[UIEffectSelectionView alloc] init];
    //effectSelectionView.effectPreviewImage = effectSelectionPreviewImgae;
    [effectSelectionView setY:bottom];
    effectSelectionView.delegate = self;
    [wrapper addSubview:effectSelectionView];

    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"Effect", nil);
    [wrapper addSubview:label];
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    // knob
    effectKnobView = [[UISliderView alloc] init];
    effectKnobView.tag = KnobIdEffect;
    [effectKnobView addGestureRecognizer:recognizer];
    effectKnobView.center = effectImageView.center;
    effectKnobView.hidden = YES;
    [wrapper addSubview:effectKnobView];
    
    // Buy
    buyButton = [[UIBuyButton alloc] initWithFrame:CGRectMake([UIScreen screenSize].width - 90.0f, label.center.y - 20.0f, 80.0f, 36.0f)];
    [buyButton addTarget:self action:@selector(buyEffect) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setTitle:NSLocalizedString(@"Buy", nil) forState:UIControlStateNormal];
    buyButton.hidden = YES;
    [buyButton setY:bottom - 64.0f];
    [buyButton setX:[UIScreen screenSize].width - 90.0f];
    [wrapper addSubview:buyButton];
    
    UIImageView* buy = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"buy_test"]];
    [buy setY:bottom - 64.0f];
    [buy setX:170.0f];
    
    [scrollView addSubview:wrapper];
}

- (void)layoutShareScreen
{
    
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    [wrapper setX:[UIScreen screenSize].width * 4.0f];
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"Open", nil);
    [wrapper addSubview:label];
    
    // Buttons
    CGFloat bottom = 100.0f;
    UIShareButton* twitter = [UIShareButton twitter:CGRectMake(20.0f, bottom, 280.0f, 44.0f)];
    twitter.type = ButtonTypeTwitter;
    [twitter addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [twitter setTitle:@"Twitter" forState:UIControlStateNormal];
    [wrapper addSubview:twitter];
    bottom += 64.0f;
    
    UIShareButton* facebook = [UIShareButton facebook:CGRectMake(20.0f, bottom, 280.0f, 44.0f)];
    facebook.type = ButtonTypeFacebook;
    [facebook addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [facebook setTitle:@"Facebook" forState:UIControlStateNormal];
    [wrapper addSubview:facebook];
    bottom += 64.0f;
    
    UIShareButton* insta = [UIShareButton instagram:CGRectMake(20.0f, bottom, 280.0f, 44.0f)];
    insta.type = ButtonTypeInstagram;
    [insta addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [insta setTitle:@"Instagram" forState:UIControlStateNormal];
    [wrapper addSubview:insta];
    bottom += 64.0f;
    
    UIShareButton* line = [UIShareButton line:CGRectMake(20.0f, bottom, 280.0f, 44.0f)];
    line.type = ButtonTypeLine;
    [line addTarget:self action:@selector(didClickShareButton:) forControlEvents:UIControlEventTouchUpInside];
    [line setTitle:@"LINE" forState:UIControlStateNormal];
    [wrapper addSubview:line];
    bottom += 64.0f;
    
    [scrollView addSubview:wrapper];
}

- (CGPoint)currentImageCenter
{
    if(state == EditorStateLevels){
        return levelsImageView.center;
    }
    if(state == EditorStateWhiteBalance){
        return whitebalanceImageView.center;
    }
    if(state == EditorStateSaturation){
        return saturationImageView.center;
    }
    if(state == EditorStateEffect){
        return effectImageView.center;
    }
    return self.view.center;
}

#pragma mark events

- (void)didClickNextButton
{
    saveBtn.hidden = YES;
    nextBtn.hidden = NO;
    __block EditorViewController* _self = self;
    
    if (state == EditorStateLevels) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(processingQueue, ^{
            
            [editor applyBrightnessShadowAmount];
            editor.pictureWhiteBalance = nil;
            [editor applyWhiteBalance];
            
            //メインスレッド
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self goToNextPage];
                [SVProgressHUD dismiss];
            });
        });
    } else if (state == EditorStateWhiteBalance) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(processingQueue, ^{
            
            [editor applyWhiteBalance];
            editor.pictureSaturation = nil;
            [editor applySaturation];
            
            //メインスレッド
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self goToNextPage];
                [SVProgressHUD dismiss];
            });
        });
    } else if (state == EditorStateSaturation) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(processingQueue, ^{
            [editor applySaturation];
            [_self createPreviewImage];
            [editor applyCurrentSelectedEffect];
            [editor adjustCurrentSelectedEffect];
            //メインスレッド
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self goToNextPage];
                [SVProgressHUD dismiss];
            });
        });
        
    } else if (state == EditorStateEffect) {
        nextBtn.hidden = YES;
        saveBtn.hidden = NO;
        [self saveImage];
    } else if (state == EditorStateFinishedSaving) {
        state = EditorStateSharing;
        nextBtn.hidden = YES;
        pageControl.currentPage++;
        [self changePageControl];
    }
}

- (void)didClickBackButton
{
    saveBtn.hidden = YES;
    nextBtn.hidden = NO;
    if (state == EditorStateLevels) {
        [self.navigationController popViewControllerAnimated:YES];
        scrollView.delegate = nil;
        return;
    }
    if (state == EditorStateWhiteBalance){
        state = EditorStateLevels;
    } else if (state == EditorStateSaturation){
        state = EditorStateWhiteBalance;
    } else if (state == EditorStateEffect){
        state = EditorStateSaturation;
    } else if (state == EditorStateSharing){
        state = EditorStateEffect;
        nextBtn.hidden = YES;
        saveBtn.hidden = NO; 
    }
    pageControl.currentPage--;
    [self changePageControl];
}

- (void)didClickShareButton:(UIShareButton *)button
{
    NSString *url;
    if(button.type == ButtonTypeTwitter){
        url = @"twitter://post?message=";
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
        if(canOpen){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Twitter not installed.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
    if(button.type == ButtonTypeFacebook){
        url = @"fb://feed";
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
        if(canOpen){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Facebook not installed.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
    if(button.type == ButtonTypeInstagram){
        url = @"instagram://app";
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
        if(canOpen){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"Instagram not installed.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
    if(button.type == ButtonTypeLine){
        url = @"line://msg/text/";
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
        if(canOpen){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        } else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:NSLocalizedString(@"LINE not installed.", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Close", nil) otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
}

- (void)didDragView:(UIPanGestureRecognizer *)sender
{
    float imageHeight_2 = editor.originalImageResized.size.height / 2.0f;
    float imageWidth_2 = editor.originalImageResized.size.width / 2.0f;
    float screenWidth_2 = [UIScreen screenSize].width / 2.0f;
    float ratioX = screenWidth_2 / imageWidth_2;
    float ratioY = screenHeight / editor.originalImageResized.size.height;
    
    UIView* targetView = sender.view;
    CGPoint p = [sender translationInView:targetView];
    CGFloat movePointX = targetView.center.x + p.x;
    CGFloat movePointY = targetView.center.y + p.y;
    CGFloat rest = (screenHeight - 480) * 0.5;
    rest = 0.0f;
    CGPoint center = [self currentImageCenter];
    
    movePointY = MAX(center.y - imageHeight_2 - rest, MIN(center.y + imageHeight_2 + rest,  movePointY));
    movePointX = MAX(center.x - imageWidth_2, MIN(center.x + imageWidth_2, movePointX));
    
    float deltaX = (targetView.center.x - center.x) / screenWidth_2;
    deltaX = MAX(-1.0f, MIN(1.0f, deltaX * ratioX));
    float deltaY = (targetView.center.y - center.y) / screenWidth_2;
    deltaY = MAX(-1.0f, MIN(1.0f, deltaY * ratioY));
    
    if(targetView.tag == KnobIdLevels){
        if(!processingBrightness){
            processingBrightness = YES;
            dispatch_async(processingQueue, ^{
                [editor applyBrightnessShadowAmount:deltaX Radius:deltaY];
                //メインスレッド
                dispatch_async(dispatch_get_main_queue(), ^{
                    [levelsImageView setImage:editor.appliedImageBrightness];
                    processingBrightness = NO;
                });
            });
        }
    } else if(targetView.tag == KnobIdWhiteBalance){
        if(!processingWhiteBalance){
            processingWhiteBalance = YES;
            dispatch_async(processingQueue, ^{
                [editor applyWhiteBalanceAmountRed:deltaX Blue:deltaY];
                //メインスレッド
                dispatch_async(dispatch_get_main_queue(), ^{
                    [whitebalanceImageView setImage:editor.appliedImageWhiteBalancee];
                    processingWhiteBalance = NO;
                });
            });
        }
    } else if(targetView.tag == KnobIdSaturation){
        if(!processingSaturation){
            processingSaturation = YES;
            dispatch_async(processingQueue, ^{
                [editor applySaturationAmount:deltaX Radius:deltaY];
                //メインスレッド
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saturationImageView setImage:editor.appliedImageSaturation];
                    processingSaturation = NO;
                });
            });
            
        }

    } else if(targetView.tag == KnobIdEffect){
        
        if(!processingEffect){
            processingEffect = YES;
            deltaX = MIN(0.9999f, MAX(-0.9999f, deltaX));
            deltaY = MIN(0.9999f, MAX(-0.9999f, deltaY));
            dispatch_async(processingQueue, ^{
                editor.weightLeftBottom = 0.0f;
                editor.weightLeftTop = 0.0f;
                editor.weightRightBottom = 0.0f;
                editor.weightRightTop = 0.0f;
                
                CGFloat k;
                CGFloat cX, cY, d, dr, dX, dY, drX, drY, ratio;
                /*
                 y = -x
                 y + 1.0 = k (x + 1.0)
                 1 - k = (k + 1)x
                 x = (1 - k) / (k + 1)
                 y = -x
                 */
                k = (deltaY + 1.0f) / (deltaX + 1.0f);
                cX = (1.0f - k) / (1.0f + k);
                cY = -cX;
                drX = cX - deltaX;
                drY = cY - deltaY;
                if(cX > deltaX && cY > deltaY){
                    dX = cX + 1.0f;
                    dY = cY + 1.0f;
                    dr = sqrtf(drX * drX + drY * drY);
                    d = sqrtf(dX * dX + dY * dY);
                    ratio = MAX(0.0f, dr / d);
                    editor.weightLeftTop = ratio;
                }
                
                /*
                 y = -x
                 y - 1.0 = k (x - 1.0)
                 k - 1 = (k + 1)x
                 x = (k - 1) / (k + 1)
                 y = -x
                 */
                k = (deltaY - 1.0f) / (deltaX - 1.0f);
                cX = (k - 1.0f) / (1.0f + k);
                cY = -cX;
                drX = cX - deltaX;
                drY = cY - deltaY;
                if(cX < deltaX && cY < deltaY){
                    dX = cX - 1.0f;
                    dY = cY - 1.0f;
                    dr = sqrtf(drX * drX + drY * drY);
                    d = sqrtf(dX * dX + dY * dY);
                    ratio = MAX(0.0f, dr / d);
                    editor.weightRightBottom = ratio;
                }
                
                /*
                 y = x
                 y - 1.0 = k (x + 1.0)
                 -k - 1 = (k - 1)x
                 x = (-k - 1) / (k - 1)
                 y = x
                 */
                k = (deltaY - 1.0f) / (deltaX + 1.0f);
                cX = (-k - 1.0f) / (k - 1.0f);
                cY = cX;
                drX = cX - deltaX;
                drY = cY - deltaY;
                if(cX > deltaX && cY < deltaY){
                    dX = cX + 1.0f;
                    dY = cY - 1.0f;
                    dr = sqrtf(drX * drX + drY * drY);
                    d = sqrtf(dX * dX + dY * dY);
                    ratio = MAX(0.0f, dr / d);
                    editor.weightLeftBottom = ratio;
                }
                
                /*
                 y = x
                 y + 1.0 = k (x - 1.0)
                 k + 1 = (k - 1)x
                 x = (k + 1) / (k - 1)
                 y = x
                 */
                k = (deltaY + 1.0f) / (deltaX - 1.0f);
                cX = (k + 1.0f) / (k - 1.0f);
                cY = cX;
                drX = cX - deltaX;
                drY = cY - deltaY;
                if(cX < deltaX && cY > deltaY){
                    dX = cX + 1.0f;
                    dY = cY - 1.0f;
                    dr = sqrtf(drX * drX + drY * drY);
                    d = sqrtf(dX * dX + dY * dY);
                    ratio = MAX(0.0f, dr / d);
                    editor.weightRightTop = ratio;
                }

                [editor adjustCurrentSelectedEffect];
                
                //メインスレッド
                dispatch_async(dispatch_get_main_queue(), ^{
                    [effectImageView setImage:editor.appliedImageEffect];
                    processingEffect = NO;
                });
            });
            
        }
    }
    
    
    CGPoint movedPoint = CGPointMake(movePointX, movePointY);
    targetView.center = movedPoint;
    [sender setTranslation:CGPointZero inView:targetView];
    
    
}

- (void)goToNextPage
{
    if(state == EditorStateLevels){
        [whitebalanceImageView setImage:editor.appliedImageWhiteBalancee];
        editor.adjustmentsBrightness = nil;
        state = EditorStateWhiteBalance;
    } else if(state == EditorStateWhiteBalance){
        [saturationImageView setImage:editor.appliedImageSaturation];
        editor.adjustmentsWhiteBalance = nil;
        state = EditorStateSaturation;
    } else if(state == EditorStateSaturation){
        if(!editor.appliedImageEffect){
            editor.appliedImageEffect = editor.appliedImageSaturation;
        }
        effectSelectionView.effectPreviewImage = effectSelectionPreviewImgae;
        [effectImageView setImage:editor.appliedImageEffect];
        [effectSelectionView highlightButton:editor.currentSelectedEffectId];
        editor.adjustmentsSaturation = nil;
        state = EditorStateEffect;
        saveBtn.hidden = NO;
        nextBtn.hidden = YES;
    }
    pageControl.currentPage++;
    [self changePageControl];
}

#pragma mark delegates

- (void)touchesBegan:(UIThumbnailView *)view
{
    view.image = editor.originalImageResized;
}

- (void)touchesEnded:(UIThumbnailView *)view
{
    if(view.thumbnailId == ThumbnailViewIdWhiteBalance){
        view.image = editor.appliedImageWhiteBalancee;
        return;
    }
    if(view.thumbnailId == ThumbnailViewIdLevels){
        view.image = editor.appliedImageBrightness;
        return;
    }
    if(view.thumbnailId == ThumbnailViewIdSaturation){
        view.image = editor.appliedImageSaturation;
        return;
    }
    if(view.thumbnailId == ThumbnailViewIdEffect){
        view.image = editor.appliedImageEffect;
        return;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
    // UIScrollViewのページ切替時イベント:UIPageControlの現在ページを切り替える処理
    //pageControl.currentPage = sender.contentOffset.x / 320.0f;
}

- (void)changePageControl {
    // ページコントロールが変更された場合、それに合わせてページングスクロールビューを該当ページまでスクロールさせる
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
    // 可視領域まで移動
    [scrollView scrollRectToVisible:frame animated:YES];
}
- (void)effectSelected:(EffectId)effectId
{
    if(effectId == EffectIdNone){
        editor.currentSelectedEffectId = effectId;
        [editor applyCurrentSelectedEffect];
        effectKnobView.hidden = YES;
        [effectImageView setImage:editor.appliedImageEffect];
        return;
    }
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    editor.currentSelectedEffectId = effectId;
    dispatch_async(processingQueue, ^{
        [editor applyCurrentSelectedEffect];

        //メインスレッド
        dispatch_async(dispatch_get_main_queue(), ^{
            [effectImageView setImage:editor.appliedImageEffect];
            effectKnobView.hidden = NO;
            effectKnobView.center = effectImageView.center;
            if([PurchaseManager didPurchaseEffectId:editor.currentSelectedEffectId]){
                saveBtn.hidden = NO;
                libonImageView.hidden = YES;
                buyButton.hidden = YES;
            } else {
                saveBtn.hidden = YES;
                libonImageView.hidden = NO;
                buyButton.hidden = NO;
            }
            [SVProgressHUD dismiss];
        });
    });
}

#pragma mark Image Processing

- (void)resizeOriginalImage
{
    if(self.originalImage){
        BOOL portrait = NO;
        if(self.originalImage.size.height > self.originalImage.size.width){
            portrait = YES;
        }
        UIScreen *mainScreen = [UIScreen mainScreen];
        CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
        
        CIImage* ciImage = [[CIImage alloc] initWithImage:self.originalImage];
        
        CGFloat areaHeight = [UIScreen screenSize].height - 205.0f;
        CGFloat baseWidth = [UIScreen screenSize].width;
        CGFloat zoom;
        if(portrait){
            zoom = areaHeight * scale / self.originalImage.size.height;
        } else{
            zoom = baseWidth * scale / self.originalImage.size.width;
        }
        CIImage* filteredImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(zoom, zoom)];
        editor.originalImageResized = [self uiImageFromCIImage:filteredImage];
        [editor initialize];
        editor.avarageLuminosity = [self detectImageBrightness:editor.originalImageResized];

        
    }
}

- (void)createPreviewImage
{
    UIImage *sourceA = editor.appliedImageSaturation;
    CIImage *sourceImage = [[CIImage alloc] initWithCGImage:sourceA.CGImage];
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    
    // 新しい画像サイズ
    CGSize newSize = CGSizeMake(70.0f * scale, 70.0f * scale);
    
    // ソーズ画像のサイズと、新しいサイズの比率計算
    CGFloat min = MIN(editor.appliedImageSaturation.size.width, editor.appliedImageSaturation.size.height);
    CGPoint scales = CGPointMake(newSize.width / min,
                                newSize.width / min);
    
    // AffineTransformでサイズを変更し、切り抜く
    CIImage *filteredImage = [sourceImage imageByApplyingTransform:CGAffineTransformMakeScale(scales.x,scales.y)];
    filteredImage = [filteredImage imageByCroppingToRect:CGRectMake(0, 0, newSize.width,newSize.height)];
    
    // UIImageに変換する
    CIContext *ciContext = [CIContext contextWithOptions:[NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO]
                                                                                     forKey:kCIContextUseSoftwareRenderer]];
    
    CGImageRef imageRef = [ciContext createCGImage:filteredImage fromRect:[filteredImage extent]];
    UIImage *resizedImage  = [UIImage imageWithCGImage:imageRef scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);
    effectSelectionPreviewImgae = resizedImage;
    /*
    UIScreen *mainScreen = [UIScreen mainScreen];
    CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
    CGFloat cropSize = MIN(editor.appliedImageSaturation.size.width, editor.appliedImageSaturation.size.height) * scale;
    CGRect clippedRect = CGRectMake(0, 0, cropSize, cropSize);
    CGImageRef imageRef = CGImageCreateWithImageInRect(editor.appliedImageSaturation.CGImage, clippedRect);
    UIImage* resizedImage = [UIImage imageWithCGImage:imageRef];
    
    CIImage* ciImage = [[CIImage alloc] initWithImage:resizedImage];
    CGFloat zoom = 70.0f * scale / resizedImage.size.width;
    CIImage* filteredImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(zoom, zoom)];
    resizedImage = [self uiImageFromCIImage:filteredImage];
    CGImageRelease(imageRef);
    effectSelectionPreviewImgae = resizedImage;
     */
}

- (float)detectImageBrightness:(UIImage *)inputImage
{
    float avaBrightness = 0.0f;
    
    // CGImageを取得する
    CGImageRef  cgImage = inputImage.CGImage;
    
    // 画像情報を取得する
    size_t                  width;
    size_t                  height;
    size_t                  bitsPerComponent;
    size_t                  bitsPerPixel;
    size_t                  bytesPerRow;
    CGColorSpaceRef         colorSpace;
    CGBitmapInfo            bitmapInfo;
    bool                    shouldInterpolate;
    CGColorRenderingIntent  intent;
    width = CGImageGetWidth(cgImage);
    height = CGImageGetHeight(cgImage);
    bitsPerComponent = CGImageGetBitsPerComponent(cgImage);
    bitsPerPixel = CGImageGetBitsPerPixel(cgImage);
    bytesPerRow = CGImageGetBytesPerRow(cgImage);
    colorSpace = CGImageGetColorSpace(cgImage);
    bitmapInfo = CGImageGetBitmapInfo(cgImage);
    shouldInterpolate = CGImageGetShouldInterpolate(cgImage);
    intent = CGImageGetRenderingIntent(cgImage);
    
    
    // データプロバイダを取得する
    CGDataProviderRef   dataProvider;
    dataProvider = CGImageGetDataProvider(cgImage);
    
    // ビットマップデータを取得する
    CFDataRef   data;
    UInt8*      buffer;
    data = CGDataProviderCopyData(dataProvider);
    buffer = (UInt8*)CFDataGetBytePtr(data);
    
    // ビットマップに効果を与える
    UInt8   r, g, b;
    NSUInteger  i, j;
    for (j = 0; j < height; j++) {
        for (i = 0; i < width; i++) {
            // ピクセルのポインタを取得する
            UInt8*  tmp;
            tmp = buffer + j * bytesPerRow + i * 4;
            
            // RGBの値を取得する
            r = *(tmp + 3);
            g = *(tmp + 2);
            b = *(tmp + 1);
            
            avaBrightness += r * 0.216f * 0.00392156862f + g * 0.7152f * 0.00392156862f + b * 0.0722 * 0.00392156862f;

        }
    }
    
    avaBrightness /= height * width;
    
    //CGDataProviderRelease(dataProvider);
    //CFRelease(data);
    
    dlog(@"ava: %f", avaBrightness);
    
    return avaBrightness;
}

- (UIImage *)fixOrientationOfImage:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage*)uiImageFromCIImage:(CIImage*)ciImage
{
    CIContext *ciContext = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @NO }];
    CGImageRef imgRef = [ciContext createCGImage:ciImage fromRect:[ciImage extent]];
    UIImage *newImg  = [UIImage imageWithCGImage:imgRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef);
    return newImg;
    
    /* iOS6.0以降だと以下が使用可能 */
    //  [[UIImage alloc] initWithCIImage:ciImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
}


- (void)saveImage
{
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
    __weak EditorViewController* _self = self;
    dispatch_async(processingQueue, ^{
        
        UIImage* resultImage;
        
        @autoreleasepool {
            resultImage = [editor executeBrightnessShadow:self.originalImage];
            
        }
        @autoreleasepool {
            resultImage = [editor executeWhiteBalance:resultImage];
            
        }
        @autoreleasepool {
            resultImage = [editor executeSaturation:resultImage];
            
        }
        if([PurchaseManager didPurchaseEffectId:editor.currentSelectedEffectId]){
            @autoreleasepool {
                resultImage = [editor executeCurrentSelectedEffectWithWeight:resultImage];
            }
        }
        
        /*
        
        GPUEffectSpringLight* effect = [[GPUEffectSpringLight alloc] init];
        effect.imageToProcess = self.originalImage;
        resultImage = [effect process];

        */
                
        
        UIImageWriteToSavedPhotosAlbum(resultImage, nil, nil, nil);
        
        
        //メインスレッド
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Saved successfully", nil)];
            state = EditorStateFinishedSaving;
            [_self didClickNextButton];
        });
    });
    
}

#pragma mark in app purchase

- (void)buyEffect
{
    
}

- (void)dealloc
{
    scrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
