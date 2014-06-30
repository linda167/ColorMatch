//
//  ColorBoard.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "ColorBoard.h"
#import "ColorCell.h"
#import "ZonerCell.h"
#import "BoardCells.h"
#import "ConnectorCell.h"

@implementation ColorBoard

-(void)updateAllColorCells
{
    // Apply colors from top buttons
    for (int i=0; i<_topColorsState.count; i++)
    {
        NSNumber* color = (NSNumber *)[_topColorsState objectAtIndex:i];
        [self addColorForColumn:color.intValue colIndex:i cellsAffected:NULL];
    }
    
    // Apply colors from left buttons
    for (int i=0; i<_leftColorsState.count; i++)
    {
        NSNumber* color = (NSNumber *)[_leftColorsState objectAtIndex:i];
        [self addColorForRow:color.intValue rowIndex:i cellsAffected:NULL];
    }
}

-(void)removeColorForRow:(int)color rowIndex:(int)rowIndex cellsAffected:(NSMutableArray*)cellsAffected
{
    [self applyColor:rowIndex currentCol:-1 isHorizontal:true color:color isAdd:false cellsAffected:cellsAffected];
}

-(void)removeColorForColumn:(int)color colIndex:(int)colIndex cellsAffected:(NSMutableArray*)cellsAffected
{
    [self applyColor:-1 currentCol:colIndex isHorizontal:false color:color isAdd:false cellsAffected:cellsAffected];
}

-(void)addColorForRow:(int)color rowIndex:(int)rowIndex cellsAffected:(NSMutableArray*)cellsAffected
{
    [self applyColor:rowIndex currentCol:-1 isHorizontal:true color:color isAdd:true cellsAffected:cellsAffected];
}

-(void)addColorForColumn:(int)color colIndex:(int)colIndex cellsAffected:(NSMutableArray*)cellsAffected
{
    [self applyColor:-1 currentCol:colIndex isHorizontal:false color:color isAdd:true cellsAffected:cellsAffected];
}

