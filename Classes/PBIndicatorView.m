//
//  PBIndicatiorView.m
//  PageBasedKit
//
//  Created by huxiu on 16/9/22.
//  Copyright © 2016年 ganyuchuan. All rights reserved.
//

#import "PBIndicatorView.h"
#import "PBLatticeView.h"

#define kFadeAnimation @"FadeAnimation"

@interface PBIndicatorView ()

@property (nonatomic, strong) PBLatticeView *latticeView;
@property (nonatomic, strong) CAShapeLayer *activePointShapeLayer;

@property (nonatomic, copy) void (^completionBlock)(CAAnimation *anim, BOOL finished);

@end

@implementation PBIndicatorView {
    PBLatticeViewCellValue _activePointCellValue;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
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

- (void)setup {
    self.clipsToBounds = NO;
    
    [self addSubview:self.latticeView];
    [self.layer addSublayer:self.activePointShapeLayer];
}

#pragma mark Public

- (void)checkmarkPointAtIndex:(NSUInteger)index {
    NSUInteger count = 0;
    NSUInteger i = NSNotFound;
    for (NSValue *cellValue in self.latticeView.cellValues) {
        PBLatticeViewCellValue value;
        [cellValue getValue:&value];
        
        if (value.shape > 0) {
            count ++;
            
            if (count - 1 == index) {
                i = value.index;
                break;
            }
        }
    }
    
    if (i == NSNotFound) {
        return;
    }
    
    PBLatticeViewCellValue cellValue = [self.latticeView cellValueAtIndex:i];
    
    self.activePointShapeLayer.frame = cellValue.frame;
    _activePointCellValue = cellValue;
    _checkmarkedIndex = index;
}

- (void)checkmarkPointAtIndex:(NSUInteger)index animated:(BOOL)animated {
    if (animated) {
        // 先渐出
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        animation.fromValue = @1;
        animation.toValue = @0;
        animation.duration = 0.25f;
        animation.delegate = self;
        
        __weak PBIndicatorView *self_weak = self;
        [self setCompletionBlock:^(CAAnimation *anim, BOOL finished) {
            // 后渐入
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
            animation.fromValue = @0;
            animation.toValue = @1;
            animation.duration = 0.25f;
            
            [self_weak.activePointShapeLayer addAnimation:animation forKey:kFadeAnimation];
        }];
        
        [self.activePointShapeLayer addAnimation:animation forKey:kFadeAnimation];
    }
    else {
        
    }
}

#pragma mark Getter

- (PBLatticeView *)latticeView {
    if (_latticeView == nil) {
        // 定义排列形状为3x3
        PBLatticeViewCellShape lattice[3][3] = {
            {2,2,2},
            {2,2},
            {2},
        };
        _latticeView = PBLatticeViewCreate(3, 3, lattice);
        
        _latticeView.tintColor = self.uncheckedPointColor;
        _latticeView.backgroundColor = [UIColor clearColor];
        
        _latticeView.cellBounds = CGRectMake(0, 0, self.pointSize.width, self.pointSize.height);
        _latticeView.cellEdgeInsetDistance = CGPointMake(self.pointSpacing.x / 2, self.pointSpacing.y / 2);
    }
    
    return _latticeView;
}

- (CAShapeLayer *)activePointShapeLayer {
    if (_activePointShapeLayer == nil) {
        // 获取PBLatticeViewCellValue相关数据
        _activePointCellValue = [self.latticeView cellValueAtIndex:0];
        _checkmarkedIndex = 0;
        
        // 初始化
        _activePointShapeLayer = [CAShapeLayer layer];
        
        _activePointShapeLayer.frame = _activePointCellValue.frame;
        _activePointShapeLayer.path = [[UIBezierPath bezierPathWithCellValue:_activePointCellValue edgeInsetDistance:self.latticeView.cellEdgeInsetDistance] CGPath];
        _activePointShapeLayer.fillColor = [self.checkedPointColor CGColor];
    }
    
    return _activePointShapeLayer;
}

#pragma mark Setter

#pragma mark CAAnimationDelegate

- (void)animationDidStart:(CAAnimation *)anim {
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_completionBlock) _completionBlock(anim, flag);
}

@end
