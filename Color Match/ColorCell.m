//
//  ColorCell.m
//  Color Match
//
//  Created by Linda Chen on 1/26/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "ColorCell.h"

@implementation ColorCell

-(id)initWithImage: (UIImageView*)image
{
    self = [super init];
    if (self)
    {
        _image = image;
        _colorInputs = [[NSMutableArray alloc] init];
    }
    
    return self;
}

-(void)addInputColor: (NSNumber *)color
{
    [_colorInputs addObject:color];
    [self recalculateOutputColor];
}

-(void)removeInputColor: (NSNumber *)color;
{
    int existingColorIndex = [_colorInputs indexOfObject:color];
    if (existingColorIndex == NSNotFound)
    {
        [NSException raise:@"Invalid input" format:@"Color to remove not found in current input list"];
    }
    
    [_colorInputs removeObjectAtIndex:existingColorIndex];
    [self recalculateOutputColor];
}

-(void)recalculateOutputColor
{
    int combinedColor = [CommonUtils CombineColorsList:_colorInputs];
    UIImage *image = [CommonUtils GetCellImageForColor:combinedColor];
    [_image setImage:image];
}

-(void)removeAllInputColors
{
    [_colorInputs removeAllObjects];
}

@end
