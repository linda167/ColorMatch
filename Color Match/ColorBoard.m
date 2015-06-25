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
#import "SplitterCell.h"
#import "ConverterCell.h"
#import "TransporterCell.h"
#import "TransporterGroup.h"
#import "ShifterCell.h"
#import "UserColorBoard.h"
#import "GridColorButton.h"
#import "DiverterCell.h"

@interface ColorBoard ()
@property int shifterCellCount;
@property int shifterCellFirstColor;
@end

@implementation ColorBoard

- (id)initWithParameters:(BoardCells*) boardCells
{
    self = [super init];
    if (self)
    {
        self.boardCells = boardCells;
        self.transporterGroups = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

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
                [self applyColorToSingleCell:colorCell color:color cellsAffected:cellsAffected isAdd:isAdd isHorizontal:isHorizontal];
                
                if (cellsAffected != NULL)
                {
                    // Add cell to list of cells affected
                    [cellsAffected addObject:colorCell.image];
                }
            }
            
            if (colorCell.cellType == ReflectorLeftToDown || colorCell.cellType == Diverter)
            {
                // Trigger apply color vertically down
                [self applyColor:currentRow currentCol:i isHorizontal:false color:color isAdd:isAdd cellsAffected:cellsAffected];
                
                // Change special image
                [self updateSpecialCellImagesOnApplyColor:colorCell color:color isHorizontal:isHorizontal cellsAffected:cellsAffected];
                
                break;
            }
            else if (colorCell.cellType == ReflectorTopToRight)
            {
                // NOOP since we're coming from the left
                break;
            }
            else if (colorCell.cellType == Converter)
            {
                [self OnApplyColorOnConverterCell:(ConverterCell*)colorCell color:color isHorizontal:isHorizontal];
                
                if (!((ConverterCell*)colorCell).isDirectionRight)
                {
                    // Stop color flow when hitting a vertical converter
                    break;
                }
            }
            else if (colorCell.cellType == TransporterInputLeft)
            {
                [self applyColorForTransporterInput:colorCell color:color isAdd:isAdd cellsAffected:cellsAffected];
                break;
            }
            else if (colorCell.cellType == TransporterOutputRight)
            {
                // Stop color flow when hitting a transporter output right
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
                [self applyColorToSingleCell:colorCell color:color cellsAffected:cellsAffected isAdd:isAdd isHorizontal:isHorizontal];
                
                if (cellsAffected != NULL)
                {
                    // Add cell to list of cells affected
                    [cellsAffected addObject:colorCell.image];
                }
            }
            
            if (colorCell.cellType == ReflectorLeftToDown)
            {
                // NOOP since we're coming from top
                break;
            }
            else if (colorCell.cellType == ReflectorTopToRight || colorCell.cellType == Diverter)
            {
                // Trigger apply color horizontal to the right
                [self applyColor:i currentCol:currentCol isHorizontal:true color:color isAdd:isAdd cellsAffected:cellsAffected];
                
                // Change special image
                [self updateSpecialCellImagesOnApplyColor:colorCell color:color isHorizontal:isHorizontal cellsAffected:cellsAffected];
                
                break;
            }
            else if (colorCell.cellType == Converter)
            {
                [self OnApplyColorOnConverterCell:(ConverterCell*)colorCell color:color isHorizontal:isHorizontal];
                
                if (((ConverterCell*)colorCell).isDirectionRight)
                {
                    // Stop color flow when hitting a horizontal converter
                    break;
                }
            }
            else if (colorCell.cellType == TransporterInputTop)
            {
                [self applyColorForTransporterInput:colorCell color:color isAdd:isAdd cellsAffected:cellsAffected];
                break;
            }
            else if (colorCell.cellType == TransporterOutputDown)
            {
                // Stop color flow when hitting a transporter output down
                break;
            }
        }
    }
}

