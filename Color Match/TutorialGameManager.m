//
//  TutorialGameManager.m
//  Color Match
//
//  Created by Linda Chen on 7/3/15.
//  Copyright (c) 2015 SunSpark Entertainment. All rights reserved.
//

#import "TutorialGameManager.h"
#import "UserColorBoard.h"
#import "GridColorButton.h"
#import "UserData.h"
#import "SplitterCell.h"
#import "SplitterCellButton.h"
#import "ConnectorCell.h"
#import "ZonerCellButton.h"
#import "ConverterCellButton.h"
#import "ShifterCell.h"
#import <Google/Analytics.h>

@interface TutorialGameManager ()
@property UILabel *dialogText;
@property UIImageView* pointerImageView;
@property UIImageView* pointerImageViewSmall;
@property UIImageView* pointerImageViewBig;
@property bool allowColorButtonPress;
@property bool allowGridButtonPress;
@property bool allowSpecialCellPress;
@property UIButton* gridColorButtonWaitingPress;
@property UIButton* colorButtonWaitingPress;
@property ColorCell* specialCellWaitingPress;
@property (nonatomic, strong) void (^waitingDelegate)(void);
@property UIButton* beginButton;
@property bool tutorialComplete;
@end

@implementation TutorialGameManager

- (void)StartNewGame
{
    [super StartNewGame];
    
    self.allowColorButtonPress = false;
    self.allowGridButtonPress = false;
    
    // Add skip button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Skip Tutorial" style:UIBarButtonItemStyleDone target:self action:@selector(OnSkipButtonPressed)];
    self.viewController.navigationItem.rightBarButtonItem = rightButton;
    
    // Instrument
    NSString *name = [NSString stringWithFormat:@"Tutorial %d", self.worldId];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)OnSkipButtonPressed
{
    [self completeTutorialAndStartGame];
    
    // Instrument
    NSString *name = [NSString stringWithFormat:@"Tutorial %d skipped", self.worldId];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)startTimer
{
    // NOOP
}

- (void)OnGridButtonPressed:(id)sender
{
    if (!self.allowGridButtonPress)
    {
        return;
    }
    
    if (self.gridColorButtonWaitingPress != NULL)
    {
        if (sender == self.gridColorButtonWaitingPress)
        {
            self.gridColorButtonWaitingPress = NULL;
            self.allowGridButtonPress = false;
            self.waitingDelegate();
            [super OnGridButtonPressed:sender];
        }
        else
        {
            // NOOP if pressing wrong button
        }
    }
    else
    {
        [super OnGridButtonPressed:sender];
    }
}

- (void)OnColorButtonPressed:(id)sender
{
    if (!self.allowColorButtonPress)
    {
        return;
    }
    
    if (self.colorButtonWaitingPress != NULL)
    {
        if (sender == self.colorButtonWaitingPress)
        {
            self.colorButtonWaitingPress = NULL;
            self.allowColorButtonPress = false;
            self.waitingDelegate();
            [super OnColorButtonPressed:sender];
        }
        else
        {
            // NOOP if pressing wrong button
        }
    }
    else
    {
        [super OnColorButtonPressed:sender];
    }
}

- (void)finishHandleSpecialCellPress
{
    self.allowSpecialCellPress = false;
    self.specialCellWaitingPress = NULL;
    self.waitingDelegate();
}

- (IBAction)splitterButtonPressed:(id)sender
{
    if (!self.allowSpecialCellPress ||
        ![sender isKindOfClass:[SplitterCellButton class]] ||
        self.specialCellWaitingPress != ((SplitterCellButton*)sender).splitterCell)
    {
        return;
    }
    
    [super splitterButtonPressed:sender];
    [self finishHandleSpecialCellPress];
}

- (IBAction)connectorCellPressed:(id)sender
{
    if (!self.allowSpecialCellPress ||
        ![self.specialCellWaitingPress isKindOfClass:[ConnectorCell class]] ||
        ((ConnectorCell*)self.specialCellWaitingPress).button != sender)
    {
        return;
    }
    
    [super connectorCellPressed:sender];
    [self finishHandleSpecialCellPress];
}

- (IBAction)zonerCellPressed:(id)sender
{
    if (!self.allowSpecialCellPress ||
        ![sender isKindOfClass:[ZonerCellButton class]] ||
        self.specialCellWaitingPress != ((ZonerCellButton*)sender).colorCell)
    {
        return;
    }
    
    [super zonerCellPressed:sender];
    [self finishHandleSpecialCellPress];
}

- (IBAction)converterButtonPressed:(id)sender
{
    if (!self.allowSpecialCellPress ||
        ![sender isKindOfClass:[ConverterCellButton class]] ||
        self.specialCellWaitingPress != ((ConverterCellButton*)sender).converterCell)
    {
        return;
    }
    
    [super converterButtonPressed:sender];
    [self finishHandleSpecialCellPress];
}

