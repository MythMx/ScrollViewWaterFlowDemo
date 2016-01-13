//
//  WaterfallFlowViewCell.h
//  WaterfallFlow
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 com.itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaterfallFlowViewCell : UIView

@property (nonatomic, copy, readonly) NSString *reuseIdentifier;

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier;

@end
