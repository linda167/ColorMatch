//
//  GridColorButton.h
//  Color Match
//
//  Created by Linda Chen on 1/4/14.
//  Copyright (c) 2014 SunSpark Entertainment. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GridColorButton : NSObject

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSNumber *color;
@property bool hasInputColorFromUser;

-(id)initWithButton: (UIButton*)button;
-(void)setColor: (NSNumber *)color isUserInput:(bool)isUserInput;
@end
