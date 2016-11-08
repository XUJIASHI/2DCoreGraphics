//
//  ShoppingCarCell.m
//  2DCoreGraphicesExamoles
//
//  Created by walter on 16/11/7.
//  Copyright © 2016年 walter. All rights reserved.
//

#import "ShoppingCarCell.h"
@interface ShoppingCarCell()

    {
        ShoppingCarCellDidClickShoppingCarButtonCallback _shoppingCarCellDidClickShoppingCarButtonCallback;
    }

@end
@implementation ShoppingCarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)addToCar:(UIButton *)sender {
    
    //坐标点转化
    CGPoint startPoint = [self convertPoint:sender.center toView:self.superview];
    
    
    /**
     *  回调
     */
    if (_shoppingCarCellDidClickShoppingCarButtonCallback)
    {
        _shoppingCarCellDidClickShoppingCarButtonCallback(startPoint);
    }
}
- (void)setShoppingCarCellDidClickShoppingCarButtonCallback:(ShoppingCarCellDidClickShoppingCarButtonCallback)callback
{
    _shoppingCarCellDidClickShoppingCarButtonCallback = callback;
}
- (IBAction)addQUANTITY:(UIButton *)sender {
    if (self.textField.text.integerValue) {
        NSInteger a = self.textField.text.integerValue;
        self.textField.text = [NSString stringWithFormat:@"%ld",a+=1] ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

@end
