//
//  DiverterCell.m
//  Color Match
//
//  Created by Linda Chen on 6/24/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import "DiverterCell.h"

@implementation DiverterCell

-(id)init:(int)cellType
{
    self = [super init:cellType];
    if (self)
    {
        self.topToRightLine = [[ColorCell alloc] init:NormalCell];
        self.leftToDownLine = [[ColorCell alloc] init:NormalCell];
    }
    
    return self;
}

-(void)addInputColor:(NSNumber*)color cellsAffected:(NSMutableArray*)cellsAffected isHorizontal:(bool)isHorizontal
{
    ColorCell* cellToPassColor = isHorizontal ? self.leftToDownLine : self.topToRightLine;

    [cellToPassColor addInputColor:color cellsAffected:NULL isHorizontal:isHorizontal];
}

-(void)removeInputColor:(NSNumber*)color cellsAffected:(NSMutableArray*)cellsAffected isHorizontal:(bool)isHorizontal
{
    ColorCell* cellToPassColor = isHorizontal ? self.leftToDownLine : self.topToRightLine;
    
    [cellToPassColor removeInputColor:color cellsAffected:NULL isHorizontal:isHorizontal];
}

@end
