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
    // Apply colors from top buttons
    int rowCount = (int)_colorCellSections.count;
    for (int i=0; i<_topColorsState.count; i++)
    {
        NSNumber* color = (NSNumber *)[_topColorsState objectAtIndex:i];
        for (int j=0; j<rowCount; j++)
        {
            NSArray *row = [self.colorCellSections objectAtIndex:j];
            ColorCell *colorCell = [row objectAtIndex:i];
            [colorCell addInputColor:color];
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
            [colorCell addInputColor:color];
        }
    }
}

-(void)removeColorForRow:(int)color rowIndex:(int)rowIndex
{
    NSArray *row = [self.colorCellSections objectAtIndex:rowIndex];
    for (int j=0; j<row.count; j++)
    {
        ColorCell *colorCell = [row objectAtIndex:j];
        [colorCell removeInputColor:[NSNumber numberWithInt:color]];
    }
}

-(void)removeColorForColumn:(int)color colIndex:(int)colIndex
{
    int rowCount = (int)_colorCellSections.count;
    for (int j=0; j<rowCount; j++)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:j];
        ColorCell *colorCell = [row objectAtIndex:colIndex];
        [colorCell removeInputColor:[NSNumber numberWithInt:color]];
    }
}

-(void)addColorForRow:(int)color rowIndex:(int)rowIndex
{
    NSArray *row = [self.colorCellSections objectAtIndex:rowIndex];
    for (int j=0; j<row.count; j++)
    {
        ColorCell *colorCell = [row objectAtIndex:j];
        [colorCell addInputColor:[NSNumber numberWithInt:color]];
    }
}

-(void)addColorForColumn:(int)color colIndex:(int)colIndex
{
    int rowCount = (int)_colorCellSections.count;
    for (int j=0; j<rowCount; j++)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:j];
        ColorCell *colorCell = [row objectAtIndex:colIndex];
        [colorCell addInputColor:[NSNumber numberWithInt:color]];
    }
}

@end
