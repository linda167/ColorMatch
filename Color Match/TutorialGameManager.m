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
@property bool topContainerWaitingPress;
@property bool bottomContainerWaitingPress;
@property UIView* bottomPlayfieldContainer;
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

- (void)addContainerForBottomPlayfield
{
    self.bottomPlayfieldContainer = [[UIView alloc] initWithFrame:self.viewController.GridContainerView.frame];
    [self.viewController.view addSubview:self.bottomPlayfieldContainer];
    
    // Add tap handler
    UITapGestureRecognizer *tapBottomSectionGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(OnTapBottomPlayfieldContainer)];
    [self.bottomPlayfieldContainer addGestureRecognizer:tapBottomSectionGesture];
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
    
    if (self.bottomPlayfieldContainer != nil)
    {
        [self.bottomPlayfieldContainer removeFromSuperview];
    }
    
    if (self.beginButton != NULL)
    {
        [self.beginButton removeFromSuperview];
    }
    
    self.viewController.navigationItem.rightBarButtonItem = NULL;
    
    // Start game
    [self.viewController createGameManagerAndStartNewGame];
    
    // Instrument
    NSString *name = [NSString stringWithFormat:@"Tutorial %d completed", self.worldId];
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:name];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
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
        // Create the begin button
        [self createBeginButton];
        CGPoint center = CGPointMake(self.viewController.view.frame.size.width / 2, self.dialogText.frame.origin.y + self.dialogText.frame.size.height + 45);
        [self.beginButton setCenter: center];
    };
    
    void (^showFinalText)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        // Move text to center
        self.dialogText.alpha = 1.0;
        [self.dialogText setCenter:self.viewController.view.center];
        
        [self setTutorialDialogText:@"That's basically it. \n\n There will be more to learn, but we can cover that later. \n\n When you're ready, tap the \"Begin\" button below. \n\n Good luck!"];
        showBeginImage();
    };
    
    void (^fadeOutEntireUI)(void) = ^(void)
    {
        self.dialogText.alpha = 0;
        [self animateHideTopSectionContainer:showFinalText hide:true delay:0];
        [self animateHideUpperPlayField:NULL hide:true delay:0];
        [self animateHideColorButtonBar:NULL hide:true delay:0];
    };
    
    void (^tapToFadeOutUI)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.waitingDelegate = fadeOutEntireUI;
        self.bottomContainerWaitingPress = true;
    };
    
    void (^showBigPointerImage)(void) = ^(void)
    {
        [self.pointerImageViewBig setCenter:self.viewController.GoalContainerView.center];
        [self fadeInBigPointerImage:tapToFadeOutUI delay:0.5 fadeIn:true];
    };
    
    void (^showText12)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Here is the target board you're trying to match."];
        
        showBigPointerImage();
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
        
        self.dialogText.alpha = 1.0;
        [self setTutorialDialogText:@"Check out the upper part of the play field."];
        
        self.waitingDelegate = showText12;
        self.bottomContainerWaitingPress = true;
    };
    
    void (^showTopUIHideBottom)(void) = ^(void)
    {
        self.dialogText.alpha = 0;
        
        // Animate show upper playfield
        [self hideUpperPlayField:false];
        [self animateHideUpperPlayField:nil hide:false delay:0];
        
        // Animate hide lower playfield
        [self animateHideBottomPlayField:showBottomText hide:true delay:0.5];
        
        // Add capture container for bottom playfield
        [self addContainerForBottomPlayfield];
    };
    
    void (^showText11)(void) = ^(void)
    {
        [self setTutorialDialogText:@"And finally..."];
        
        self.waitingDelegate = showTopUIHideBottom;
        self.topContainerWaitingPress = true;
    };
    
    void (^showText10)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Don't worry if you don't know the color mixes. You can view all the color combinations from the help menu."];
        
        self.waitingDelegate = showText11;
        self.topContainerWaitingPress = true;
    };
    
    void (^showText9)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        
        [self setTutorialDialogText:@"What's this?! The square where the blue and yellow intersect has turned green!"];
        
        self.waitingDelegate = showText10;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCircle2)(void) = ^(void)
    {
        GridColorButton* gridColorButton = [self.userColorBoard.leftGridColorButtons objectAtIndex:1];
        self.allowGridButtonPress = true;
        
        self.gridColorButtonWaitingPress = gridColorButton.button;
        self.waitingDelegate = showText9;
        [self.pointerImageViewSmall setCenter:gridColorButton.button.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showPointerOverYellowButton)(void) = ^(void)
    {
        [self.pointerImageView setCenter:self.viewController.yellowButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.yellowButton;
        self.waitingDelegate = showPointerOverCircle2;
    };
    
    void (^showText8)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Try adding yellow to the middle circle on the left."];
        
        showPointerOverYellowButton();
    };
    
    void (^showText7)(void) = ^(void)
    {
        [self setTutorialDialogText:@"But there's one more thing to consider. Check out that second set of circles on the left."];
        
        self.waitingDelegate = showText8;
        self.topContainerWaitingPress = true;
    };
    
    void (^showText6)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Well done! \n\n Notice the entire column filled up with blue."];
        
        self.waitingDelegate = showText7;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCircle)(void) = ^(void)
    {
        GridColorButton* gridColorButton = [self.userColorBoard.topGridColorButtons objectAtIndex:0];
        
        self.allowGridButtonPress = true;
        
        self.gridColorButtonWaitingPress = gridColorButton.button;
        self.waitingDelegate = showText6;
        [self.pointerImageViewSmall setCenter:gridColorButton.button.center];
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:true];
    };
    
    void (^showText5)(void) = ^(void)
    {
        [self setTutorialDialogText:@"With blue selected, you can now add color into the play field. \n\n Try tapping on the circle below."];
        
        showPointerOverCircle();
    };
    
    void (^showText4)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.pointerImageView.alpha = 0;
        [self setTutorialDialogText:@"Great! \n\n Now what? Glad you asked. \n See those circles?"];
        self.waitingDelegate = showText5;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverBlueButton)(void) = ^(void)
    {
        [self.pointerImageView setCenter:self.viewController.blueButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.7 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.blueButton;
        self.waitingDelegate = showText4;
    };
    
    void (^showText3)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Let's focus on that blue color in the center. \n\n Go ahead and tap it!"];
        showPointerOverBlueButton();
    };
    
    void (^showText2)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Your goal is to add colors to the play field below to match the target board."];
        self.waitingDelegate = showText3;
        self.topContainerWaitingPress = true;
    };
    
    [self setTutorialDialogText:@"Wecome to Color Dash! \n\n (Tap here to continue.)"];
    self.waitingDelegate = showText2;
    self.topContainerWaitingPress = true;
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
}

