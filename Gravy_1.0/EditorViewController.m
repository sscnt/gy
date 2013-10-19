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
    state = EditorStateWhiteBalance;
    screenHeight = [UIScreen screenSize].height;
    screenWidth = [UIScreen screenSize].width;
    
    // image processing
    [self resizeOriginalImage];
    
    //// bg.png
    if([UIScreen height] >= 568){
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
    UIDockButtonBack* backBtn = [[UIDockButtonBack alloc] init];
    [backBtn setY:[UIScreen screenSize].height - 45.0f];
    [backBtn addTarget:self action:@selector(didClickBackButton) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setAlpha:0.90f];
    [self.view addSubview:backBtn];
    ////// photos button
    UIDockButtonNext* nextBtn = [[UIDockButtonNext alloc] init];
    [nextBtn setY:[UIScreen screenSize].height - 45.0f];
    [nextBtn setX:160.0f];
    [nextBtn setAlpha:0.90f];
    [nextBtn addTarget:self action:@selector(didClickNextButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextBtn];
    
    whiteBalanceAppliedImage = originalImageResized;
    levelsAppliedImage = originalImageResized;
    saturationAppliedImage = originalImageResized;
    
    processRunning = NO;
    dragStarted = NO;
    
    wbBlueWeight = 0;
    wbRedWeight = 0;
    lvHighWeight = 255;
    lvMidWeight = 127;
    lvLowWeight = 0;
    stSaturationWeight = 0;
    stVibranceWeight = 0;
    
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
    [wrapper addSubview:whitebalanceImageView];
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    whiteBalanceKnobView = [[UIKnobView alloc] init];
    whiteBalanceKnobView.tag = KnobIdWhiteBalance;
    [whiteBalanceKnobView addGestureRecognizer:recognizer];
    knobDefaultPosX = [UIScreen screenSize].width  / 2.0f - whiteBalanceKnobView.bounds.size.width / 2.0f;
    knobDefaultPosY = imageY + whiteBalanceAppliedImage.size.height / 2.0f - whiteBalanceKnobView.bounds.size.height / 2.0f;
    [whiteBalanceKnobView setX:knobDefaultPosX];
    [whiteBalanceKnobView setY:knobDefaultPosY];
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
    [wrapper addSubview:levelsImageView];
    [wrapper setX:320.0f];
    
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    levelsKnobView = [[UIKnobView alloc] init];
    levelsKnobView.tag = KnobIdLevels;
    [levelsKnobView addGestureRecognizer:recognizer];
    [levelsKnobView setX:knobDefaultPosX];
    [levelsKnobView setY:knobDefaultPosY];
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
    [wrapper addSubview:saturationImageView];
    [wrapper setX:640.0f];
    
    UIGestureRecognizer* recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didDragView:)];
    
    // knob
    saturationKnobView = [[UIKnobView alloc] init];
    saturationKnobView.tag = KnobIdSaturation;
    [saturationKnobView addGestureRecognizer:recognizer];
    [saturationKnobView setX:knobDefaultPosX];
    [saturationKnobView setY:knobDefaultPosY];
    [wrapper addSubview:saturationKnobView];
    
    [scrollView addSubview:wrapper];
}

#pragma mark events

- (void)didClickNextButton
{
    processRunning = NO;
    dragStarted = NO;
    if (state == EditorStateWhiteBalance) {
        state = EditorStateLevels;
        [levelsImageView setImage:whiteBalanceAppliedImage];
        [self processLevels];
    } else if (state == EditorStateLevels) {
        state = EditorStateSaturation;
        [saturationImageView setImage:levelsAppliedImage];
        [self processSaturation];
    } else if (state == EditorStateSaturation) {
        state = EditorStateSharing;
    }
    pageControl.currentPage++;
    [self changePageControl];
}

- (void)didClickBackButton
{
    if (state == EditorStateWhiteBalance) {
        [self.navigationController popViewControllerAnimated:YES];
        self.originalImage = nil;
        return;
    }
    if (state == EditorStateLevels){
        state = EditorStateWhiteBalance;
    } else if (state == EditorStateSaturation){
        state = EditorStateLevels;
    } else if (state == EditorStateSharing){
        state = EditorStateSaturation;
    }
    pageControl.currentPage--;
    [self changePageControl];
}

