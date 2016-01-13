//
//  WaterfallFlowView.h
//  WaterfallFlow
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 com.itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WaterfallFlowViewCell.h"

@class WaterfallFlowView;


typedef enum
{
    WaterfallFlowViewTypeTop,
    WaterfallFlowViewTypeBottom,
    WaterfallFlowViewTypeLeft,
    WaterfallFlowViewTypeRight,
    WaterfallFlowViewTypeRow,
    WaterfallFlowViewTypeCloumn
} WaterfallFlowViewType;


@protocol WaterfallFlowViewDelegate <UIScrollViewDelegate>

@optional

//每个cell的高度
- (CGFloat)waterfallFlowView:(WaterfallFlowView *)waterfallFlowView cellWidth:(CGFloat)width heightAtIndex:(NSUInteger)index;

//点击cell
- (void)waterfallFlowView:(WaterfallFlowView *)waterfallFlowView didSelectAtIndex:(NSUInteger)index;

@end

@protocol WaterfallFlowViewDataSource <NSObject>

@required

//cell的总数
- (NSUInteger)numberOfCellsInWaterfallFlowView:(WaterfallFlowView *)waterfallFlowView;

//每个cell
- (WaterfallFlowViewCell *)waterfallFlowView:(WaterfallFlowView *)waterfallFlowView cellAtIndex:(NSUInteger)index;

@optional

//cell间距
- (CGFloat)waterfallFlowView:(WaterfallFlowView *)waterfallFlowView marginForViewType:(WaterfallFlowViewType)type;


//列数
- (NSUInteger)numberOfCloumnsInWaterfallFlowView:(WaterfallFlowView *)waterfallFlowView;

@end

@interface WaterfallFlowView : UIScrollView

@property (weak, nonatomic) IBOutlet id<WaterfallFlowViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet id<WaterfallFlowViewDataSource> dataSource;

- (void)reloadData;

- (WaterfallFlowViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
