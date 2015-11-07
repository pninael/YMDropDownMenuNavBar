//
//  DropDownMenuNavBar.h
//  DropDown
//
//  Created by Pnina Eliyahu on 11/3/15.
//  Copyright © 2015 Pnina Eliyahu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YMDropDownMenu.h"

/**
 *  A custom navigation bar, with a drop down menu embedded
 */
@interface YMDropDownMenuNavBar : UINavigationBar

@property (nonatomic, strong) YMDropDownMenu *dropDownMenu;

-(id)initWithMenuItems:(YMDropDownMenuItem*)firstItem, ...;

@end
