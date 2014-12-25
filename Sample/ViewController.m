//
//  ViewController.m
//  Sample
//
//  Created by abc123 on 14-12-24.
//  Copyright (c) 2014年 Ralph Shane. All rights reserved.
//

#import "ViewController.h"
#import "UIComboBox.h"

@interface ViewController () <UIComboBoxDelegate>

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
    self.myComboBox.delegate = self;

#if 0
    UIComboBox *box = [[UIComboBox alloc] initWithFrame:CGRectMake(58, 202, 165, 37)];
#else
    UIComboBox *box = [[UIComboBox alloc] init];
    box.frame = CGRectMake(58, 202, 165, 37);
#endif
    box.delegate = self;
    box.entries = @[@"xxxx", @"yyyy", @"zzzz", @"hhhh", @"wwww", @"aaaaa", @"bbbb"];
    box.selectedItem = 5;

    [self.view addSubview:box];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)comboBox:(UIComboBox *)comboBox selected:(int)selected {
    NSLog(@"%@ select changed to %d", comboBox, selected);
}

@end
