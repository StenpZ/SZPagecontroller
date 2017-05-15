//
//  TempViewController.m
//  SZPageControllerDemo
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "TempViewController.h"
#import "UIView+SZPageController.h"

@interface TempViewController ()

@end

@implementation TempViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.frame = CGRectMake(self.view.width - 50, self.view.height - 50, 50, 50);
    textLabel.backgroundColor = [UIColor redColor];
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:25];
    [self.view addSubview:textLabel];
    self.textLabel = textLabel;
}

- (void)dealloc {
    NSLog(@"TempViewController 释放了 字符串为: -----  %@",self.textLabel.text);
}

@end
