//
//  ColorCell.m
//  Color Match
//
//  Description: Object representing a single color cell
//
//  Created by Linda Chen on 1/26/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "ColorCell.h"

@implementation ColorCell

-(id)init:(int)cellType
{
    self = [super init];
    if (self)
    {
        _specialImage = NULL;
        _cellType = cellType;
        _colorInputs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

+(bool)doesCellSupportCombineColor:(CellType)cellType
{
    return cellType == NormalCell || cellType == Connector;
}

-(void)recalculateSpecialCellImage
{
    if (self.cellType == Connector)
    {
        [self.specialImage setImage:[CommonUtils GetConnectorInnerImageForColor:self.currentColor]];
    }
}

-(void)addInputColor:(NSNumber*)color cellsAffected:(NSMutableArray*)cellsAffected
{
    if (![ColorCell doesCellSupportCombineColor:self.cellType])
    {
        return;
    }
    
    [_colorInputs addObject:color];
    [self recalculateOutputColor];
    [self recalculateSpecialCellImage];
    
    if (cellsAffected != NULL)
    {
        [cellsAffected addObject:self.image];
    }
}

-(void)removeInputColor:(NSNumber*)color cellsAffected:(NSMutableArray*)cellsAffected
{
    if (![ColorCell doesCellSupportCombineColor:self.cellType])
    {
        return;
    }
    
    NSInteger existingColorIndex = [_colorInputs indexOfObject:color];
    if (existingColorIndex == NSNotFound)
    {
        [NSException raise:@"Invalid input" format:@"Color to remove not found in current input list"];
    }
    
    [_colorInputs removeObjectAtIndex:existingColorIndex];
    [self recalculateOutputColor];
    
    if (cellsAffected != NULL)
    {
        [cellsAffected addObject:self.image];
    }
}

-(void)recalculateOutputColor
{
    int combinedColor = [CommonUtils CombineColorsList:_colorInputs];
    
    if (self.cellType == NormalCell)
    {
        UIImage *image = [CommonUtils GetCellImageForColor:combinedColor];
        [_image setImage:image];
    }
    
    self.currentColor = combinedColor;
}

-(void)removeAllInputColors
{
    [_colorInputs removeAllObjects];
}

@end
