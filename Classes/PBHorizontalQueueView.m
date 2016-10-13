//
//  PBHorizontalQueueView.m
//  PageBasedKit
//
//  Created by huxiu on 16/9/20.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import "PBHorizontalQueueView.h"

@interface PBHorizontalQueueView ()

@end

@implementation PBHorizontalQueueView

- (instancetype)initWithArrangedSubviews:(NSArray<__kindof UIView *> *)views {
    // 计算bounds
    CGRect bounds = CGRectZero;
    for (UIView *view in views) {
        bounds.size.width += view.bounds.size.width;
        bounds.size.height = MAX(bounds.size.height, view.bounds.size.height);
    }
    bounds.size.width = MIN(bounds.size.width, [UIScreen mainScreen].bounds.size.width);
    
    // 初始化
    if (self = [super initWithFrame:bounds]) {
        _arrangedSubviews = [views copy];
        _distribution = PBHorizontalStackViewDistributionEqualSpacing;
        _alignment = PBHorizontalStackViewAlignmentCenter;
        _spacing = 0;
        
        [self setup];
    }
    
    return self;
}

- (void)setup {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    
    for (UIView *subview in self.arrangedSubviews) {
        [self addSubview:subview];
    }
    
    [self layoutSubviewsManually];
}

- (void)layoutSubviewsManually {
    CGFloat centerY = self.bounds.size.height / 2;
    CGRect lastSubviewFrame = CGRectOffset(CGRectZero, -self.spacing, 0);
    
    // subview按从左到右依次排列
    // 并且垂直居中对齐
    for (UIView *subview in self.arrangedSubviews) {
        CGFloat centerX = CGRectGetMaxX(lastSubviewFrame) + self.spacing + subview.frame.size.width / 2;
        subview.center = CGPointMake(centerX, centerY);
        
        lastSubviewFrame = subview.frame;
    }
    
    // 更新contentSize
    self.contentSize = CGSizeMake(CGRectGetMaxX(lastSubviewFrame), self.bounds.size.height);
}

- (void)scrollArrangedSubviewIndex:(NSUInteger)index toVisibleAnimated:(BOOL)animated {
    if (index >= self.arrangedSubviews.count) {
        return;
    }
    
    UIView *subview = [self.arrangedSubviews objectAtIndex:index];
    [self scrollRectToVisible:subview.frame animated:animated];
}

- (void)scrollArrangedSubviewIndex:(NSUInteger)index toCenteringAnimated:(BOOL)animated {
    if (index >= self.arrangedSubviews.count) {
        return;
    }
    
    UIView *subview = [self.arrangedSubviews objectAtIndex:index];
    CGFloat offsetX = subview.center.x - self.bounds.size.width / 2;
    [self setContentOffset:CGPointMake(offsetX, 0) animated:animated];
}

#pragma mark Setter

- (void)setDistribution:(PBHorizontalQueueViewDistribution)distribution {
    if (_distribution != distribution) {
        _distribution = distribution;
        
        [self layoutSubviewsManually];
    }
}

- (void)setAlignment:(PBHorizontalQueueViewAlignment)alignment {
    if (_alignment != alignment) {
        _alignment = alignment;
        
        [self layoutSubviewsManually];
    }
}

- (void)setSpacing:(CGFloat)spacing {
    if (_spacing != spacing) {
        _spacing = spacing;
        
        [self layoutSubviewsManually];
    }
}

- (void)setContentOffset:(CGPoint)contentOffset {
    [super setContentOffset:contentOffset];
    
    NSLog(@"%@", @(contentOffset.x));
}

@end
