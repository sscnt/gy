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
    
    [self resizeOriginalImage];
    
    processingQueue = dispatch_queue_create("jp.ssctech.gravy.processing", 0);
    state = EditorStateLevels;
    screenHeight = [UIScreen height];
    screenWidth = [UIScreen width];
    
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
}

#pragma mark layout

- (void)layoutLevelsEditor
{
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"Brightness", nil);
    [wrapper addSubview:label];
    
    // place original image
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - editor.originalImageResized.size.height / 2.0f - 25.0f;
    levelsImageView = [[UIThumbnailView alloc] initWithImage:editor.originalImageResized];
    [levelsImageView setY:imageY];
    levelsImageView.delegate = self;
    levelsImageView.userInteractionEnabled = YES;
    levelsImageView.thumbnailId = ThumbnailViewIdLevels;
    [wrapper addSubview:levelsImageView];
    
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    levelsKnobView = [[UISliderView alloc] init];
    levelsKnobView.tag = KnobIdLevels;
    [levelsKnobView addGestureRecognizer:recognizer];
    knobDefaultCenterX = [UIScreen screenSize].width / 2.0f;
    knobDefaultCenterY = imageY + editor.originalImageResized.size.height / 2.0f;
    CGPoint center = CGPointMake(knobDefaultCenterX, knobDefaultCenterY);
    levelsKnobView.center = center;
    [wrapper addSubview:levelsKnobView];
    
    
    [scrollView addSubview:wrapper];
    
}

- (void)layoutWhiteBalanceEditor
{
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"White Balance", nil);
    [wrapper addSubview:label];
    
    // place original image
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - editor.originalImageResized.size.height / 2.0f - 25.0f;
    whitebalanceImageView = [[UIThumbnailView alloc] initWithImage:editor.originalImageResized];
    [whitebalanceImageView setY:imageY];
    whitebalanceImageView.thumbnailId = ThumbnailViewIdWhiteBalance;
    whitebalanceImageView.delegate = self;
    whitebalanceImageView.userInteractionEnabled = YES;
    [wrapper addSubview:whitebalanceImageView];
    [wrapper setX:320.0f];
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    whiteBalanceKnobView = [[UISliderView alloc] init];
    whiteBalanceKnobView.tag = KnobIdWhiteBalance;
    [whiteBalanceKnobView addGestureRecognizer:recognizer];
    CGPoint center = CGPointMake(knobDefaultCenterX, knobDefaultCenterY);
    whiteBalanceKnobView.center = center;
    [wrapper addSubview:whiteBalanceKnobView];
    
    [scrollView addSubview:wrapper];
}


- (void)layoutSaturationEditor
{
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"Saturation", nil);
    [wrapper addSubview:label];
    
    // place original image
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - editor.originalImageResized.size.height / 2.0f - 25.0f;
    saturationImageView = [[UIThumbnailView alloc] initWithImage:editor.originalImageResized];
    [saturationImageView setY:imageY];
    saturationImageView.delegate = self;
    saturationImageView.userInteractionEnabled = YES;
    saturationImageView.thumbnailId = ThumbnailViewIdSaturation;
    [wrapper addSubview:saturationImageView];
    [wrapper setX:640.0f];
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    saturationKnobView = [[UISliderView alloc] init];
    saturationKnobView.tag = KnobIdSaturation;
    [saturationKnobView addGestureRecognizer:recognizer];
    CGPoint center = CGPointMake(knobDefaultCenterX, knobDefaultCenterY);
    saturationKnobView.center = center;
    [wrapper addSubview:saturationKnobView];
    
    [scrollView addSubview:wrapper];
}

- (void)layoutEffectEditor
{
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"Effect", nil);
    [wrapper addSubview:label];
    
    // place original image
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - editor.originalImageResized.size.height / 2.0f - 25.0f;
    effectImageView = [[UIThumbnailView alloc] initWithImage:editor.originalImageResized];
    [effectImageView setY:imageY];
    effectImageView.delegate = self;
    effectImageView.userInteractionEnabled = YES;
    effectImageView.thumbnailId = ThumbnailViewIdEffect;
    [wrapper addSubview:effectImageView];
    [wrapper setX:960.0f];
    
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    effectKnobView = [[UISliderView alloc] init];
    effectKnobView.tag = KnobIdEffect;
    [effectKnobView addGestureRecognizer:recognizer];
    CGPoint center = CGPointMake(knobDefaultCenterX, knobDefaultCenterY);
    effectKnobView.center = center;
    [wrapper addSubview:effectKnobView];
    
    [scrollView addSubview:wrapper];
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
            [editor applyWhiteBalance];
            
            //メインスレッド
            dispatch_async(dispatch_get_main_queue(), ^{
                [whitebalanceImageView setImage:editor.appliedImageWhiteBalancee];
                editor.pictureWhiteBalance = nil;
                [SVProgressHUD dismiss];
                state = EditorStateWhiteBalance;
                pageControl.currentPage++;
                [_self changePageControl];
            });
        });
    } else if (state == EditorStateWhiteBalance) {
    } else if (state == EditorStateSaturation) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [pictureSaturation processImage];
        effectAppliedImage = [imageFilterSaturation imageFromCurrentlyProcessedOutput];
        pictureEffect = [[GPUImagePicture alloc] initWithImage:effectAppliedImage];
        [effectImageView setImage:effectAppliedImage];

        
        dispatch_async(processingQueue, ^{
            
            GPUAdjustmentsBrightness* brightness = [[GPUAdjustmentsBrightness alloc] init];
            pictureEffect = [[GPUImagePicture alloc] initWithImage:effectAppliedImage];
            [pictureEffect addTarget:brightness];
            [pictureEffect processImage];
            effectAppliedImage = [brightness imageFromCurrentlyProcessedOutput];
            
            /*
            GPUEffectSweetFlower* sweetflower = [[GPUEffectSweetFlower alloc] init];
            sweetflower.imageToProcess = effectAppliedImage;
            effectAppliedImage = [sweetflower process];
            
            GPUEffectSoftPop* softpop = [[GPUEffectSoftPop alloc] init];
            softpop.imageToProcess = effectAppliedImage;
            effectAppliedImage = [softpop process];
         
            GPUEffectColorfulCandy* candy = [[GPUEffectColorfulCandy alloc] init];
            candy.imageToProcess = effectAppliedImage;
            effectAppliedImage = [candy process];
   
            GPUEffectHaze3* haze = [[GPUEffectHaze3 alloc] init];
            haze.imageToProcess = effectAppliedImage;
            effectAppliedImage = [haze process];
            */
            
            //メインスレッド
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [effectImageView setImage:effectAppliedImage];
                nextBtn.hidden = YES;
                saveBtn.hidden = NO;
                state = EditorStateEffect;
                pageControl.currentPage++;
                [_self changePageControl];
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
        state = EditorStateSaturation;
        nextBtn.hidden = YES;
        saveBtn.hidden = NO; 
    }
    pageControl.currentPage--;
    [self changePageControl];
}

