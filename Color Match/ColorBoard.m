//
//  ColorBoard.m
//  Color Match
//
//  Created by Linda Chen on 1/11/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "ColorBoard.h"

@implementation ColorBoard

-(void)updateColorCells
{
    int sectionsCount = (int)[_colorCellSections count];
    for (int i=0; i<sectionsCount; i++)
    {
        NSArray *row = [_colorCellSections objectAtIndex:i];
        int rowLength = (int)[row count];
        for (int j=0; j<rowLength; j++)
        {
            int topColor = [(NSNumber *)[_topColorsState objectAtIndex:j] intValue];
            int leftColor = [(NSNumber *)[_leftColorsState objectAtIndex:i] intValue];
            
            int combinedColor = [CommonUtils CombineColors:leftColor color2:topColor];
            
            UIImage *image = [CommonUtils GetCellImageForColor:combinedColor];
            
            UIImageView *imageView = [row objectAtIndex:j];
            [imageView setImage:image];
        }
    }
}

@end
