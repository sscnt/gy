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
    processingQueue = dispatch_queue_create("jp.ssctech.gravy.processing", 0);
    state = EditorStateWhiteBalance;
    screenHeight = [UIScreen height];
    screenWidth = [UIScreen width];
    
    processorWb = [[WhiteBalanceProcessor alloc] init];
    processorWb.delegate = self;
    processorLv = [[LevelsProcessor alloc] init];
    processorLv.delegate = self;
    processorSt = [[SaturationProcessor alloc] init];
    processorSt.delegate = self;
 

    [self resizeOriginalImage];
    [processorWb loadImage:originalImageResized];
    [processorLv loadImage:originalImageResized];
    [processorLv makeHistogram];

    
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
    scrollView.contentSize = CGSizeMake(320.0f * 4.0f, self.view.bounds.size.height);
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.scrollEnabled = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    //// page control
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, [UIScreen screenSize].height - 80.0f, 320.0f, 20.0f)];
    pageControl.numberOfPages = 4;
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
    
    [self layoutWhiteBalanceEditor];
    [self layoutLevelsEditor];
    [self layoutSaturationEditor];
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

#pragma mark events

- (void)didClickNextButton
{
    __weak EditorViewController* _self = self;
    saveBtn.hidden = YES;
    nextBtn.hidden = NO;
    if (state == EditorStateWhiteBalance) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(processingQueue, ^{
            [processorWb execute];
            UIImage* image = [processorWb appliedImage];
            [processorLv loadImage:image];
            [processorLv execute];
            image = [processorLv appliedImage];
            //メインスレッド
            dispatch_async(dispatch_get_main_queue(), ^{
                [levelsImageView setImage:image];
                [SVProgressHUD dismiss];
                processorLv.dragStarted = NO;
                processorLv.processRunning = NO;
                state = EditorStateLevels;
                pageControl.currentPage++;
                [_self changePageControl];
            });
        });        
    } else if (state == EditorStateLevels) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(processingQueue, ^{
            [processorLv execute];
            UIImage* image = [processorLv appliedImage];
            [processorSt loadImage:image];
            [processorSt execute];
            image = [processorSt appliedImage];
            //メインスレッド
            dispatch_async(dispatch_get_main_queue(), ^{
                [saturationImageView setImage:image];
                [SVProgressHUD dismiss];
                processorSt.dragStarted = NO;
                processorSt.processRunning = NO;
                state = EditorStateSaturation;
                nextBtn.hidden = YES;
                saveBtn.hidden = NO;
                pageControl.currentPage++;
                [_self changePageControl];
            });
        });

    } else if (state == EditorStateSaturation) {
        nextBtn.hidden = YES;
        saveBtn.hidden = NO;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(processingQueue, ^{
            [processorSt execute];
            //メインスレッド
            dispatch_async(dispatch_get_main_queue(), ^{
                [_self saveImage];
            });
        });
        return;
    } else if (state == EditorStateFinishedSaving) {
        [SVProgressHUD dismiss];
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
        processorWb.dragStarted = NO;
        processorWb.processRunning = NO;
    } else if (state == EditorStateSaturation){
        processorLv.dragStarted = NO;
        processorLv.processRunning = NO;
        state = EditorStateLevels;
    } else if (state == EditorStateSharing){
        __weak EditorViewController* _self = self;
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeClear];
        dispatch_async(processingQueue, ^{
            [processorWb loadImage:originalImageResized];
            [processorWb execute];
            [processorLv loadImage:[processorWb appliedImage]];
            [processorLv execute];
            [processorSt loadImage:[processorLv appliedImage]];
            [processorSt execute];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                state = EditorStateSaturation;
                nextBtn.hidden = YES;
                saveBtn.hidden = NO;
                pageControl.currentPage--;
                [_self changePageControl];
            });

        });
        return;
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
        processorWb.dragStarted = YES;
        float redWeight = targetView.center.y - knobDefaultCenterY;
        float blueWeight = targetView.center.x - knobDefaultCenterX;
        redWeight /= 4.0f;
        blueWeight /= 4.0f;
        redWeight = MAX(0.0f, MIN(255.0f, redWeight));
        blueWeight = MAX(0.0f, MIN(255.0f, blueWeight));
        processorWb.wbRedWeight = (int)roundf(redWeight);
        processorWb.wbBlueWeight = (int)roundf(blueWeight);
        [processorWb executeAsync:processingQueue];
    } else if(targetView.tag == KnobIdLevels){
        processorLv.dragStarted = YES;
        int lvMidWeight = (NSInteger)roundf((targetView.center.x - knobDefaultCenterX) / 3.0f) + 127;
        lvMidWeight = MAX(0, MIN(255, lvMidWeight));
        int diff = (NSInteger)roundf((targetView.center.y - knobDefaultCenterY) / 3.0f);
        int lvHighWeight = processorLv.histHighestValue - abs(diff);
        int lvLowWeight = 0;
        if(diff < 0){
            lvLowWeight = processorLv.histLowestValue + abs(diff);
        }
        lvHighWeight = MAX(lvMidWeight, MIN(255, lvHighWeight));
        lvLowWeight = MAX(0, MIN(lvMidWeight, lvLowWeight));
        processorLv.lvHighWeight = lvHighWeight;
        processorLv.lvMidWeight = lvMidWeight;
        processorLv.lvLowWeight = lvLowWeight;
        [processorLv executeAsync:processingQueue];
    } else if(targetView.tag == KnobIdSaturation){
        processorSt.dragStarted = YES;
        int stSaturationWeight = -(NSInteger)roundf((targetView.center.x - knobDefaultCenterX));
        int stVibranceWeight = (NSInteger)roundf((targetView.center.y - knobDefaultCenterY));
        processorSt.stSaturationWeight = stSaturationWeight;
        processorSt.stVibranceWeight = stVibranceWeight;
        [processorSt executeAsync:processingQueue];
    }
    
    
    CGPoint movedPoint = CGPointMake(deltaX, deltaY);
    targetView.center = movedPoint;
    [sender setTranslation:CGPointZero inView:targetView];
    
    
}

