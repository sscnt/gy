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
    whitebalanceImageView = [[UIThumbnailView alloc] initWithImage:originalImageResized];
    [whitebalanceImageView setY:imageY];
    [wrapper addSubview:whitebalanceImageView];
    
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
    levelsImageView = [[UIThumbnailView alloc] initWithImage:originalImageResized];
    [levelsImageView setY:imageY];
    [wrapper addSubview:levelsImageView];
    [wrapper setX:320.0f];
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
    saturationImageView = [[UIThumbnailView alloc] initWithImage:originalImageResized];
    [saturationImageView setY:imageY];
    [wrapper addSubview:saturationImageView];
    [wrapper setX:640.0f];
    [scrollView addSubview:wrapper];
}

#pragma mark events

- (void)didClickNextButton
{
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
        
    } else if (state == EditorStateSaturation){
        
    } else if (state == EditorStateSharing){
        
    }
    pageControl.currentPage--;
    [self changePageControl];
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
        CGFloat scale = [UIScreen screenSize].width / self.originalImage.size.width;
        CIImage* filteredImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scale, scale)];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
