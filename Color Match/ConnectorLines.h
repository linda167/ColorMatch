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

- (void)addLine:(LineInfo*)lineInfo isHorizontal:(BOOL)isHorizontal;
- (void)updateLine:(int)lineIndex isHorizontal:(BOOL)isHorizontal color:(UIColor*)color;

@end
