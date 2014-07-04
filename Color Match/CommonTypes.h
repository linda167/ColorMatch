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
    int xOffsetForFirstLeftGridButton;
    int yOffsetForFirstTopGridButton;
    int emptyPaddingInGridButton;
    int goalColorCellSize;
    int goalColorCellSpacing;
    int xAdjustmentForColorCells;
    int reflectorArrowCellSize;
    int reflectorLeftToDownArrowXAdjustment;
    int reflectorTopToRightArrowXAdjustment;
    int reflectorLeftToDownArrowYAdjustment;
    int reflectorTopToRightArrowYAdjustment;
    
    // Mechanics lower and upper bound
    int reflectorMechanicLowerBound;
    int reflectorMechanicUpperBound;
    int zonerMechanicLowerBound;
    int zonerMechanicUpperBound;
    int connectorMechanicLowerBound;
    int connectorMechanicUpperBound;
    int diverterMechanicLowerBound;
    int diverterMechanicUpperBound;
    int splitterMechanicLowerBound;
    int splitterMechanicUpperBound;
} BoardParameters;

// Cell type
typedef NS_ENUM(NSUInteger, CellType)
{
    NormalCell = 0,
    ReflectorLeftToDown = 1,
    ReflectorTopToRight = 2,
    Zoner = 3,
    Connector = 4,
    Diverter = 5,
    Splitter = 6,
    Converter = 7
};


#endif