- (void)runWorld2Tutorial
{
    void (^showText5)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Can you master the Reflector?"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self showBeginButtonCommon];
    };
    
    void (^showText4)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Excellent! \n\n Notice that the color bends to the right instead of going down."];
        
        self.waitingDelegate = showText5;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCircle)(void) = ^(void)
    {
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
        [self.pointerImageView setCenter:self.viewController.redButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:1 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.redButton;
        self.waitingDelegate = showPointerOverCircle;
    };
    
    void (^showText3)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Watch what happens when we add red color to the circle above the Reflector."];
        showPointerOverRedButton();
    };
    
    void (^showText2)(void) = ^(void)
    {
        [self setTutorialDialogText:@"That's called a Reflector. It takes color from one direction and redirects it."];
        self.waitingDelegate = showText3;
        self.topContainerWaitingPress = true;
    };
    
    void (^tapToShowText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.waitingDelegate = showText2;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverArrow)(void) = ^(void)
    {
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:1];
        ColorCell *userColorCell = [colorRow objectAtIndex:1];
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:tapToShowText2 delay:1 smallPointer:true];
    };
    
    [self setTutorialDialogText:@"Not bad so far, but are you ready for a twist? \n\n See that arrow in the middle of the board?"];
    showPointerOverArrow();
}

