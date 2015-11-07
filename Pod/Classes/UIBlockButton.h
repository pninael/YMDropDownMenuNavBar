//
//  UIBlockButton.h
//  DropDown
//
//  Created by Pnina Eliyahu on 11/3/15.
//  Copyright © 2015 Pnina Eliyahu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ActionBlock)();

/**
 *  UIButton with the ability to add a block as target
 *  
 *  @note current implementation is simple and enables adding handler ONLY for a single UIControlEvent
 *  It can be expended later if needed
 */
@interface UIBlockButton : UIButton

@property (nonatomic, strong) ActionBlock actionBlock;

-(void) addActionBlock:(ActionBlock)action forControlEvents:(UIControlEvents)controlEvents;

@end