- (IBAction)shifterCellPressed:(id)sender
{
    if (!self.allowSpecialCellPress ||
        ![self.specialCellWaitingPress isKindOfClass:[ShifterCell class]] ||
        ((ShifterCell*)self.specialCellWaitingPress).button != sender)
    {
        return;
    }
    
    [super shifterCellPressed:sender];
    [self finishHandleSpecialCellPress];
}

- (void)renderNewBoard
{
    [super renderNewBoard];
    
    [self hideInitialUI];
    [self addTutorialDialogText];
    [self addPointerImage];
    [self runTutorialScript];
}

-(void)OnUserActionTaken
{
    // NOOP
}

- (void)OnShowHelpMenu:(id)sender
{
    // NOOP
}

- (void)hideUpperPlayField:(bool)hide
{
    self.viewController.GoalContainerView.hidden = hide;
    self.viewController.LevelLabel.hidden = hide;
    self.viewController.LevelNumberLabel.hidden = hide;
    self.viewController.MovesPrefixLabel.hidden = hide;
    self.viewController.MovesLabel.hidden = hide;
    self.viewController.TimePrefixLabel.hidden = hide;
    self.viewController.TimerLabel.hidden = hide;
    self.viewController.HelpButton.hidden = hide;
    
    if (!hide)
    {
        self.viewController.GoalContainerView.alpha = 1;
        self.viewController.LevelLabel.alpha = 1;
        self.viewController.LevelNumberLabel.alpha = 1;
        self.viewController.MovesPrefixLabel.alpha = 1;
        self.viewController.MovesLabel.alpha = 1;
        self.viewController.TimePrefixLabel.alpha = 1;
        self.viewController.TimerLabel.alpha = 1;
        self.viewController.HelpButton.alpha = 1;
    }
}

- (void)animateHideUpperPlayField:(void (^)(void))callback hide:(bool)hide delay:(int)delay
{
    int initialAlpha = hide ? 1.0: 0;
    int finalAlpha = hide ? 0: 1.0;
    
    self.viewController.GoalContainerView.alpha = initialAlpha;
    self.viewController.LevelLabel.alpha = initialAlpha;
    self.viewController.LevelNumberLabel.alpha = initialAlpha;
    self.viewController.MovesPrefixLabel.alpha = initialAlpha;
    self.viewController.MovesLabel.alpha = initialAlpha;
    self.viewController.TimePrefixLabel.alpha = initialAlpha;
    self.viewController.TimerLabel.alpha = initialAlpha;
    self.viewController.HelpButton.alpha = initialAlpha;
    
    [UIView
     animateWithDuration:.9
     delay:delay
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         self.viewController.GoalContainerView.alpha = finalAlpha;
         self.viewController.LevelLabel.alpha = finalAlpha;
         self.viewController.LevelNumberLabel.alpha = finalAlpha;
         self.viewController.MovesPrefixLabel.alpha = finalAlpha;
         self.viewController.MovesLabel.alpha = finalAlpha;
         self.viewController.TimePrefixLabel.alpha = finalAlpha;
         self.viewController.TimerLabel.alpha = finalAlpha;
         self.viewController.HelpButton.alpha = finalAlpha;
     }
     completion:^(BOOL finished)
     {
         if (callback != NULL)
         {
             callback();
         }
     }];
}

- (void)hideBottomPlayField:(bool)hide
{
    self.viewController.GridContainerView.hidden = hide;
    
    if (!hide)
    {
        self.viewController.GridContainerView.alpha = 1;
    }
}

- (void)animateHideBottomPlayField:(void (^)(void))callback hide:(bool)hide delay:(int)delay
{
    int initialAlpha = hide ? 1.0: 0;
    int finalAlpha = hide ? 0: 1.0;
    
    self.viewController.GridContainerView.alpha = initialAlpha;
    
    [UIView
     animateWithDuration:.9
     delay:delay
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         self.viewController.GridContainerView.alpha = finalAlpha;
     }
     completion:^(BOOL finished)
     {
         if (callback != NULL)
         {
             callback();
         }
     }];
}

- (void)hideColorButtonBar:(bool)hide
{
    self.viewController.ColorButtonBarContainer.hidden = hide;
    NSArray* colorButtons = [self getColorButtons];
    for (UIButton* button in colorButtons)
    {
        button.hidden = hide;
    }
    
    if (!hide)
    {
        self.viewController.ColorButtonBarContainer.alpha = 1;
        NSArray* colorButtons = [self getColorButtons];
        for (UIButton* button in colorButtons)
        {
            button.alpha = 1;
        }
    }
}

- (void)animateHideColorButtonBar:(void (^)(void))callback hide:(bool)hide delay:(int)delay
{
    int initialAlpha = hide ? 1.0: 0;
    int finalAlpha = hide ? 0: 1.0;
    
    self.viewController.ColorButtonBarContainer.alpha = initialAlpha;
    
    NSArray* colorButtons = [self getColorButtons];
    for (UIButton* button in colorButtons)
    {
        button.alpha = initialAlpha;
    }
    
    [UIView
     animateWithDuration:.9
     delay:delay
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         self.viewController.ColorButtonBarContainer.alpha = finalAlpha;
         
         for (UIButton* button in colorButtons)
         {
             button.alpha = finalAlpha;
         }
     }
     completion:^(BOOL finished)
     {
         if (callback != NULL)
         {
             callback();
         }
     }];
}

