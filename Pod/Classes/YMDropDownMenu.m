//
//  DropDownMenuView.m
//  DropDown
//
//  Created by Pnina Eliyahu on 10/29/15.
//  Copyright © 2015 Pnina Eliyahu. All rights reserved.
//

#import "YMDropDownMenu.h"
#import "UIControl+Blocks.h"

@implementation YMDropDownMenu

// @synthesize since both setter & getter are override
@synthesize textColor = _textColor;
@synthesize menuItemsBackgroudColor = _menuItemsBackgroudColor;
@synthesize selectedItemBackgroundColor = _selectedItemBackgroundColor;

#pragma mark - init

-(id)initWithFrame:(CGRect)frame andMenuItems:(YMDropDownMenuItem*)firstItem, ...
{
    va_list argumentList;
    va_start(argumentList, firstItem);
    
    return [self initWithFrame:frame andMenuItems:firstItem otherItems:argumentList];
}

-(id)initWithFrame:(CGRect)frame andMenuItems:(YMDropDownMenuItem*)firstItem otherItems:(va_list)vaList
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        // First collect the menu items from the arguments va_list
        id nextItem;
        NSMutableArray *items = [[NSMutableArray alloc] init];
        if (firstItem)
        {
            // The first argument isn't part of the varargs list,so we'll handle it separately
            [items addObject: firstItem];
            
            while ((nextItem = va_arg(vaList, id)))
            {
                [items addObject: nextItem];
            }
            va_end(vaList);
        }
        
        // Initialize the toggle button
        UIColor *buttonsTitleColor = _textColor ? _textColor : [self.class defaultTitlesColor];
        UIColor *buttonsBackgroudColor = _menuItemsBackgroudColor ? _menuItemsBackgroudColor : [self.class defaultMenuItemsBackgroudColor];
        
        _toggleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //_toggleButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
        
        [_toggleButton setTitleColor:buttonsTitleColor forState:UIControlStateNormal];
        
        UIImage *arrow = [UIImage imageNamed:@"arrowDown"];
        [_toggleButton setImage:arrow forState:UIControlStateNormal];
        [_toggleButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        
        // switch the positions of the button title and image, so that image appears on right
        _toggleButton.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _toggleButton.titleLabel.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        _toggleButton.imageView.transform = CGAffineTransformMakeScale(-1.0, 1.0);
        
        [_toggleButton addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];

        
        [self addSubview:_toggleButton];
        
        // Initialize the menu view
        _menuView = [[UIView alloc] init];
        _menuView.alpha = 0;
        _menuView.clipsToBounds = YES;
        
        //_menuView.layer.borderColor = [UIColor grayColor].CGColor;
        //_menuView.layer.borderWidth = 1.0f;
        
        // Initialize the menu buttons
        _menuButtons = [[NSMutableArray alloc] init];
        int itemIndex = 0;
        for (YMDropDownMenuItem* menuAction in items)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            
            [button setTitle:menuAction.title forState:UIControlStateNormal];
            [button setTitleColor:buttonsTitleColor forState:UIControlStateNormal];
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            
            [button addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(itemClicked:) forControlEvents:UIControlEventTouchDown];
            [button addActionCompletionBlock:menuAction.actionBlock forControlEvents:UIControlEventTouchUpInside];
            [button setTag:itemIndex];
            
            [_menuView addSubview:button];
            [_menuButtons addObject:button];
            itemIndex++;
            
            [button setBackgroundColor:buttonsBackgroudColor];
            //[button setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        }
        
        //add bottom border
        _bottomBorderView = [[UIView alloc] init];
        _bottomBorderView.backgroundColor = [UIColor grayColor];
        [_menuView addSubview:_bottomBorderView];
    }
    
    self.selectedItemIndex = 0;
    return self;
}

#pragma mark - setters & getters

- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex
{
    // de-select the privious selected item
    UIButton *previousSelected = self.menuButtons[_selectedItemIndex];
    [previousSelected setBackgroundColor:self.menuItemsBackgroudColor];
    [previousSelected setImage:nil forState:UIControlStateNormal];
    previousSelected.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    
    _selectedItemIndex = selectedItemIndex;
    UIButton *selectedItem = self.menuButtons[selectedItemIndex];
    [selectedItem setBackgroundColor:self.selectedItemBackgroundColor];
    [selectedItem setImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.toggleButton setTitle:selectedItem.titleLabel.text forState:UIControlStateNormal];
    
    UIEdgeInsets checkMarkImageInsets = selectedItem.imageEdgeInsets;
    checkMarkImageInsets.left = selectedItem.frame.size.width - selectedItem.imageView.image.size.width - 25;
    [selectedItem setImageEdgeInsets:checkMarkImageInsets];
    selectedItem.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, selectedItem.imageView.image.size.width);
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    
    [self.toggleButton setTitleColor:textColor forState:UIControlStateNormal];
    for (UIButton *button in self.menuButtons)
    {
        [button setTitleColor:textColor forState:UIControlStateNormal];
    }
}

- (void)setToggleButtonFont:(UIFont *)toggleButtonFont
{
    _toggleButtonFont = toggleButtonFont;
    self.toggleButton.titleLabel.font = toggleButtonFont;
}

- (void)setMenuButtonsFont:(UIFont *)menuButtonsFont
{
    _menuButtonsFont = menuButtonsFont;

    for (UIButton *button in self.menuButtons)
    {
        button.titleLabel.font = menuButtonsFont;
    }
}

- (void)setMenuItemsBackgroudColor:(UIColor *)menuItemsBackgroudColor
{
    _menuItemsBackgroudColor = menuItemsBackgroudColor;
    
    UIButton *selectedItem = self.menuButtons[self.selectedItemIndex];
    for (UIButton *button in self.menuButtons)
    {
        if(button != selectedItem)
        {
            [button setBackgroundColor:menuItemsBackgroudColor];
        }
    }
}

