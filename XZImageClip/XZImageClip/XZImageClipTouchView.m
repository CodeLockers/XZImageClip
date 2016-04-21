//
//  XZImageClipTouchView.m
//  XZImageClip
//
//  Created by 徐章 on 16/4/21.
//  Copyright © 2016年 徐章. All rights reserved.
//

#import "XZImageClipTouchView.h"

@implementation XZImageClipTouchView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{

    if ([self pointInside:point withEvent:event]) {
        
        return self.receiver;
    }
    return nil;
}

@end