-(void)applyColorForTransporterInput:(ColorCell*)colorCell color:(int)color isAdd:(int)isAdd cellsAffected:(NSMutableArray*)cellsAffected
{
    TransporterCell *transporterCell = (TransporterCell*)colorCell;
    TransporterGroup* transporterGroup = [self getTransporterGroup:transporterCell.groupId];
    
    // Apply color to group
    [transporterGroup applyColorToGroup:[NSNumber numberWithInt:color] isAdd:isAdd];
    
    if (cellsAffected != NULL)
    {
        // Add transporter input to list of cells affected
        [cellsAffected addObject:transporterCell.image];
    }
    
    if ([self isKindOfClass:[UserColorBoard class]])
    {
        // Change transporter input image
        [transporterCell.image setImage:[self getTransporterImageWithColor:transporterCell color:color]];
        
        // Change special image, direction doesn't matter
        [self updateSpecialCellImagesOnApplyColor:transporterCell color:color isHorizontal:true cellsAffected:cellsAffected];
    }

    for (TransporterCell *outputCell in transporterGroup.teleporterOutputs)
    {
        if (cellsAffected != NULL)
        {
            // Add transporter output to list of cells affected
            [cellsAffected addObject:outputCell.image];
        }
        
        // Only need to change output cell on add
        if (isAdd)
        {
            [self updateTransporterOutputCell:outputCell transporterGroup:transporterGroup cellsAffected:cellsAffected];
        }
        
        bool outputHorizontal = outputCell.cellType == TransporterOutputRight;
        
        [CommonUtils Log:[NSMutableString stringWithFormat: @"Applying color for transport output at:(%d,%d), isHorizontal:%d", outputCell.row, outputCell.col, outputHorizontal]];
        
        [self applyColor:outputCell.row currentCol:outputCell.col isHorizontal:outputHorizontal color:color isAdd:isAdd cellsAffected:cellsAffected];
    }
}

-(void)updateTransporterOutputCell:(TransporterCell*)outputCell transporterGroup:(TransporterGroup*)transporterGroup cellsAffected:(NSMutableArray*)cellsAffected
{
    // NOOP in base class
}

-(void)updateSpecialCellImagesOnApplyColor:(ColorCell*)colorCell color:(int)color isHorizontal:(BOOL)isHorizontal cellsAffected:(NSMutableArray*)cellsAffected
{
    // Change special image
    UIImage *specialImage = [self updateSpecialImageForCellWithColor:colorCell color:color isHorizontal:isHorizontal];
    if (specialImage != NULL)
    {
        [colorCell.specialImage setImage:specialImage];
        if (cellsAffected != NULL)
        {
            [cellsAffected addObject:colorCell.specialImage];
        }
    }
    
    // Change special image2
    UIImage *specialImage2 = [self updateSpecialImage2ForCellWithColor:colorCell color:color isHorizontal:isHorizontal];
    if (specialImage2 != NULL)
    {
        [colorCell.specialImage2 setImage:specialImage2];
        if (cellsAffected != NULL)
        {
            [cellsAffected addObject:colorCell.specialImage2];
        }
    }
}

-(UIImage*)updateSpecialImageForCellWithColor:(ColorCell*)colorCell color:(int)color isHorizontal:(BOOL)isHorizontal
{
    // NOOP in base class
    return NULL;
}

-(UIImage*)updateSpecialImage2ForCellWithColor:(ColorCell*)colorCell color:(int)color isHorizontal:(BOOL)isHorizontal
{
    // NOOP in base class
    return NULL;
}

-(void)addColorToSingleCell:(ColorCell*)colorCell color:(int)color cellsAffected:(NSMutableArray*)cellsAffected isHorizontal:(bool)isHorizontal
{
    [colorCell addInputColor:[NSNumber numberWithInt:color] cellsAffected:cellsAffected isHorizontal:isHorizontal];
}

