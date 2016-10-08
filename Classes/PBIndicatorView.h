//
//  PBIndicatiorView.h
//  PageBasedKit
//
//  Created by huxiu on 16/9/22.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PBIndicatorView : UIView

/*!
 *  点的大小，默认为(CGSize){0, 0}
 */
@property (nonatomic) IBInspectable CGSize pointSize;
/*!
 *  相邻点（x轴、y轴方向）之间的间距，默认为(CGPoint){0, 0}
 */
@property (nonatomic) IBInspectable CGPoint pointSpacing;
/*!
 *  选中点的颜色，默认为nil
 */
@property (nonatomic) IBInspectable UIColor *checkedPointColor;
/*!
 *  未选中点的颜色，默认为nil
 */
@property (nonatomic) IBInspectable UIColor *uncheckedPointColor;
/*!
 *  选中点所对应的索引，默认为0
 */
@property (nonatomic, readonly) NSUInteger checkmarkedIndex;

/*!
 *  选中某点
 *
 *  @param index 要选中点所对应的索引
 */
- (void)checkmarkPointAtIndex:(NSUInteger)index;

@end