- (void)hideTopSectionContainer:(bool)hide
{
    self.viewController.topSectionContainer.hidden = hide;
    if (!hide)
    {
        self.viewController.topSectionContainer.alpha = 1;
    }
}

- (void)animateHideTopSectionContainer:(void (^)(void))callback hide:(bool)hide delay:(int)delay
{
    int initialAlpha = hide ? 1.0: 0;
    int finalAlpha = hide ? 0: 1.0;
    
    self.viewController.topSectionContainer.alpha = initialAlpha;
    
    [UIView
     animateWithDuration:.9
     delay:delay
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         self.viewController.topSectionContainer.alpha = finalAlpha;
     }
     completion:^(BOOL finished)
     {
         if (callback != NULL)
         {
             callback();
         }
     }];
}

- (void)hideInitialUI
{
    [self hideUpperPlayField:true];
    
    // Hide world specific initial UI
    if (self.worldId == 10)
    {
        for (GridColorButton* gridColorButton in self.userColorBoard.allGridColorButtons)
        {
            gridColorButton.button.hidden = YES;
        }
        
        [self.userColorBoard.connectorLines clear];
    }
}

- (void)centerDialogTextInTopContainer
{
    [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 90)];
}

- (void)addTutorialDialogText
{
    self.dialogText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 250)];
    self.dialogText.font = [UIFont fontWithName:@"Avenir" size:19.0];
    self.dialogText.textColor = [UIColor colorWithRed:(61/255.0) green:(61/255.0) blue:(61/255.0) alpha:1];;
    self.dialogText.numberOfLines = 0;
    self.dialogText.textAlignment = NSTextAlignmentCenter;
    self.dialogText.alpha = 0;
    [self centerDialogTextInTopContainer];
    
    [self.viewController.topSectionContainer addSubview:self.dialogText];
}

- (void)addPointerImage
{
    // Add pointer image for top
    UIImage* pointerImage = [UIImage imageNamed:@"TutorialPointer@2x.png"];
    self.pointerImageView = [[UIImageView alloc] initWithImage:pointerImage];
    self.pointerImageView.alpha = 0;
    
    [self.viewController.view addSubview:self.pointerImageView];
    
    // Add big pointer image for top
    UIImage* pointerImageBig = [UIImage imageNamed:@"TutorialPointerBig@2x.png"];
    self.pointerImageViewBig = [[UIImageView alloc] initWithImage:pointerImageBig];
    self.pointerImageViewBig.alpha = 0;
    
    [self.viewController.topSectionContainer addSubview:self.pointerImageViewBig];
    
    // Add smaller pointer image for bottom board
    UIImage* pointerImageSmall = [UIImage imageNamed:@"TutorialPointerSmall@2x.png"];
    self.pointerImageViewSmall = [[UIImageView alloc] initWithImage:pointerImageSmall];
    self.pointerImageViewSmall.alpha = 0;
    
    [self.viewController.GridContainerView addSubview:self.pointerImageViewSmall];
}

- (void)setTutorialDialogText:(NSString*)text
{
    self.dialogText.text = text;
}

- (void)runTutorialScript
{
    switch (self.worldId)
    {
        case 1:
            [self runWorld1Tutorial];
            break;
        case 2:
            [self runWorld2Tutorial];
            break;
        case 3:
            [self runWorld3Tutorial];
            break;
        case 4:
            [self runWorld4Tutorial];
            break;
        case 5:
            [self runWorld5Tutorial];
            break;
        case 6:
            [self runWorld6Tutorial];
            break;
        case 7:
            [self runWorld7Tutorial];
            break;
        case 8:
            [self runWorld8Tutorial];
            break;
        case 9:
            [self runWorld9Tutorial];
            break;
        case 10:
            [self runWorld10Tutorial];
            break;
    }
}

- (void)fadeInDialogText:(void (^)(void))callback delay:(int)delay
{
    self.dialogText.alpha = 0;
    [UIView
     animateWithDuration:.9
     delay:delay
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         self.dialogText.alpha = 1.0;
     }
     completion:^(BOOL finished)
     {
         if (callback != NULL)
         {
             callback();
         }
     }];
}

- (void)fadeOutDialogText:(void (^)(void))callback delay:(int)delay
{
    [UIView
     animateWithDuration:.9
     delay:delay
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         self.dialogText.alpha = 0;
     }
     completion:^(BOOL finished)
     {
         if (callback != NULL)
         {
             callback();
         }
     }];
}

