//
//  DropDownMenuNavBar.m
//  DropDown
//
//  Created by Pnina Eliyahu on 11/3/15.
//  Copyright © 2015 Pnina Eliyahu. All rights reserved.
//

#import "YMDropDownMenuNavBar.h"

@implementation YMDropDownMenuNavBar

-(id)initWithMenuItems:(YMDropDownMenuItem*)firstItem, ...;
{
    self = [super init];
    
    if(self)
    {
        va_list vaList;
        va_start(vaList, firstItem);
        
        _dropDownMenu = [[YMDropDownMenu alloc] initWithFrame:self.frame
                                               andMenuItems:firstItem
                                                 otherItems:vaList];
        
        [[UINavigationBar appearance] setBarTintColor:_dropDownMenu.menuItemsBackgroudColor];
        
        [self addSubview:_dropDownMenu];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.dropDownMenu.frame = (CGRect){
        .origin = CGPointZero,
        .size = self.bounds.size
    };
    
    [_dropDownMenu setMenuItemsBackgroudColor:[super barTintColor]];
}

@end
