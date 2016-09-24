//
//  PBNavigationBar.m
//  PageBasedKit
//
//  Created by huxiu on 16/9/17.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import "PBNavigationBar.h"
#import "PBHorizontalQueueView.h"

@interface PBNavigationBar () <UIToolbarDelegate>

@property (nonatomic, strong) UIToolbar *backgroundBar;
@property (nonatomic, strong) PBHorizontalQueueView *contentView;

@end

@implementation PBNavigationBar

- (instancetype)initWithBarButtons:(NSArray<__kindof UIButton *> *)barButtons {
    if (self = [super initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64.f)]) {
        _barButtons = [barButtons copy];
        _barButtons.firstObject.selected = YES;
        _selectedIndex = NSNotFound;
        
        // 设置初始值
        _selectedAlpha = 1.f;
        _unselectedAlpha = 0.5f;
        _selectedScale = 1.1f;
        _unselectedScale = 1.f;
        
        _barButtonsSpacing = 15.f;
        _scrollEnable = YES;
        _backgroundTranslucent = NO;
        _contentEdgeInsetsString = NSStringFromUIEdgeInsets(UIEdgeInsetsMake(20.f, 8.f, 8.f, 8.f));
        
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 此处无法从nib文件中取得keyPath值
    }
    
    return self;
}

- (void)awakeFromNib {
    [self setup];
}

#pragma mark Private

- (void)setup {
    // 添加子视图
    [self addSubview:self.backgroundBar];
    [self addSubview:self.contentView];
    
    [self layoutSubviewsManually];
}

- (void)layoutSubviewsManually {
    self.backgroundBar.frame = self.bounds;
    
    self.contentView.frame = UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsFromString(self.contentEdgeInsetsString));
}

#pragma mark Public

- (void)transitioningWhenScrollViewDidScroll:(UIScrollView *)scrollView {
    // 子类重写...
}

- (void)updateBarButtonsStateAnimated:(BOOL)animated {
    void(^animations)() = ^() {
        for (int i = 0; i < self.barButtons.count; i++) {
            UIButton *button = [self.barButtons objectAtIndex:i];
            BOOL selected = i == self.selectedIndex;
            
            // 设置文本颜色
            [button setTitleColor:self.tintColor forState:UIControlStateNormal];
            
            // 设置透明度
            button.alpha = selected ? self.selectedAlpha : self.unselectedAlpha;
            
            // 设置缩放
            CGFloat scale = selected ? self.selectedScale : self.unselectedScale;
            button.transform = CGAffineTransformMakeScale(scale, scale);
        }
    };
    void(^completion)(BOOL) = ^(BOOL finished) {
        for (int i = 0; i < self.barButtons.count; i++) {
            UIButton *button = [self.barButtons objectAtIndex:i];
            BOOL selected = i == self.selectedIndex;
            
            // 设置按钮是否选中
            button.selected = selected;
        }
    };
    
    if (animated) {
        [UIView animateWithDuration:0.25f animations:animations completion:completion];
    }
    else {
        animations();
        completion(YES);
    }
}

- (void)moveBarButtonsPositionForVisibleAnimated:(BOOL)animated {
    [self.contentView scrollArrangedSubviewIndex:self.selectedIndex toVisibleAnimated:animated];
}

- (void)moveBarButtonsPositionForCenteringAnimated:(BOOL)animated {
    [self.contentView scrollArrangedSubviewIndex:self.selectedIndex toCenteringAnimated:animated];
}

- (void)updateBarButtonsStateWhenScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == nil || self.barButtons.count == 0) {
        return;
    }
    
    // 获取scrollView的横向滑动位移
    // 右滑（视图向左移动）为正
    // 左滑（视图向右移动）为负
    CGFloat offsetX = scrollView.bounds.size.width - scrollView.contentOffset.x;
    
    // 计算总长
    CGFloat totalWidth = scrollView.bounds.size.width * self.barButtons.count;
    
    // 计算当前位移占总长的百分比
    CGFloat process = (scrollView.bounds.size.width * self.selectedIndex - offsetX) / totalWidth;
    
    // 获取当前索引
    CGFloat index = process * self.barButtons.count;
    for (int i = 0; i < self.barButtons.count; i++) {
        // 计算索引偏差
        CGFloat indexDeviation = fabs(index - i);
        
        // 获取button
        UIButton *button = [self.barButtons objectAtIndex:i];
        
        // 如果偏差大于1
        // 则索引i所对应的button与选中button之间至少有1个以上的按钮
        if (indexDeviation > 1) {
            button.alpha = self.unselectedAlpha;
            button.transform = CGAffineTransformMakeScale(self.unselectedScale, self.unselectedScale);
        }
        // 否则与选中button相邻
        else {
            // 改变透明度
            CGFloat deltasAlpha = (self.selectedAlpha - self.unselectedAlpha) * (1 - indexDeviation);
            button.alpha = self.unselectedAlpha + deltasAlpha;
            
            // 改变大小
            CGFloat deltasScale = (self.selectedScale - self.unselectedScale) * (1 - indexDeviation);
            button.transform = CGAffineTransformMakeScale(self.unselectedScale + deltasScale, self.unselectedScale + deltasScale);
        }
    }
}

