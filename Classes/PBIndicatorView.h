//
//  PBIndicatiorView.h
//  PageBasedKit
//
//  Created by huxiu on 16/9/22.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBIndicatorView : UIView

@property (nonatomic) IBInspectable CGSize pointSize;
@property (nonatomic) IBInspectable CGPoint pointSpacing;

@property (nonatomic) IBInspectable UIColor *checkedPointColor;
@property (nonatomic) IBInspectable UIColor *uncheckedPointColor;

@property (nonatomic, readonly) NSUInteger checkmarkedIndex;

- (void)checkmarkPointAtIndex:(NSUInteger)index;

@end