- (void)didDragView:(UIPanGestureRecognizer *)sender
{
    dragStarted = YES;
    
    UIView *targetView = sender.view;
    CGPoint p = [sender translationInView:targetView];
    CGFloat deltaX = targetView.center.x + p.x;
    CGFloat deltaY = targetView.center.y + p.y;
    deltaY = MAX(0, MIN(screenHeight, deltaY));
    deltaX = MAX(0, MIN(screenWidth, deltaX));
    
    if(targetView.tag == KnobIdWhiteBalance){
        wbRedWeight = targetView.center.y - knobDefaultPosY;
        wbBlueWeight = targetView.center.x - knobDefaultPosX;
        wbRedWeight /= 4;
        wbBlueWeight /= 4;
        [self processWhiteBalance];
    } else if(targetView.tag == KnobIdLevels){
        lvMidWeight = (NSInteger)roundf((targetView.center.x - knobDefaultPosX) / 3.0f) + 127;
        lvMidWeight = MAX(0, MIN(255, lvMidWeight));
        [self processLevels];
    }
    
    CGPoint movedPoint = CGPointMake(deltaX, deltaY);
    targetView.center = movedPoint;
    [sender setTranslation:CGPointZero inView:targetView];


}

#pragma mark delegates


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

- (void)processWhiteBalance
{    
    // CGImageを取得する
    CGImageRef cgImage;
    cgImage = originalImageResized.CGImage;
    
    
    // 画像情報を取得する
    size_t width;
    size_t height;
    size_t bitsPerComponent;
    size_t bitsPerPixel;
    size_t bytesPerRow;
    CGColorSpaceRef colorSpace;
    CGBitmapInfo bitmapInfo;
    bool shouldInterpolate;
    CGColorRenderingIntent intent;
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
    CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
    
    
    // ビットマップデータを取得する
    CFDataRef data = CGDataProviderCopyData(dataProvider);
    CFMutableDataRef mutableData = CFDataCreateMutableCopy(0, 0, data);
    UInt8* buffer = (UInt8*)CFDataGetMutableBytePtr(mutableData);
    
    // ビットマップに効果を与える
    
    NSUInteger i, j;
    for (j = 0 ; j < height; j++)
    {
        for (i = 0; i < width; i++)
        {
            
            // ピクセルのポインタを取得する
            UInt8* tmp = buffer + j * bytesPerRow + i * 4;
            
            // RGBの値を取得する
            UInt8 r, g, b;
            r = *(tmp + 0);
            g = *(tmp + 1);
            b = *(tmp + 2);
            
            r = MAX(0, MIN(255, r + wbRedWeight));
            b = MAX(0, MIN(255, b + wbBlueWeight));
            g = MAX(0, MIN(255, g + 0));
            
            
            // 輝度の値をRGB値として設定する
            *(tmp + 0) = r;
            *(tmp + 1) = g;
            *(tmp + 2) = b;
        }
    }
    
    // 効果を与えたデータを作成する
    CFDataRef effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    // 効果を与えたデータプロバイダを作成する
    CGDataProviderRef effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    // 画像を作成する
    CGImageRef effectedCgImage = CGImageCreate(
                                               width, height,
                                               bitsPerComponent, bitsPerPixel, bytesPerRow,
                                               colorSpace, bitmapInfo, effectedDataProvider,
                                               NULL, shouldInterpolate, intent);
    
    
    whiteBalanceAppliedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
    
    // 作成したデータを解放する
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    CFRelease(mutableData);
    
    
    
    [whitebalanceImageView setImage:whiteBalanceAppliedImage];
    
    
    //[whitebalanceImageView setNeedsDisplay];
}

