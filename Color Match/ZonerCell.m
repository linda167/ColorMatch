//
//  ZonerCell.m
//  Color Match
//
//  Created by Linda Chen on 6/19/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "ZonerCell.h"

@implementation ZonerCell

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