-(void)removeColorFromSingleCell:(ColorCell*)colorCell color:(int)color cellsAffected:(NSMutableArray*)cellsAffected isHorizontal:(bool)isHorizontal
{
    [colorCell removeInputColor:[NSNumber numberWithInt:color] cellsAffected:cellsAffected isHorizontal:isHorizontal];
}

-(void)applyColorToSingleCell:(ColorCell*)colorCell color:(int)color cellsAffected:(NSMutableArray*)cellsAffected isAdd:(bool)isAdd isHorizontal:(bool)isHorizontal
{
    if (isAdd)
    {
        [self addColorToSingleCell:colorCell color:color cellsAffected:cellsAffected isHorizontal:isHorizontal];
    }
    else
    {
        [self removeColorFromSingleCell:colorCell color:color cellsAffected:cellsAffected isHorizontal:isHorizontal];
    }
}

-(void)applyColorToSingleCellAtIndex:(int)rowValue col:(int)colValue color:(int)color cellsAffected:(NSMutableArray*)cellsAffected isAdd:(bool)isAdd
{
    NSArray *row = [self.colorCellSections objectAtIndex:rowValue];
    ColorCell *colorCell = [row objectAtIndex:colValue];
    
    // Direction doesn't matter
    [self applyColorToSingleCell:colorCell color:color cellsAffected:cellsAffected isAdd:isAdd isHorizontal:true];
}

-(UIView*)getUIViewForCell:(int)cellType xOffset:(int)xOffset yOffset:(int)yOffset size:(int)size colorCell:(ColorCell*)colorCell
{
    UIImageView* cellBlock = [[UIImageView alloc] initWithFrame:CGRectMake(xOffset, yOffset, size, size)];
    cellBlock.image = [self GetImageForCellType:colorCell];
    
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
        case Splitter:
            colorCell = [[SplitterCell alloc] init:cellType];
            ((SplitterCell*)colorCell).row = row;
            ((SplitterCell*)colorCell).col = col;
            break;
        case Converter:
            colorCell = [[ConverterCell alloc] init:cellType];
            ((ConverterCell*)colorCell).row = row;
            ((ConverterCell*)colorCell).col = col;
            break;
        case TransporterInputLeft:
        case TransporterInputTop:
            colorCell = [self createTransporterCell:cellType row:row col:col boardCells:boardCells isInput:true];
            break;
        case TransporterOutputDown:
        case TransporterOutputRight:
            colorCell = [self createTransporterCell:cellType row:row col:col boardCells:boardCells isInput:false];
            break;
        case Shifter:
            colorCell = [self createShifterCell:cellType row:row col:col boardCells:boardCells];
            break;
        case Diverter:
            colorCell = [[DiverterCell alloc] init:cellType];
            break;
        default:
            colorCell = [[ColorCell alloc] init:cellType];
    }
    
    UIView* cellBlock = [self getUIViewForCell:cellType xOffset:xOffset yOffset:yOffset size:size colorCell:colorCell];
    colorCell.image = (UIImageView*)cellBlock;
    
    // Add cell image to view
    [self.containerView addSubview:cellBlock];
    [self GetSpecialImageForCellIfNeeded:colorCell boardCells:boardCells];
    
    return colorCell;
}

-(ColorCell*)createTransporterCell:(int)cellType row:(int)row col:(int)col boardCells:(BoardCells*)boardCells isInput:(bool)isInput
{
    TransporterCell* colorCell = [[TransporterCell alloc] init:cellType];
    int transporterGroupNumber = [self.boardCells getTransporterGroupMapping:row col:col];
    colorCell.isInput = isInput;
    colorCell.groupId = transporterGroupNumber;
    colorCell.row = row;
    colorCell.col = col;
    
    TransporterGroup* transporterGroup = [self getTransporterGroup:transporterGroupNumber];
    
    if (isInput)
    {
        [transporterGroup.teleporterInputs addObject:colorCell];
    }
    else
    {
        [transporterGroup.teleporterOutputs addObject:colorCell];
    }
    
    return colorCell;
}

