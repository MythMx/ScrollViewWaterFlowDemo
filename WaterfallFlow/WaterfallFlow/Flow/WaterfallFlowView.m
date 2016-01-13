//
//  WaterfallFlowView.m
//  WaterfallFlow
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 com.itcast. All rights reserved.
//

#import "WaterfallFlowView.h"

#define kWaterfallFlowViewDefaultCloumn 3
#define kWaterfallFlowViewDefaultMargin 10
#define kWaterfallFlowViewDefaultHeight 60

@interface WaterfallFlowView ()

//所有哦cell的frame
@property (nonatomic, strong) NSMutableDictionary *cellFrames;

//显示在屏幕上的cell
@property (nonatomic, strong) NSMutableDictionary *displayCells;

//缓存池
@property (nonatomic, strong) NSMutableSet *reuseSet;

@end

@implementation WaterfallFlowView

- (NSMutableSet *)reuseSet
{
    if (!_reuseSet) {
        _reuseSet = [NSMutableSet set];
    }
    return _reuseSet;
}

- (NSMutableDictionary *)displayCells
{
    if (!_displayCells) {
        _displayCells = [NSMutableDictionary dictionary];
    }
    return _displayCells;
}

- (NSMutableDictionary *)cellFrames
{
    if (!_cellFrames) {
        _cellFrames = [NSMutableDictionary dictionary];
    }
    return _cellFrames;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //获取cell的总数
    NSUInteger count = [self.dataSource numberOfCellsInWaterfallFlowView:self];
    
    for (int i = 0; i < count; i++) {
        
        CGRect frame = [self.cellFrames[@(i)] CGRectValue];
        
        WaterfallFlowViewCell *cell = self.displayCells[@(i)];
        
        if ([self isInScreen:frame]) {
            //在屏幕上
            if (cell == nil) {
                cell = [self.dataSource waterfallFlowView:self cellAtIndex:i];
                cell.frame = frame;
                [self addSubview:cell];
                self.displayCells[@(i)] = cell;
            }
            
        } else {
            //不在屏幕上
            if (cell) {
                [cell removeFromSuperview];
                [self.displayCells removeObjectForKey:@(i)];
                
                //把cell加入到缓存池
                [self.reuseSet addObject:cell];
            }
        }
    }

}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
}

- (void)reloadData
{
    //从新计算之前，清除数据
    [self.displayCells.allValues makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.displayCells removeAllObjects];
    [self.cellFrames removeAllObjects];
    [self.reuseSet removeAllObjects];
    
    
    //获取cell的总数
    NSUInteger count = [self.dataSource numberOfCellsInWaterfallFlowView:self];
    
    //获取列数cloumn
    NSUInteger cloumn = [self.dataSource numberOfCloumnsInWaterfallFlowView:self];
    
    
    //创建一个保存最大y值的数组
    CGFloat cloumnMaxY[cloumn];
    
    //数组初始化
    for (int i = 0; i < cloumn; i++) {
        cloumnMaxY[i] = 0.0;
    }

    
    //间距
    CGFloat topMargin = [self marginForType:WaterfallFlowViewTypeTop];
    CGFloat bottomMargin = [self marginForType:WaterfallFlowViewTypeBottom];
    CGFloat leftMargin = [self marginForType:WaterfallFlowViewTypeLeft];
    CGFloat rightMargin = [self marginForType:WaterfallFlowViewTypeRight];
    CGFloat rowMargin = [self marginForType:WaterfallFlowViewTypeRow];
    CGFloat cloumnMargin = [self marginForType:WaterfallFlowViewTypeCloumn];
    
    //计算每个cell的宽度
    CGFloat width = (self.bounds.size.width - leftMargin - rightMargin - (cloumn - 1) * cloumnMargin) / cloumn;
    
    
    for (int i = 0; i < count; i++) {
        
        //假设最短的是第0列
        NSUInteger defaultCloumnMin = 0;
        //假设最短y值
        CGFloat defaultCloumnMinY = cloumnMaxY[defaultCloumnMin];
        //计算出最短的列
        for (int j = 0; j < cloumn; j++) {
            if (defaultCloumnMinY > cloumnMaxY[j]) {
                defaultCloumnMin = j;
                defaultCloumnMinY = cloumnMaxY[j];
            }
        }
        
        
        
        CGFloat cellX = leftMargin + (width + cloumnMargin) * defaultCloumnMin;
        
        CGFloat cellY = defaultCloumnMinY + rowMargin;
        
        if (defaultCloumnMinY == 0.0) {
            defaultCloumnMinY = topMargin;
        }
        
        CGFloat cellH = [self getCellHeightWithWidth:width atIndex:i];
        
        
        
        //每个cell的frame
        CGRect rect = CGRectMake(cellX, cellY, width, cellH);
        
        
        cloumnMaxY[defaultCloumnMin] = CGRectGetMaxY(rect);
        
        
        //保存cell的frame
        self.cellFrames[@(i)] = [NSValue valueWithCGRect:rect];
    }
    
    
    //假设最大值的是第0列
    NSUInteger defaultCloumnMax = 0;
    //假设最大y值
    CGFloat defaultCloumnMaxY = cloumnMaxY[defaultCloumnMax];
    //计算出最大y值的列
    for (int j = 0; j < cloumn; j++) {
        if (defaultCloumnMaxY < cloumnMaxY[j]) {
            defaultCloumnMaxY = cloumnMaxY[j];
        }
    }
    
    self.contentSize = CGSizeMake(0, defaultCloumnMaxY + bottomMargin);
}