- (void)fadeInPointerImage:(void (^)(void))callback delay:(int)delay smallPointer:(bool)smallPointer
{
    self.pointerImageView.alpha = 0;
    self.pointerImageViewSmall.alpha = 0;
    [UIView
     animateWithDuration:.9
     delay:delay
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         if (smallPointer)
         {
             self.pointerImageViewSmall.alpha = 1.0;
         }
         else
         {
             self.pointerImageView.alpha = 1.0;
         }
     }
     completion:^(BOOL finished)
     {
         if (callback != NULL)
         {
             callback();
         }
     }];
}

- (void)fadeOutPointerImage:(void (^)(void))callback delay:(int)delay smallPointer:(bool)smallPointer
{
    [UIView
     animateWithDuration:.9
     delay:delay
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         if (smallPointer)
         {
             self.pointerImageViewSmall.alpha = 0;
         }
         else
         {
             self.pointerImageView.alpha = 0;
         }
     }
     completion:^(BOOL finished)
     {
         if (callback != NULL)
         {
             callback();
         }
     }];
}

- (void)fadeInBigPointerImage:(void (^)(void))callback delay:(int)delay fadeIn:(bool)fadeIn
{
    if (fadeIn)
    {
        self.pointerImageViewBig.alpha = 0;
    }
    
    [UIView
     animateWithDuration:.9
     delay:delay
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         if (fadeIn)
         {
             self.pointerImageViewBig.alpha = 1.0;
         }
         else
         {
             self.pointerImageViewBig.alpha = 0;
         }
     }
     completion:^(BOOL finished)
     {
         if (callback != NULL)
         {
             callback();
         }
     }];
}

- (void)fadeInBeginButton:(int)delay
{
    self.beginButton.alpha = 0;
    
    [UIView
     animateWithDuration:.9
     delay:delay
     options:UIViewAnimationOptionCurveEaseOut
     animations:^
     {
         self.beginButton.alpha = 1;
     }
     completion:^(BOOL finished)
     {
     }];
}

- (void)completeTutorialAndStartGame
{
    [[UserData sharedUserData] storeTutorialComplete:self.worldId];
    
    self.tutorialComplete = true;
    
    [self removeExistingBoard];
    [self resetActionBar];
    
    // Restore game UI
    [self hideUpperPlayField:false];
    [self hideBottomPlayField:false];
    [self hideColorButtonBar:false];
    [self hideTopSectionContainer:false];
    
    // Remove tutorial UI
    [self.dialogText removeFromSuperview];
    [self.pointerImageView removeFromSuperview];
    [self.pointerImageViewBig removeFromSuperview];
    [self.pointerImageViewSmall removeFromSuperview];
    
    if (self.beginButton != NULL)
    {
        [self.beginButton removeFromSuperview];
    }
    
    self.viewController.navigationItem.rightBarButtonItem = NULL;
    
    // Start game
    [self.viewController createGameManagerAndStartNewGame];
}

- (IBAction)beginButtonPressed:(id)sender
{
    [self completeTutorialAndStartGame];
}

- (void)createBeginButton
{
    UIImage *beginImage = [UIImage imageNamed:@"beginButton@2x.png"];
    self.beginButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,beginImage.size.width,beginImage.size.height)];
    [self.beginButton setImage:beginImage forState:UIControlStateNormal];
    
    [self.beginButton addTarget:self action:@selector(beginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.viewController.view addSubview:self.beginButton];
}

