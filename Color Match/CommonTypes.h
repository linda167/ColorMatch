//
//  CommonTypes.h
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#ifndef Color_Match_CommonTypes_h
#define Color_Match_CommonTypes_h

// Parameters used to create current board
typedef struct BoardParameters
{
    int gridSize;
    int colorCellSize;
    int colorCellSpacing;
    int yOffsetForFirstTopGridButton;
    int xOffsetForFirstLeftGridButton;
    int emptyPaddingInGridButton;
    int goalColorCellSize;
    int goalColorCellSpacing;
} BoardParameters;

#endif