- (void)processLevels
{
    dragStarted = NO;
    if(processRunning){
        return;
    }
    processRunning = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // CGImageを取得する
        CGImageRef cgImage;
        cgImage = whiteBalanceAppliedImage.CGImage;
        
        
        // 画像情報を取得する
        size_t width;
        size_t height;
        size_t bitsPerComponent;
        size_t bitsPerPixel;
        size_t bytesPerRow;
        CGColorSpaceRef colorSpace;
        CGBitmapInfo bitmapInfo;
        bool shouldInterpolate;
        CGColorRenderingIntent intent;
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
        CGDataProviderRef dataProvider = CGImageGetDataProvider(cgImage);
        
        
        // ビットマップデータを取得する
        CFDataRef data = CGDataProviderCopyData(dataProvider);
        CFMutableDataRef mutableData = CFDataCreateMutableCopy(0, 0, data);
        UInt8* buffer = (UInt8*)CFDataGetMutableBytePtr(mutableData);
        
        NSInteger diffHighAndMid = lvHighWeight - lvMidWeight;
        NSInteger diffMidAndLow = lvMidWeight - lvLowWeight;
        
        float dblMid = 1.0f / (float)diffHighAndMid;
        float dblLow = 1.0f / (float)diffMidAndLow;
        
        float _lvMidWeight = (float)lvMidWeight;
        UInt8* tmp;
        
        // RGBの値を取得する
        UInt8 r, g, b;
        float y, u, v, _r, _g, _b, _y;
        
        
        // ビットマップに効果を与える
        NSUInteger i, j;
        for (j = 0 ; j < height; j++)
        {
        
            for (i = 0; i < width; i++)
            {
                if(dragStarted){
                    processRunning = NO;
                    CFRelease(data);
                    CFRelease(mutableData);
                    return;
                }
                
                // ピクセルのポインタを取得する
                tmp = buffer + j * bytesPerRow + i * 4;
                
                // RGBの値を取得する
                r = *(tmp + 0);
                g = *(tmp + 1);
                b = *(tmp + 2);
                
                _r = (float)r * 0.8588f + 16.0f;
                _g = (float)g * 0.8588f + 16.0f;
                _b = (float)b * 0.8588f + 16.0f;
                
                
                
                y = 0.299 * _r + 0.587 * _g + 0.114 * _b;
                u = -0.169 * _r - 0.331 * _g + 0.500 * _b;
                v = 0.500 * _r - 0.419 * _g - 0.081 * _b;
                
                
                if(y >= _lvMidWeight){
                    _y = (y - _lvMidWeight) * 127.0f * dblMid + 127.0f;
                } else {
                    _y = y * 127.0f * dblLow;
                }
                
                
                
                _r = 1.000f * _y + 1.402f * v - 16.0f;
                _g = 1.000f * _y - 0.344f * u - 0.714f * v - 16.0f;
                _b = 1.000f * _y + 1.772f * u - 16.0f;
                
                _r *= 1.164;
                _g *= 1.164;
                _b *= 1.164;
                
                
                _r = MAX(0.0f, MIN(255.0f, _r));
                _g = MAX(0.0f, MIN(255.0f, _g));
                _b = MAX(0.0f, MIN(255.0f, _b));
                
                r = (UInt8)roundf(_r);
                g = (UInt8)roundf(_g);
                b = (UInt8)roundf(_b);
                
                
                // 輝度の値をRGB値として設定する
                *(tmp + 0) = r;
                *(tmp + 1) = g;
                *(tmp + 2) = b;
            }
        }
        
        // 効果を与えたデータを作成する
        CFDataRef effectedData;
        effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
        
        // 効果を与えたデータプロバイダを作成する
        CGDataProviderRef effectedDataProvider;
        effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
        
        // 画像を作成する
        CGImageRef effectedCgImage = CGImageCreate(
                                                   width, height,
                                                   bitsPerComponent, bitsPerPixel, bytesPerRow,
                                                   colorSpace, bitmapInfo, effectedDataProvider,
                                                   NULL, shouldInterpolate, intent);
        
        
        levelsAppliedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
        
        // 作成したデータを解放する
        CGImageRelease(effectedCgImage);
        CFRelease(effectedDataProvider);
        CFRelease(effectedData);
        CFRelease(data);
        CFRelease(mutableData);
        
        
        
        //メインスレッド
        dispatch_async(dispatch_get_main_queue(), ^{
            [levelsImageView setImage:levelsAppliedImage];
            processRunning = NO;
        });
    });
    
    
}

- (void)processSaturation
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
