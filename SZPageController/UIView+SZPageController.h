//
//  UIView+SZPageController.h
//  SZPageController
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (SZPageController)

@property(nonatomic, readonly) CGFloat screenWidth;
@property(nonatomic, readonly) CGFloat screenHeight;
@property(nonatomic) CGFloat width;
@property(nonatomic) CGFloat height;
@property(nonatomic) CGFloat orgin_x;
@property(nonatomic) CGFloat orgin_y;
@property(nonatomic) CGFloat center_x;
@property(nonatomic) CGFloat center_y;

@end
