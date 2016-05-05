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
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view insertSubview:self.scrollView atIndex:0];
    [self.view addSubview:self.touchView];
    [self.view addSubview:self.completeBtn];
    [self.view addSubview:self.clipImageView];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - Private_Methods
/**
 *  0->4:3
 *  1->1:1
 *  2->3:4
 *  3->16:9
 */
- (void)makeMaskPathWithType:(NSInteger)type{
    
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:self.touchView.bounds];
    UIBezierPath *maskPath;

    switch (type) {
        case 0:
            maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, (CGRectGetHeight(self.touchView.bounds) - UISCREEN_WIDTH/4*3)/2.0f , UISCREEN_WIDTH, UISCREEN_WIDTH/4*3)];
            break;
        case 1:
            maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, (CGRectGetHeight(self.touchView.bounds) - UISCREEN_WIDTH)/2.0f , UISCREEN_WIDTH, UISCREEN_WIDTH)];
            break;
        case 2:
            maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(UISCREEN_WIDTH/8.0f, (CGRectGetHeight(self.touchView.bounds) - UISCREEN_WIDTH)/2.0f, UISCREEN_WIDTH/4*3, UISCREEN_WIDTH)];
            break;
        case 3:
            maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, (CGRectGetHeight(self.touchView.bounds) - UISCREEN_WIDTH/16*9)/2.0f , UISCREEN_WIDTH, UISCREEN_WIDTH/16*9)];
            break;
        default:
            break;
    }
    clipPath.usesEvenOddFillRule = YES;
    [clipPath appendPath:maskPath];
    
    self.maskLayer.path = clipPath.CGPath;
}

#pragma mark - Setter && Getter
- (XZImageClipTouchView *)touchView{
    
    if (!_touchView) {
        _touchView = [[XZImageClipTouchView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-100.0f)];
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
        [self makeMaskPathWithType:1];
    }
    return _maskLayer;
}

- (XZImageClipScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[XZImageClipScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, (CGRectGetHeight(self.touchView.bounds) - UISCREEN_WIDTH)/2.0f, UISCREEN_WIDTH, UISCREEN_WIDTH);
        [self.scrollView displayImage:[UIImage imageNamed:@"image"]];
    }
    return _scrollView;
}

- (UIImageView *)clipImageView{

    if (!_clipImageView) {
        
        _clipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _clipImageView.layer.borderWidth = 1.0f;
        _clipImageView.layer.borderColor = [UIColor greenColor].CGColor;
        _clipImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _clipImageView;
}

#pragma mark - UIButton_Action
- (IBAction)cropBtn_Pressed:(id)sender {
    
    [self cropImage];
}

- (IBAction)ration43Btn_Pressed:(id)sender {
    
    CGPoint center = self.touchView.center;

    self.scrollView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH/4*3);
    self.scrollView.center = center;
    [self makeMaskPathWithType:0];
}

- (IBAction)ration11Btn_Pressed:(id)sender {
    CGPoint center = self.touchView.center;
    
    self.scrollView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH);
    self.scrollView.center = center;
    [self makeMaskPathWithType:1];
}

- (IBAction)ration34Btn_Pressed:(id)sender {
    CGPoint center = self.touchView.center;
    
    self.scrollView.frame = CGRectMake(0, 0, UISCREEN_WIDTH/4*3, UISCREEN_WIDTH);
    self.scrollView.center = center;
    [self makeMaskPathWithType:2];
}

- (IBAction)ration169Btn_Pressed:(id)sender {
    CGPoint center = self.touchView.center;
    
    self.scrollView.frame = CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH/16*9);
    self.scrollView.center = center;
    [self makeMaskPathWithType:3];
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
    UIImage *croppedImage = [UIImage imageWithCGImage:croppedCGImage scale:1 orientation:image.imageOrientation];
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
