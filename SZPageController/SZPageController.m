//
//  SZPageController.m
//  SZPageController
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import "SZPageController.h"
#import "UIView+SZPageController.h"

#define AnimateDuration 0.2

@interface SZPageController ()

/*! 左拉右拉手势 */
@property(nonatomic, strong) UIPanGestureRecognizer *pan;

/*! 点击手势 */
@property(nonatomic, strong) UITapGestureRecognizer *tap;

/*! 手势触发点在左边 辨认方向 左边拿上一个控制器  右边拿下一个控制器 */
@property(nonatomic) BOOL isLeft;

/*! 判断执行pan手势 */
@property(nonatomic) BOOL isPan;

/*! 手势是否重新开始识别 */
@property(nonatomic) BOOL isPanBegin;

@property(nonatomic) BOOL isAnimating;

/*! 临时控制器 通过代理获取回来的控制器 还没有完全展示出来的控制器 */
@property(nonatomic, strong, nullable) UIViewController *tempController;

/*! 临时View 通过代理获取回来的View 还没有完全展示出来的View */
@property(nonatomic, strong, nullable) UIView *tempView;

@property(nonatomic) NSInteger numberOfPages;

@property(nonatomic) NSInteger currentIndex;

@property(nonatomic, readonly) NSInteger lastIndex;

@property(nonatomic, readonly) NSInteger nextIndex;

@property(nonatomic) BOOL scrollToLastEnabled;
@property(nonatomic) BOOL scrollToNextEnabled;

@end

@implementation SZPageController

#pragma mark - lifeCircle
- (void)dealloc {
    // 移除手势
    [self.view removeGestureRecognizer:self.pan];
    [self.view removeGestureRecognizer:self.tap];
    
    // 移除当前控制器
    if (self.currentController) {
        [self.currentController.view removeFromSuperview];
        [self.currentController removeFromParentViewController];
        _currentController = nil;
    }
    
    // 移除临时控制器
    if (self.tempController) {
        [self.tempController.view removeFromSuperview];
        [self.tempController removeFromParentViewController];
        self.tempController = nil;
    }
    
    if (self.currentView) {
        [self.currentView removeFromSuperview];
        _currentView = nil;
    }
    
    if (self.tempView) {
        [self.tempView removeFromSuperview];
        self.tempView = nil;
    }
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.contentModeController = YES;
        self.switchAnimated = YES;
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
        
        self.switchSlideEnabled = YES;
        self.switchTapEnabled = YES;
        
        self.switchToLastEnabled = YES;
        self.switchToNextEnabled = YES;
        
        self.circleSwitchEnabled = YES;
        self.scrollToLastEnabled = YES;
        self.scrollToNextEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.layer.masksToBounds = YES;
    
    [self.view removeGestureRecognizer:self.tap];
    [self.view removeGestureRecognizer:self.pan];
    [self.view addGestureRecognizer:self.pan];
    [self.view addGestureRecognizer:self.tap];
}

