//
//  DiverterCell.h
//  Color Match
//
//  Created by Linda Chen on 6/24/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import "ColorCell.h"

@interface DiverterCell : ColorCell
@property ColorCell* topToRightLine;
@property ColorCell* leftToDownLine;
@end
