//
//  DropDownMenuView.m
//  DropDown
//
//  Created by Pnina Eliyahu on 10/29/15.
//  Copyright © 2015 Pnina Eliyahu. All rights reserved.
//

#import "YMDropDownMenu.h"
#import "UIBlockButton.h"

@implementation YMDropDownMenu

// @synthesize since both setter & getter are override
@synthesize titlesColor = _titlesColor;
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
        UIColor *buttonsTitleColor = _titlesColor ? _titlesColor : [self.class defaultTitlesColor];
        UIColor *buttonsBackgroudColor = _menuItemsBackgroudColor ? _menuItemsBackgroudColor : [self.class defaultMenuItemsBackgroudColor];
        
        _toggleButton = [[UIButton alloc]init];
        [_toggleButton addTarget:self action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
        [_toggleButton setTitleColor:buttonsTitleColor forState:UIControlStateNormal];
        [self addSubview:_toggleButton];
        
        // Initialize the menu view
        _menuView = [[UIView alloc] init];
        _menuView.alpha = 0;

        // Initialize the menu buttons
        _menuButtons = [[NSMutableArray alloc] init];
        int itemIndex = 0;
        for (YMDropDownMenuItem* menuAction in items)
        {
            UIBlockButton *button = [[UIBlockButton alloc]init];
            [button setTitle:menuAction.title forState:UIControlStateNormal];
            [button addActionBlock:menuAction.actionBlock forControlEvents:UIControlEventTouchUpInside];
            [button addTarget:self action:@selector(itemSelected:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:buttonsTitleColor forState:UIControlStateNormal];
            [button setTag:itemIndex];
            [_menuView addSubview:button];
            [_menuButtons addObject:button];
            itemIndex++;
            
            [button setBackgroundColor:buttonsBackgroudColor];
        }
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
    
    _selectedItemIndex = selectedItemIndex;
    UIButton *selectedItem = self.menuButtons[selectedItemIndex];
    [selectedItem setBackgroundColor:self.selectedItemBackgroundColor];
    [self.toggleButton setTitle:selectedItem.titleLabel.text forState:UIControlStateNormal];
}

- (void)setTitlesColor:(UIColor *)titlesColor
{
    _titlesColor = titlesColor;
    
    [self.toggleButton setTitleColor:titlesColor forState:UIControlStateNormal];
    for (UIButton *button in self.menuButtons)
    {
        [button setTitleColor:titlesColor forState:UIControlStateNormal];
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
    return _titlesColor ? _titlesColor : [self.class defaultTitlesColor];
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
    
    CGFloat toggleButtonWidth = CGRectGetWidth(self.bounds) * 0.6;
    CGFloat menuItemWidth = CGRectGetWidth(self.bounds);
    CGFloat menuItemHeight = CGRectGetHeight(self.bounds);
    
    self.toggleButton.frame = CGRectMake((CGRectGetWidth(self.bounds) - toggleButtonWidth) / 2, 0, toggleButtonWidth, menuItemHeight);
    
    // Convert the coordinates of the view into the window coordinate, and layout the menu view accordingly
    CGRect viewInMainWindow = [self convertRect:self.bounds toView:nil];
    self.menuView.frame = CGRectMake(viewInMainWindow.origin.x,
                                     viewInMainWindow.origin.y + viewInMainWindow.size.height,
                                     menuItemWidth,
                                     [_menuButtons count] * menuItemHeight);
    
    // layout the menu buttons
    CGFloat y = 0;
    for(UIButton *button in self.menuButtons)
    {
        button.frame = CGRectMake(0, y, menuItemWidth, menuItemHeight);
        y += menuItemHeight;
    }
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

#pragma mark - private

- (void)showMenu
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuView];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:4.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
                     {
                         _menuView.alpha = 1;
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)hideMenu
{
    [self.menuView removeFromSuperview];
    
    [UIView animateWithDuration:0.4
                          delay:0.0
         usingSpringWithDamping:1.0
          initialSpringVelocity:4.0
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
                     {
                         _menuView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                     }];
}

// The default colors listed below are temporary until final design is ready

+ (UIColor *)defaultTitlesColor
{
    return [UIColor colorWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0f];
}

+ (UIColor *)defaultMenuItemsBackgroudColor
{
    return [UIColor colorWithRed:230/255.0f green:230/255.0f blue:230/255.0f alpha:1.0f];
}

+ (UIColor *)defaultSelectedItemBackgroundColor
{
    return [UIColor colorWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0f];
}

@end

#pragma mark - YMDropDownMenuItem

@implementation YMDropDownMenuItem

+ (instancetype)itemWithTitle: (NSString*)title blockAction:(ActionBlock)actionBlock
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
