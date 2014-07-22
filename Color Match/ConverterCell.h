//
//  ConverterCell.h
//  Color Match
//
//  Created by Linda Chen on 7/2/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "ColorCell.h"
#import "GridColorButton.h"

@interface ConverterCell : ColorCell
@property bool isDirectionRight;
@property int row;
@property int col;
@property int horizontalColorInput;
@property int verticalColorInput;
@end
