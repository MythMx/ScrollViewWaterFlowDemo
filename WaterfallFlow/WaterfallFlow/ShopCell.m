//
//  ShopCell.m
//  WaterfallFlow
//
//  Created by apple on 16/1/13.
//  Copyright © 2016年 com.itcast. All rights reserved.
//

#import "ShopCell.h"
#import "UIImageView+WebCache.h"

@interface ShopCell ()

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation ShopCell

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        self.imageView = imageView;
        
    }
    return self;
}

- (void)setShop:(Shop *)shop
{
    _shop = shop;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:shop.img] placeholderImage:[UIImage imageNamed:@"loading"]];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = self.bounds;
}

@end
