//
//  PBViewController.m
//  PageBasedKit
//
//  Created by huxiu on 16/9/17.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import "PBRootViewController.h"
#import "PBNavigationBar.h"
#import "PBIndicatorView.h"

@interface PBRootViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, weak) UIScrollView *pageScrollView;

@end

@implementation PBRootViewController {
    BOOL _isDragging;
}

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers currentIndex:(NSUInteger)currentIndex {
    if (self = [super init]) {
        _viewControllers = viewControllers;
        _currentIndex = currentIndex;
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // storyboard在此处为nil
        // 所以需要在awakeFromNib中对viewControllers进行初始化
    }
    
    return self;
}

#pragma mark - Lifecycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 通过从nib文件中读取标识控制器索引的字符串
    // 创建viewControllers
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSString *prefix = _viewControllersIndexPreIdentifier;
    NSUInteger index = 0;
    BOOL flag = YES;
    
    while (flag) {
        NSString *identifier = [prefix stringByAppendingFormat:@"%@", @(index)];
        @try {
            UIViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
            [viewControllers addObject:viewController];
        }
        @catch (NSException *exception) {
            flag = NO;
        }
        @finally {
            index ++;
        }
    }
    
    _viewControllers = viewControllers;
    _currentIndex = 0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 添加pageViewController
    [self addChildViewController:self.pageViewController];
    [self.view insertSubview:self.pageViewController.view atIndex:0];
    
    self.pageViewController.view.frame = self.view.bounds;
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    [self.pageViewController didMoveToParentViewController:self];
    
    // 设置代理
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    self.pageScrollView.delegate = self;
    
    // 设置navigationBar
    self.navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, _navigationBar.frame.size.height);
    // 创建按钮
    NSMutableArray *barButtons = [[NSMutableArray alloc] init];
    for (UIViewController *viewController in self.viewControllers) {
        UIButton *button = [[UIButton alloc] init];
        [button setTitle:viewController.title forState:UIControlStateNormal];
        [button setTitleColor:self.view.tintColor forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickedNavigationBarButton:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        
        [barButtons addObject:button];
    }
    self.navigationBar.barButtons = [barButtons copy];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 设置当前索引
    [self setCurrentIndex:_currentIndex animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private

- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if (index >= _viewControllers.count) {
        return nil;
    }
    
    return [_viewControllers objectAtIndex:index];
}

#pragma mark - Action

- (void)clickedNavigationBarButton:(UIButton *)sender {
    NSInteger targetIndex = [self.navigationBar.barButtons indexOfObject:sender];
    if (targetIndex == NSNotFound) {
        return;
    }
    
    _isDragging = NO;
    [self setCurrentIndex:targetIndex animated:YES];
}

#pragma mark - Getter

- (UIPageViewController *)pageViewController {
    if (_pageViewController == nil) {
        // 初始化
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:@{UIPageViewControllerOptionInterPageSpacingKey:@0}];
    }
    
    return _pageViewController;
}

- (UIScrollView *)pageScrollView {
    if (_pageScrollView == nil) {
        // 获取pageViewController中的UIScrollView对象
        for (UIView *subview in self.pageViewController.view.subviews) {
            if ([subview isKindOfClass:[UIScrollView class]]) {
                _pageScrollView = (UIScrollView *)subview;
                break;
            }
        }
    }
    
    return _pageScrollView;
}

#pragma mark - Setter

//- (void)setNavigationBar:(PBNavigationBar *)navigationBar {
//    // 移除旧navigationBar
//    [_navigationBar removeFromSuperview];
//    _navigationBar = nil;
//    
//    if (navigationBar == nil) {
//        return;
//    }
//    
//    // 布局
//    navigationBar.frame = CGRectMake(0, 0, self.view.frame.size.width, _navigationBar.frame.size.height);
//    
//    // 添加新navigationBar
//    [self.view addSubview:navigationBar];
//    _navigationBar = navigationBar;
//}

//- (void)setIndicatorView:(PBIndicatorView *)indicatorView {
//    // 移除旧indicatorView
//    [_indicatorView removeFromSuperview];
//    _indicatorView = nil;
//    
//    if (indicatorView == nil) {
//        return;
//    }
//    
//    // 添加新indicatorView
//    [self.view addSubview:indicatorView];
//    _indicatorView = indicatorView;
//}

- (void)setCurrentIndex:(NSUInteger)currentIndex animated:(BOOL)animated {
    // 移动pageViewController
    NSUInteger pageIndex = [self.viewControllers indexOfObject:self.pageViewController.viewControllers.firstObject];
    if (pageIndex != currentIndex) {
        UIViewController *viewController = [self viewControllerAtIndex:currentIndex];
        UIPageViewControllerNavigationDirection direction = currentIndex > _currentIndex ? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse;
        [self.pageViewController setViewControllers:@[viewController] direction:direction animated:animated completion:NULL];
    }
    
    // 移动navigationBar
    [self.navigationBar setSelectedIndex:currentIndex animated:animated];
    
    // 标记indicatorView
    [self.indicatorView checkmarkPointAtIndex:currentIndex];
    
    _currentIndex = currentIndex;
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [_viewControllers indexOfObject:viewController];
    if (index == 0 || index == NSNotFound) {
        return nil;
    }
    
    index --;
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [_viewControllers indexOfObject:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index ++;
    if (index >= _viewControllers.count) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate

- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        NSUInteger index = [_viewControllers indexOfObject:pageViewController.viewControllers.firstObject];
        [self setCurrentIndex:index animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_isDragging) {
        [self.navigationBar transitioningWhenScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _isDragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _isDragging = NO;
}

@end
