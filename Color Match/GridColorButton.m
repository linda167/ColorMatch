//
//  GridColorButton.m
//  Color Match
//
//  Created by Linda Chen on 1/4/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import "GridColorButton.h"

@implementation GridColorButton

-(id)initWithButton: (UIButton*)button
{
    self = [super init];
    if (self)
    {
        _button = button;
        [self setColor:[NSNumber numberWithInt:0]];
    }
    
    return self;
}

-(void)setColor: (NSNumber *)color
{
    _color = color;

    int intColor = [color intValue];
    if (intColor == 0)
    {
        UIImage *btnImage = [UIImage imageNamed:@"EmptyCircle.png"];
        [_button setImage:btnImage forState:UIControlStateNormal];
    }
    else if (intColor == 1)
    {
        UIImage *btnImage = [UIImage imageNamed:@"FilledCircleBlue.png"];
        [_button setImage:btnImage forState:UIControlStateNormal];
    }
    else if (intColor == 2)
    {
        UIImage *btnImage = [UIImage imageNamed:@"FilledCircleRed.png"];
        [_button setImage:btnImage forState:UIControlStateNormal];
    }
    else if (intColor == 3)
    {
        UIImage *btnImage = [UIImage imageNamed:@"FilledCircleYellow.png"];
        [_button setImage:btnImage forState:UIControlStateNormal];
    }
}

@end
