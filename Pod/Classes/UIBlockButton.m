//
//  UIBlockButton.m
//  DropDown
//
//  Created by Pnina Eliyahu on 11/3/15.
//  Copyright © 2015 Pnina Eliyahu. All rights reserved.
//

#import "UIBlockButton.h"

@implementation UIBlockButton

- (void)addActionBlock:(ActionBlock)action forControlEvents:(UIControlEvents)controlEvents
{
    [self setActionBlock:[action copy]];
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:controlEvents];
}

- (void)callActionBlock:(id)sender
{
    self.actionBlock();
}

@end