- (void)moveBarButtonsPositionForVisibleWhenScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == nil) {
        return;
    }
}

- (void)moveBarButtonsPositionForCenteringWhenScrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == nil) {
        return;
    }
    
    CGFloat offsetX = scrollView.bounds.size.width - scrollView.contentOffset.x;
    CGFloat totalWidth = scrollView.bounds.size.width * self.barButtons.count;
    CGFloat process = (scrollView.bounds.size.width * self.selectedIndex - offsetX) / totalWidth;
    CGFloat index = process * self.barButtons.count;
    
    CGFloat targetIndex = offsetX < 0 ? ceil(index) : floor(index);
    if (targetIndex < 0 || targetIndex >= self.barButtons.count) {
        return;
    }
    UIButton *targetButton = [self.barButtons objectAtIndex:targetIndex];
    UIButton *selectedButton = [self.barButtons objectAtIndex:self.selectedIndex];
    CGFloat selectedOffsetX = selectedButton.center.x - self.contentView.bounds.size.width / 2;
    
    CGFloat distance = fabs(targetButton.center.x - selectedButton.center.x);
    CGFloat percent = index - self.selectedIndex;
    self.contentView.contentOffset = CGPointMake(selectedOffsetX + distance * percent, 0);
}

#pragma mark Getter

- (UIToolbar *)backgroundBar {
    if (_backgroundBar == nil) {
        _backgroundBar = [[UIToolbar alloc] init];
        _backgroundBar.delegate = self;
        _backgroundBar.barTintColor = self.backgroundColor;
        _backgroundBar.translucent = self.backgroundTranslucent;
    }
    
    return _backgroundBar;
}

- (PBHorizontalQueueView *)contentView {
    if (_contentView == nil) {
        _contentView = [[PBHorizontalQueueView alloc] initWithArrangedSubviews:self.barButtons];
        _contentView.clipsToBounds = YES;
        _contentView.scrollEnabled = self.scrollEnable;
        _contentView.spacing = 15.f;
    }
    
    return _contentView;
}

#pragma mark Setter

- (void)setBarButtons:(NSArray<__kindof UIButton *> *)barButtons {
    [self.contentView removeFromSuperview];
    self.contentView = nil;
    
    _barButtons = [barButtons copy];
    _barButtons.firstObject.selected = YES;
    _selectedIndex = NSNotFound;
    
    [self addSubview:self.contentView];
    [self layoutSubviewsManually];
}

- (void)setTintColor:(UIColor *)tintColor {
    [super setTintColor:tintColor];
    
    [self updateBarButtonsStateAnimated:NO];
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    self.backgroundBar.barTintColor = backgroundColor;
}

- (void)setBackgroundTranslucent:(BOOL)backgroundTranslucent {
    _backgroundTranslucent = backgroundTranslucent;
    
    self.backgroundBar.translucent = backgroundTranslucent;
}

- (void)setContentEdgeInsetsString:(NSString *)contentEdgeInsetsString {
    _contentEdgeInsetsString = [contentEdgeInsetsString copy];
    
    [self layoutSubviewsManually];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    _selectedIndex = selectedIndex;
    
    // 调用父类方法
    // 然后子类重写...
}

- (void)setSelectedAlpha:(CGFloat)selectedAlpha {
    _selectedAlpha = selectedAlpha;
    
    [self updateBarButtonsStateAnimated:NO];
}

- (void)setUnselectedAlpha:(CGFloat)unselectedAlpha {
    _unselectedAlpha = unselectedAlpha;
    
    [self updateBarButtonsStateAnimated:NO];
}

- (void)setSelectedScale:(CGFloat)selectedScale {
    _selectedScale = selectedScale;
    
    [self updateBarButtonsStateAnimated:NO];
}

- (void)setUnselectedScale:(CGFloat)unselectedScale {
    _unselectedScale = unselectedScale;
    
    [self updateBarButtonsStateAnimated:NO];
}

#pragma mark UIToolbarDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTop;
}

@end

#pragma mark -

@implementation PBNavigationAlignLeadingBar

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    [super setSelectedIndex:selectedIndex animated:animated];
    
    [self updateBarButtonsStateAnimated:animated];
    [self moveBarButtonsPositionForVisibleAnimated:animated];
}

- (void)transitioningWhenScrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateBarButtonsStateWhenScrollViewDidScroll:scrollView];
    [self moveBarButtonsPositionForVisibleWhenScrollViewDidScroll:scrollView];
}

@end

#pragma mark -

@implementation PBNavigationAlignCenterBar

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated {
    [super setSelectedIndex:selectedIndex animated:animated];
    
    [self updateBarButtonsStateAnimated:animated];
    [self moveBarButtonsPositionForCenteringAnimated:animated];
}

- (void)transitioningWhenScrollViewDidScroll:(UIScrollView *)scrollView {
    [self updateBarButtonsStateWhenScrollViewDidScroll:scrollView];
    [self moveBarButtonsPositionForCenteringWhenScrollViewDidScroll:scrollView];
}

@end
