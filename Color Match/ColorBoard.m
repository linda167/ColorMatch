//
//  ColorBoard.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "ColorBoard.h"
#import "ColorCell.h"

@implementation ColorBoard

-(void)updateAllColorCells
{
    // TODO: lindach: Need to change this to support mechanic cells
    // Apply colors from top buttons
    int rowCount = (int)_colorCellSections.count;
    for (int i=0; i<_topColorsState.count; i++)
    {
        NSNumber* color = (NSNumber *)[_topColorsState objectAtIndex:i];
        for (int j=0; j<rowCount; j++)
        {
            NSArray *row = [self.colorCellSections objectAtIndex:j];
            ColorCell *colorCell = [row objectAtIndex:i];
            
            // Applying colors only valid for normal cells
            if (colorCell.cellType == NormalCell)
            {
                [colorCell addInputColor:color];
            }
        }
    }
    
    // Apply colors from left buttons
    for (int i=0; i<_leftColorsState.count; i++)
    {
        NSNumber* color = (NSNumber *)[_leftColorsState objectAtIndex:i];
        NSArray *row = [self.colorCellSections objectAtIndex:i];
        for (int j=0; j<row.count; j++)
        {
            ColorCell *colorCell = [row objectAtIndex:j];
            
            // Applying colors only valid for normal cells
            if (colorCell.cellType == NormalCell)
            {
                [colorCell addInputColor:color];
            }
        }
    }
}

-(void)removeColorForRow:(int)color rowIndex:(int)rowIndex
{
    NSArray *row = [self.colorCellSections objectAtIndex:rowIndex];
    for (int j=0; j<row.count; j++)
    {
        ColorCell *colorCell = [row objectAtIndex:j];
        
        // Applying colors only valid for normal cells
        if (colorCell.cellType == NormalCell)
        {
            [colorCell removeInputColor:[NSNumber numberWithInt:color]];
        }
    }
}

-(void)removeColorForColumn:(int)color colIndex:(int)colIndex
{
    int rowCount = (int)_colorCellSections.count;
    for (int j=0; j<rowCount; j++)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:j];
        ColorCell *colorCell = [row objectAtIndex:colIndex];
        
        // Applying colors only valid for normal cells
        if (colorCell.cellType == NormalCell)
        {
            [colorCell removeInputColor:[NSNumber numberWithInt:color]];
        }
    }
}

-(void)addColorForRow:(int)color rowIndex:(int)rowIndex
{
    NSArray *row = [self.colorCellSections objectAtIndex:rowIndex];
    for (int j=0; j<row.count; j++)
    {
        ColorCell *colorCell = [row objectAtIndex:j];
        
        // Applying colors only valid for normal cells
        if (colorCell.cellType == NormalCell)
        {
            [colorCell addInputColor:[NSNumber numberWithInt:color]];
        }
    }
}

-(void)addColorForColumn:(int)color colIndex:(int)colIndex
{
    int rowCount = (int)_colorCellSections.count;
    for (int j=0; j<rowCount; j++)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:j];
        ColorCell *colorCell = [row objectAtIndex:colIndex];
        
        // Applying colors only valid for normal cells
        if (colorCell.cellType == NormalCell)
        {
            [colorCell addInputColor:[NSNumber numberWithInt:color]];
        }
    }
}

- (ColorCell*) getColorCellForType:(int)cellType xOffset:(int)xOffset yOffset:(int)yOffset size:(int)size
{
    UIImageView *cellBlock = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
    
    switch (cellType)
    {
        case NormalCell:
            cellBlock.image=[UIImage imageNamed:@"BlockWhite.png"];
            break;
        case ReflectorLeftToDown:
            cellBlock.image=[UIImage imageNamed:@"mechanicReflectorLeftBottom@2x.png"];
            break;
        case ReflectorTopToRight:
            cellBlock.image=[UIImage imageNamed:@"mechanicReflectorTopRight@2x.png"];
            break;
    }
    
    // Add cell image to view
    [self.containerView addSubview:cellBlock];
    
    // Create ColorCell object and add it to our color cell matrix
    ColorCell *colorCell = [[ColorCell alloc] initWithImage:cellBlock cellType:cellType];
    
    return colorCell;
}

@end
