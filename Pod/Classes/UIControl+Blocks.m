//
//  UIControl+Blocks.m
//
//  Created by Dave Peck on 1/2/12.
//

#import "UIControl+Blocks.h"
#import <objc/runtime.h>

@interface UIControlActionBlockWrapper : NSObject
@property (nonatomic, copy) void (^actionBlock)(id);

- (void)invokeBlock:(id)sender;
@end

@implementation UIControlActionBlockWrapper
@synthesize actionBlock;

- (void)dealloc
{
    [self setActionBlock:nil];
}

- (void)invokeBlock:(id)sender
{
    [self actionBlock](sender);
}
@end

@implementation UIControl (Blocks)

static const char *UIControlBlocks = "C573F3BB-5F2E-4192-B6B9-AB4E8ED8AC3A";

- (void)addActionCompletionBlock:(void (^)(id))actionCompletionBlock forControlEvents:(UIControlEvents)controlEvents {
    
    NSMutableDictionary *blockActions = objc_getAssociatedObject(self, &UIControlBlocks);
    if (blockActions == nil) {
        blockActions = [NSMutableDictionary dictionaryWithCapacity:1];
        objc_setAssociatedObject(self, &UIControlBlocks, blockActions, OBJC_ASSOCIATION_RETAIN);
    }
    
    UIControlActionBlockWrapper *target = [[UIControlActionBlockWrapper alloc] init];
    [target setActionBlock:actionCompletionBlock];
    
    NSNumber *key = [NSNumber numberWithInt:controlEvents];
    NSMutableArray *actionsForControlEvents = blockActions[key];
    if (!actionsForControlEvents) {
        actionsForControlEvents = [NSMutableArray arrayWithCapacity:1];
        blockActions[key] = actionsForControlEvents;
    }
    
    [actionsForControlEvents addObject:target];
    
    [self addTarget:target action:@selector(invokeBlock:) forControlEvents:controlEvents];    
}

- (void)removeActionCompletionBlocksForControlEvents:(UIControlEvents)controlEvents
{
    NSMutableDictionary *blockActions = objc_getAssociatedObject(self, &UIControlBlocks);
    if (blockActions) {
        NSMutableArray *actionsForControlEvents = blockActions[[NSNumber numberWithInt:controlEvents]];
        if (actionsForControlEvents) {
            for (NSInteger i = ([actionsForControlEvents count] - 1); i >= 0; i--) {
                UIControlActionBlockWrapper *target = (UIControlActionBlockWrapper *)actionsForControlEvents[i];
                [self removeTarget:target action:@selector(invokeBlock:) forControlEvents:controlEvents];
                [actionsForControlEvents removeObjectAtIndex:i];
            }
        }
    }
}

@end