#pragma mark - GestureRecognizerHandle
- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    CGPoint tempPoint = [recognizer translationInView:self.view];
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        if (self.isAnimating) return;
        self.isAnimating = YES;
        self.isPan = YES;
        self.isPanBegin = YES;
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        
        if (self.isPanBegin) {
            self.isPanBegin = NO;
            
            self.isLeft = tempPoint.x > 0 ? YES: NO;
            
            if (![self canHandlePanOrTap]) {
                self.isPan = NO;
                return;
            }
            
            if (self.contentModeController) {
                
                self.tempController = [self getNeedsController];
                [self addController:self.tempController];
                
            } else {
                self.tempView = [self getNeedsView];
                [self addView:self.tempView];
            }
        }
        
        if (!self.isPan) return;
        
        
        if (self.contentModeController) {
            if (!self.tempController) return;
            
            if (self.isLeft) {
                
                self.tempController.view.frame = CGRectMake(tempPoint.x - self.view.width, 0, self.view.width, self.view.height);
                
            } else {
                self.currentController.view.frame = CGRectMake(tempPoint.x > 0 ? 0 : tempPoint.x, 0, self.view.width, self.view.height);
                
            }
            
        } else {
            if (!self.tempView) return;
            
            if (self.isLeft) {
                
                self.tempView.frame = CGRectMake(tempPoint.x - self.view.width, 0, self.view.width, self.view.height);
                
            } else {
                
                self.currentView.frame = CGRectMake(tempPoint.x > 0 ? 0 : tempPoint.x, 0, self.view.width, self.view.height);
            }
        }
    } else { //!< 手势结束
        if (!self.isPan) return;
        
        self.isPan = NO;
        
        if (self.contentModeController) {
            if (!self.tempController) {
                self.isAnimating = NO;
                return;
            }
            
            BOOL isSuccess = YES;
            
            if (self.isLeft) {
                
                if (self.tempController.view.frame.origin.x <= -(self.view.width - self.view.width*0.18)) {
                    
                    isSuccess = NO;
                }
                
            } else {
                
                if (self.currentController.view.frame.origin.x >= -self.view.width*0.18) {
                    
                    isSuccess = NO;
                }
            }
            
            [self GestureSuccess:isSuccess animated:self.switchAnimated];
        } else {
            if (!self.tempView) {
                self.isAnimating = NO;
                return;
            }
            BOOL isSuccess = YES;
            
            if (self.isLeft) {
                
                if (self.tempView.frame.origin.x <= -(self.view.width - self.view.width*0.18)) {
                    
                    isSuccess = NO;
                }
                
            } else {
                
                if (self.currentView.frame.origin.x >= -self.view.width*0.18) {
                    
                    isSuccess = NO;
                }
            }
            
            // 手势结束
            [self GestureSuccess:isSuccess animated:self.switchAnimated];
            
        }
        
    }
}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    // 正在动画
    if (self.isAnimating) return;
    
    self.isAnimating = YES;
    
    CGPoint touchPoint = [recognizer locationInView:self.view];
    
    self.isLeft = touchPoint.x < self.view.center_x ? YES: NO;
    
    if (![self canHandlePanOrTap]) {
        return;
    }
    
    if (self.contentModeController) {
        
        self.tempController = [self getNeedsController];
        [self addController:self.tempController];
        
    } else {
        self.tempView = [self getNeedsView];
        [self addView:self.tempView];
    }
    
    [self GestureSuccess:YES animated:self.switchAnimated];
}


- (BOOL)canHandlePanOrTap {
    
    BOOL can = YES;
    if (!self.numberOfPages) {
        self.isAnimating = NO;
        return NO;
    }
    if (self.isLeft) {
        if (!self.switchToLastEnabled || !self.scrollToLastEnabled) {
            self.isAnimating = NO;
            can = NO;
            if ([self.delegate respondsToSelector:@selector(pageControllerSwitchToLastDisabled:)]) {
                [self.delegate pageControllerSwitchToLastDisabled:self];
            }
        }
    } else {
        if (!self.switchToNextEnabled || !self.scrollToNextEnabled) {
            self.isAnimating = NO;
            can = NO;
            if ([self.delegate respondsToSelector:@selector(pageControllerSwitchToNextDisabled:)]) {
                [self.delegate pageControllerSwitchToNextDisabled:self];
            }
        }
    }
    
    return can;
}


- (UIViewController *)getNeedsController {
    UIViewController *vc = nil;
    
    if (![self.dataSource respondsToSelector:@selector(pageController:controllerForIndex:)]) {
        self.isAnimating = NO;
        return vc;
    }
    
    if (self.isLeft) {
        vc = [self.dataSource pageController:self controllerForIndex:self.lastIndex];
    } else {
        vc = [self.dataSource pageController:self controllerForIndex:self.nextIndex];
    }
    
    if (!vc) {
        self.isAnimating = NO;
    }
    
    return vc;
}

