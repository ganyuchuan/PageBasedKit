//
//  PBHorizontalQueueView.h
//  PageBasedKit
//
//  Created by huxiu on 16/9/20.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PBHorizontalQueueViewDistribution) {
    PBHorizontalStackViewDistributionEqualSpacing,
};

typedef NS_ENUM(NSUInteger, PBHorizontalQueueViewAlignment) {
    PBHorizontalStackViewAlignmentCenter,
};

@interface PBHorizontalQueueView : UIScrollView

@property (nonatomic, readonly, copy) NSArray<__kindof UIView *> *arrangedSubviews;
/*!
 *  用于控制arrangedSubviews的宽高，默认为PBHorizontalStackViewDistributionEqualSpacing
 */
@property (nonatomic) PBHorizontalQueueViewDistribution distribution;
/*!
 *  用于控制arrangedSubviews的xy，默认为PBHorizontalStackViewAlignmentCenter
 */
@property (nonatomic) PBHorizontalQueueViewAlignment alignment;
/*!
 *  用于控制相邻arrangedSubviews的间距，默认为0
 */
@property (nonatomic) CGFloat spacing;

/*!
 *  初始化
 *
 *  @param views 需要水平逐个排列的视图
 *
 *  @return PBHorizontalQueueView对象
 */
- (instancetype)initWithArrangedSubviews:(NSArray<__kindof UIView *> *)views;

/*!
 *  滑动指定索引所对应的视图，使之处于可见位置
 *
 *  @param index    索引
 *  @param animated 滑动过程是否动画
 */
- (void)scrollArrangedSubviewIndex:(NSUInteger)index toVisibleAnimated:(BOOL)animated;
/*!
 *  滑动指定索引所对应的视图，使之处于中心位置
 *
 *  @param index    索引
 *  @param animated 滑动过程是否动画
 */
- (void)scrollArrangedSubviewIndex:(NSUInteger)index toCenteringAnimated:(BOOL)animated;

@end
