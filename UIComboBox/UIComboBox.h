//
//  UIComboBox.h
//  Sample
//
//  Created by abc123 on 14-12-24.
//  Copyright (c) 2014 Ralph Shane. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIComboBox : UIControl

@property (strong, nonatomic) NSArray *entries;
@property (nonatomic) NSUInteger selectedItem;

@end