- (void)runWorld3Tutorial
{
    void (^showText6)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Don't split your attention on these tricky new levels!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self showBeginButtonCommon];
    };
    
    void (^showText5)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Be aware that if you mix all three colors, you will end up with the color brown."];
        self.waitingDelegate = showText6;
        self.topContainerWaitingPress = true;
    };
    
    void (^showText4)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Great work! \n\n The Splitter will add color to the four diagonal cells around it."];
        
        self.waitingDelegate = showText5;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCell2)(void) = ^(void)
    {
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
        
        self.pointerImageViewSmall.alpha = 0;
        
        [self setTutorialDialogText:@"Try adding some yellow directly to it."];
        showPointerOverYellowButton();
    };
    
    void (^showText2)(void) = ^(void)
    {
        [self setTutorialDialogText:@"That's called a Splitter."];
        self.waitingDelegate = showText3;
        self.topContainerWaitingPress = true;
    };
    
    void (^tapToShowText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }

        self.waitingDelegate = showText2;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:1];
        ColorCell *userColorCell = [colorRow objectAtIndex:1];
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:tapToShowText2 delay:1.5 smallPointer:true];
    };
    
    [self setTutorialDialogText:@"Let's change things up a bit. \n\n See that cell in the middle of the board?"];
    showPointerOverCell();
}

- (void)runWorld4Tutorial
{
    void (^showText5)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Get out there and connect away!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self showBeginButtonCommon];
    };
    
    void (^showText4)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Those smaller circles around the Connector are there to remind you of what color you added."];
        
        self.waitingDelegate = showText5;
        self.topContainerWaitingPress = true;
    };
    
    void (^showText3)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Sweet!\n\nConnectors all share the same color."];
        
        self.waitingDelegate = showText4;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
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
        [self.pointerImageView setCenter:self.viewController.blueButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.blueButton;
        self.waitingDelegate = showPointerOverCell;
    };
    
    void (^showText2)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Try adding blue to this Connector cell."];
        showPointerOverBlueButton();
    };
    
    [self setTutorialDialogText:@"It's time to bring things together with the Connector."];
    self.waitingDelegate = showText2;
    self.topContainerWaitingPress = true;
}

- (void)runWorld5Tutorial
{
    void (^showText4)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Divert all your focus to crushing these levels!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self showBeginButtonCommon];
    };
    
    void (^showText3)(void) = ^(void)
    {
        [self setTutorialDialogText:@"It diverts flows from both directions at the same time."];
        
        self.waitingDelegate = showText4;
        self.topContainerWaitingPress = true;
    };
    
    void (^showText2)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"As you may have already guessed, the Diverter is like a double Reflector."];
        
        self.waitingDelegate = showText3;
        self.topContainerWaitingPress = true;
    };
    
    void (^tapToShowText2)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        self.waitingDelegate = showText2;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
        NSMutableArray *colorRow = [self.userColorBoard.colorCellSections objectAtIndex:1];
        ColorCell *userColorCell = [colorRow objectAtIndex:1];
        
        [self.pointerImageViewSmall setCenter:userColorCell.image.center];
        [self fadeInPointerImage:tapToShowText2 delay:.7 smallPointer:true];
    };
    
    [self setTutorialDialogText:@"It's time to put a spin on an old classic ... introducing the Diverter!"];
    showPointerOverCell();
    
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
    void (^showText5)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Try not to zone out!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self showBeginButtonCommon];
    };
    
    void (^showText4)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Whoa! That's a lot of red!"];
        self.waitingDelegate = showText5;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
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
        [self.pointerImageView setCenter:self.viewController.redButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.redButton;
        self.waitingDelegate = showPointerOverCell;
    };
    
    void (^showText3)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Give it a try!\n\nAdd some red to the Zoner."];
        showPointerOverRedButton();
    };
    
    void (^showText2)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Adding color to it will spread the color into all surrounding cells."];
        self.waitingDelegate = showText3;
        self.topContainerWaitingPress = true;
    };
    
    [self setTutorialDialogText:@"Remember the splitter?\n\nMeet its powered up cousin,\nthe Zoner!"];
    
    self.waitingDelegate = showText2;
    self.topContainerWaitingPress = true;
}

