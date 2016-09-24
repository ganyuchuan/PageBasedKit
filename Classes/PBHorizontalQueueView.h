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
 *  distribution用于控制arrangedSubviews的宽高
 */
@property (nonatomic) PBHorizontalQueueViewDistribution distribution;
/*!
 *  alignment用于控制arrangedSubviews的xy
 */
@property (nonatomic) PBHorizontalQueueViewAlignment alignment;
@property (nonatomic) CGFloat spacing;

- (instancetype)initWithArrangedSubviews:(NSArray<__kindof UIView *> *)views;

- (void)scrollArrangedSubviewIndex:(NSUInteger)index toVisibleAnimated:(BOOL)animated;
- (void)scrollArrangedSubviewIndex:(NSUInteger)index toCenteringAnimated:(BOOL)animated;

@end
