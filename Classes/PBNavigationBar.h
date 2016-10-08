//
//  PBNavigationBar.h
//  PageBasedKit
//
//  Created by huxiu on 16/9/17.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBNavigationBar : UIView

/*!
 *  导航栏上有序排列的一系列按钮
 */
@property (nonatomic, copy) NSArray<__kindof UIButton *> *barButtons;

/*!
 *  被选按钮所对应的索引，默认为NSNotFound
 */
@property (nonatomic) NSUInteger selectedIndex;

/*!
 *  被选按钮的透明度，默认为1
 */
@property (nonatomic) IBInspectable CGFloat selectedAlpha;
/*!
 *  未选按钮的透明度，默认为0.5
 */
@property (nonatomic) IBInspectable CGFloat unselectedAlpha;
/*!
 *  被选按钮的缩放值，默认为1.1
 */
@property (nonatomic) IBInspectable CGFloat selectedScale;
/*!
 *  未选按钮的缩放值，默认为1
 */
@property (nonatomic) IBInspectable CGFloat unselectedScale;

/*!
 *  相邻按钮之间的间距，默认为15
 */
@property (nonatomic) IBInspectable CGFloat barButtonsSpacing;
/*!
 *  左右滑动，默认为YES
 */
@property (nonatomic) IBInspectable BOOL scrollEnable;
/*!
 *  背景半透明，默认为NO
 */
@property (nonatomic) IBInspectable BOOL backgroundTranslucent;
/*!
 *  内容区域（按钮所在的父视图）上下左右边距，使用NSStringFromUIEdgeInsets函数进行赋值，默认为(UIEdgeInsets){20, 8, 8, 8}
 */
@property (nonatomic, copy) IBInspectable NSString *contentEdgeInsetsString;

/*!
 *  初始化
 *
 *  @param barButtons 需要添加到导航栏上的按钮
 *
 *  @return PBNavigationBar对象
 */
- (instancetype)initWithBarButtons:(NSArray<__kindof UIButton *> *)barButtons;

/*!
 *  选中某一个按钮
 *
 *  @param selectedIndex 选中按钮所对应的索引
 *  @param animated      过程是否需要动画
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;
/*!
 *  跟随滑动手势，PBNavigationBar对象整体逐渐发生变化，只可在UIScrollViewDelegate的方法scrollViewDidScroll中调用
 *
 *  @param scrollView 滑动视图
 */
- (void)transitioningWhenScrollViewDidScroll:(UIScrollView *)scrollView;

/*!
 *  更新所有按钮的状态
 *
 *  @param animated 过程是否需要动画
 */
- (void)updateBarButtonsStateAnimated:(BOOL)animated;
/*!
 *  跟随滑动手势，PBNavigationBar对象的按钮状态逐渐发生变化，只可在UIScrollViewDelegate的方法scrollViewDidScroll中调用，一般将此方法写在transitioningWhenScrollViewDidScroll方法中
 *
 *  @param scrollView 滑动视图
 */
- (void)updateBarButtonsStateWhenScrollViewDidScroll:(UIScrollView *)scrollView;

/*!
 *  整体移动所有按钮到被选按钮处于可见位置
 *
 *  @param animated 过程是否需要动画
 */
- (void)moveBarButtonsPositionForVisibleAnimated:(BOOL)animated;
/*!
 *  暂时没有任何作用
 *
 *  @param scrollView 滑动视图
 */
- (void)moveBarButtonsPositionForVisibleWhenScrollViewDidScroll:(UIScrollView *)scrollView;

/*!
 *  整体移动所有按钮到被选按钮处于中心位置
 *
 *  @param animated 过程是否需要动画
 */
- (void)moveBarButtonsPositionForCenteringAnimated:(BOOL)animated;
/*!
 *  跟随滑动手势，PBNavigationBar对象的按钮位置逐渐发生变化，只可在UIScrollViewDelegate的方法scrollViewDidScroll中调用，一般将此方法写在transitioningWhenScrollViewDidScroll方法中
 *
 *  @param scrollView 滑动视图
 */
- (void)moveBarButtonsPositionForCenteringWhenScrollViewDidScroll:(UIScrollView *)scrollView;

@end

#pragma mark -

@interface PBNavigationAlignLeadingBar : PBNavigationBar

@end

#pragma mark -

@interface PBNavigationAlignCenterBar : PBNavigationBar

@end
