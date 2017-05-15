//
//  UIView+SZPageController.m
//  SZPageController
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "UIView+SZPageController.h"

@implementation UIView (SZPageController)

- (CGFloat)screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

- (CGFloat)screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

- (CGFloat)width {
    return self.bounds.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.bounds.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)orgin_x {
    return self.frame.origin.x;
}

- (void)setOrgin_x:(CGFloat)orgin_x {
    CGRect frame = self.frame;
    frame.origin.x = orgin_x;
    self.frame = frame;
}

- (CGFloat)orgin_y {
    return self.frame.origin.y;
}

- (void)setOrgin_y:(CGFloat)orgin_y {
    CGRect frame = self.frame;
    frame.origin.y = orgin_y;
    self.frame = frame;
}

- (CGFloat)center_x {
    return self.center.x;
}

- (void)setCenter_x:(CGFloat)center_x {
    CGPoint center = self.center;
    center.x = center_x;
    self.center = center;
}

- (CGFloat)center_y {
    return self.center.y;
}

- (void)setCenter_y:(CGFloat)center_y {
    CGPoint center = self.center;
    center.y = center_y;
    self.center = center;
}

@end
