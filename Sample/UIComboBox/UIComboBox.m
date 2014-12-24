//
//  UIComboBox.m
//  Sample
//
//  Created by abc123 on 14-12-24.
//  Copyright (c) 2014 Ralph Shane. All rights reserved.
//

#import "UIComboBox.h"

@interface UIComboBox () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightView;

@property (strong, nonatomic) UITableView* innerInputView;
//@property (nonatomic, readwrite, retain) UIToolbar *innerInputAccessoryView;

@end

@implementation UIComboBox

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadContentViewFromNib];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadContentViewFromNib];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadContentViewFromNib];
    }
    return self;
}

- (void)setSelectedItem:(NSUInteger)selectedItem {
    _selectedItem = selectedItem;
    _textLabel.text = _entries[_selectedItem];
    
    if (_innerInputView) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
        [_innerInputView selectRowAtIndexPath:path
                                     animated:YES
                               scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)loadContentViewFromNib {
    NSString *className = NSStringFromClass([self class]);
    self.contentView = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
    [self addSubview:self.contentView];
    self.layer.cornerRadius = 7.;
    self.layer.borderWidth = .5;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.masksToBounds = YES;
    
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self addConstraint:[self pin:_contentView attribute:NSLayoutAttributeTop]];
    [self addConstraint:[self pin:_contentView attribute:NSLayoutAttributeLeft]];
    [self addConstraint:[self pin:_contentView attribute:NSLayoutAttributeBottom]];
    [self addConstraint:[self pin:_contentView attribute:NSLayoutAttributeRight]];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self
                                          action:@selector(tapHandle)];
    [self addGestureRecognizer:tapGesture];
    self.userInteractionEnabled = YES;
}

- (NSLayoutConstraint *)pin:(id)item attribute:(NSLayoutAttribute)attribute
{
    return [NSLayoutConstraint constraintWithItem:self
                                        attribute:attribute
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:item
                                        attribute:attribute
                                       multiplier:1.0
                                         constant:0.0];
}

#pragma mark - firstResponder
- (void)tapHandle {
#pragma mark - TODO: customize this action for iPhone and iPad
    [self becomeFirstResponder];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - change state when highlighed

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    _rightView.highlighted = highlighted; // change button to highlighed state
    _textLabel.highlighted = highlighted; // change label to highlighed state
    UIColor *shadowColor = highlighted ? [UIColor lightGrayColor] : nil;
    _textLabel.shadowColor = shadowColor;
}

#pragma mark - 'inputView' and 'inputAccessoryView'

-(UIView *)inputView {
    if (!_innerInputView) {
        _innerInputView = [[UITableView alloc] initWithFrame:CGRectMake(100, 100, 320, 162)];
        [_innerInputView setDelegate:self];
        [_innerInputView setDataSource:self];
    }
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
    [_innerInputView selectRowAtIndexPath:path
                                 animated:YES
                           scrollPosition:UITableViewScrollPositionMiddle];

    return _innerInputView;
}

//- (UIView *)inputAccessoryView {
//    if (!_innerInputAccessoryView) {
//        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
//        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//                                                                                      target:nil
//                                                                                      action:nil];
//        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
//                                                                                  target:self
//                                                                                  action:@selector(pressDone)];
//        toolbar.items = @[flexibleItem, doneItem];
//        _innerInputAccessoryView = toolbar;
//    }
//    return _innerInputAccessoryView;
//}
//
//- (void)pressDone {
//    [self resignFirstResponder];
//}


#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_entries count];
}


#define kTableViewCellHeight 28.0f

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kTableViewCellHeight;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* identifier = @"UIComboBoxCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = [[_entries objectAtIndex:[indexPath row] ] description];
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedItem = indexPath.row;
    [self resignFirstResponder];
}

@end
