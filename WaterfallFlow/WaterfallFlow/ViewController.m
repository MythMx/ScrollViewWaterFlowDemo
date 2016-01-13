//
//  ViewController.m
//  WaterfallFlow
//
//  Created by apple on 16/1/12.
//  Copyright © 2016年 com.itcast. All rights reserved.
//

#import "ViewController.h"
#import "WaterfallFlowView.h"

#import "Shop.h"
#import "ShopCell.h"
#import "MJExtension.h"

@interface ViewController ()<WaterfallFlowViewDelegate, WaterfallFlowViewDataSource>

@property (weak, nonatomic) IBOutlet WaterfallFlowView *waterfallFlowView;

@property (nonatomic, strong) NSMutableArray *shops;

@end

@implementation ViewController

- (NSMutableArray *)shops
{
    if (!_shops) {
        _shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //初始化数据
    NSArray *array = [Shop mj_objectArrayWithFilename:@"1.plist"];
    
    [self.shops addObjectsFromArray:array];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.waterfallFlowView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (NSUInteger)numberOfCellsInWaterfallFlowView:(WaterfallFlowView *)waterfallFlowView
{
    return self.shops.count;
}

- (NSUInteger)numberOfCloumnsInWaterfallFlowView:(WaterfallFlowView *)waterfallFlowView
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        return 3;
    } else {
        return 5;
    }

}

- (CGFloat)waterfallFlowView:(WaterfallFlowView *)waterfallFlowView cellWidth:(CGFloat)width heightAtIndex:(NSUInteger)index
{
    Shop *shop = self.shops[index];
    
    return [shop.h floatValue] / [shop.w floatValue] * width;
}

- (CGFloat)waterfallFlowView:(WaterfallFlowView *)waterfallFlowView marginForViewType:(WaterfallFlowViewType)type
{
    switch (type) {
        case WaterfallFlowViewTypeRow:
            return 10;
            break;
            
        default:
            return 10;
            break;
    }
}

- (WaterfallFlowViewCell *)waterfallFlowView:(WaterfallFlowView *)waterfallFlowView cellAtIndex:(NSUInteger)index
{
    
    
    ShopCell *cell = (ShopCell *)[waterfallFlowView dequeueReusableCellWithReuseIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[ShopCell alloc] initWithReuseIdentifier:@"cell"];
    }
    
    cell.shop = self.shops[index];

    return cell;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.waterfallFlowView reloadData];
}


- (void)waterfallFlowView:(WaterfallFlowView *)waterfallFlowView didSelectAtIndex:(NSUInteger)index
{
    Shop *shop = self.shops[index];
    NSString *message = [NSString stringWithFormat:@"price: %@", shop.price];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    [alertView show];
}

@end
