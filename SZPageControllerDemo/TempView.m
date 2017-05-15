//
//  TempView.m
//  SZPageControllerDemo
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "TempView.h"

@implementation TempView

- (instancetype)init {
    self = [super init];
    if (self) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(0, 0, 50, 50);
        textLabel.backgroundColor = [UIColor redColor];
        textLabel.textColor = [UIColor blackColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:25];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
    }
    return self;
}

- (void)dealloc {
    NSLog(@"TempView 释放了 字符串为: -----  %@",self.textLabel.text);
}

@end