- (void)setSelectedItemBackgroundColor:(UIColor *)selectedItemBackgroundColor
{
    _selectedItemBackgroundColor = selectedItemBackgroundColor;
    UIButton *selectedItem = self.menuButtons[self.selectedItemIndex];
    [selectedItem setBackgroundColor:selectedItemBackgroundColor];
}

- (UIColor *)titlesColor
{
    return _textColor ? _textColor : [self.class defaultTitlesColor];
}

- (UIColor *)menuItemsBackgroudColor
{
    return _menuItemsBackgroudColor ? _menuItemsBackgroudColor : [self.class defaultMenuItemsBackgroudColor];
}

- (UIColor *)selectedItemBackgroundColor
{
    return _selectedItemBackgroundColor ? _selectedItemBackgroundColor : [self.class defaultSelectedItemBackgroundColor];
}

#pragma mark - UIView override

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat toggleButtonWidth = CGRectGetWidth(self.bounds);
    CGFloat menuItemWidth = CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds);
    CGFloat menuItemHeight = CGRectGetHeight(self.bounds);
    
    self.toggleButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - toggleButtonWidth) / 2, 0, toggleButtonWidth, menuItemHeight);
    
    self.toggleImage.frame = CGRectMake(self.toggleButton.titleLabel.frame.origin.x + self.toggleButton.titleLabel.frame.size.width + 5,
                                        self.toggleButton.titleLabel.frame.origin.y,
                                        self.toggleButton.titleLabel.frame.size.height,
                                        self.toggleButton.titleLabel.frame.size.height);
    
    // Convert the coordinates of the view into the window coordinate, and layout the menu view accordingly
    CGRect viewInMainWindow = [self convertRect:self.bounds toView:nil];
    self.menuView.frame = CGRectMake(0,
                                     viewInMainWindow.origin.y + viewInMainWindow.size.height - 1,
                                     menuItemWidth,
                                     [_menuButtons count] * menuItemHeight + 1);
    
    // layout the menu buttons
    CGFloat y = 0;
    for(UIButton *button in self.menuButtons)
    {
        button.frame = CGRectMake(0, y, menuItemWidth, menuItemHeight);
        y += menuItemHeight;
        
        UIEdgeInsets checkMarkImageInsets = button.imageEdgeInsets;
        // if the button is selected, fix the check mark image edgeInsets
        if(button.imageView.image) {
            checkMarkImageInsets.left = button.frame.size.width - button.imageView.image.size.width - 25;
            [button setImageEdgeInsets:checkMarkImageInsets];
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, button.imageView.image.size.width);
        }
        else
        {
            button.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
            
//            checkMarkImageInsets.left = button.frame.size.width - 25;
//            [button setImageEdgeInsets:checkMarkImageInsets];
//            //button.contentEdgeInsets = UIEdgeInsetsMake(0, 200, 0, 0);
        }
    }
    
    //layout the bottom border
    self.bottomBorderView.frame = CGRectMake(0, y, self.menuView.frame.size.width, 1);
}

#pragma mark - IBActions

- (IBAction)toggleMenu:(UIButton *)sender
{
    if(self.menuView.alpha == 0)
    {
        [self showMenu];
    }
    else
    {
        [self hideMenu];
    }
}

- (IBAction)itemSelected:(UIButton *)sender
{
    self.selectedItemIndex = sender.tag;
    [self hideMenu];
}

- (IBAction)itemClicked:(UIButton *)sender
{
    [self.toggleButton setTitle:sender.titleLabel.text forState:UIControlStateNormal];
    UIImage *arrow = [UIImage imageNamed:@"arrowDown"];
    [_toggleButton setImage:arrow forState:UIControlStateNormal];
}

#pragma mark - private

- (void)showMenu
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
    
    self.menuView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 0.001f);
    [self.menuView layer].anchorPoint = CGPointMake(0.5f, 0.0f);
    
    CGFloat offsetFromMovingAnchorPoint = -1 * self.bounds.size.height;
    self.menuView.transform = CGAffineTransformTranslate(self.menuView.transform, 0, offsetFromMovingAnchorPoint);

    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:4.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _menuView.alpha = 1;
                         self.menuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, offsetFromMovingAnchorPoint);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
                     }
                     completion:^(BOOL finished){
                     }];
    
    UIImage *arrow = [UIImage imageNamed:@"arrowUp"];
    [_toggleButton setImage:arrow forState:UIControlStateNormal];
}

- (void)hideMenu
{
    self.menuView.alpha = 0;
    [self.menuView removeFromSuperview];
    self.menuView.transform = CGAffineTransformIdentity;
    
    UIImage *arrow = [UIImage imageNamed:@"arrowDown"];
    [_toggleButton setImage:arrow forState:UIControlStateNormal];
}

// The default colors listed below are temporary until final design is ready

+ (UIColor *)defaultTitlesColor
{
    return [UIColor blackColor];
}

+ (UIColor *)defaultMenuItemsBackgroudColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)defaultSelectedItemBackgroundColor
{
    return [UIColor whiteColor];
}

@end

#pragma mark - YMDropDownMenuItem

@implementation YMDropDownMenuItem

+ (instancetype)itemWithTitle:(NSString *)title actionBlock:(void (^)(id))actionBlock
{
    YMDropDownMenuItem* menuAction = [[self alloc] init];
    
    if(menuAction)
    {
        [menuAction setTitle:title];
        [menuAction setActionBlock:actionBlock];
    }
    
    return menuAction;
}

@end
