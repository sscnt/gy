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
    [self.view addSubview:scrollView];
    //// page control
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0f, [UIScreen screenSize].height - 80.0f, 320.0f, 20.0f)];
    pageControl.numberOfPages = 4;
    pageControl.currentPage = 0;
    [pageControl setAlpha:0.8f];
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
    CGFloat imageHeight = self.originalImage.size.height * 320.0f / self.originalImage.size.width;
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - imageHeight / 2.0f - 25.0f;
    whitebalanceImageView = [[UIImageView alloc] initWithImage:self.originalImage];
    whitebalanceImageView.bounds = CGRectInset(whitebalanceImageView.bounds, 0.0f, 8.0f);
    whitebalanceImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    whitebalanceImageView.layer.shadowOffset = CGSizeMake(0, 0);
    whitebalanceImageView.layer.shadowOpacity = 1;
    whitebalanceImageView.layer.shadowRadius = 4.0;
    [whitebalanceImageView setFrame:CGRectMake(0.0f, imageY, 320.0f, imageHeight)];
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
    CGFloat imageHeight = self.originalImage.size.height * 320.0f / self.originalImage.size.width;
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - imageHeight / 2.0f - 25.0f;
    levelsImageView = [[UIImageView alloc] initWithImage:self.originalImage];
    levelsImageView.bounds = CGRectInset(levelsImageView.bounds, 0.0f, 8.0f);
    levelsImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    levelsImageView.layer.shadowOffset = CGSizeMake(0, 0);
    levelsImageView.layer.shadowOpacity = 1;
    levelsImageView.layer.shadowRadius = 4.0;
    [levelsImageView setFrame:CGRectMake(0.0f, imageY, 320.0f, imageHeight)];
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
    CGFloat imageHeight = self.originalImage.size.height * 320.0f / self.originalImage.size.width;
    CGFloat imageY = [UIScreen screenSize].height / 2.0f - imageHeight / 2.0f - 25.0f;
    saturationImageView = [[UIImageView alloc] initWithImage:self.originalImage];
    saturationImageView.bounds = CGRectInset(saturationImageView.bounds, 0.0f, 8.0f);
    saturationImageView.layer.shadowColor = [UIColor blackColor].CGColor;
    saturationImageView.layer.shadowOffset = CGSizeMake(0, 0);
    saturationImageView.layer.shadowOpacity = 1;
    saturationImageView.layer.shadowRadius = 4.0;
    [saturationImageView setFrame:CGRectMake(0.0f, imageY, 320.0f, imageHeight)];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
