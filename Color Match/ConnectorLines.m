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
@property NSMutableArray *converterVerticalLines;
@property NSMutableArray *converterHorizontalLines;
@property NSMutableDictionary *transporterGroups;
@property BOOL needToClear;
@end

@implementation ConnectorLines

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.verticalLines = [[NSMutableArray alloc] init];
        self.horizontalLines = [[NSMutableArray alloc] init];
        self.converterVerticalLines = [[NSMutableArray alloc] init];
        self.converterHorizontalLines = [[NSMutableArray alloc] init];
        self.transporterGroups = [[NSMutableDictionary alloc] init];
        [self setBackgroundColor:[UIColor clearColor]];
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
    
    for (int i = 0; i < self.converterHorizontalLines.count; i++)
    {
        LineInfo *lineInfo = [self.converterHorizontalLines objectAtIndex:i];
        [self drawLine:lineInfo];
    }
    
    for (int i = 0; i < self.converterVerticalLines.count; i++)
    {
        LineInfo *lineInfo = [self.converterVerticalLines objectAtIndex:i];
        [self drawLine:lineInfo];
    }
    
    for (id key in self.transporterGroups)
    {
        NSMutableArray* groupLines = [self.transporterGroups objectForKey:key];
        
        for (int j = 0; j < groupLines.count; j++)
        {
            LineInfo *lineInfo = [groupLines objectAtIndex:j];
            [self drawLine:lineInfo];
        }
    }
}

- (void)drawLine:(LineInfo*)line
{
    int curveRadius = 11;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, line.lineThickness);
    
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

- (void)addConverterLine:(LineInfo*)lineInfo isHorizontal:(BOOL)isHorizontal
{
    if (isHorizontal)
    {
        [self.converterHorizontalLines addObject:lineInfo];
    }
    else
    {
        [self.converterVerticalLines addObject:lineInfo];
    }
    
    [self setNeedsDisplay];
}

- (void)addTransporterGroupLines:(int)groupId groupLines:(NSMutableArray*)groupLines
{
    NSString* key = [NSString stringWithFormat:@"%d", groupId];
    [self.transporterGroups setObject:groupLines forKey:key];
}

-(NSMutableArray*)getTransporterGroupLines:(int)groupId
{
    NSString* key = [NSString stringWithFormat:@"%d", groupId];
    NSMutableArray* transporterGroupLines = [self.transporterGroups objectForKey:(key)];
    
    if (transporterGroupLines == NULL)
    {
        transporterGroupLines = [[NSMutableArray alloc] init];
        [self addTransporterGroupLines:groupId groupLines:transporterGroupLines];
    }
    
    return transporterGroupLines;
}

- (void)addTransporterLine:(int)groupId lineInfo:(LineInfo*)lineInfo
{
    NSMutableArray* groupLines = [self getTransporterGroupLines:groupId];
    [groupLines addObject:lineInfo];
    
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

- (void)updateConverterLine:(int)lineIndex color:(UIColor*)color
{
    // Update both lines
    LineInfo *verticalLineInfo = [self.converterVerticalLines objectAtIndex:lineIndex];
    verticalLineInfo.color = color;
    
    LineInfo *horizontalLineInfo = [self.converterHorizontalLines objectAtIndex:lineIndex];
    horizontalLineInfo.color = color;
    
    [self setNeedsDisplay];
}

- (void)updateTransporterLine:(int)groupId color:(UIColor*)color
{
    NSMutableArray* groupLines = [self getTransporterGroupLines:groupId];
    
    for (LineInfo* line in groupLines)
    {
        // Update both lines
        line.color = color;
    }
    
    [self setNeedsDisplay];
}

- (void)clear
{
    self.needToClear = true;
    [self setNeedsDisplay];
}

@end
