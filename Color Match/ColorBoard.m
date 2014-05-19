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
    for (int i=0; i<_topColorsState.count; i++)
    {
        NSNumber* color = (NSNumber *)[_topColorsState objectAtIndex:i];
        [self addColorForColumn:color.intValue colIndex:i];
    }
    
    // Apply colors from left buttons
    for (int i=0; i<_leftColorsState.count; i++)
    {
        NSNumber* color = (NSNumber *)[_leftColorsState objectAtIndex:i];
        [self addColorForRow:color.intValue rowIndex:i];
    }
}

-(void)removeColorForRow:(int)color rowIndex:(int)rowIndex
{
    [self applyColor:rowIndex currentCol:-1 isHorizontal:true color:color isAdd:false];
}

-(void)removeColorForColumn:(int)color colIndex:(int)colIndex
{
    [self applyColor:-1 currentCol:colIndex isHorizontal:false color:color isAdd:false];
}

-(void)addColorForRow:(int)color rowIndex:(int)rowIndex
{
    [self applyColor:rowIndex currentCol:-1 isHorizontal:true color:color isAdd:true];
}

-(void)addColorForColumn:(int)color colIndex:(int)colIndex
{
    [self applyColor:-1 currentCol:colIndex isHorizontal:false color:color isAdd:true];
}

-(void)applyColor:(int)currentRow currentCol:(int)currentCol isHorizontal:(BOOL)isHorizontal color:(int)color isAdd:(BOOL)isAdd
{
    if (isHorizontal)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:currentRow];
        
        for (int i = currentCol+1; i < row.count; i++)
        {
            ColorCell *colorCell = [row objectAtIndex:i];
            if (colorCell.cellType == NormalCell)
            {
                if (isAdd)
                {
                    [colorCell addInputColor:[NSNumber numberWithInt:color]];
                }
                else
                {
                    [colorCell removeInputColor:[NSNumber numberWithInt:color]];
                }
            }
            else if (colorCell.cellType == ReflectorLeftToDown)
            {
                // Trigger apply color vertically down
                [self applyColor:currentRow currentCol:i isHorizontal:false color:color isAdd:isAdd];
                break;
            }
            else if (colorCell.cellType == ReflectorTopToRight)
            {
                // NOOP since we're coming from the left
                break;
            }
        }
    }
    else    // if vertical
    {
        for (int i=currentRow+1; i<self.colorCellSections.count; i++)
        {
            NSArray *row = [self.colorCellSections objectAtIndex:i];
            ColorCell *colorCell = [row objectAtIndex:currentCol];
            
            if (colorCell.cellType == NormalCell)
            {
                if (isAdd)
                {
                    [colorCell addInputColor:[NSNumber numberWithInt:color]];
                }
                else
                {
                    [colorCell removeInputColor:[NSNumber numberWithInt:color]];
                }
            }
            else if (colorCell.cellType == ReflectorLeftToDown)
            {
                // NOOP since we're coming from top
                break;
            }
            else if (colorCell.cellType == ReflectorTopToRight)
            {
                // Trigger apply color horizontal to the right
                [self applyColor:i currentCol:currentCol isHorizontal:true color:color isAdd:isAdd];
                break;
            }
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
        case ReflectorTopToRight:
            cellBlock.image=[UIImage imageNamed:@"BlockClear.png"];
            break;
    }
    
    // Add cell image to view
    [self.containerView addSubview:cellBlock];
    
    // Create ColorCell object and add it to our color cell matrix
    ColorCell *colorCell = [[ColorCell alloc] initWithImage:cellBlock cellType:cellType];
    
    return colorCell;
}

@end