- (void)didFinishedExecute:(BOOL)success sender:(ProcessorId)identifier
{
    if(success){
        if(identifier == ProcessorIdWhiteBalance){
            dispatch_async(processingQueue, ^{
                whiteBalanceAppliedImage = [processorWb appliedImage];
                //メインスレッド
                dispatch_async(dispatch_get_main_queue(), ^{
                    [whitebalanceImageView setImage:whiteBalanceAppliedImage];
                });
            });
            return;
        }
        if(identifier == ProcessorIdLevels){
            dispatch_async(processingQueue, ^{
                levelsAppliedImage = [processorLv appliedImage];
                //メインスレッド
                dispatch_async(dispatch_get_main_queue(), ^{
                    [levelsImageView setImage:levelsAppliedImage];
                });
            });
            return;
        }
        if(identifier == ProcessorIdSaturation){
            dispatch_async(processingQueue, ^{
                saturationAppliedImage = [processorSt appliedImage];
                //メインスレッド
                dispatch_async(dispatch_get_main_queue(), ^{
                    [saturationImageView setImage:saturationAppliedImage];
                });
            });
            return;
        }
    }
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
    [processorWb clean];
    [processorLv clean];
    [processorSt clean];
    __weak EditorViewController* _self = self;
    dispatch_async(processingQueue, ^{
        UIImage* resultImage;
        
        size_t width = CGImageGetWidth(self.originalImage.CGImage);
        size_t height = CGImageGetHeight(self.originalImage.CGImage);
        size_t bitsPerComponent = CGImageGetBitsPerComponent(self.originalImage.CGImage);
        size_t bitsPerPixel = CGImageGetBitsPerPixel(self.originalImage.CGImage);
        size_t bytesPerRow = CGImageGetBytesPerRow(self.originalImage.CGImage);
        CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.originalImage.CGImage);
        CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(self.originalImage.CGImage);
        BOOL shouldInterpolate = CGImageGetShouldInterpolate(self.originalImage.CGImage);
        CGColorRenderingIntent intent = CGImageGetRenderingIntent(self.originalImage.CGImage);
        
        // データプロバイダを取得する
        CGDataProviderRef dataProvider = CGImageGetDataProvider(self.originalImage.CGImage);
        
        // ビットマップデータを取得する
        CFDataRef data = CGDataProviderCopyData(dataProvider);
        CFMutableDataRef mutableData = CFDataCreateMutableCopy(0, 0, data);
        CFRelease(data);
        
        UInt8* buffer = (UInt8*)CFDataGetMutableBytePtr(mutableData);
        NSUInteger i, j;
        UInt8* pixel;
        for (j = 0 ; j < height; j++)
        {
            for (i = 0; i < width; i++)
            {
                // ピクセルのポインタを取得する
                pixel = buffer + j * bytesPerRow + i * 4;
                [processorWb calcPixel:pixel];
                [processorLv calcPixel:pixel];
                [processorSt calcPixel:pixel];
            }
        }
                
        // 効果を与えたデータを作成する
        CFDataRef effectedData;
        effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(mutableData));
        CFRelease(mutableData);
        
        // 効果を与えたデータプロバイダを作成する
        CGDataProviderRef effectedDataProvider;
        effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
        
        // 画像を作成する
        CGImageRef effectedCgImage = CGImageCreate(
                                                   width, height,
                                                   bitsPerComponent, bitsPerPixel, bytesPerRow,
                                                   colorSpace, bitmapInfo, effectedDataProvider,
                                                   NULL, shouldInterpolate, intent);
        
        
        resultImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
        
        // 作成したデータを解放する
        CGImageRelease(effectedCgImage);
        CFRelease(effectedDataProvider);
        CFRelease(effectedData);
        
        
        UIImageWriteToSavedPhotosAlbum(resultImage, nil, nil, nil);
        
        //メインスレッド
        dispatch_async(dispatch_get_main_queue(), ^{
            state = EditorStateFinishedSaving;
            [_self didClickNextButton];
        });
    });
    
}

- (void)dealloc
{
    processorLv.delegate = nil;
    processorSt.delegate = nil;
    processorWb.delegate = nil;
    scrollView.delegate = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
