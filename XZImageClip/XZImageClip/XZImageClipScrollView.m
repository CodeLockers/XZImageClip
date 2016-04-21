//
//  XZImageClipScrollView.m
//  XZImageClip
//
//  Created by 徐章 on 16/4/21.
//  Copyright © 2016年 徐章. All rights reserved.
//

#import "XZImageClipScrollView.h"

@implementation XZImageClipScrollView

- (id)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.scrollsToTop = NO;
        self.layer.borderColor = [UIColor yellowColor].CGColor;
        self.layer.borderWidth = 2.0f;
        self.clipsToBounds = NO;
        self.delegate = self;
        self.maximumZoomScale = 2.0f;
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // center the zoom view as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    } else {
        frameToCenter.origin.y = 0;
    }
    
    self.imageView.frame = frameToCenter;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)displayImage:(UIImage *)image{
    
    [self.imageView removeFromSuperview];
    self.imageView = nil;
    
    self.zoomScale = 1.0f;
    
    self.imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:self.imageView];
    
    self.contentSize = image.size;
    [self setInitialContentOffset];
}

- (void)setInitialContentOffset
{
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    CGPoint contentOffset = self.contentOffset;
    contentOffset.x = (frameToCenter.size.width - boundsSize.width) / 2.0;
    contentOffset.y = (frameToCenter.size.height - boundsSize.height) / 2.0;
    [self setContentOffset:contentOffset];
}
@end