- (UIView *)getNeedsView {
    UIView *view = nil;
    
    if (![self.dataSource respondsToSelector:@selector(pageController:viewForIndex:)]) {
        self.isAnimating = NO;
        return view;
    }
    
    if (self.isLeft) {
        view = [self.dataSource pageController:self viewForIndex:self.lastIndex];
    } else {
        view = [self.dataSource pageController:self viewForIndex:self.nextIndex];
    }
    
    if (!view) {
        self.isAnimating = NO;
    }
    
    return view;
}

/**
 *  手势结束
 */
- (void)GestureSuccess:(BOOL)isSuccess animated:(BOOL)animated {
    if (self.contentModeController) {
        if (self.tempController) {
            
            if (self.isLeft) { // 左边
                
                if (animated) {
                    
                    __weak SZPageController *weakSelf = self;
                    
                    [UIView animateWithDuration:AnimateDuration animations:^{
                        
                        if (isSuccess) {
                            
                            weakSelf.tempController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                            
                        }else{
                            
                            weakSelf.tempController.view.frame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
                        }
                        
                    } completion:^(BOOL finished) {
                        
                        [weakSelf animateSuccess:isSuccess];
                    }];
                    
                } else {
                    
                    if (isSuccess) {
                        
                        self.tempController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                        
                    }else{
                        
                        self.tempController.view.frame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
                    }
                    
                    [self animateSuccess:isSuccess];
                }
                
            } else { // 右边
                
                if (animated) {
                    
                    __weak SZPageController *weakSelf = self;
                    
                    [UIView animateWithDuration:AnimateDuration animations:^{
                        
                        if (isSuccess) {
                            
                            weakSelf.currentController.view.frame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
                            
                        }else{
                            
                            weakSelf.currentController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                        }
                        
                    } completion:^(BOOL finished) {
                        
                        [weakSelf animateSuccess:isSuccess];
                    }];
                    
                } else {
                    
                    if (isSuccess) {
                        
                        self.currentController.view.frame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
                        
                    }else{
                        
                        self.currentController.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                    }
                    
                    [self animateSuccess:isSuccess];
                }
            }
        }
    } else {
        if (self.tempView) {
            
            if (self.isLeft) { // 左边
                
                if (animated) {
                    
                    __weak SZPageController *weakSelf = self;
                    
                    [UIView animateWithDuration:AnimateDuration animations:^{
                        
                        if (isSuccess) {
                            
                            weakSelf.tempView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                            
                        }else{
                            
                            weakSelf.tempView.frame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
                        }
                        
                    } completion:^(BOOL finished) {
                        
                        [weakSelf animateSuccess:isSuccess];
                    }];
                    
                }else{
                    
                    if (isSuccess) {
                        
                        self.tempView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                        
                    }else{
                        
                        self.tempView.frame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
                    }
                    
                    [self animateSuccess:isSuccess];
                }
                
            }else{ // 右边
                
                if (animated) {
                    
                    __weak SZPageController *weakSelf = self;
                    
                    [UIView animateWithDuration:AnimateDuration animations:^{
                        
                        if (isSuccess) {
                            
                            weakSelf.currentView.frame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
                            
                        }else{
                            
                            weakSelf.currentView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                        }
                        
                    } completion:^(BOOL finished) {
                        
                        [weakSelf animateSuccess:isSuccess];
                    }];
                    
                }else{
                    
                    if (isSuccess) {
                        
                        self.currentView.frame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
                        
                    }else{
                        
                        self.currentView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
                    }
                    
                    [self animateSuccess:isSuccess];
                }
            }
        }
    }
}

/**
 *  动画结束
 */
