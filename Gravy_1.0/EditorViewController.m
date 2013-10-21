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
    screenHeight = [UIScreen height];
    screenWidth = [UIScreen width];
    
    // image processing
    [self resizeOriginalImage];
    
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
    processRunning = NO;
    dragStarted = NO;
    saveBtn.hidden = YES;
    nextBtn.hidden = NO;
    if (state == EditorStateWhiteBalance) {
        state = EditorStateLevels;
        [levelsImageView setImage:whiteBalanceAppliedImage];
        [self processLevels];
    } else if (state == EditorStateLevels) {
        state = EditorStateSaturation;
        [saturationImageView setImage:levelsAppliedImage];
        nextBtn.hidden = YES;
        saveBtn.hidden = NO;
        [self processSaturation];
    } else if (state == EditorStateSaturation) {
        state = EditorStateSharing;
        nextBtn.hidden = YES;
    }
    pageControl.currentPage++;
    [self changePageControl];
}

- (void)didClickBackButton
{
    saveBtn.hidden = YES;
    nextBtn.hidden = NO;
    if (state == EditorStateWhiteBalance) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (state == EditorStateLevels){
        state = EditorStateWhiteBalance;
    } else if (state == EditorStateSaturation){
        state = EditorStateLevels;
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
    dragStarted = YES;
    
    UIView *targetView = sender.view;
    CGPoint p = [sender translationInView:targetView];
    CGFloat deltaX = targetView.center.x + p.x;
    CGFloat deltaY = targetView.center.y + p.y;
    CGFloat rest = (screenHeight - 480) * 0.5;
    deltaY = MAX(knobDefaultCenterY - screenWidth * 0.5 - rest, MIN(knobDefaultCenterY + screenWidth * 0.5 + rest,  deltaY));
    deltaX = MAX(0, MIN(screenWidth, deltaX));
    
    if(targetView.tag == KnobIdWhiteBalance){
        wbRedWeight = targetView.center.y - knobDefaultCenterY;
        wbBlueWeight = targetView.center.x - knobDefaultCenterX;
        wbRedWeight /= 4;
        wbBlueWeight /= 4;
        [self processWhiteBalance];
    } else if(targetView.tag == KnobIdLevels){
        lvMidWeight = (NSInteger)roundf((targetView.center.x - knobDefaultCenterX) / 3.0f) + 127;
        lvMidWeight = MAX(0, MIN(255, lvMidWeight));
        NSInteger diff = (NSInteger)roundf((targetView.center.y - knobDefaultCenterY) / 3.0f);
        lvHighWeight = histHighestValue - abs(diff);
        if(diff < 0){
            lvLowWeight = histLowestValue + abs(diff);
        }
        lvHighWeight = MAX(lvMidWeight, MIN(255, lvHighWeight));
        lvLowWeight = MAX(0, MIN(lvMidWeight, lvLowWeight));
        [self processLevels];
    } else if(targetView.tag == KnobIdSaturation){
        stSaturationWeight = -(NSInteger)roundf((targetView.center.x - knobDefaultCenterX));
        stVibranceWeight = (NSInteger)roundf((targetView.center.y - knobDefaultCenterY));
        [self processSaturation];
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
        [self makeHistogram];
    }
}

- (void)makeHistogram
{
    
    for(int i = 0;i  < 256;i++){
        hist[i] = 0;
    }
    
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
    UInt8* tmp;
    
    UInt8 r, g, b;
    int _y;
    float y, _r, _g, _b;
    
    NSUInteger i, j;
    for (j = 0 ; j < height; j++)
    {
        
        for (i = 0; i < width; i++)
        {
            
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
            
            y = MAX(0.0f, MIN(255.0f, y));
            _y = (int)y;
            
            hist[_y] += 1;
        }
    }
    
    BOOL rev = NO;
    
    for(int i = 0;i  < 256;i++){
        if(rev){
            if(hist[i] != 0){
                histLowestValue = i;
                rev = YES;
                i = 0;
            }
        } else {
            if(hist[255 - i] == 0){
                histHighestValue = 255 - i;
                break;
            }
        }
    }
    
    lvHighWeight = histHighestValue;
    lvLowWeight = histLowestValue;

    CFRelease(data);
    CFRelease(mutableData);
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
    dragStarted = NO;
    if(processRunning){
        return;
    }
    processRunning = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
                if(dragStarted){
                    processRunning = NO;
                    CFRelease(data);
                    CFRelease(mutableData);
                    return;
                }
                
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
        
        
        
        //メインスレッド
        dispatch_async(dispatch_get_main_queue(), ^{            
            [whitebalanceImageView setImage:whiteBalanceAppliedImage];
            processRunning = NO;
        });
    });
    
    
    
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
                    _y = (y - lvLowWeight) * 127.0f * dblLow;
                }
                _y = MAX(0.0f, MIN(255.0f, _y));
                
                
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
    dragStarted = NO;
    if(processRunning){
        return;
    }
    processRunning = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // CGImageを取得する
        CGImageRef cgImage;
        cgImage = levelsAppliedImage.CGImage;
        
        
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
        UInt8* tmp;
        
        // RGBの値を取得する
        UInt8 r, g, b;
        int hi;
        float h, s, v, _r, _g, _b, max, min,m6, m60, m255, f, p, q, t, spx, spy, _s, b1, b2, b3, b4,x0, x1, x2, x3, x4, x5, y0, y1, y2, y3, y4, y5;
        m6 = 1.0f/ 6.0f;
        m60 = 1.0f / 60.0f;
        m255 =  1.0f / 255.0f;
    
        
        stVibranceWeight = MAX(24, MIN(127, abs(stVibranceWeight / 2)));
        
        for(int i = 0;i < 1000;i++){
            if(dragStarted){
                processRunning = NO;
                CFRelease(data);
                CFRelease(mutableData);
                return;
            }
            if(stVibranceWeight < 0){
                t = (float)i * 0.001;
                spx = 2.0f * t * (1.0f - t) * 200.0f + t * t * 255.0f;
                spy = 2.0f * t * (1.0f - t) * (float)abs(stSaturationWeight) + t * t * MAX(0.0f, (float)abs(stVibranceWeight));
                if(spx < 0.0f || spx > 255.0f) continue;
                if(spy < 0.0f || spy > 255.0f) continue;
                saturationSpline[(int)roundf(spx)] = spy;
            } else {
                t = (float)i * 0.001;
                b1 = (-1.0f * t * t * t + 3.0f * t * t - 3.0f * t + 1.0f) * m6;
                b2 = (3.0f * t * t * t - 6.0f * t * t + 4.0f) * m6;
                b3 = (-3.0f * t * t * t + 3.0f * t * t + 3.0f * t + 1.0f) * m6;
                b4 = (t * t * t) * m6;
                x2 = 127.0f - (float)stVibranceWeight;
                x3 = 127.0f + (float)stVibranceWeight;
                x0 = -x2;
                x5 = 510.0f - x3;
                x1 = 0;
                x4 = 255.0f;
                y2 = y3 = (float)abs(stSaturationWeight);
                y1 = y4 = 0;
                y0 = y5 = -y2;
                
                spx = x1 * b1 + x2 * b2 + x3 * b3 + x4 * b4;
                spy = y1 * b1 + y2 * b2 + y3 * b3 + y4 * b4;
                if(spx < 0.0f || spx > 255.0f) continue;
                if(spy < 0.0f || spy > 255.0f) continue;
                saturationSpline[(int)roundf(spx)] = spy;
                spx = x0 * b1 + x1 * b2 + x2 * b3 + x3 * b4;
                spy = y0 * b1 + y1 * b2 + y2 * b3 + y3 * b4;
                if(spx < 0.0f || spx > 255.0f) continue;
                if(spy < 0.0f || spy > 255.0f) continue;
                saturationSpline[(int)roundf(spx)] = spy;
                spx = x2 * b1 + x3 * b2 + x4 * b3 + x5 * b4;
                spy = y2 * b1 + y3 * b2 + y4 * b3 + y5 * b4;
                if(spx < 0.0f || spx > 255.0f) continue;
                if(spy < 0.0f || spy > 255.0f) continue;
                saturationSpline[(int)roundf(spx)] = spy;
            }
            
        }
        
        
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
                
                _r = (float)r;
                _g = (float)g;
                _b = (float)b;
                
                max = MAX(_r, MAX(_g, _b));
                min = MIN(_r, MIN(_g, _b));
                
                if(max == min){
                    h = 0.0f;
                } else if(max == _r){
                    h = 60.0f * (_g - _b) / (max - min);
                } else if (max == _g){
                    h = 60.0f * (_b - _r) / (max - min) + 120.0f;
                } else if (max == _b){
                    h = 60.0f * (_r - _g) / (max - min) + 240.0f;
                }
                
                if(h < 0.0f) h += 360.0f;
                
                s =  255.0f * (max - min) / max;
                if(max == 0.0f) s = 0.0f;
                v = max;
                
                
                if(stSaturationWeight > 0){
                    _s = saturationSpline[(int)roundf(s)];
                    _s *= saturationSpline[(int)roundf(v)];
                    _s *= m255 * 3.0f;
                    s += _s;
                } else {
                    _s = saturationSpline[(int)roundf(s)];
                    _s *= saturationSpline[(int)roundf(v)];
                    _s *= m255 * 3.0f;
                    s -= _s;
                }

                s = MAX(0.0f, MIN(255.0f, s));
                
                
                hi = (int)(h * m60) % 6;
                f = (h * m60) - floorf(h * m60);
                p = roundf(v * (1.0f - (s * m255)));
                q = roundf(v * (1.0f - (s * m255) * f));
                t = roundf(v * (1.0f - (s * m255) * (1.0f - f)));
                
                switch (hi) {
                    case 0:
                        _r = v;
                        _g = t;
                        _b = p;
                        break;
                    case 1:
                        _r = q;
                        _g = v;
                        _b = p;
                        break;
                    case 2:
                        _r = p;
                        _g = v;
                        _b = t;
                        break;
                    case 3:
                        _r = p;
                        _g = q;
                        _b = v;
                        break;
                    case 4:
                        _r = t;
                        _g = p;
                        _b = v;
                        break;
                    case 5:
                        _r = v;
                        _g = p;
                        _b = q;
                        break;
                    default:
                        break;
                }
                
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
        
        
        saturationAppliedImage = [[UIImage alloc] initWithCGImage:effectedCgImage];
        
        // 作成したデータを解放する
        CGImageRelease(effectedCgImage);
        CFRelease(effectedDataProvider);
        CFRelease(effectedData);
        CFRelease(data);
        CFRelease(mutableData);
        
        
        
        //メインスレッド
        dispatch_async(dispatch_get_main_queue(), ^{
            [saturationImageView setImage:saturationAppliedImage];
            processRunning = NO;
        });
    });
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
