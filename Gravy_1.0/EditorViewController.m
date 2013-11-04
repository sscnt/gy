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
    
    [self resizeOriginalImage];
    imageFilterWhiteBalance = [[GPUWhitebalanceImageFilter alloc] init];
    pictureWhiteBalance = [[GPUImagePicture alloc] initWithImage:originalImageResized];
    [pictureWhiteBalance addTarget:imageFilterWhiteBalance];
    
    processingQueue = dispatch_queue_create("jp.ssctech.gravy.processing", 0);
    state = EditorStateWhiteBalance;
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
    
    whiteBalanceAppliedImage = originalImageResized;
    levelsAppliedImage = originalImageResized;
    saturationAppliedImage = originalImageResized;
    effectAppliedImage = originalImageResized;
    
    [self layoutWhiteBalanceEditor];
    [self layoutLevelsEditor];
    [self layoutSaturationEditor];
    [self layoutEffectEditor];
}

#pragma mark layout

- (void)layoutWhiteBalanceEditor
{
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"White Balance", nil);
    [wrapper addSubview:label];
    
    // place original image
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - originalImageResized.size.height / 2.0f - 25.0f;
    whitebalanceImageView = [[UIThumbnailView alloc] initWithImage:whiteBalanceAppliedImage];
    [whitebalanceImageView setY:imageY];
    whitebalanceImageView.thumbnailId = ThumbnailViewIdWhiteBalance;
    whitebalanceImageView.delegate = self;
    whitebalanceImageView.userInteractionEnabled = YES;
    [wrapper addSubview:whitebalanceImageView];
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    whiteBalanceKnobView = [[UISliderView alloc] init];
    whiteBalanceKnobView.tag = KnobIdWhiteBalance;
    [whiteBalanceKnobView addGestureRecognizer:recognizer];
    knobDefaultCenterX = [UIScreen screenSize].width / 2.0f;
    knobDefaultCenterY = imageY + whiteBalanceAppliedImage.size.height / 2.0f;
    CGPoint center = CGPointMake(knobDefaultCenterX, knobDefaultCenterY);
    whiteBalanceKnobView.center = center;
    [wrapper addSubview:whiteBalanceKnobView];
    
    [scrollView addSubview:wrapper];
}

