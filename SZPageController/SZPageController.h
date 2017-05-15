//
//  SZPageController.h
//  SZPageController
//
//  Created by zxc on 2017/5/14.
//  Copyright © 2017年 StenpZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SZPageController;

@protocol SZPageControllerDataSource <NSObject>

@required
- (NSInteger)numberOfPagesInPageController:(nonnull SZPageController *)pageController;

@optional
- (nullable UIViewController *)pageController:(nonnull SZPageController *)pageController controllerForIndex:(NSInteger)index;

- (nullable UIView *)pageController:(nonnull SZPageController *)pageController viewForIndex:(NSInteger)index;

@end

@protocol SZPageControllerDelegate <NSObject>

@optional
/*! 当前显示的Controller */
- (void)pageController:(nonnull SZPageController *)pageController currentController:(nullable UIViewController *)currentController currentIndex:(NSInteger)currentIndex;

/*! 当前显示的View */
- (void)pageController:(nonnull SZPageController *)pageController currentView:(nullable UIView *)currentView currentIndex:(NSInteger)currentIndex;

/*! 第一页 */
- (void)pageControllerDidSwitchToFirst:(nonnull SZPageController *)pageController;

/*! 最后一页 */
- (void)pageControllerDidSwitchToLast:(nonnull SZPageController *)pageController;

/*! 不能再上一页 */
- (void)pageControllerSwitchToLastDisabled:(nonnull SZPageController *)pageController;

/*! 不能再下一页 */
- (void)pageControllerSwitchToNextDisabled:(nonnull SZPageController *)pageController;

@end


@interface SZPageController : UIViewController

/*! 数据源代理 */
@property(nonatomic, weak, nullable) id<SZPageControllerDataSource> dataSource;

/*! 代理 */
@property(nonatomic, weak, nullable) id<SZPageControllerDelegate> delegate;

/*! Controller内容模式 default YES / View内容模式 NO  */
@property(nonatomic) BOOL contentModeController;

/*! 动画开启状态 default：YES */
@property(nonatomic) BOOL switchAnimated;

/*! 滑动切换启用状态 default：YES */
@property(nonatomic) BOOL switchSlideEnabled;

/*! 单击切换启用状态 default：YES */
@property(nonatomic) BOOL switchTapEnabled;

/*! 循环切换启用状态 default：YES */
@property(nonatomic) BOOL circleSwitchEnabled;

/*! 上一页切换启用状态 default：YES */
@property(nonatomic) BOOL switchToLastEnabled;

/*! 下一页切换启用状态 default：YES */
@property(nonatomic) BOOL switchToNextEnabled;

/*! 当前控制器 */
@property(nonatomic, strong, readonly, nullable) UIViewController *currentController;

/*! 当前显示的View */
@property(nonatomic, strong, readonly, nullable) UIView *currentView;

@property(nonatomic, readonly) BOOL isAnimating;


#pragma mark - Method
/*! 重新加载 继续加载（当currentIndex != 0 && currentIndex < numberOfPages 不刷新当前页面） */
- (void)reloadData;

/*! 重新加载 会回到第一页 currentIndex == 0 */
- (void)reloadDataToFirst;

- (BOOL)canSwitchToIndex:(NSInteger)index;

- (void)switchToIndex:(NSInteger)index animated:(BOOL)animated;

@end
