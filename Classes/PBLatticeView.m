//
//  PBLatticeView.m
//  PageBasedKit
//
//  Created by huxiu on 16/9/21.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import "PBLatticeView.h"

const PBLatticeViewCellValue PBLatticeViewCellValueNull = {
    PBLatticeViewCellShapeNone,
    NSNotFound,
    NSNotFound,
    NSNotFound,
    (CGRect) {
        0,0,0,0
    },
    (CGPoint) {
        0,0
    }
};

NSArray *CreateCellValues(NSUInteger rows,
                          NSUInteger cols,
                          PBLatticeViewCellShape shapes[rows][cols],
                          CGSize size) {
    NSMutableArray *cellValues = [[NSMutableArray alloc] init];
    NSUInteger count = 0;
    
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            // 构造PBLatticeViewCellValue
            PBLatticeViewCellValue value;
            value.shape = shapes[i][j];
            value.index = count;
            value.row = i;
            value.col = j;
            value.frame = CGRectMake(j * size.width,
                                     i * size.height,
                                     size.width,
                                     size.height);
            value.center = CGPointMake(CGRectGetMidX(value.frame), CGRectGetMidY(value.frame));
            
            // 封装为NSValue对象
            NSValue *cellValue = [NSValue valueWithBytes:&value objCType:@encode(PBLatticeViewCellValue)];
            // 然后添加
            [cellValues addObject:cellValue];
            
            // 记数
            count ++;
        }
    }
    
    return [cellValues copy];
}

PBLatticeView *PBLatticeViewCreate(NSUInteger rows,
                                   NSUInteger cols,
                                   PBLatticeViewCellShape shapes[rows][cols],
                                   CGSize size) {
    return [[PBLatticeView alloc] initWithCellValues:CreateCellValues(rows, cols, shapes, size)];
}

@implementation PBLatticeView

- (instancetype)initWithCellValues:(NSArray *)values {
    CGRect frame = CGRectZero;
    for (NSValue *cellValue in values) {
        // 获取
        PBLatticeViewCellValue value;
        [cellValue getValue:&value];
        
        frame = CGRectUnion(frame, value.frame);
    }
    
    if (self = [super initWithFrame:frame]) {
        // 设置每个cell与其容器边距
        _cellEdgeInsetDistance = CGPointMake(2.f, 2.f);
        
        // 设置cellValues
        _cellValues = [values copy];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    for (NSValue *cellValue in self.cellValues) {
        // 获取
        PBLatticeViewCellValue value;
        [cellValue getValue:&value];
        
        // 使用UIBezierPath进行绘制
        UIBezierPath *path = [UIBezierPath bezierPathWithCellValue:value edgeInsetDistance:self.cellEdgeInsetDistance];
        [self.tintColor setFill];
        [path fill];
    }
}

- (PBLatticeViewCellValue)cellValueForCol:(NSUInteger)col inRow:(NSUInteger)row {
    if (col * row >= self.cellValues.count) {
        return PBLatticeViewCellValueNull;
    }
    
    PBLatticeViewCellValue value = PBLatticeViewCellValueNull;
    for (NSValue *cellValue in self.cellValues) {
        // 获取
        PBLatticeViewCellValue tmpValue;
        [cellValue getValue:&tmpValue];
        
        // 进行匹配
        if (value.col == col && value.row == row) {
            value = tmpValue;
            break;
        }
    }
    
    return value;
}

- (PBLatticeViewCellValue)cellValueAtIndex:(NSUInteger)index {
    if (index >= self.cellValues.count) {
        return PBLatticeViewCellValueNull;
    }
    
    NSValue *cellValue = [self.cellValues objectAtIndex:index];
    PBLatticeViewCellValue value;
    [cellValue getValue:&value];
    
    return value;
}

#pragma mark Setter

- (void)setCellEdgeInsetDistance:(CGPoint)cellEdgeInsetDistance {
    _cellEdgeInsetDistance = cellEdgeInsetDistance;
    
    [self setNeedsDisplay];
}

@end

#pragma mark -

@implementation UIBezierPath (PBLatticeView)

+ (instancetype)bezierPathWithCellValue:(PBLatticeViewCellValue)value edgeInsetDistance:(CGPoint)distance {
    switch (value.shape) {
        case PBLatticeViewCellShapeRect:
            return [UIBezierPath bezierPathWithRect:CGRectInset(value.frame, distance.x, distance.y)];
        case PBLatticeViewCellShapeOval:
            return [UIBezierPath bezierPathWithOvalInRect:CGRectInset(value.frame, distance.x, distance.y)];
        default:
            return nil;
    }
}

@end
