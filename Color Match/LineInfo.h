//
//  LineInfo.h
//  Color Match
//
//  Created by Linda Chen on 5/18/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LinePiece.h"

@interface LineInfo : NSObject

@property UIColor* color;
@property int startX;
@property int startY;
@property NSMutableArray *linePieces;
- (void)addLinePiece:(LinePiece*) linePiece;

@end
