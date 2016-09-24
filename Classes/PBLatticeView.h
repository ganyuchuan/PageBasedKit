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

- (instancetype)initWithCellValues:(NSArray *)values;

@property (nonatomic, readonly, copy) NSArray *cellValues;
@property (nonatomic) CGRect cellBounds;
@property (nonatomic) CGPoint cellEdgeInsetDistance;

- (PBLatticeViewCellValue)cellValueForCol:(NSUInteger)col inRow:(NSUInteger)row;
- (PBLatticeViewCellValue)cellValueAtIndex:(NSUInteger)index;

@end

UIKIT_EXTERN PBLatticeView *PBLatticeViewCreate(NSUInteger rows, NSUInteger cols, PBLatticeViewCellShape shapes[rows][cols]);

#pragma mark -

@interface UIBezierPath (PBLatticeView)

+ (instancetype)bezierPathWithCellValue:(PBLatticeViewCellValue)value edgeInsetDistance:(CGPoint)distance;

@end
