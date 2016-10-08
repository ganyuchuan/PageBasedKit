//
//  PBViewController.h
//  PageBasedKit
//
//  Created by huxiu on 16/9/17.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PBNavigationBar;
@class PBIndicatorView;

@interface PBRootViewController : UIViewController

/*!
 *  页码指示器，目前暂时需要在PBIndicatorView.m文件中的latticeView方法中对排列形状进行手动修改
 */
@property (nonatomic, strong) IBOutlet PBIndicatorView *indicatorView;

/*!
 *  导航栏
 */
@property (nonatomic, strong) IBOutlet PBNavigationBar *navigationBar;

/*!
 *  子控制器索引前缀标识，比如需要添加3个子视图控制器到PBRootViewController中，其Storyboard ID分别为ViewController0、ViewController1和ViewController2，则viewControllersIndexPreIdentifier为ViewController（只在Storyboard中创建PBRootViewController对象时才会用到）
 */
@property (nonatomic, copy) IBInspectable NSString *viewControllersIndexPreIdentifier;

/*!
 *  子控制器
 */
@property (nonatomic, readonly) NSArray<__kindof UIViewController *> *viewControllers;
/*!
 *  当前索引
 */
@property (nonatomic, readonly) NSUInteger currentIndex;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers currentIndex:(NSUInteger)currentIndex;

@end
