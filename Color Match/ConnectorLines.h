//
//  ConnectorLine.h
//  Color Match
//
//  Created by Linda Chen on 5/12/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LineInfo.h"

@interface ConnectorLines : UIView

@property NSMutableArray *converterLines;

- (void)addLine:(LineInfo*)lineInfo isHorizontal:(BOOL)isHorizontal;
- (void)updateLine:(int)lineIndex isHorizontal:(BOOL)isHorizontal color:(UIColor*)color;
- (void)clear;
- (void)addConverterLine:(LineInfo*)lineInfo;
- (void)updateConverterLine:(int)lineIndex color:(UIColor*)color;
- (NSMutableArray*)getTransporterGroupLines:(int)groupId;
- (void)addTransporterLine:(int)groupId lineInfo:(LineInfo*)lineInfo;
- (void)updateTransporterLine:(int)groupId color:(UIColor*)color;
- (void)replaceConverterLine:(LineInfo*)lineInfo index:(int)index;

@end