- (void)didDragView:(UIPanGestureRecognizer *)sender
{
    UIView *targetView = sender.view;
    CGPoint p = [sender translationInView:targetView];
    CGFloat movePointX = targetView.center.x + p.x;
    CGFloat movePointY = targetView.center.y + p.y;
    CGFloat rest = (screenHeight - 480) * 0.5;
    movePointY = MAX(knobDefaultCenterY - screenWidth * 0.5 - rest, MIN(knobDefaultCenterY + screenWidth * 0.5 + rest,  movePointY));
    movePointX = MAX(0, MIN(screenWidth, movePointX));
    
    float screenWidth_2 = [UIScreen screenSize].width / 2.0f;
    float deltaX = (targetView.center.x - knobDefaultCenterX) / screenWidth_2;
    deltaX = MAX(-1.0f, MIN(1.0f, deltaX));
    float deltaY = (targetView.center.y - knobDefaultCenterY) / screenWidth_2;
    deltaY = MAX(-1.0f, MIN(1.0f, deltaY));
    
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
            dispatch_async(processingQueue, ^{
                [editor applyWhiteBalanceAmountRed:deltaX Blue:deltaY];
                //メインスレッド
                dispatch_async(dispatch_get_main_queue(), ^{
                    [whitebalanceImageView setImage:editor.appliedImageWhiteBalancee];
                });
            });
        }
    } else if(targetView.tag == KnobIdSaturation){
        float stWeight = targetView.center.x - knobDefaultCenterX;
        float vbWeight = targetView.center.y - knobDefaultCenterY;
        
        stWeight *= -0.00625;
        vbWeight *= 0.00625;
        
        imageFilterSaturation.stSaturationWeight = stWeight;
        imageFilterSaturation.stVibranceWeight = vbWeight;
        [pictureSaturation processImage];
        
        saturationAppliedImage = [imageFilterSaturation imageFromCurrentlyProcessedOutput];
        [saturationImageView setImage:saturationAppliedImage];

    } else if(targetView.tag == KnobIdEffect){

    }
    
    
    CGPoint movedPoint = CGPointMake(movePointX, movePointY);
    targetView.center = movedPoint;
    [sender setTranslation:CGPointZero inView:targetView];
    
    
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

#pragma mark Image Processing

- (void)resizeOriginalImage
{
    if(self.originalImage){
        CIImage* ciImage = [[CIImage alloc] initWithImage:self.originalImage];
        UIScreen *mainScreen = [UIScreen mainScreen];
        CGFloat scale = ([mainScreen respondsToSelector:@selector(scale)] ? mainScreen.scale : 1.0f);
        CGFloat zoom = [UIScreen screenSize].width * scale / self.originalImage.size.width;
        CIImage* filteredImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(zoom, zoom)];
        editor.originalImageResized = [self uiImageFromCIImage:filteredImage];
    }
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
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:_originalImage];

        GPUAdjustmentsWhiteBalance* filterWb = [[GPUAdjustmentsWhiteBalance alloc] init];
        filterWb.redWeight = imageFilterWhiteBalance.redWeight;
        filterWb.blueWeight = imageFilterWhiteBalance.blueWeight;

        GPULevelsImageFilter* filterLv = [[GPULevelsImageFilter alloc] init];
        filterLv.lvHighWeight = imageFilterLevels.lvHighWeight;
        filterLv.lvMidWeight = imageFilterLevels.lvMidWeight;
        filterLv.lvLowWeight = imageFilterLevels.lvLowWeight;
        [filterWb addTarget:filterLv];
        GPUAdjustmentsSaturation* filterSt = [[GPUAdjustmentsSaturation alloc] init];
        filterSt.stSaturationWeight = imageFilterSaturation.stSaturationWeight;
        filterSt.stVibranceWeight = imageFilterSaturation.stVibranceWeight;
        [filterLv addTarget:filterSt];
    
        [picture addTarget:filterWb];
        [picture processImage];
        resultImage = [filterSt imageFromCurrentlyProcessedOutput];
        
        GPUEffectSweetFlower* sweetflower = [[GPUEffectSweetFlower alloc] init];
        sweetflower.imageToProcess = resultImage;
        resultImage = [sweetflower process];
        
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
