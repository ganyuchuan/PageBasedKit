//
//  PBNavigationBar.h
//  PageBasedKit
//
//  Created by huxiu on 16/9/17.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBNavigationBar : UIView

@property (nonatomic, copy) NSArray<__kindof UIButton *> *barButtons;

@property (nonatomic) NSUInteger selectedIndex;

@property (nonatomic) IBInspectable CGFloat selectedAlpha;
@property (nonatomic) IBInspectable CGFloat unselectedAlpha;
@property (nonatomic) IBInspectable CGFloat selectedScale;
@property (nonatomic) IBInspectable CGFloat unselectedScale;

@property (nonatomic) IBInspectable CGFloat barButtonsSpacing;
@property (nonatomic) IBInspectable BOOL scrollEnable;
@property (nonatomic) IBInspectable BOOL backgroundTranslucent;
@property (nonatomic, copy) IBInspectable NSString *contentEdgeInsetsString;

- (instancetype)initWithBarButtons:(NSArray<__kindof UIButton *> *)barButtons;

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)animated;
- (void)transitioningWhenScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)updateBarButtonsStateAnimated:(BOOL)animated;
- (void)updateBarButtonsStateWhenScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)moveBarButtonsPositionForVisibleAnimated:(BOOL)animated;
- (void)moveBarButtonsPositionForVisibleWhenScrollViewDidScroll:(UIScrollView *)scrollView;

- (void)moveBarButtonsPositionForCenteringAnimated:(BOOL)animated;
- (void)moveBarButtonsPositionForCenteringWhenScrollViewDidScroll:(UIScrollView *)scrollView;

@end

#pragma mark -

@interface PBNavigationAlignLeadingBar : PBNavigationBar

@end

#pragma mark -

@interface PBNavigationAlignCenterBar : PBNavigationBar

@end