- (void)layoutLevelsEditor
{
    UIWrapperView* wrapper = [[UIWrapperView alloc] initWithFrame:self.view.bounds];
    
    // label
    UIEditorTitleLabel* label = [[UIEditorTitleLabel alloc] initWithFrame:CGRectMake(0.0f, 30.0f, 320.0f, 20.0f)];
    label.text = NSLocalizedString(@"Levels", nil);
    [wrapper addSubview:label];
    
    // place original image
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - originalImageResized.size.height / 2.0f - 25.0f;
    levelsImageView = [[UIThumbnailView alloc] initWithImage:levelsAppliedImage];
    [levelsImageView setY:imageY];
    levelsImageView.delegate = self;
    levelsImageView.userInteractionEnabled = YES;
    levelsImageView.thumbnailId = ThumbnailViewIdLevels;
    [wrapper addSubview:levelsImageView];
    [wrapper setX:320.0f];
    
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    levelsKnobView = [[UISliderView alloc] init];
    levelsKnobView.tag = KnobIdLevels;
    [levelsKnobView addGestureRecognizer:recognizer];
    CGPoint center = CGPointMake(knobDefaultCenterX, knobDefaultCenterY);
    levelsKnobView.center = center;
    [wrapper addSubview:levelsKnobView];
    
    
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
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - originalImageResized.size.height / 2.0f - 25.0f;
    saturationImageView = [[UIThumbnailView alloc] initWithImage:saturationAppliedImage];
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
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - originalImageResized.size.height / 2.0f - 25.0f;
    effectImageView = [[UIThumbnailView alloc] initWithImage:effectAppliedImage];
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
    if (state == EditorStateWhiteBalance) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [pictureWhiteBalance processImage];
        levelsAppliedImage = [imageFilterWhiteBalance imageFromCurrentlyProcessedOutput];
        pictureLevels = [[GPUImagePicture alloc] initWithImage:levelsAppliedImage];
        if(!imageFilterLevels){
            imageFilterLevels = [[GPULevelsImageFilter alloc] init];
        }
        [pictureLevels addTarget:imageFilterLevels];
        [pictureLevels processImage];
        levelsAppliedImage = [imageFilterLevels imageFromCurrentlyProcessedOutput];
        [levelsImageView setImage:levelsAppliedImage];
        [SVProgressHUD dismiss];
        state = EditorStateLevels;
        pageControl.currentPage++;
        [self changePageControl];
    } else if (state == EditorStateLevels) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [pictureLevels processImage];
        saturationAppliedImage = [imageFilterLevels imageFromCurrentlyProcessedOutput];
        pictureSaturation = [[GPUImagePicture alloc] initWithImage:saturationAppliedImage];
        if(!imageFilterSaturation){
            imageFilterSaturation = [[GPUSaturationImageFilter alloc] init];
        }
        [pictureSaturation addTarget:imageFilterSaturation];
        [pictureSaturation processImage];
        saturationAppliedImage = [imageFilterSaturation imageFromCurrentlyProcessedOutput];
        [saturationImageView setImage:saturationAppliedImage];
        [SVProgressHUD dismiss];
        state = EditorStateSaturation;
        pageControl.currentPage++;
        [self changePageControl];
    } else if (state == EditorStateSaturation) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        [pictureSaturation processImage];
        effectAppliedImage = [imageFilterSaturation imageFromCurrentlyProcessedOutput];
        pictureEffect = [[GPUImagePicture alloc] initWithImage:effectAppliedImage];
        [effectImageView setImage:effectAppliedImage];

        __block EditorViewController* _self = self;
        
        dispatch_async(processingQueue, ^{
            
            GPUEffectSoftPop* softpop = [[GPUEffectSoftPop alloc] init];
            softpop.imageToProcess = effectAppliedImage;
            effectAppliedImage = [softpop process];
         
            /*
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
    if (state == EditorStateWhiteBalance) {
        [self.navigationController popViewControllerAnimated:YES];
        scrollView.delegate = nil;
        return;
    }
    if (state == EditorStateLevels){
        state = EditorStateWhiteBalance;
    } else if (state == EditorStateSaturation){
        state = EditorStateLevels;
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
    CGFloat deltaX = targetView.center.x + p.x;
    CGFloat deltaY = targetView.center.y + p.y;
    CGFloat rest = (screenHeight - 480) * 0.5;
    deltaY = MAX(knobDefaultCenterY - screenWidth * 0.5 - rest, MIN(knobDefaultCenterY + screenWidth * 0.5 + rest,  deltaY));
    deltaX = MAX(0, MIN(screenWidth, deltaX));
    
    if(targetView.tag == KnobIdWhiteBalance){
        float redWeight = targetView.center.y - knobDefaultCenterY;
        float blueWeight = targetView.center.x - knobDefaultCenterX;
        redWeight *= 0.00098039215;
        blueWeight *= 0.00098039215;
        redWeight = MAX(-1.0f, MIN(1.0f, redWeight));
        blueWeight = MAX(-1.0f, MIN(1.0f, blueWeight));
        imageFilterWhiteBalance.redWeight = redWeight;
        imageFilterWhiteBalance.blueWeight = blueWeight;
        [pictureWhiteBalance processImage];
        
        whiteBalanceAppliedImage = [imageFilterWhiteBalance imageFromCurrentlyProcessedOutput];
        [whitebalanceImageView setImage:whiteBalanceAppliedImage];
    } else if(targetView.tag == KnobIdLevels){
        imageFilterLevels.sigmoid = 0;
        float  lvMidWeight = (targetView.center.x - knobDefaultCenterX) * 0.001307f + 0.500f;
        lvMidWeight = MAX(0.0f, MIN(1.0f, lvMidWeight));
        if(lvMidWeight > 0.5){
            lvMidWeight = 1.0 - lvMidWeight;
            imageFilterLevels.sigmoid = 1;
        }
        float  lvHighWeight = 1.0f - (targetView.center.y - knobDefaultCenterY) * 0.001961;
        lvHighWeight = MAX(0.0f, MIN(1.0f, lvHighWeight));
        imageFilterLevels.lvMidWeight = lvMidWeight;
        imageFilterLevels.lvHighWeight = lvHighWeight;
        [pictureLevels processImage];
        
        levelsAppliedImage = [imageFilterLevels imageFromCurrentlyProcessedOutput];
        [levelsImageView setImage:levelsAppliedImage];
        
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
    
    
    CGPoint movedPoint = CGPointMake(deltaX, deltaY);
    targetView.center = movedPoint;
    [sender setTranslation:CGPointZero inView:targetView];
    
    
}

#pragma mark delegates

- (void)touchesBegan:(UIThumbnailView *)view
{
    view.image = originalImageResized;
}

- (void)touchesEnded:(UIThumbnailView *)view
{
    if(view.thumbnailId == ThumbnailViewIdWhiteBalance){
        view.image = whiteBalanceAppliedImage;
        return;
    }
    if(view.thumbnailId == ThumbnailViewIdLevels){
        view.image = levelsAppliedImage;
        return;
    }
    if(view.thumbnailId == ThumbnailViewIdSaturation){
        view.image = saturationAppliedImage;
        return;
    }
    if(view.thumbnailId == ThumbnailViewIdEffect){
        view.image = effectAppliedImage;
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
        originalImageResized = [self uiImageFromCIImage:filteredImage];
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

        GPUWhitebalanceImageFilter* filterWb = [[GPUWhitebalanceImageFilter alloc] init];
        filterWb.redWeight = imageFilterWhiteBalance.redWeight;
        filterWb.blueWeight = imageFilterWhiteBalance.blueWeight;

        GPULevelsImageFilter* filterLv = [[GPULevelsImageFilter alloc] init];
        filterLv.lvHighWeight = imageFilterLevels.lvHighWeight;
        filterLv.lvMidWeight = imageFilterLevels.lvMidWeight;
        filterLv.lvLowWeight = imageFilterLevels.lvLowWeight;
        [filterWb addTarget:filterLv];
        GPUSaturationImageFilter* filterSt = [[GPUSaturationImageFilter alloc] init];
        filterSt.stSaturationWeight = imageFilterSaturation.stSaturationWeight;
        filterSt.stVibranceWeight = imageFilterSaturation.stVibranceWeight;
        [filterLv addTarget:filterSt];
    
        [picture addTarget:filterWb];
        [picture processImage];
        resultImage = [filterSt imageFromCurrentlyProcessedOutput];
        
        GPUEffectColorfulCandy* candy = [[GPUEffectColorfulCandy alloc] init];
        [candy setImageToProcess:resultImage];
        resultImage = [candy process];
        
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
