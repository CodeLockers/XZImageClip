//
//  ViewController.m
//  XZImageClip
//
//  Created by 徐章 on 16/4/21.
//  Copyright © 2016年 徐章. All rights reserved.
//

#import "ViewController.h"
#import "XZImageClipTouchView.h"
#import "XZImageClipScrollView.h"

#define UISCREEN_WIDTH         [UIScreen mainScreen].bounds.size.width
#define UISCREEN_HEIGHT        [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) UIButton *completeBtn;
@property (nonatomic, strong) XZImageClipTouchView *touchView;
@property (nonatomic, strong) XZImageClipScrollView *scrollView;
@property (nonatomic, strong) UIImageView *clipImageView;
@property (nonatomic, strong) CAShapeLayer *maskLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.touchView];
    [self.view addSubview:self.completeBtn];
    [self.view addSubview:self.clipImageView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    [self.scrollView displayImage:[UIImage imageNamed:@"image"]];
}

#pragma mark - Setter && Getter
- (XZImageClipTouchView *)touchView{
    
    if (!_touchView) {
        _touchView = [[XZImageClipTouchView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
        _touchView.receiver = self.scrollView;
        [_touchView.layer addSublayer:self.maskLayer];
    }
    return _touchView;
}

- (CAShapeLayer *)maskLayer{
    
    if (!_maskLayer) {
        
        _maskLayer = [[CAShapeLayer alloc] init];
        _maskLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7].CGColor;
        _maskLayer.fillRule = kCAFillRuleEvenOdd;
        UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.touchView.frame];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, (CGRectGetHeight(self.touchView.bounds) - UISCREEN_WIDTH)/2.0f , UISCREEN_WIDTH, UISCREEN_WIDTH)];
        clipPath.usesEvenOddFillRule = YES;
        [clipPath appendPath:maskPath];
        
        self.maskLayer.path = clipPath.CGPath;
    }
    return _maskLayer;
}

- (XZImageClipScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[XZImageClipScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, (CGRectGetHeight(self.touchView.bounds) - UISCREEN_WIDTH)/2.0f, UISCREEN_WIDTH, UISCREEN_WIDTH);
    }
    return _scrollView;
}

- (UIImageView *)clipImageView{

    if (!_clipImageView) {
        
        _clipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH - 100, 0, 100, 100)];
        _clipImageView.backgroundColor = [UIColor redColor];
    }
    return _clipImageView;
}

- (UIButton *)completeBtn{
    
    if (!_completeBtn) {
        
        _completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        _completeBtn.backgroundColor = [UIColor yellowColor];
        [_completeBtn addTarget:self action:@selector(compelteBtn_Pressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeBtn;
}

#pragma mark - UIButton_Action
- (void)compelteBtn_Pressed{

    [self cropImage];
}

- (CGRect)cropRect
{
    CGRect cropRect = CGRectZero;
    float zoomScale = 1.0 / self.scrollView.zoomScale;
    
    cropRect.origin.x = self.scrollView.contentOffset.x * zoomScale;
    cropRect.origin.y = self.scrollView.contentOffset.y * zoomScale;
    cropRect.size.width = CGRectGetWidth(self.scrollView.bounds) * zoomScale;
    cropRect.size.height = CGRectGetHeight(self.scrollView.bounds) * zoomScale;
    return cropRect;
}

- (UIImage *)croppedImage:(UIImage *)image cropRect:(CGRect)cropRect
{
    CGImageRef croppedCGImage = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage scale:[UIScreen mainScreen].scale orientation:image.imageOrientation];
    CGImageRelease(croppedCGImage);
    return croppedImage;
}

- (void)cropImage
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *croppedImage = [self croppedImage:self.scrollView.imageView.image cropRect:[self cropRect]];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.clipImageView.image = croppedImage;
            
        });
    });
}

@end
