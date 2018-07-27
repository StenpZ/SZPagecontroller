//
//  TempView.m
//  SZPageControllerDemo
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "TempView.h"

@implementation TempView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *textLabel = [[UILabel alloc] init];
        textLabel.frame = CGRectMake(0, 0, 200, 50);
        textLabel.backgroundColor = [UIColor redColor];
        textLabel.textColor = [UIColor blackColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.font = [UIFont systemFontOfSize:25];
        [self addSubview:textLabel];
        self.textLabel = textLabel;
        
        self.answerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.answerButton setTitle:@"答题" forState:UIControlStateNormal];
        self.answerButton.frame = CGRectMake(0, 100, 100, 30);
        [self addSubview:self.answerButton];
        [self.answerButton addTarget:self action:@selector(answerAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.answerView = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 100, 100)];
            view.backgroundColor = [UIColor redColor];
            [self addSubview:view];
            
            view;
        });
    }
    return self;
}

- (void)setModel:(DemoModel *)model {
    _model = model;
    [self configUI];
}

- (void)answerAction {
    self.model.answered = YES;
    [self configUI];
}

- (void)configUI {
    self.answerButton.hidden = self.model.answered;
    self.answerView.hidden = !self.model.answered;
    self.textLabel.text = self.model.text;
}

- (void)dealloc {
    NSLog(@"TempView 释放了 字符串为: -----  %@",self.textLabel.text);
}

@end
