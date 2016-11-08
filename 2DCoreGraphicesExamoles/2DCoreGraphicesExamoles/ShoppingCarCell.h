//
//  ShoppingCarCell.h
//  2DCoreGraphicesExamoles
//
//  Created by walter on 16/11/7.
//  Copyright © 2016年 walter. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ShoppingCarCellDidClickShoppingCarButtonCallback)(CGPoint startPoint);
@interface ShoppingCarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *textField;

-(void)setShoppingCarCellDidClickShoppingCarButtonCallback:(ShoppingCarCellDidClickShoppingCarButtonCallback)callback;
@end
