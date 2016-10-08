//
//  PBLatticeView.h
//  PageBasedKit
//
//  Created by huxiu on 16/9/21.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PBLatticeViewCellShape) {
    PBLatticeViewCellShapeNone      = 0,
    PBLatticeViewCellShapeRect      = 1,
    PBLatticeViewCellShapeOval      = 2,
};

typedef struct _PBLatticeViewCellValue {
    PBLatticeViewCellShape shape;   // 形状
    NSUInteger index;               // 序号
    NSUInteger row;                 // 行数
    NSUInteger col;                 // 列数
    CGRect frame;
    CGPoint center;
} PBLatticeViewCellValue;

UIKIT_EXTERN const PBLatticeViewCellValue PBLatticeViewCellValueNull;

@interface PBLatticeView : UIView

/*!
 *  初始化
 *
 *  @param values 一系列NSValue（封装PBLatticeViewCellValue结构体的）对象
 *
 *  @return PBLatticeView对象
 */
- (instancetype)initWithCellValues:(NSArray *)values;

/*!
 *  一系列NSValue（封装PBLatticeViewCellValue结构体的）对象
 */
@property (nonatomic, readonly, copy) NSArray *cellValues;
/*!
 *  cell所处的矩形范围，默认为(CGRect){0, 0, 10, 10}
 */
@property (nonatomic) CGRect cellBounds;
/*!
 *  cell本身离矩形范围的边距（x轴、y轴方向），默认为(CGPoint){0, 0}
 */
@property (nonatomic) CGPoint cellEdgeInsetDistance;

/*!
 *  指定行列，获取所对应的cell属性值
 *
 *  @param col 所在行数，最小为0
 *  @param row 所在列数，最小为0
 *
 *  @return PBLatticeViewCellValue结构体
 */
- (PBLatticeViewCellValue)cellValueForCol:(NSUInteger)col inRow:(NSUInteger)row;
/*!
 *  指定索引（从左到右、从上到下的顺序），获取所对应的cell属性值
 *
 *  @param index 索引
 *
 *  @return PBLatticeViewCellValue结构体
 */
- (PBLatticeViewCellValue)cellValueAtIndex:(NSUInteger)index;

@end

UIKIT_EXTERN PBLatticeView *PBLatticeViewCreate(NSUInteger rows, NSUInteger cols, PBLatticeViewCellShape shapes[rows][cols]);

#pragma mark -

@interface UIBezierPath (PBLatticeView)

/*!
 *  根据cell属性值和cell四周边距，简易构造
 *
 *  @param value    cell属性值
 *  @param distance cell本身离矩形范围的边距（x轴、y轴方向）
 *
 *  @return UIBezierPath对象
 */
+ (instancetype)bezierPathWithCellValue:(PBLatticeViewCellValue)value edgeInsetDistance:(CGPoint)distance;

@end
