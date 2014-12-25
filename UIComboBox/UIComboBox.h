//
//  UIComboBox.h
//  Sample
//
//  Created by abc123 on 14-12-24.
//  Copyright (c) 2014 Ralph Shane. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIComboBox;

@protocol UIComboBoxDelegate <NSObject>
-(void) comboBox:(UIComboBox *)comboBox selected:(int)selected;
@end

@interface UIComboBox : UIControl

@property (strong, nonatomic) NSArray *entries;
@property (nonatomic) NSUInteger selectedItem;
@property(nonatomic, strong) id<UIComboBoxDelegate> delegate;

@end
