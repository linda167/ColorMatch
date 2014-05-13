//
//  ConnectorLine.m
//  Color Match
//
//  Created by Linda Chen on 5/12/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "ConnectorLines.h"

@interface ConnectorLines ()
@property NSMutableArray *lines;
@end

@implementation ConnectorLines

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.lines = [[NSMutableArray alloc] init];
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3.0);
    CGContextSetStrokeColorWithColor(context, [CommonUtils GetGrayColor].CGColor);
    CGContextBeginPath(context);
    
    for (int i = 0; i < self.lines.count; i++)
    {
        
        NSValue *boxedLineInfo = [self.lines objectAtIndex:i];
        struct LineInfo lineInfo;
        [boxedLineInfo getValue:&lineInfo];
        CGContextMoveToPoint(context, lineInfo.startX, lineInfo.startY);
        CGContextAddLineToPoint(context, lineInfo.endX, lineInfo.endY);
    }
    
    CGContextStrokePath(context);
}

- (void)addLine:(LineInfo)lineInfo
{
    NSValue *boxedLineInfo = [NSValue valueWithBytes:&lineInfo objCType:@encode(struct LineInfo)];
    [self.lines addObject:boxedLineInfo];
}

@end