- (void)animateSuccess:(BOOL)isSuccess {
    if (self.contentModeController) {
        if (isSuccess) {
            [self.currentController.view removeFromSuperview];
            
            [self.currentController removeFromParentViewController];
            
            _currentController = self.tempController;
            
            self.tempController = nil;
            
            self.isAnimating = NO;
            if (self.isLeft) {
                self.currentIndex --;
            } else {
                self.currentIndex ++;
            }
            
        } else {
            [self.tempController.view removeFromSuperview];
            
            [self.tempController removeFromParentViewController];
            
            self.tempController = nil;
            
            self.isAnimating = NO;
        }
        
        // 代理回调
        if ([self.delegate respondsToSelector:@selector(pageController:currentController:currentIndex:)]) {
            [self.delegate pageController:self currentController:self.currentController currentIndex:self.currentIndex];
        }
        
    } else {
        if (isSuccess) {
            
            [self.currentView removeFromSuperview];
            
            _currentView = self.tempView;
            
            self.tempView = nil;
            
            self.isAnimating = NO;
            if (self.isLeft) {
                self.currentIndex --;
            } else {
                self.currentIndex ++;
            }
        }else{
            
            [self.tempView removeFromSuperview];
            
            self.tempView = nil;
            
            self.isAnimating = NO;
        }
        
        if ([self.delegate respondsToSelector:@selector(pageController:currentView:currentIndex:)]) {
            [self.delegate pageController:self currentView:self.currentView currentIndex:self.currentIndex];
        }
    }
}

#pragma mark - 设置显示控制器

/**
 *  手动设置显示控制器 无动画
 *
 *  @param controller 设置显示的控制器
 */
- (void)setController:(UIViewController * _Nonnull)controller {
    [self setController:controller animated:NO isAbove:YES];
}

/**
 *  手动设置显示控制器
 *
 *  @param controller 设置显示的控制器
 *  @param animated   是否需要动画
 *  @param isAbove    动画是否从上面显示 YES   从下面显示 NO
 */
- (void)setController:(UIViewController * _Nonnull)controller animated:(BOOL)animated isAbove:(BOOL)isAbove {
    if (animated && self.currentController) { // 需要动画 同时有根控制器了
        
        // 正在动画
        if (self.isAnimating) return;
        
        self.isAnimating = YES;
        
        self.isLeft = isAbove;
        
        // 记录
        self.tempController = controller;
        
        // 添加
        [self addController:controller];
        
        // 手势结束
        [self GestureSuccess:YES animated:YES];
        
    } else {
        
        // 添加
        [self addController:controller];
        
        // 修改frame
        controller.view.frame = self.view.bounds;
        
        // 当前控制器有值 进行删除
        if (_currentController) {
            
            [_currentController.view removeFromSuperview];
            
            [_currentController removeFromParentViewController];
        }
        
        // 赋值记录
        _currentController = controller;
    }
}

/**
 *  添加控制器
 *
 *  @param controller 控制器
 */
- (void)addController:(UIViewController * _Nullable)controller {
    if (controller) {
        
        [self addChildViewController:controller];
        
        if (self.isLeft) { // 左边
            
            [self.view addSubview:controller.view];
            
            controller.view.frame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
            
        } else { // 右边
            
            if (self.currentController) { // 有值
                
                [self.view insertSubview:controller.view belowSubview:self.currentController.view];
                
            } else { // 没值
                
                [self.view addSubview:controller.view];
            }
            
            controller.view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        }
        
        // 添加阴影
        [self setShadowController:controller];
    }
}

#pragma mark - 设置显示View

/**
 *  手动设置显示View 无动画
 *
 *  @param currentView 设置显示的View
 */
- (void)setCurrentView:(UIView * _Nonnull)currentView {
    [self setCurrentView:currentView animated:NO isAbove:YES];
}

/**
 *  手动设置显示View
 *
 *  @param currentView 设置显示的View
 *  @param animated    是否需要动画
 *  @param isAbove     动画是否从上面显示 YES   从下面显示 NO
 */
