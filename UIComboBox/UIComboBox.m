//
//  UIComboBox.m
//  UIComboBox
//
//  Created by abc123 on 14-12-24.
//  Copyright (c) 2014 Ralph Shane. All rights reserved.
//

#import "UIComboBox.h"

#define __USING_ANIMATE__ 0

#define kComboBoxHeight 160.0

//========================== PassthroughView =============================================

@protocol PassthroughViewDelegate <NSObject>
-(void)doPassthrough:(BOOL)isPass;
@end


@interface PassthroughView : UIView
@property (nonatomic, copy) NSArray *passViews;
@property(nonatomic) BOOL testHits;
@property(nonatomic, assign) id<PassthroughViewDelegate> delegate;
@end


@implementation PassthroughView

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if (self.testHits) {
        return nil;
    }
    if (!self.passViews || (self.passViews && self.passViews.count==0)) {
        return nil;
    }
    UIView *hitView = [super hitTest:point withEvent:event];
    if (hitView == self) {
        self.testHits = YES;
        CGPoint superPoint = [self.superview convertPoint:point fromView:self];
        UIView *superHitView = [self.superview hitTest:superPoint withEvent:event];
        self.testHits = NO;
        BOOL pass = [self isPassthroughView:superHitView];
        if (pass) {
            hitView = superHitView;
        }
        [self.delegate doPassthrough:pass];
    }
    return hitView;
}

-(BOOL)isPassthroughView:(UIView *)view {
    if (view == nil) {
        return NO;
    }
    if ([self.passViews containsObject:view]) {
        return YES;
    }
    return [self isPassthroughView:view.superview];
}

@end


//========================== UIComboBox =============================================


@interface UIComboBox () <UITableViewDelegate, UITableViewDataSource, PassthroughViewDelegate>

@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) UIImageView *rightView;

@property (strong, nonatomic) UITableView* tableView;
@property (nonatomic) CGRect cachedTableViewFrame;

@property(strong, nonatomic) PassthroughView *passthroughView;
@end

@implementation UIComboBox

-(NSString *)description {
    return [NSString stringWithFormat:@"UIComboBox instance %0xd", (int)self];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(58, 102, 165, 37)];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)setSelectedItem:(NSUInteger)selectedItem {
    _selectedItem = selectedItem;
    _textLabel.text = [_entries[_selectedItem] description];
    
    if (_tableView) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
        [_tableView selectRowAtIndexPath:path
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
    }
}

-(void)initSubviews {
    self.layer.cornerRadius = 7.;
    self.layer.borderWidth = .5;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.textLabel = [[UILabel alloc] init];
    self.textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.textLabel];
    
    self.rightView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"combobox_down"]];
    self.rightView.highlightedImage = [UIImage imageNamed:@"combobox_down_highlighed"];
    [self addSubview:self.rightView];
    
    [self addTarget:self action:@selector(tapHandle) forControlEvents:UIControlEventTouchUpInside];
    self.userInteractionEnabled = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rc = CGRectZero; rc.size = self.frame.size;
    
    CGRect rcRight = rc;
    rcRight.size.width = rc.size.height;
    rcRight.origin.x = rc.origin.x + rc.size.width -rcRight.size.width;
    
    CGRect rcLabel = rc;
    rcLabel.size.width = rc.size.width - rcRight.size.width;
    
    rcLabel = CGRectInset(rcLabel, 3, 3);
    rcRight = CGRectInset(rcRight, 3, 3);
    
    self.textLabel.frame = rcLabel;
    self.rightView.frame = rcRight;
}

#pragma mark - firstResponder
- (void)tapHandle {
    UIView *topView = [UIComboBox topMostView:self];
    assert(topView);
    if (!_tableView) {
        CGRect frame = self.frame;
        frame.origin.y += self.frame.size.height + 2.0;
        frame.size.height = 0.0;
        
        if (self.tableViewOnTop) {
            frame.origin.y = self.frame.origin.y - 2.0 - kComboBoxHeight;
        }
        
        _tableView = [[UITableView alloc] initWithFrame:frame];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        _tableView.layer.cornerRadius = 7.;
        _tableView.layer.borderWidth = .5;
        _tableView.layer.borderColor = [UIColor grayColor].CGColor;
        self.cachedTableViewFrame = frame;
    }
    
    if (_tableView.superview == nil) {
        _rightView.image = [UIImage imageNamed:@"combobox_up"];
        _rightView.highlightedImage = [UIImage imageNamed:@"combobox_up_highlighed"];
        
        CGRect frame = [self.superview convertRect:self.cachedTableViewFrame toView:topView];
        _rightView.frame = frame;
        
        frame.size.height = kComboBoxHeight;
        
        [topView addSubview:_tableView];
        
#if __USING_ANIMATE__
        [UIView animateWithDuration:0.5 animations:^{
            _tableView.frame = frame;
        } completion:^(BOOL finished) {
            //
        }];
#else
        _tableView.frame = frame;
#endif
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:_selectedItem inSection:0];
        [_tableView selectRowAtIndexPath:path
                                animated:YES
                          scrollPosition:UITableViewScrollPositionMiddle];
        
        if (_passthroughView == nil) {
            CGRect rc = [[UIApplication sharedApplication] keyWindow].frame;
            
            _passthroughView = [[PassthroughView alloc] initWithFrame:rc];
            _passthroughView.passViews = [NSArray arrayWithObjects:self, _tableView, nil];
            _passthroughView.delegate = self;
        }
        [topView addSubview:_passthroughView];
    } else {
        [self doClearup];
    }
}

#pragma mark - change state when highlighed

-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    _rightView.highlighted = highlighted; // change button to highlighed state
    _textLabel.highlighted = highlighted; // change label to highlighed state
    UIColor *shadowColor = highlighted ? [UIColor lightGrayColor] : nil;
    _textLabel.shadowColor = shadowColor;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_entries count];
}


#define kTableViewCellHeight 32.0f

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
        cell.textLabel.font = _textLabel.font;
    }
    cell.textLabel.text = [[_entries objectAtIndex:[indexPath row] ] description];
    return cell;
}

- (void)          tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int selectedItem = indexPath.row;
    self.selectedItem = selectedItem;
    [self doClearup];
    [self.delegate comboBox:self selected:selectedItem];
}

-(void) doClearup {
#if __USING_ANIMATE__
    [UIView animateWithDuration:0.5 animations:^{
        CGRect frame = _tableView.frame;
        frame.size.height = 0.0;
        _tableView.frame = frame;
    } completion:^(BOOL finished) {
        [_tableView removeFromSuperview];
        [_passthroughView removeFromSuperview];
    }];
#else
    [_tableView removeFromSuperview];
    [_passthroughView removeFromSuperview];
#endif
    _rightView.image = [UIImage imageNamed:@"combobox_down"];
    _rightView.highlightedImage = [UIImage imageNamed:@"combobox_down_highlighed"];
}


#pragma mark - PassthroughViewDelegate

-(void)doPassthrough:(BOOL)isPass {
    if (!isPass) {
        [self doClearup];
    }
}


#pragma mark ---

+(UIView *) topMostView:(UIView *)view {
    UIView *superView = view.superview;
    if (superView) {
        return [self topMostView:superView];
    } else {
        return view;
    }
}


@end