-(void)addTransporterGroup:(int)groupId transporterGroup:(TransporterGroup*)transporterGroup
{
    NSString* key = [NSString stringWithFormat:@"%d", groupId];
    [self.transporterGroups setObject:transporterGroup forKey:key];
}

-(TransporterGroup*)getTransporterGroup:(int)groupId
{
    NSString* key = [NSString stringWithFormat:@"%d", groupId];
    TransporterGroup* transporterGroup = [self.transporterGroups objectForKey:(key)];
    
    if (transporterGroup == NULL)
    {
        transporterGroup = [[TransporterGroup alloc] init];
        [self addTransporterGroup:groupId transporterGroup:transporterGroup];
    }
    
    return transporterGroup;
}

-(ShifterCell*)createShifterCell:(int)cellType row:(int)row col:(int)col boardCells:(BoardCells*)boardCells
{
    // NOOP in base class
    return NULL;
}

-(int)shiftColor:(int)color backwards:(bool)backwards shiftCount:(int)shiftCount
{
    for (int i = 0; i < shiftCount; i++)
    {
        switch (color)
        {
            case 1:
                color = backwards ? 3 : 2;
                break;
            case 2:
                color = backwards ? 1 : 3;
                break;
            case 3:
                color = backwards ? 2 : 1;
                break;
        }
    }
    
    return color;
}

-(UIImage*)GetImageForCellType:(ColorCell*)colorCell
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
    else if (colorCell.cellType == Splitter)
    {
        [self applySpecialCellSplitter:colorCell isAdd:isAdd cellsAffected:cellsAffected];
    }
    else if (colorCell.cellType == Shifter)
    {
        [self applySpecialCellShifter:colorCell isAdd:isAdd cellsAffected:cellsAffected];
    }
}