// Apply color from (but not including) currentRow and currentCol
-(void)applyColor:(int)currentRow currentCol:(int)currentCol isHorizontal:(BOOL)isHorizontal color:(int)color isAdd:(BOOL)isAdd cellsAffected:(NSMutableArray*)cellsAffected
{
    if (isHorizontal)
    {
        NSArray *row = [self.colorCellSections objectAtIndex:currentRow];
        
        for (int i = currentCol+1; i < row.count; i++)
        {
            ColorCell *colorCell = [row objectAtIndex:i];
            if ([ColorCell doesCellSupportCombineColor:colorCell.cellType])
            {
                if (isAdd)
                {
                    [colorCell addInputColor:[NSNumber numberWithInt:color] cellsAffected:NULL];
                }
                else
                {
                    [colorCell removeInputColor:[NSNumber numberWithInt:color] cellsAffected:NULL];
                }
                
                if (cellsAffected != NULL)
                {
                    // Add cell to list of cells affected
                    [cellsAffected addObject:colorCell.image];
                }
            }
            else if (colorCell.cellType == ReflectorLeftToDown || colorCell.cellType == Diverter)
            {
                // Trigger apply color vertically down
                [self applyColor:currentRow currentCol:i isHorizontal:false color:color isAdd:isAdd cellsAffected:cellsAffected];
                
                // Change special image
                [self updateSpecialCellImagesOnApplyColor:colorCell color:color isHorizontal:isHorizontal];
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
            
            if ([ColorCell doesCellSupportCombineColor:colorCell.cellType])
            {
                if (isAdd)
                {
                    [colorCell addInputColor:[NSNumber numberWithInt:color] cellsAffected:NULL];
                }
                else
                {
                    [colorCell removeInputColor:[NSNumber numberWithInt:color] cellsAffected:NULL];
                }
                
                if (cellsAffected != NULL)
                {
                    // Add cell to list of cells affected
                    [cellsAffected addObject:colorCell.image];
                }
            }
            else if (colorCell.cellType == ReflectorLeftToDown)
            {
                // NOOP since we're coming from top
                break;
            }
            else if (colorCell.cellType == ReflectorTopToRight || colorCell.cellType == Diverter)
            {
                // Trigger apply color horizontal to the right
                [self applyColor:i currentCol:currentCol isHorizontal:true color:color isAdd:isAdd cellsAffected:cellsAffected];
                
                // Change special image
                [self updateSpecialCellImagesOnApplyColor:colorCell color:color isHorizontal:isHorizontal];
                break;
            }
        }
    }
}

-(void)updateSpecialCellImagesOnApplyColor:(ColorCell*)colorCell color:(int)color isHorizontal:(BOOL)isHorizontal
{
    // Change special image
    UIImage *specialImage = [self getSpecialImageForCellWithColor:colorCell.cellType color:color isHorizontal:isHorizontal];
    if (specialImage != NULL)
    {
        [colorCell.specialImage setImage:specialImage];
    }
    
    // Change special image2
    UIImage *specialImage2 = [self getSpecialImage2ForCellWithColor:colorCell.cellType color:color isHorizontal:isHorizontal];
    if (specialImage2 != NULL)
    {
        [colorCell.specialImage2 setImage:specialImage2];
    }
}

-(UIImage*)getSpecialImageForCellWithColor:(CellType)cellType color:(int)color isHorizontal:(BOOL)isHorizontal
{
    // NOOP in base class
    return NULL;
}

-(UIImage*)getSpecialImage2ForCellWithColor:(CellType)cellType color:(int)color isHorizontal:(BOOL)isHorizontal
{
    // NOOP in base class
    return NULL;
}

-(void)addColorToSingleCell:(int)rowValue col:(int)colValue color:(int)color cellsAffected:(NSMutableArray*)cellsAffected
{
    NSArray *row = [self.colorCellSections objectAtIndex:rowValue];
    ColorCell *colorCell = [row objectAtIndex:colValue];
    [colorCell addInputColor:[NSNumber numberWithInt:color] cellsAffected:cellsAffected];
}

-(void)removeColorFromSingleCell:(int)rowValue col:(int)colValue color:(int)color cellsAffected:(NSMutableArray*)cellsAffected
{
    NSArray *row = [self.colorCellSections objectAtIndex:rowValue];
    ColorCell *colorCell = [row objectAtIndex:colValue];
    [colorCell removeInputColor:[NSNumber numberWithInt:color] cellsAffected:cellsAffected];
}

-(UIView*)getUIViewForCell:(int)cellType xOffset:(int)xOffset yOffset:(int)yOffset size:(int)size colorCell:(ColorCell*)colorCell
{
    UIImageView* cellBlock = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
    cellBlock.image = [self GetImageForCellType:cellType];
    
    return cellBlock;
}

-(ColorCell*)getColorCellForType:(int)cellType xOffset:(int)xOffset yOffset:(int)yOffset size:(int)size row:(int)row col:(int)col boardCells:(BoardCells*)boardCells
{
    // Create ColorCell object and add it to our color cell matrix
    ColorCell *colorCell;
    
    switch (cellType)
    {
        case Zoner:
            colorCell = [[ZonerCell alloc] init:cellType];
            ((ZonerCell*)colorCell).row = row;
            ((ZonerCell*)colorCell).col = col;
            break;
        case Connector:
            colorCell = [[ConnectorCell alloc] init:cellType];
            break;
        default:
            colorCell = [[ColorCell alloc] init:cellType];
    }
    
    UIView* cellBlock = [self getUIViewForCell:cellType xOffset:xOffset yOffset:yOffset size:size colorCell:colorCell];
    colorCell.image = cellBlock;
    
    // Add cell image to view
    [self.containerView addSubview:cellBlock];
    [self GetSpecialImageForCellIfNeeded:colorCell boardCells:boardCells];
    
    return colorCell;
}

-(UIImage*)GetImageForCellType:(int)cellType
{
    // Default image
    return [UIImage imageNamed:@"BlockWhite.png"];
}

-(void)GetSpecialImageForCellIfNeeded:(ColorCell*)colorCell boardCells:(BoardCells*)boardCells
{
    // NOOP in base class
}

-(void)applySpecialCell:(ColorCell*)colorCell isAdd:(bool)isAdd cellsAffected:(NSMutableArray*)cellsAffected
{
    if (colorCell.cellType == Zoner)
    {
        [self applySpecialCellZoner:colorCell isAdd:isAdd cellsAffected:cellsAffected];
    }
    else if (colorCell.cellType == Connector)
    {
        [self applySpecialCellConnector:colorCell isAdd:isAdd cellsAffected:cellsAffected];
    }
}

-(void)applySpecialCellConnector:(ColorCell*)colorCell isAdd:(bool)isAdd cellsAffected:(NSMutableArray*)cellsAffected
{
    ConnectorCell *connectorCell = (ConnectorCell*)colorCell;
    if (isAdd)
    {
        [connectorCell addInputColor:[NSNumber numberWithInt:connectorCell.inputColor] cellsAffected:cellsAffected];
    }
    else
    {
        if (connectorCell.inputColor != 0)
        {
            [connectorCell removeInputColor:[NSNumber numberWithInt:connectorCell.inputColor] cellsAffected:cellsAffected];
        }
    }
}

-(void)applySpecialCellZoner:(ColorCell*)colorCell isAdd:(bool)isAdd cellsAffected:(NSMutableArray*)cellsAffected
{
    ZonerCell *zonerCell = (ZonerCell*)colorCell;
    int row = zonerCell.row;
    int col = zonerCell.col;
    
    // Apply to top
    if (row > 0)
    {
        // Apply to top left
        if (col > 0)
        {
            if (isAdd)
            {
                [self addColorToSingleCell:row-1 col:col-1 color:zonerCell.inputColor cellsAffected:cellsAffected];
            }
            else
            {
                [self removeColorFromSingleCell:row-1 col:col-1 color:zonerCell.inputColor cellsAffected:cellsAffected];
            }
        }
        
        // Apply to top
        if (isAdd)
        {
            [self addColorToSingleCell:row-1 col:col color:zonerCell.inputColor cellsAffected:cellsAffected];
        }
        else
        {
            [self removeColorFromSingleCell:row-1 col:col color:zonerCell.inputColor cellsAffected:cellsAffected];
        }
        
        // Apply to top right
        if (col < self.boardParameters.gridSize - 1)
        {
            if (isAdd)
            {
                [self addColorToSingleCell:row-1 col:col+1 color:zonerCell.inputColor cellsAffected:cellsAffected];
            }
            else
            {
                [self removeColorFromSingleCell:row-1 col:col+1 color:zonerCell.inputColor cellsAffected:cellsAffected];
            }
        }
    }
    
    // Apply to left
    if (col > 0)
    {
        if (isAdd)
        {
            [self addColorToSingleCell:row col:col-1 color:zonerCell.inputColor cellsAffected:cellsAffected];
        }
        else
        {
            [self removeColorFromSingleCell:row col:col-1 color:zonerCell.inputColor cellsAffected:cellsAffected];
        }
    }
    
    // Apply to right
    if (col < self.boardParameters.gridSize - 1)
    {
        if (isAdd)
        {
            [self addColorToSingleCell:row col:col+1 color:zonerCell.inputColor cellsAffected:cellsAffected];
        }
        else
        {
            [self removeColorFromSingleCell:row col:col+1 color:zonerCell.inputColor cellsAffected:cellsAffected];
        }
    }
    
    // Apply to bottom
    if (row < self.boardParameters.gridSize - 1)
    {
        // Apply to bottom left
        if (col > 0)
        {
            if (isAdd)
            {
                [self addColorToSingleCell:row+1 col:col-1 color:zonerCell.inputColor cellsAffected:cellsAffected];
            }
            else
            {
                [self removeColorFromSingleCell:row+1 col:col-1 color:zonerCell.inputColor cellsAffected:cellsAffected];
            }
        }
        
        // Apply to bottom
        if (isAdd)
        {
            [self addColorToSingleCell:row+1 col:col color:zonerCell.inputColor cellsAffected:cellsAffected];
        }
        else
        {
            [self removeColorFromSingleCell:row+1 col:col color:zonerCell.inputColor cellsAffected:cellsAffected];
        }
        
        // Apply to bottom right
        if (col < self.boardParameters.gridSize - 1)
        {
            if (isAdd)
            {
                [self addColorToSingleCell:row+1 col:col+1 color:zonerCell.inputColor cellsAffected:cellsAffected];
            }
            else
            {
                [self removeColorFromSingleCell:row+1 col:col+1 color:zonerCell.inputColor cellsAffected:cellsAffected];
            }
        }
    }
}

- (void)removeExistingGridCells
{
    for (int i=0; i<self.colorCellSections.count; i++)
    {
        NSMutableArray *row = [self.colorCellSections objectAtIndex:i];
        for (int j=0; j<row.count; j++)
        {
            ColorCell *colorCell = [row objectAtIndex:j];
            UIView *cellBlock = [colorCell image];
            [cellBlock removeFromSuperview];
            
            if (colorCell.specialImage != NULL)
            {
                [colorCell.specialImage removeFromSuperview];
            }
            
            if (colorCell.specialImage2 != NULL)
            {
                [colorCell.specialImage2 removeFromSuperview];
            }
        }
        
        [row removeAllObjects];
    }
    
    [self.colorCellSections removeAllObjects];
}

@end