- (void)setCurrentView:(UIView * _Nonnull)currentView animated:(BOOL)animated isAbove:(BOOL)isAbove {
    if (animated && self.currentView) { // 需要动画 同时有根View了
        
        // 正在动画
        if (self.isAnimating) { return; }
        
        self.isAnimating = YES;
        
        self.isLeft = isAbove;
        
        // 记录
        self.tempView = currentView;
        
        // 添加
        [self addView:currentView];
        
        // 手势结束
        [self GestureSuccess:YES animated:YES];
        
    }else{
        
        // 添加
        [self addView:currentView];
        
        // 修改frame
        currentView.frame = self.view.bounds;
        
        // 当前View有值 进行删除
        if (_currentView) {
            
            [_currentView removeFromSuperview];
            
            _currentView = nil;
        }
        
        // 赋值记录
        _currentView = currentView;
    }
}

/**
 *  添加View
 *
 *  @param view 显示View
 */
- (void)addView:(UIView * _Nullable)view {
    if (view) {
        
        if (self.isLeft) { // 左边
            
            [self.view addSubview:view];
            
            view.frame = CGRectMake(-self.view.width, 0, self.view.width, self.view.height);
            
        }else{ // 右边
            
            if (self.currentView) { // 有值
                
                [self.view insertSubview:view belowSubview:self.currentView];
                
            }else{ // 没值
                
                [self.view addSubview:view];
            }
            
            view.frame = CGRectMake(0, 0, self.view.width, self.view.height);
        }
        
        // 添加阴影
        [self setShadowView:view];
    }
}

/**
 *  给控制器添加阴影
 */
- (void)setShadowController:(UIViewController * _Nullable)controller {
    if (controller) {
        controller.view.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
        controller.view.layer.shadowOffset = CGSizeMake(0, 0); // 偏移距离
        controller.view.layer.shadowOpacity = 0.5; // 不透明度
        controller.view.layer.shadowRadius = 10.0; // 半径
    }
}

/**
 *  给View添加阴影
 */
- (void)setShadowView:(UIView * _Nullable)view {
    if (view) {
        view.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
        view.layer.shadowOffset = CGSizeMake(0, 0); // 偏移距离
        view.layer.shadowOpacity = 0.5; // 不透明度
        view.layer.shadowRadius = 10.0; // 半径
    }
}

#pragma mark - Method
- (void)reloadData {
    if (self.isAnimating) {
        return;
    }
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInPageController:)]) {
        _numberOfPages = [self.dataSource numberOfPagesInPageController:self];
        
        if (_numberOfPages <= 0) return;
        
        if (self.currentIndex && self.currentIndex < self.numberOfPages) {
            self.currentIndex = self.currentIndex;
            return;
        }
        self.currentIndex = 0;
        
        if (self.contentModeController) {
            if ([self.dataSource respondsToSelector:@selector(pageController:controllerForIndex:)]) {
                self.tempController = [self.dataSource pageController:self controllerForIndex:self.currentIndex];
                [self initViewController];
            }
        } else {
            if ([self.dataSource respondsToSelector:@selector(pageController:viewForIndex:)]) {
                self.tempView = [self.dataSource pageController:self viewForIndex:self.currentIndex];
                [self initView];
            }
        }
    }
}

- (void)reloadDataToFirst {
    if (self.isAnimating) {
        return;
    }
    if ([self.dataSource respondsToSelector:@selector(numberOfPagesInPageController:)]) {
        _numberOfPages = [self.dataSource numberOfPagesInPageController:self];
        
        if (_numberOfPages <= 0) return;
        
        self.currentIndex = 0;
        
        if (self.contentModeController) {
            if ([self.dataSource respondsToSelector:@selector(pageController:controllerForIndex:)]) {
                self.tempController = [self.dataSource pageController:self controllerForIndex:self.currentIndex];
                [self initViewController];
            }
        } else {
            if ([self.dataSource respondsToSelector:@selector(pageController:viewForIndex:)]) {
                self.tempView = [self.dataSource pageController:self viewForIndex:self.currentIndex];
                [self initView];
            }
        }
    }
}

