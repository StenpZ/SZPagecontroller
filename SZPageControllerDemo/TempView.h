//
//  TempView.h
//  SZPageControllerDemo
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoModel.h"

@interface TempView : UIView

@property (weak, nonatomic) UILabel *textLabel;

@property(nonatomic, strong) UIButton *answerButton;
@property(nonatomic, strong) UIView *answerView;

@property(nonatomic, weak) DemoModel *model;

@end
