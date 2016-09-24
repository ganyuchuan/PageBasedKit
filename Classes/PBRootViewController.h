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

@property (nonatomic, strong) IBOutlet PBIndicatorView *indicatorView;

@property (nonatomic, strong) IBOutlet PBNavigationBar *navigationBar;

@property (nonatomic, copy) IBInspectable NSString *viewControllersIndexPreIdentifier;

@property (nonatomic, readonly) NSArray<__kindof UIViewController *> *viewControllers;
@property (nonatomic, readonly) NSUInteger currentIndex;

- (instancetype)initWithViewControllers:(NSArray<UIViewController *> *)viewControllers currentIndex:(NSUInteger)currentIndex;

@end