- (void)runWorld1Tutorial
{
    void (^showBeginImage)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        // Create the begin button
        [self createBeginButton];
        CGPoint center = CGPointMake(self.viewController.view.frame.size.width / 2, self.dialogText.frame.origin.y + self.dialogText.frame.size.height + 45);
        [self.beginButton setCenter: center];
        
        [self fadeInBeginButton:1];
    };
    
    void (^showFinalText)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        // Move text to center
        [self.dialogText setCenter:self.viewController.view.center];
        
        [self setTutorialDialogText:@"That's basically it. \n\n There will be more to learn, but we can cover that later. \n\n When you're ready, tap the \"Begin\" button below. \n\n Good luck!"];
        [self fadeInDialogText:showBeginImage delay:0.8];
    };
    
    void (^fadeOutEntireUI)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self animateHideTopSectionContainer:showFinalText hide:true delay:1];
        [self animateHideUpperPlayField:NULL hide:true delay:1];
        [self animateHideColorButtonBar:NULL hide:true delay:1];
    };
    
    void (^fadeOutTextAndPointer)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:NULL delay:3];
        [self fadeInBigPointerImage:fadeOutEntireUI delay:2.5 fadeIn:false];
    };
    
    void (^showBigPointerImage)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self.pointerImageViewBig setCenter:self.viewController.GoalContainerView.center];
        [self fadeInBigPointerImage:fadeOutTextAndPointer delay:0.5 fadeIn:true];
    };
    
    void (^showText12)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Here is the target board you're trying to match."];
        
        [self fadeInDialogText:showBigPointerImage delay:0.8];
    };
    
    void (^fadeOutText12)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText12 delay:2.5];
    };
    
    void (^showBottomText)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        // Move dialog to the bottom
        [self.dialogText removeFromSuperview];
        [self.viewController.view addSubview:self.dialogText];
        CGPoint gridContainerViewCenter = self.viewController.GridContainerView.center;
        gridContainerViewCenter.y -= 50;
        [self.dialogText setCenter:gridContainerViewCenter];
        
        [self setTutorialDialogText:@"Check out the upper part of the play field."];
        [self fadeInDialogText:fadeOutText12 delay:0.8];
    };
    
    void (^showTopUIHideBottom)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        // Animate show upper playfield
        [self hideUpperPlayField:false];
        [self animateHideUpperPlayField:showBottomText hide:false delay:1];
        
        // Animate hide lower playfield
        [self animateHideBottomPlayField:NULL hide:true delay:1];
    };
    
    void (^fadeOutText11)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showTopUIHideBottom delay:1.5];
    };
    
    void (^showText11)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"And finally..."];
        
        [self fadeInDialogText:fadeOutText11 delay:0.8];
    };
    
    void (^fadeOutText10)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText11 delay:3];
    };
    
    void (^showText10)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Don't worry if you don't know the color mixes. You can view all the color combinations from the help menu."];
        
        [self fadeInDialogText:fadeOutText10 delay:0.8];
    };
    
    void (^fadeOutText9)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText10 delay:2.5];
    };
    
    void (^showText9)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        
        [self setTutorialDialogText:@"What's this?! The square where the blue and yellow intersect has turned green!"];
        
        [self fadeInDialogText:fadeOutText9 delay:0.5];
    };
    
    void (^showPointerOverCircle2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        GridColorButton* gridColorButton = [self.userColorBoard.leftGridColorButtons objectAtIndex:1];
        self.allowGridButtonPress = true;
        
        self.gridColorButtonWaitingPress = gridColorButton.button;
        self.waitingDelegate = showText9;
        [self.pointerImageViewSmall setCenter:gridColorButton.button.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showPointerOverYellowButton)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self.pointerImageView setCenter:self.viewController.yellowButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.yellowButton;
        self.waitingDelegate = showPointerOverCircle2;
    };
    
    void (^showText8)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Try adding yellow to the middle circle on the left."];
        
        [self fadeInDialogText:showPointerOverYellowButton delay:0.8];
    };
    
    void (^fadeOutText7)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText8 delay:2.5];
    };
    
    void (^showText7)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"But there's one more thing to consider. Check out that second set of circles on the left."];
        
        [self fadeInDialogText:fadeOutText7 delay:0.8];
    };
    
    void (^fadeOutText6)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText7 delay:2.0];
    };
    
    void (^showText6)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Well done! \n\n Notice the entire column filled up with blue."];
        
        [self fadeInDialogText:fadeOutText6 delay:.5];
    };
    
    void (^showPointerOverCircle)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        GridColorButton* gridColorButton = [self.userColorBoard.topGridColorButtons objectAtIndex:0];
        
        self.allowGridButtonPress = true;
        
        self.gridColorButtonWaitingPress = gridColorButton.button;
        self.waitingDelegate = showText6;
        [self.pointerImageViewSmall setCenter:gridColorButton.button.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showText5)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"With blue selected, you can now add color into the play field. \n\n Try tapping on the circle below."];
        
        [self fadeInDialogText:showPointerOverCircle delay:0.8];
    };
    
    void (^fadeOutText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText5 delay:2.0];
    };
    
    void (^showText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageView.alpha = 0;
        [self setTutorialDialogText:@"Great! \n\n Now what? Glad you asked. \n See those circles?"];
        [self fadeInDialogText:fadeOutText4 delay:.5];
    };
    
    void (^showPointerOverBlueButton)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self.pointerImageView setCenter:self.viewController.blueButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.blueButton;
        self.waitingDelegate = showText4;
    };
    
    void (^showText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Let's focus on that blue color in the center. \n\n Go ahead and tap it!"];
        [self fadeInDialogText:showPointerOverBlueButton delay:0.8];
    };
    
    void (^fadeOutText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText3 delay:2.5];
    };
    
    void (^showText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Your goal is to add colors to the play field below to match the target board."];
        [self fadeInDialogText:fadeOutText2 delay:0.8];
    };
    
    void (^fadeOutText1)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText2 delay:2];
    };
    
    [self setTutorialDialogText:@"Wecome to Color Dash!"];
    [self fadeInDialogText:fadeOutText1 delay:1];
}

- (void)showBeginButtonCommon
{
    if (self.tutorialComplete)
    {
        return;
    }
    
    [self createBeginButton];
    
    CGPoint center = CGPointMake(self.viewController.view.frame.size.width / 2, self.dialogText.frame.origin.y + self.dialogText.frame.size.height + self.viewController.topSectionContainer.frame.origin.y + 40
                                 );
    [self.beginButton setCenter: center];
    
    [self fadeInBeginButton:0.5];
}

