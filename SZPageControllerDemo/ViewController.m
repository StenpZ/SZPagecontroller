//
//  ViewController.m
//  SZPageControllerDemo
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "ViewController.h"

#define ViewColor [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0]

#import "SZPageController.h"
#import "TempViewController.h"
#import "TempView.h"

@interface ViewController ()<SZPageControllerDataSource, SZPageControllerDelegate>

@property(nonatomic, weak) SZPageController *pageController;
@property(nonatomic, strong) NSArray *dataArray;

@property(nonatomic) NSInteger index;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    SZPageController *pageVC = [[SZPageController alloc] init];
    pageVC.dataSource = self;
    pageVC.delegate = self;
    pageVC.switchTapEnabled = NO;
    pageVC.circleSwitchEnabled = NO;
    pageVC.contentModeController = NO;
//    pageVC.switchToLastEnabled = NO;
//    pageVC.switchSlideEnabled = NO;
//    pageVC.switchTapEnabled = NO;
    [self.view addSubview:pageVC.view];
    [self addChildViewController:pageVC];
    self.pageController = pageVC;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger index = 0; index < 12; index ++) {
        DemoModel *model = [DemoModel new];
        model.text = [NSString stringWithFormat:@"第%ld页", index];
        [arr addObject:model];
    }
    
    self.dataArray = [arr copy];
    [self.pageController reloadData];
//    [self.pageController setValue:@(100) forKey:@"numberOfPages"];
    
    //    if ([self.pageController canSwitchToIndex:12]) {
    //        [self.pageController switchToIndex:12 animated:YES];
    //    }
    //
//    if ([self.pageController canSwitchToIndex:5]) {
//        [self.pageController switchToIndex:5 animated:YES];
//    }
    
    /*! 注意，View方式或者Controller方式只需要实现一种代理即可
     contentModeController YES 实现Controller相关代理
     contentModeController NO 实现View相关代理*/
    
   { UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(0, 0, 100, 100);
    [btn setTitle:@"跳转到第5页" forState:UIControlStateNormal];
    btn.center = self.view.center;
    [btn addTarget:self action:@selector(skip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];}
    
    {    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - 100, 100, 100);
        [btn setTitle:@"上一页" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(last) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];}
    
    {    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(CGRectGetWidth(self.view.bounds) - 100, CGRectGetHeight(self.view.bounds) - 100, 100, 100);
        [btn setTitle:@"下一页" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];}
}

- (void)skip {
    [self.pageController switchToIndex:5 animated:YES];
}

- (void)next {
    [self.pageController switchToNextAnimated:YES];
}

- (void)last {
    [self.pageController switchToLastAnimated:YES];
}

#pragma mark - SZPageControllerDataSource

- (NSInteger)numberOfPagesInPageController:(SZPageController *)pageController {
    return self.dataArray.count;
}

- (UIViewController *)pageController:(SZPageController *)pageController controllerForIndex:(NSInteger)index {
    TempViewController *vc = [[TempViewController alloc] init];
    
    vc.view.backgroundColor = ViewColor;
    
    vc.textLabel.text = [NSString stringWithFormat:@"%ld", (long)index];
    
    return vc;
}

- (UIView *)pageController:(SZPageController *)pageController viewForIndex:(NSInteger)index {
    TempView *view = [[TempView alloc] init];
    view.backgroundColor = ViewColor;
    view.model = self.dataArray[index];
    return view;
}

#pragma mark - SZPageControllerDelegate
- (void)pageController:(SZPageController *)pageController currentController:(UIViewController *)currentController currentIndex:(NSInteger)currentIndex {
    NSLog(@"%@ __ %ld", currentController, currentIndex);
}

- (void)pageController:(SZPageController *)pageController currentView:(UIView *)currentView currentIndex:(NSInteger)currentIndex {
    NSLog(@"%@ __ %ld", currentView, currentIndex);
    self.index = currentIndex;
}

- (void)pageControllerDidSwitchToFirst:(SZPageController *)pageController {
    NSLog(@"第一个");
}

- (void)pageControllerDidSwitchToLast:(SZPageController *)pageController {
    NSLog(@"最后一个");
}

- (void)pageControllerSwitchToLastDisabled:(SZPageController *)pageController {
    NSLog(@"不能再向前了");
}

- (void)pageControllerSwitchToNextDisabled:(SZPageController *)pageController {
    NSLog(@"不能再向后了");
}

- (void)dealloc {
    NSLog(@"ViewController 释放了");
}

@end

