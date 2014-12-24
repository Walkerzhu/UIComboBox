//
//  ViewController.m
//  Sample
//
//  Created by abc123 on 14-12-24.
//  Copyright (c) 2014年 Ralph Shane. All rights reserved.
//

#import "ViewController.h"
#import "UIComboBox.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIComboBox *myComboBox;
@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.myComboBox.backgroundColor = [UIColor whiteColor];
    self.myComboBox.entries = @[@"15 minutes", @"30 minutes", @"1 hours", @"2 hours"];
    self.myComboBox.selectedItem = 1;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
