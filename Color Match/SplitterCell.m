//
//  SplitterCell.m
//  Color Match
//
//  Created by Linda Chen on 7/1/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "SplitterCell.h"

@implementation SplitterCell

-(id)init:(int)cellType
{
    self = [super init:cellType];
    if (self)
    {
        self.inputColor = 0;
    }
    
    return self;
}

@end
