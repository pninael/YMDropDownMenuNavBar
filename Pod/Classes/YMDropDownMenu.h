//
//  DropDownMenuView.h
//  DropDown
//
//  Created by Pnina Eliyahu on 10/29/15.
//  Copyright © 2015 Pnina Eliyahu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "UIControl+Blocks.h"

@class YMDropDownMenuItem;

@interface YMDropDownMenu : UIView

@property (nonatomic, strong, readonly) UIButton *toggleButton;
@property (nonatomic, strong, readonly) UIImageView *toggleImage;
@property (nonatomic, strong, readonly) UIView *menuView;
@property (nonatomic, strong, readonly) NSMutableArray *menuButtons;
@property (nonatomic, strong, readonly) UIView *bottomBorderView;
@property (nonatomic, assign) NSInteger selectedItemIndex;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *toggleButtonFont;
@property (nonatomic, strong) UIFont *menuButtonsFont;
@property (nonatomic, strong) UIColor *menuItemsBackgroudColor;
@property (nonatomic, strong) UIColor *selectedItemBackgroundColor;

/**
 *  Initialize a DropDownMenu with a nil termintaed menuItems list
 *  The list can contain unlimited number of menu items
 *
 *  @note the list must terminate with nil
 */
-(id)initWithFrame:(CGRect)frame andMenuItems:(YMDropDownMenuItem*)firstItem, ...;

/**
 *  Initialize a DropDownMenu with the given first item, and a nil termintaed va_list of other items
 *
 *  @note the va_list must terminate with nil
 */
-(id)initWithFrame:(CGRect)frame andMenuItems:(YMDropDownMenuItem*)firstItem otherItems:(va_list)valist;

@end

@interface YMDropDownMenuItem : NSObject

@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) void (^actionBlock)(id sender) ;

+ (instancetype)itemWithTitle:(NSString*)title actionBlock:(void(^)(id sender))actionBlock;

@end

