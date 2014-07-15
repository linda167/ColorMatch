//
//  TeleporterGroup.m
//  Color Match
//
//  Created by Linda Chen on 7/4/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "TransporterGroup.h"

@implementation TransporterGroup

- (id)init
{
    self = [super init];
    if (self)
    {
        self.teleporterInputs = [[NSMutableArray alloc] init];
        self.teleporterOutputs = [[NSMutableArray alloc] init];
        self.colorInputs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)applyColorToGroup:(NSNumber*)color isAdd:(int)isAdd
{
    if (isAdd)
    {
        [self addInputColor:color];
    }
    else
    {
        [self removeInputColor:color];
    }
}

-(void)addInputColor:(NSNumber*)color
{
    [self.colorInputs addObject:color];
    [self recalculateOutputColor];
}

-(void)removeInputColor:(NSNumber*)color
{
    NSInteger existingColorIndex = [self.colorInputs indexOfObject:color];
    if (existingColorIndex == NSNotFound)
    {
        [NSException raise:@"Invalid input" format:@"Color to remove not found in current input list"];
    }
    
    [self.colorInputs removeObjectAtIndex:existingColorIndex];
    [self recalculateOutputColor];
}

-(void)recalculateOutputColor
{
    int combinedColor = [CommonUtils CombineColorsList:_colorInputs];
    self.currentColor = combinedColor;
}

@end
