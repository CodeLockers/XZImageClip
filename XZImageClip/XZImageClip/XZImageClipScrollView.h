//
//  XZImageClipScrollView.h
//  XZImageClip
//
//  Created by 徐章 on 16/4/21.
//  Copyright © 2016年 徐章. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZImageClipScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView *imageView;

- (void)displayImage:(UIImage *)image;
@end