-(void)applySpecialCellSplitter:(ColorCell*)colorCell isAdd:(bool)isAdd cellsAffected:(NSMutableArray*)cellsAffected
{
    SplitterCell *splitterCell = (SplitterCell*)colorCell;
    int row = splitterCell.row;
    int col = splitterCell.col;
    
    // Apply to top
    if (row > 0)
    {
        // Apply to top left
        if (col > 0)
        {
            [self applyColorToSingleCellAtIndex:row-1 col:col-1 color:splitterCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
        }
        
        // Apply to top right
        if (col < self.boardParameters.gridSize - 1)
        {
            [self applyColorToSingleCellAtIndex:row-1 col:col+1 color:splitterCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
        }
    }
    
    // Apply to bottom
    if (row < self.boardParameters.gridSize - 1)
    {
        // Apply to bottom left
        if (col > 0)
        {
            [self applyColorToSingleCellAtIndex:row+1 col:col-1 color:splitterCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
        }
        
        // Apply to bottom right
        if (col < self.boardParameters.gridSize - 1)
        {
            [self applyColorToSingleCellAtIndex:row+1 col:col+1 color:splitterCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
        }
    }
}

-(void)applySpecialCellConnector:(ColorCell*)colorCell isAdd:(bool)isAdd cellsAffected:(NSMutableArray*)cellsAffected
{
    ConnectorCell *connectorCell = (ConnectorCell*)colorCell;
    if (isAdd)
    {
        // Direction doesn't matter
        [connectorCell addInputColor:[NSNumber numberWithInt:connectorCell.inputColor] cellsAffected:cellsAffected isHorizontal:true];
    }
    else
    {
        if (connectorCell.inputColor != 0)
        {
            // Direction doesn't matter
            [connectorCell removeInputColor:[NSNumber numberWithInt:connectorCell.inputColor] cellsAffected:cellsAffected isHorizontal:true];
        }
    }
}

-(void)applySpecialCellShifter:(ColorCell*)colorCell isAdd:(bool)isAdd cellsAffected:(NSMutableArray*)cellsAffected
{
    ShifterCell *shifterCell = (ShifterCell*)colorCell;
    if (isAdd)
    {
        // Direction doesn't matter
        [shifterCell addInputColor:[NSNumber numberWithInt:shifterCell.outerColor] cellsAffected:cellsAffected isHorizontal:true];
    }
    else
    {
        if (shifterCell.outerColor != 0)
        {
            // Direction doesn't matter
            [shifterCell removeInputColor:[NSNumber numberWithInt:shifterCell.outerColor] cellsAffected:cellsAffected isHorizontal:true];
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
            [self applyColorToSingleCellAtIndex:row-1 col:col-1 color:zonerCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
        }
        
        // Apply to top
        [self applyColorToSingleCellAtIndex:row-1 col:col color:zonerCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];\
        
        // Apply to top right
        if (col < self.boardParameters.gridSize - 1)
        {
            [self applyColorToSingleCellAtIndex:row-1 col:col+1 color:zonerCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
        }
    }
    
    // Apply to left
    if (col > 0)
    {
        [self applyColorToSingleCellAtIndex:row col:col-1 color:zonerCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
    }
    
    // Apply to right
    if (col < self.boardParameters.gridSize - 1)
    {
        [self applyColorToSingleCellAtIndex:row col:col+1 color:zonerCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
    }
    
    // Apply to bottom
    if (row < self.boardParameters.gridSize - 1)
    {
        // Apply to bottom left
        if (col > 0)
        {
            [self applyColorToSingleCellAtIndex:row+1 col:col-1 color:zonerCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
        }
        
        // Apply to bottom
        [self applyColorToSingleCellAtIndex:row+1 col:col color:zonerCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
        
        // Apply to bottom right
        if (col < self.boardParameters.gridSize - 1)
        {
            [self applyColorToSingleCellAtIndex:row+1 col:col+1 color:zonerCell.inputColor cellsAffected:cellsAffected isAdd:isAdd];
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

- (void)resetBoardState
{
    [self.transporterGroups removeAllObjects];
}

-(UIImage*)getTransporterImageWithColor:(ColorCell*)colorCell color:(int)color
{
    TransporterCell *transporterCell = (TransporterCell*)colorCell;
    
    NSMutableString *imageString = [[NSMutableString alloc] init];
    int groupId = transporterCell.groupId;
    if (groupId == 0)
    {
        switch (transporterCell.cellType)
        {
            case TransporterInputLeft:
                [imageString appendString:@"transporterInputLeft"];
                break;
            case TransporterInputTop:
                [imageString appendString:@"transporterInputTop"];
                break;
            case TransporterOutputDown:
                [imageString appendString:@"transporterOutputDown"];
                break;
            case TransporterOutputRight:
                [imageString appendString:@"transporterOutputRight"];
                break;
        }
        
        [imageString appendString:[self getTransporterColorString:color]];
        [imageString appendString:@".png"];
        
        return [UIImage imageNamed:imageString];
    }
    
    [NSException raise:@"Invalid group Id" format:@"Invalid group Id"];
    
    // Should not be hit
    return NULL;
}


-(NSString*)getTransporterColorString:(int)color
{
    switch (color)
    {
        case 0:
            return @"White";
        case 1:
            return @"Blue";
        case 2:
            return @"Red";
        case 3:
            return @"Yellow";
        case 4:
            return @"Purple";
        case 5:
            return @"Green";
        case 6:
            return @"Orange";
        case 7:
            return @"Brown";
    }
    // Should not be hit
    return NULL;
}

-(GridColorButton*)getGridColorButtonFromButton:(UIButton*)button
{
    return NULL;
}

-(void)OnApplyColorOnConverterCell:(ConverterCell*)converterCell color:(int)color isHorizontal:(BOOL)isHorizontal
{
    // NOOP in base class
}

@end