- (void)runWorld2Tutorial
{
    void (^showBeginButton)(void) = ^(void)
    {
        [self showBeginButtonCommon];
    };
    
    void (^showText5)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Can you master the Reflector?"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self fadeInDialogText:showBeginButton delay:0.8];
    };
    
    void (^fadeOutText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText5 delay:3];
    };
    
    void (^showText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Excellent! \n\n Notice that the color bends to the right instead of going down."];
        [self fadeInDialogText:fadeOutText4 delay:0.5];
    };
    
    void (^showPointerOverCircle)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageView.alpha = 0;
        
        GridColorButton* gridColorButton = [self.userColorBoard.topGridColorButtons objectAtIndex:1];
        
        self.allowGridButtonPress = true;
        
        self.gridColorButtonWaitingPress = gridColorButton.button;
        self.waitingDelegate = showText4;
        [self.pointerImageViewSmall setCenter:gridColorButton.button.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showPointerOverRedButton)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self.pointerImageView setCenter:self.viewController.redButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:1 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.redButton;
        self.waitingDelegate = showPointerOverCircle;
    };
    
    void (^showText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Watch what happens when we add red color to the circle above the Reflector."];
        [self fadeInDialogText:showPointerOverRedButton delay:0.8];
    };
    
    void (^fadeOutText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText3 delay:2.5];
    };
    
    void (^showText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"That's called a Reflector. It takes color from one direction and redirects it."];
        [self fadeInDialogText:fadeOutText2 delay:0.8];
    };
    
    void (^fadeOutText1)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText2 delay:1.5];
    };
    
    void (^showPointerOverArrow)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:1];
        ColorCell *userColorCell = [colorRow objectAtIndex:1];
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:fadeOutText1 delay:1.5 smallPointer:true];
    };
    
    [self setTutorialDialogText:@"Not bad so far, but are you ready for a twist? \n\n See that arrow in the middle of the board?"];
    [self fadeInDialogText:showPointerOverArrow delay:1];
}

- (void)runWorld3Tutorial
{
    void (^showBeginButton)(void) = ^(void)
    {
        [self showBeginButtonCommon];
    };
    
    void (^showText6)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Don't split your attention on these tricky new levels!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self fadeInDialogText:showBeginButton delay:0.5];
    };
    
    void (^fadeOutText5)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText6 delay:3];
    };
    
    void (^showText5)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Be aware that if you mix all three colors, you will end up with the color brown."];
        [self fadeInDialogText:fadeOutText5 delay:0.5];
    };
    
    void (^fadeOutText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText5 delay:3];
    };
    
    void (^showText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Great work! \n\n The Splitter will add color to the four diagonal cells around it."];
        [self fadeInDialogText:fadeOutText4 delay:0.5];
    };
    
    void (^showPointerOverCell2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:1];
        SplitterCell *userColorCell = [colorRow objectAtIndex:1];
        
        self.allowSpecialCellPress = true;
        self.specialCellWaitingPress = userColorCell;
        self.waitingDelegate = showText4;
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showPointerOverYellowButton)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self.pointerImageView setCenter:self.viewController.yellowButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.yellowButton;
        self.waitingDelegate = showPointerOverCell2;
    };
    
    void (^showText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Try adding some yellow directly to it."];
        [self fadeInDialogText:showPointerOverYellowButton delay:0.8];
    };
    
    void (^fadeOutPointerAndText)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText3 delay:2];
        [self fadeOutPointerImage:NULL delay:2 smallPointer:true];
    };
    
    void (^showText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"That's called a Splitter."];
        [self fadeInDialogText:fadeOutPointerAndText delay:0.8];
    };
    
    void (^fadeOutText1)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }

        [self fadeOutDialogText:showText2 delay:2];
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:1];
        ColorCell *userColorCell = [colorRow objectAtIndex:1];
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:fadeOutText1 delay:1.5 smallPointer:true];
    };
    
    [self setTutorialDialogText:@"Let's change things up a bit. \n\n See that cell in the middle of the board?"];
    [self fadeInDialogText:showPointerOverCell delay:1];
}

- (void)runWorld4Tutorial
{
    void (^showBeginButton)(void) = ^(void)
    {
        [self showBeginButtonCommon];
    };
    
    void (^showText5)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Get out there and connect away!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self fadeInDialogText:showBeginButton delay:0.8];
    };
    
    void (^fadeOutText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText5 delay:3];
    };
    
    void (^showText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Those smaller circles around the Connector are there to remind you of what color you added."];
        [self fadeInDialogText:fadeOutText4 delay:0.8];
    };
    
    void (^fadeOutText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText4 delay:2.5];
    };
    
    void (^showText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Sweet!\n\nConnectors all share the same color."];
        [self fadeInDialogText:fadeOutText3 delay:0.5];
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:1];
        ColorCell *userColorCell = [colorRow objectAtIndex:0];
        
        self.allowSpecialCellPress = true;
        self.specialCellWaitingPress = userColorCell;
        self.waitingDelegate = showText3;
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showPointerOverBlueButton)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self.pointerImageView setCenter:self.viewController.blueButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.blueButton;
        self.waitingDelegate = showPointerOverCell;
    };
    
    void (^showText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Try adding blue to this Connector cell."];
        [self fadeInDialogText:showPointerOverBlueButton delay:0.8];
    };
    
    void (^fadeOutText1)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText2 delay:2];
    };
    
    [self setTutorialDialogText:@"It's time to bring things together with the Connector."];
    [self fadeInDialogText:fadeOutText1 delay:1];
}

