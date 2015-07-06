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

@interface TutorialGameManager ()
@property UILabel *dialogText;
@property UIImageView* pointerImageView;
@property UIImageView* pointerImageViewSmall;
@property UIImageView* pointerImageViewBig;
@property bool allowColorButtonPress;
@property bool allowGridButtonPress;
@property UIButton* gridColorButtonWaitingPress;
@property UIButton* colorButtonWaitingPress;
@property (nonatomic, strong) void (^waitingDelegate)(void);
@property UIButton* beginButton;
@property bool tutorialComplete;
@property bool tutorialPaused;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeInactive:) name:UIApplicationWillResignActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)appWillBecomeInactive:(UIApplication*)application
{
    self.tutorialPaused = true;
}

- (void)appDidBecomeActive:(UIApplication*)application
{
    self.tutorialPaused = false;
}

- (void)OnSkipButtonPressed
{
    [self completeTutorialAndStartGame];
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

- (void)addTutorialDialogText
{
    self.dialogText = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, 250)];
    self.dialogText.font = [UIFont fontWithName:@"Avenir" size:19.0];
    self.dialogText.textColor = [UIColor colorWithRed:(61/255.0) green:(61/255.0) blue:(61/255.0) alpha:1];;
    self.dialogText.numberOfLines = 0;
    self.dialogText.textAlignment = NSTextAlignmentCenter;
    self.dialogText.alpha = 0;
    [self.dialogText setCenter:CGPointMake(self.viewController.view.frame.size.width / 2, 90)];
    
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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

- (void)runWorld1Tutorial
{
    void (^showBeginImage)(void) = ^(void)
    {
        if (self.tutorialComplete)
        {
            return;
        }
        
        // Create the begin button
        UIImage *beginImage = [UIImage imageNamed:@"beginButton@2x.png"];
        self.beginButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,beginImage.size.width,beginImage.size.height)];
        [self.beginButton setImage:beginImage forState:UIControlStateNormal];
        CGPoint center = CGPointMake(self.viewController.view.frame.size.width / 2, self.dialogText.frame.origin.y + self.dialogText.frame.size.height + 45);
        [self.beginButton setCenter: center];
        [self.beginButton addTarget:self action:@selector(beginButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.viewController.view addSubview:self.beginButton];
        
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
        
        self.allowGridButtonPress = false;
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
        
        self.allowColorButtonPress = false;
        
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
        
        self.allowGridButtonPress = false;
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
        
        self.allowColorButtonPress = false;
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
        
        [self fadeOutDialogText:showText2 delay:1.5];
    };
    
    [self setTutorialDialogText:@"Wecome to Color Dash!"];
    [self fadeInDialogText:fadeOutText1 delay:1];
}

@end
