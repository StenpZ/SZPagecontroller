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
@property(nonatomic) NSInteger numbers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    SZPageController *pageVC = [[SZPageController alloc] init];
    pageVC.dataSource = self;
    pageVC.delegate = self;
    pageVC.circleSwitchEnabled = NO;
    pageVC.contentModeController = NO;
//    pageVC.switchToLastEnabled = NO;
//    pageVC.switchSlideEnabled = NO;
//    pageVC.switchTapEnabled = NO;
    [self.view addSubview:pageVC.view];
    [self addChildViewController:pageVC];
    self.pageController = pageVC;
    self.numbers = 12;
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
}


#pragma mark - SZPageControllerDataSource

- (NSInteger)numberOfPagesInPageController:(SZPageController *)pageController {
    return self.numbers;
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
    view.textLabel.text = [NSString stringWithFormat:@"%ld", (long)index];
    return view;
}

#pragma mark - SZPageControllerDelegate
- (void)pageController:(SZPageController *)pageController currentController:(UIViewController *)currentController currentIndex:(NSInteger)currentIndex {
    NSLog(@"%@ __ %ld", currentController, currentIndex);
}

- (void)pageController:(SZPageController *)pageController currentView:(UIView *)currentView currentIndex:(NSInteger)currentIndex {
    NSLog(@"%@ __ %ld", currentView, currentIndex);
}

- (void)pageControllerDidSwitchToFirst:(SZPageController *)pageController {
    NSLog(@"第一个");
}

- (void)pageControllerDidSwitchToLast:(SZPageController *)pageController {
    NSLog(@"最后一个");
    self.numbers += 3;
    [self.pageController reloadData];
}

- (void)pageControllerSwitchToLastDisabled:(SZPageController *)pageController {
    NSLog(@"不能再向前了");
}

- (void)pageControllerSwitchToNextDisabled:(SZPageController *)pageController {
    NSLog(@"不能再向后了");
    self.numbers += 3;
    [self.pageController reloadData];
}

- (void)dealloc {
    NSLog(@"ViewController 释放了");
}

@end