- (void)runWorld5Tutorial
{
    void (^showBeginButton)(void) = ^(void)
    {
        [self showBeginButtonCommon];
    };
    
    void (^showText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Divert all your focus to crushing these levels!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self fadeInDialogText:showBeginButton delay:0.8];
    };
    
    void (^fadeOutText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText4 delay:2];
    };
    
    void (^showText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"It diverts flows from both directions at the same time."];
        [self fadeInDialogText:fadeOutText3 delay:0.8];
    };
    
    void (^fadeOutText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText3 delay:2];
    };
    
    void (^showText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"As you may have already guessed, the Diverter is like a double Reflector."];
        [self fadeInDialogText:fadeOutText2 delay:0.8];
    };
    
    void (^fadeOutPointerAndText)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText2 delay:2];
        [self fadeOutPointerImage:NULL delay:2 smallPointer:true];
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:1];
        ColorCell *userColorCell = [colorRow objectAtIndex:1];
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:fadeOutPointerAndText delay:0.5 smallPointer:true];
    };
    
    [self setTutorialDialogText:@"It's time to put a spin on an old classic ... introducing the Diverter!"];
    [self fadeInDialogText:showPointerOverCell delay:1];
    
    // Preset colors from left and top
    GridColorButton *gridColorButton = [self.userColorBoard.topGridColorButtons objectAtIndex:1];
    UIButton *button = gridColorButton.button;
    [self.userColorBoard pressGridButtonWithColor:button :2 doAnimate:false doSound:false];
    
    gridColorButton = [self.userColorBoard.leftGridColorButtons objectAtIndex:1];
    button = gridColorButton.button;
    [self.userColorBoard pressGridButtonWithColor:button :1 doAnimate:false doSound:false];
}

- (void)runWorld6Tutorial
{
    void (^showBeginButton)(void) = ^(void)
    {
        [self showBeginButtonCommon];
    };
    
    void (^showText5)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Try not to zone out!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self fadeInDialogText:showBeginButton delay:0.8];
    };
    
    void (^fadeOutText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText5 delay:2];
    };
    
    void (^showText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Whoa! That's a lot of red!"];
        [self fadeInDialogText:fadeOutText4 delay:0.5];
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:1];
        ColorCell *userColorCell = [colorRow objectAtIndex:1];
        
        self.allowSpecialCellPress = true;
        self.specialCellWaitingPress = userColorCell;
        self.waitingDelegate = showText4;
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showPointerOverRedButton)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self.pointerImageView setCenter:self.viewController.redButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.redButton;
        self.waitingDelegate = showPointerOverCell;
    };
    
    void (^showText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Give it a try!\n\nAdd some red to the Zoner."];
        [self fadeInDialogText:showPointerOverRedButton delay:0.8];
    };
    
    void (^fadeOutText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText3 delay:2];
    };
    
    void (^showText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Adding color to it will spread the color into all surrounding cells."];
        [self fadeInDialogText:fadeOutText2 delay:0.8];
    };
    
    void (^fadeOutText)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText2 delay:2];
    };
    
    [self setTutorialDialogText:@"Remember the splitter?\n\nMeet its powered up cousin,\nthe Zoner!"];
    [self fadeInDialogText:fadeOutText delay:1];
}

- (void)runWorld7Tutorial
{
    void (^showBeginButton)(void) = ^(void)
    {
        [self showBeginButtonCommon];
    };
    
    void (^showText5)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Time to convert some levels\ninto stars!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self fadeInDialogText:showBeginButton delay:0.8];
    };
    
    void (^fadeOutText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText5 delay:2.5];
    };
    
    void (^showText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Bam! The red is stopped while the yellow now flows freely."];
        [self fadeInDialogText:fadeOutText4 delay:0.5];
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:1];
        ColorCell *userColorCell = [colorRow objectAtIndex:1];
        
        self.allowSpecialCellPress = true;
        self.specialCellWaitingPress = userColorCell;
        self.waitingDelegate = showText4;
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Give it a try!"];
        [self fadeInDialogText:showPointerOverCell delay:0.8];
    };
    
    void (^fadeOutText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText3 delay:3];
    };
    
    void (^showText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Simply tap the Converter to change the direction of color flowing through it."];
        [self fadeInDialogText:fadeOutText2 delay:0.8];
    };
    
    void (^fadeOutText)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText2 delay:2];
    };
    
    [self setTutorialDialogText:@"Time to switch gears with the Converter."];
    [self fadeInDialogText:fadeOutText delay:1];
    
    // Preset colors from left and top
    GridColorButton *gridColorButton = [self.userColorBoard.topGridColorButtons objectAtIndex:1];
    UIButton *button = gridColorButton.button;
    [self.userColorBoard pressGridButtonWithColor:button :3 doAnimate:false doSound:false];
    
    gridColorButton = [self.userColorBoard.leftGridColorButtons objectAtIndex:1];
    button = gridColorButton.button;
    [self.userColorBoard pressGridButtonWithColor:button :2 doAnimate:false doSound:false];
}