- (BOOL)isInScreen:(CGRect)frame
{
    if (CGRectGetMaxY(frame) > self.contentOffset.y && (self.contentOffset.y + self.bounds.size.height) > frame.origin.y) {
        return YES;
    }
    
    return NO;
}

- (NSUInteger)getCloumns
{
    if ([self.dataSource respondsToSelector:@selector(numberOfCloumnsInWaterfallFlowView:)]) {
        return [self.dataSource numberOfCloumnsInWaterfallFlowView:self];
    }
    
    return kWaterfallFlowViewDefaultCloumn;
}


- (CGFloat)marginForType:(WaterfallFlowViewType)type
{
    if ([self.dataSource respondsToSelector:@selector(waterfallFlowView:marginForViewType:)]) {
        return [self.dataSource waterfallFlowView:self marginForViewType:type];
    }
    
    return kWaterfallFlowViewDefaultMargin;
}

- (CGFloat)getCellHeightWithWidth:(CGFloat)width atIndex:(NSUInteger)index
{
    if ([self.dataSource respondsToSelector:@selector(waterfallFlowView:cellWidth:heightAtIndex:)]) {
        return [self.delegate waterfallFlowView:self cellWidth:width heightAtIndex:index];
    }
    
    return kWaterfallFlowViewDefaultHeight;

}

- (WaterfallFlowViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)reuseIdentifier
{
    __block WaterfallFlowViewCell *cell = nil;
    
    [self.reuseSet enumerateObjectsUsingBlock:^(WaterfallFlowViewCell *obj, BOOL * _Nonnull stop) {
        if ([obj.reuseIdentifier isEqualToString:reuseIdentifier]) {
            cell = obj;
        }
        *stop = YES;
    }];
    
    if (cell) {
        [self.reuseSet removeObject:cell];
    }
    
    return cell;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (![self.delegate respondsToSelector:@selector(waterfallFlowView:didSelectAtIndex:)]) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    [self.displayCells enumerateKeysAndObjectsUsingBlock:^(NSNumber *index, id  _Nonnull obj, BOOL * _Nonnull stop) {
        CGRect frame = [self.cellFrames[index] CGRectValue];
        if (CGRectContainsPoint(frame, touchPoint)) {
            [self.delegate waterfallFlowView:self didSelectAtIndex:[index integerValue]];
            *stop = YES;
        }
    }];
}


@end
