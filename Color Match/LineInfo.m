//
//  LineInfo.m
//  Color Match
//
//  Created by Linda Chen on 5/18/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "LineInfo.h"
#import "LinePiece.h"

@implementation LineInfo

- (id)init
{
    self = [super init];
    if (self)
    {
        self.linePieces = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)addLinePiece:(LinePiece*) linePiece
{
    [self.linePieces addObject:linePiece];
}

@end
