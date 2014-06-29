//
//  ConnectorLine.m
//  Color Match
//
//  Created by Linda Chen on 5/12/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "ConnectorLines.h"
#import "LineInfo.h"

@interface ConnectorLines ()
@property NSMutableArray *verticalLines;
@property NSMutableArray *horizontalLines;
@property BOOL needToClear;
@end

@implementation ConnectorLines

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.verticalLines = [[NSMutableArray alloc] init];
        self.horizontalLines = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.needToClear)
    {
        self.needToClear = false;
        return;
    }
    
    for (int i = 0; i < self.horizontalLines.count; i++)
    {
        LineInfo *lineInfo = [self.horizontalLines objectAtIndex:i];
        [self drawLine:lineInfo];
    }
    
    for (int i = 0; i < self.verticalLines.count; i++)
    {
        LineInfo *lineInfo = [self.verticalLines objectAtIndex:i];
        [self drawLine:lineInfo];
    }
}

- (void)drawLine:(LineInfo*)line
{
    int curveRadius = 10;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    
    // Begin path
    CGContextSetStrokeColorWithColor(context, line.color.CGColor);
    CGContextBeginPath(context);
    
    // Add lines
    CGContextMoveToPoint(context, line.startX, line.startY);
    
    for (int i = 0; i < line.linePieces.count; i++)
    {
        LinePiece *linePiece = [line.linePieces objectAtIndex:i];
        
        if (i + 1 == line.linePieces.count)
        {
            // Normal stroke for the last line
            CGContextAddLineToPoint(context, linePiece.endX, linePiece.endY);
        }
        else
        {
            LinePiece *nextLinePiece = [line.linePieces objectAtIndex:i+1];
            if (linePiece.isHorizontal == nextLinePiece.isHorizontal)
            {
                // Normal stroke for same direction connections
                CGContextAddLineToPoint(context, linePiece.endX, linePiece.endY);
            }
            else
            {
                // Add curve
                CGContextAddArcToPoint(context, linePiece.endX, linePiece.endY, nextLinePiece.endX, nextLinePiece.endY, curveRadius);
            }
        }
    }
    
    // Stroke path
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGContextStrokePath(context);
}

- (void)addLine:(LineInfo*)lineInfo isHorizontal:(BOOL)isHorizontal
{
    if (isHorizontal)
    {
        [self.horizontalLines addObject:lineInfo];
    }
    else
    {
        [self.verticalLines addObject:lineInfo];
    }
    
    [self setNeedsDisplay];
}

- (void)updateLine:(int)lineIndex isHorizontal:(BOOL)isHorizontal color:(UIColor*)color
{
    LineInfo *lineInfo;
    
    if (!isHorizontal)
    {
        lineInfo = [self.verticalLines objectAtIndex:lineIndex];
    }
    else
    {
        lineInfo = [self.horizontalLines objectAtIndex:lineIndex];
    }
    
    lineInfo.color = color;
    
    [self setNeedsDisplay];
} 

- (void)clear
{
    self.needToClear = true;
    [self setNeedsDisplay];
}

@end
