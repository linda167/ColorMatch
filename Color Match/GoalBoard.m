//
//  GoalBoard.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "GoalBoard.h"

@implementation GoalBoard

-(id)initWithParameters:(BoardParameters)boardParameters containerView:(UIView*)containerView
{
    self = [super init];
    if (self)
    {
        self.boardParameters = boardParameters;
        self.containerView = containerView;
        
        [self initGoalColorCells];
    }
    
    return self;
}

- (void)initGoalColorCells
{
    int cellSizePlusSpace = self.boardParameters.goalColorCellSize + self.boardParameters.goalColorCellSpacing;
    int xOffsetInitial = 0;
    int xOffset = xOffsetInitial;
    int yOffset = 0;
    
    self.colorCellSections = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        NSMutableArray *row = [[NSMutableArray alloc] init];
        for (int j=0; j<self.boardParameters.gridSize; j++)
        {
            UIImageView *cellBlock = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, self.boardParameters.goalColorCellSize, self.boardParameters.goalColorCellSize)];
            cellBlock.image=[UIImage imageNamed:@"BlockWhite.png"];
            [self.containerView addSubview:cellBlock];
            
            [row addObject:cellBlock];
            xOffset += cellSizePlusSpace;
        }
        
        [self.colorCellSections addObject:row];
        yOffset += cellSizePlusSpace;
        xOffset = xOffsetInitial;
    }
}

- (void)removeExistingGoalColorCells
{
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
        
        for (int j=0; j<row.count; j++)
        {
            UIImageView *cellBlock = [row objectAtIndex:j];
            [cellBlock removeFromSuperview];
        }
        
        [row removeAllObjects];
    }
    
    [self.colorCellSections removeAllObjects];
}

-(void)randomGenGoalStates
{
    self.topColorsState = [[NSMutableArray alloc] init];
    self.leftColorsState = [[NSMutableArray alloc] init];
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        int random = arc4random()%4;
        NSNumber* wrappedNumber = [NSNumber numberWithInt:random];
        [self.topColorsState addObject:wrappedNumber];
    }
    
    for (int i=0; i<self.boardParameters.gridSize; i++)
    {
        int random = arc4random()%4;
        NSNumber* wrappedNumber = [NSNumber numberWithInt:random];
        [self.leftColorsState addObject:wrappedNumber];
    }
}

-(BOOL)checkGoalSufficientDifficulty
{
    // Check that we have all non-white colors represented in the toggle states
    bool has1 = false;
    bool has2 = false;
    bool has3 = false;
    
    // Keep track of white cells
    bool hasWhiteOnTop = false;
    bool hasWhiteOnLeft = false;
    
    for (NSNumber* number in self.topColorsState){
        int num = [number intValue];
        if (num == 0)
        {
            hasWhiteOnTop = true;
        }
        else if (num == 1)
        {
            has1 = true;
        }
        else if (num == 2)
        {
            has2 = true;
        }
        else if (num == 3)
        {
            has3 = true;
        }
    }
    
    for (NSNumber* number in self.leftColorsState){
        int num = [number intValue];
        if (num == 0)
        {
            hasWhiteOnLeft = true;
        }
        else if (num == 1)
        {
            has1 = true;
        }
        else if (num == 2)
        {
            has2 = true;
        }
        else if (num == 3)
        {
            has3 = true;
        }
    }
    
    bool hasAllColors = has1 && has2 && has3;
    if (!hasAllColors)
    {
        return false;
    }
    
    // Check that we don't have any whites in the result
    if (hasWhiteOnTop && hasWhiteOnLeft)
    {
        return false;
    }
    
    // Check all rows for N number of same colors in a row
    int maxConsecutiveCountAllowed = 3;
    for (NSNumber* leftNSNumber in self.leftColorsState)
    {
        int leftColor = [leftNSNumber intValue];
        int previousCombinedColor = -1;
        int sameColorConsecutiveCount = 0;
        for (NSNumber* topNSNumber in self.topColorsState)
        {
            int topColor = [topNSNumber intValue];
            int combinedColor = [CommonUtils CombineColors:leftColor color2:topColor];
            
            if (previousCombinedColor == -1)
            {
                previousCombinedColor = combinedColor;
                sameColorConsecutiveCount = 1;
            }
            else if (combinedColor == previousCombinedColor)
            {
                sameColorConsecutiveCount++;
                if (sameColorConsecutiveCount >= maxConsecutiveCountAllowed)
                {
                    // Too many same color found consecutively
                    return false;
                }
            }
            else
            {
                // Found a different color, reset consecutive count
                previousCombinedColor = combinedColor;
                sameColorConsecutiveCount = 1;
            }
        }
    }
    
    // Check all columns for same colors in the column
    for (NSNumber* topNSNumber in self.topColorsState)
    {
        int topColor = [topNSNumber intValue];
        int previousCombinedColor = -1;
        int sameColorConsecutiveCount = 0;
        for (NSNumber* leftNSNumber in self.leftColorsState)
        {
            int leftColor = [leftNSNumber intValue];
            int combinedColor = [CommonUtils CombineColors:leftColor color2:topColor];
            
            if (previousCombinedColor == -1)
            {
                previousCombinedColor = combinedColor;
                sameColorConsecutiveCount = 1;
            }
            else if (combinedColor == previousCombinedColor)
            {
                sameColorConsecutiveCount++;
                if (sameColorConsecutiveCount >= maxConsecutiveCountAllowed)
                {
                    // Too many same color found consecutively
                    return false;
                }
            }
            else
            {
                // Found a different color, reset consecutive count
                previousCombinedColor = combinedColor;
                sameColorConsecutiveCount = 1;
            }
        }
    }
    
    return true;
}

- (void)generateNewGoalBoardStates
{
    do
    {
        // Randomly generate goal color bar
        [self randomGenGoalStates];
    }
    while ([self checkGoalSufficientDifficulty] == false);
    
    // Update goal cells
    [self updateColorCells];
}

- (void)removeExistingGoalColorsState
{
    [self.topColorsState removeAllObjects];
    [self.leftColorsState removeAllObjects];
}

@end