- (void)runWorld7Tutorial
{
    void (^showText5)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Time to convert some levels\ninto stars!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self showBeginButtonCommon];
    };
    
    void (^showText4)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Bam! The red is stopped while the yellow now flows freely."];
        self.waitingDelegate = showText5;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
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
        [self setTutorialDialogText:@"Give it a try!"];
        showPointerOverCell();
    };
    
    void (^showText2)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Simply tap the Converter to change the direction of color flowing through it."];
        self.waitingDelegate = showText3;
        self.topContainerWaitingPress = true;
    };
    
    [self setTutorialDialogText:@"Time to switch gears with the Converter."];
    self.waitingDelegate = showText2;
    self.topContainerWaitingPress = true;
    
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
    void (^showText6)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Boldly go where no color has gone before!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self showBeginButtonCommon];
    };
    
    void (^showText5)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"The Transporter changes to the color it's taking in or letting out. This will be helpful later."];
        self.waitingDelegate = showText6;
        self.topContainerWaitingPress = true;
    };
    
    void (^showText4)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"Boom! The yellow goes in the bottom Transporter and out the top Transporter."];
        self.waitingDelegate = showText5;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCircle)(void) = ^(void)
    {
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
        [self.pointerImageView setCenter:self.viewController.yellowButton.center];
        self.allowColorButtonPress = true;
        [self fadeInPointerImage:NULL delay:0.5 smallPointer:false];
        
        self.colorButtonWaitingPress = self.viewController.yellowButton;
        self.waitingDelegate = showPointerOverCircle;
    };
    
    void (^showText3)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Try adding yellow to the top middle circle."];
        showPointerOverYellowButton();
    };
    
    void (^showText2)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Color goes in one transporter and out another.\n\nSee for yourself."];
        self.waitingDelegate = showText3;
        self.topContainerWaitingPress = true;
    };
    
    [self setTutorialDialogText:@"Beam me up, Scotty!\nIntroducing the Transporter!"];
    self.waitingDelegate = showText2;
    self.topContainerWaitingPress = true;
}

- (void)runWorld9Tutorial
{
    void (^showText5)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Shift things into high gear!"];
        [self.dialogText sizeToFit];
        [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 65)];
        
        [self showBeginButtonCommon];
    };
    
    void (^showText4)(void) = ^(void)
    {
        self.pointerImageViewSmall.alpha = 0;
        [self setTutorialDialogText:@"It turned red! But the other Shifters changed too.\n\nThe order of change is always:\nblue -> red -> yellow -> blue"];
        self.waitingDelegate = showText5;
        self.topContainerWaitingPress = true;
    };
    
    void (^showPointerOverCell)(void) = ^(void)
    {
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
        [self setTutorialDialogText:@"Give it a go by touching the\nblue Shifter."];
        showPointerOverCell();
    };
    
    void (^showText2)(void) = ^(void)
    {
        [self setTutorialDialogText:@"Shifters are all linked and pass color between them."];
        self.waitingDelegate = showText3;
        self.topContainerWaitingPress = true;
    };
    
    [self setTutorialDialogText:@"Last but not least, we have\nthe Shifter!"];
    self.waitingDelegate = showText2;
    self.topContainerWaitingPress = true;
}

- (void)runWorld10Tutorial
{
    void (^showBeginButton)(void) = ^(void)
    {
        // Create the begin button
        [self createBeginButton];
        CGPoint center = CGPointMake(self.viewController.view.frame.size.width / 2, self.dialogText.frame.origin.y + self.dialogText.frame.size.height + 45);
        [self.beginButton setCenter: center];
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
    
    showBeginButton();
}

- (void)navigatedBack
{
    // NOOP
}

- (void)OnTapTopContainer
{
    if (self.topContainerWaitingPress)
    {
        self.topContainerWaitingPress = false;
        self.waitingDelegate();
    }
}

- (void)OnTapBottomPlayfieldContainer
{
    if (self.bottomContainerWaitingPress)
    {
        self.bottomContainerWaitingPress = false;
        self.waitingDelegate();
    }
}

@end