- (void)runWorld8Tutorial
{
    void (^showBeginButton)(void) = ^(void)
    {
        [self showBeginButtonCommon];
    };
    
    void (^showText6)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Boldly go where no color has gone before!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self fadeInDialogText:showBeginButton delay:0.8];
    };
    
    void (^fadeOutText5)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText6 delay:3.5];
    };
    
    void (^showText5)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"The Transporter changes to the color it's taking in or letting out. This will be helpful later."];
        [self fadeInDialogText:fadeOutText5 delay:0.8];
    };
    
    void (^fadeOutText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText5 delay:3];
    };
    
    void (^showText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Boom! The yellow goes in the bottom Transporter and out the top Transporter."];
        [self fadeInDialogText:fadeOutText4 delay:0.8];
    };
    
    void (^showPointerOverCircle)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageView.alpha = 0;
        
        GridColorButton* gridColorButton = [self.userColorBoard.topGridColorButtons objectAtIndex:1];
        
        self.allowGridButtonPress = true;
        
        self.gridColorButtonWaitingPress = gridColorButton.button;
        self.waitingDelegate = showText4;
        [self.pointerImageViewSmall setCenter:gridColorButton.button.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showPointerOverYellowButton)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self.pointerImageView setCenter:self.viewController.yellowButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.yellowButton;
        self.waitingDelegate = showPointerOverCircle;
    };
    
    void (^showText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Try adding yellow to the top middle circle."];
        [self fadeInDialogText:showPointerOverYellowButton delay:0.8];
    };
    
    void (^fadeOutText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText3 delay:3];
    };
    
    void (^showText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Color goes in one transporter and out another.\n\nSee for yourself."];
        [self fadeInDialogText:fadeOutText2 delay:0.8];
    };
    
    void (^fadeOutText)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText2 delay:2];
    };
    
    [self setTutorialDialogText:@"Beam me up, Scotty!\nIntroducing the Transporter!"];
    [self fadeInDialogText:fadeOutText delay:1];
}

- (void)runWorld9Tutorial
{
    void (^showBeginButton)(void) = ^(void)
    {
        [self showBeginButtonCommon];
    };
    
    void (^showText5)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Shift things into high gear!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self fadeInDialogText:showBeginButton delay:0.8];
    };
    
    void (^fadeOutText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText5 delay:4];
    };
    
    void (^showText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"It turned red! But the other Shifters changed too.\n\nThe order of change is always:\nblue -> red -> yellow -> blue"];
        [self fadeInDialogText:fadeOutText4 delay:0.5];
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:2];
        ColorCell *userColorCell = [colorRow objectAtIndex:1];
        
        self.allowSpecialCellPress = true;
        self.specialCellWaitingPress = userColorCell;
        self.waitingDelegate = showText4;
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showText3)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Give it a go by touching the\nblue Shifter."];
        [self fadeInDialogText:showPointerOverCell delay:0.8];
    };
    
    void (^fadeOutText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText3 delay:3];
    };
    
    void (^showText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self setTutorialDialogText:@"Shifters are all linked and pass color between them."];
        [self fadeInDialogText:fadeOutText2 delay:0.8];
    };
    
    void (^fadeOutText)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        [self fadeOutDialogText:showText2 delay:2];
    };
    
    [self setTutorialDialogText:@"Last but not least, we have\nthe Shifter!"];
    [self fadeInDialogText:fadeOutText delay:1];
}

- (void)runWorld10Tutorial
{
    void (^showBeginButton)(void) = ^(void)
    {
        // Create the begin button
        [self createBeginButton];
        CGPoint center = CGPointMake(self.viewController.view.frame.size.width / 2, self.dialogText.frame.origin.y + self.dialogText.frame.size.height + 45);
        [self.beginButton setCenter: center];
        
        [self fadeInBeginButton:2.5];
    };
    
    [self hideUpperPlayField:true];
    [self hideBottomPlayField:true];
    [self hideColorButtonBar:true];
    [self hideTopSectionContainer:true];
    
    // Move text to center
    [self.dialogText removeFromSuperview];
    [self.viewController.view addSubview:self.dialogText];
    [self.dialogText setCenter:self.viewController.view.center];
    
    [self setTutorialDialogText:@"This is it, the final world!\n\nThese last levels combine everything you've learned up to this point.\n\nUnleash your puzzle skills and claim victory!"];
    
    [self fadeInDialogText:showBeginButton delay:1];
}

- (void)navigatedBack
{
    // NOOP
}

@end