- (void)initViewController {
    // 添加
    [self addController:self.tempController];
    
    // 修改frame
    self.tempController.view.frame = self.view.bounds;
    // 当前控制器有值 进行删除
    if (_currentController) {
        
        [_currentController.view removeFromSuperview];
        
        [_currentController removeFromParentViewController];
        _currentController = nil;
    }
    
    // 赋值记录
    _currentController = self.tempController;
    self.tempController = nil;
    
    if ([self.delegate respondsToSelector:@selector(pageController:currentController:currentIndex:)]) {
        [self.delegate pageController:self currentController:self.currentController currentIndex:self.currentIndex];
    }
}

- (void)initView {
    // 添加
    [self addView:self.tempView];
    
    // 修改frame
    self.tempView.frame = self.view.bounds;
    
    // 当前View有值 进行删除
    if (_currentView) {
        
        [_currentView removeFromSuperview];
        
        _currentView = nil;
    }
    
    // 赋值记录
    _currentView = self.tempView;
    self.tempView = nil;
    if ([self.delegate respondsToSelector:@selector(pageController:currentView:currentIndex:)]) {
        [self.delegate pageController:self currentView:self.currentView currentIndex:self.currentIndex];
    }
}

- (BOOL)canSwitchToIndex:(NSInteger)index {
    if (index < 0) {
        return NO;
    }
    if (index > self.numberOfPages - 1) {
        return NO;
    }
    return YES;
}

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated {
    self.currentIndex = index;

    if (self.contentModeController) {
        if ([self.dataSource pageController:self controllerForIndex:self.currentIndex]) {
            self.tempController = [self.dataSource pageController:self controllerForIndex:self.currentIndex];
            [self initViewController];
        }
    } else {
        if ([self.dataSource pageController:self viewForIndex:self.currentIndex]) {
            self.tempView = [self.dataSource pageController:self viewForIndex:self.currentIndex];
            [self initView];
        }
    }
}

#pragma mark - getter/setter

- (void)setCurrentIndex:(NSInteger)currentIndex {
    
    if (self.circleSwitchEnabled) {
        if (currentIndex == -1) {
            currentIndex = self.numberOfPages - 1;
        } else if (currentIndex == self.numberOfPages) {
            currentIndex = 0;
        }
    } else {
        self.scrollToNextEnabled = self.scrollToLastEnabled = YES;
        if (currentIndex == 0) {
            self.scrollToLastEnabled = NO;
        }
        if (currentIndex == self.numberOfPages - 1) {
            self.scrollToNextEnabled = NO;
        }
    }
    _currentIndex = currentIndex;
    
    if (currentIndex == 0) {
        if ([self.delegate respondsToSelector:@selector(pageControllerDidSwitchToFirst:)]) {
            [self.delegate pageControllerDidSwitchToFirst:self];
        }
    }
    
    if (currentIndex == self.numberOfPages - 1) {
        if ([self.delegate respondsToSelector:@selector(pageControllerDidSwitchToLast:)]) {
            [self.delegate pageControllerDidSwitchToLast:self];
        }
    }
}


- (NSInteger)lastIndex {
    NSInteger lastIndex = self.currentIndex - 1;
    
    if (!self.circleSwitchEnabled) return lastIndex;
    
    if (lastIndex < 0) {
        lastIndex = self.numberOfPages - 1;
    }
    
    return lastIndex;
}

- (NSInteger)nextIndex {
    NSInteger nextIndex = self.currentIndex + 1;
    
    if (!self.circleSwitchEnabled) return nextIndex;
    
    if (nextIndex >= self.numberOfPages) {
        nextIndex = 0;
    }
    
    return nextIndex;
}

- (void)setSwitchTapEnabled:(BOOL)switchTapEnabled {
    _switchTapEnabled = switchTapEnabled;
    self.tap.enabled = switchTapEnabled;
}

- (void)setSwitchSlideEnabled:(BOOL)switchSlideEnabled {
    _switchSlideEnabled = switchSlideEnabled;
    self.pan.enabled = switchSlideEnabled;
}

@end
