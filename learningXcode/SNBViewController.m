//
//  SNBViewController.m
//  learningXcode
//
//  Created by Stellios Bonadurer on 12/18/14.
//  Copyright (c) 2014 Stellios Bonadurer. All rights reserved.
//

#import "SNBViewController.h"
#import "SNBAppDelegate.h"
#import "SNBStartScreenViewController.h"
#import <Foundation/Foundation.h>
#import "SNBStartScreenViewController.h"

#import "UIColor+customColors.h"

extern SNBAppDelegate *vMainApp;

@implementation SNBViewController
//For each turn, where is the best place to put this?
@synthesize backButton, restartButton, winnerLabel, playerTurnIndicator;

int currentPlayer;

//Variables
int winningWedgeCount = 4;
int numberofWedges;
int numberofRings;
int circleRadius;
double width;
double height;
UIColor *player1Color, *player2Color;

- (IBAction)buttonPressed:(id)sender {
}

- (IBAction)Restart:(UIButton *)sender
{
    NSLog(@"Restart");
    [self initializeGame];
    winnerLabel.text = @"";
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeGame];
}
- (void) initializeGame{
    //Load the data about the game settings
    numberofWedges = [[[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfWedges"] intValue];
    numberofRings = [[[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfRings"] intValue];
    circleRadius = [[[NSUserDefaults standardUserDefaults] objectForKey:@"circleRadius" ] intValue ];
    //Screen Size Object
    CGRect screenSize = [UIScreen mainScreen].bounds;
    width = screenSize.size.width;
    height = screenSize.size.height;
    
    //color loading
    UIColor *backgroundColor = [UIColor backgroundColor];
    player1Color = [UIColor player1Color];
    player2Color = [UIColor player2Color];
    self.view.backgroundColor = backgroundColor;
    
    [backButton setTitleColor: [UIColor circleColor] forState: (UIControlStateNormal)];
    [restartButton setTitleColor: [UIColor circleColor] forState: (UIControlStateNormal)];

    //Make the canvas only the size of circle so elements work
    CGRect rectForView = CGRectMake(0,(height/2)-circleRadius,self.view.frame.size.width, (width/2)+circleRadius);
    
    
    UIView *canvas = [[UIView alloc]initWithFrame:rectForView];
    canvas.backgroundColor = backgroundColor;
    canvas.layer.borderColor = [UIColor grayColor].CGColor;
    canvas.layer.borderWidth = 0;
    canvas.clipsToBounds = YES;
    canvas.tag = 99;
    [self.view addSubview:canvas];
    
    //Wedge radius constant, the angle in the center of each outer wedge
    double wedgeRadius = (2* M_PI)/numberofWedges;
    
    //Create Array *************************************************************
    shapeArray = [[NSMutableArray alloc] initWithCapacity:6];
    
    //Create array of shapes
    for(int t = 0; t < numberofWedges; t++){
        
        //Create an array of each inner dimmension to add to the greater array
        secondaryArray = [[NSMutableArray alloc] initWithCapacity:4];
        
        for(int g = numberofRings; g>0; g--){
            //[shapeArray addObject:[[NSMutableArray alloc] initWithCapacity:4]];
            //Create temporary shape to add to array
            CAShapeLayer *tempShape = [CAShapeLayer layer];
            UIBezierPath *tempPath = [UIBezierPath bezierPath];
            
            //set each circle radius to the total radius divided by the number of rings times the level of ring its on
            //Oval radius is the radius used to draw each individual area within the loops
            double ovalRadius = (circleRadius/numberofRings) *g;
            //Make the game board fit on screen
            if(g > 1){
                ovalRadius -= 5;
            }
            
            //Instantiate the shapes
            CGMutablePathRef cgPath = CGPathCreateMutable();
            //Make each arc with the center at the center of canvas
            CGPathAddArc(cgPath,NULL,width/2.0,circleRadius,ovalRadius, (wedgeRadius)*(float)t,(wedgeRadius)*((float)t+1.0),false);
            
            ovalRadius = (circleRadius/numberofRings) * ((float)g-1);
            //Make the game board fit on screen
            if(g > 1){
                ovalRadius -= 5;
            }
            CGPathAddArc(cgPath,NULL,width/2.0,circleRadius,ovalRadius, (wedgeRadius)*((float)t+1.0),(wedgeRadius)*(float)t,true);
            
            tempPath.CGPath = cgPath;
            CGPathRelease(cgPath);
            
            //Close shape, set path to shape, add shape to array
            [tempPath closePath];
            tempShape.path = tempPath.CGPath;
            
            //Shape Data
            tempShape.lineWidth = 1;
            tempShape.fillColor = [UIColor circleColor].CGColor;
            tempShape.strokeColor = [UIColor backgroundColor].CGColor;
            
            //Create new GameCell object
            GameCell *gcTemp = [[GameCell alloc] init];
            gcTemp->shapeLayer = tempShape;
            gcTemp->wState = 0;
            
            [secondaryArray addObject: gcTemp];
            
            //Add Shape to canvas
            [canvas.layer addSublayer: tempShape];
        }
        //Add sub array to larger array
        [shapeArray addObject:(secondaryArray)];
        
    }
    [self setIndicatorColor];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch1 = [touches anyObject];
    CGPoint touchLocation = [touch1 locationInView:[self.view viewWithTag:99]];
    
    //NSLog(@"point %f, %f", touchLocation.x, touchLocation.y);
    
    for(int i = 0; i < [shapeArray count]; i++){
        
        for(int g = 0; g < [[shapeArray objectAtIndex:i ] count]; g++){

            GameCell *gcTemp = (GameCell *)[[shapeArray objectAtIndex:i] objectAtIndex:g];

            CAShapeLayer *shapeToTest = gcTemp->shapeLayer;
            
            if(CGPathContainsPoint(shapeToTest.path, 0 ,touchLocation, YES)){
                //NSLog(@"You touched the region %d around the circle, and %d in depth", i ,g);
                
                // 1 for player 1, 2 for player 2
                if (gcTemp->wState == 0)
                {
                    gcTemp->dirty = 1;
                    gcTemp->wState = currentPlayer;
                    NSLog(@" Player state %d %d", currentPlayer, gcTemp->wState);
                    //If the game has been won, run gameWon method
                    if([self checkForVerticalWinner] != 0 || [self checkForHorizontalWinner] != 0 || [self checkForDiagonalWinner: 1]|| [self checkForDiagonalWinner: -1])
                        {
                            [self gameWon];
                            
                    }
                    if (currentPlayer == 1)
                    {
                        currentPlayer = 2;
                    }
                    else
                    {
                        currentPlayer = 1;
                    }
                }
            }
        }
    }
    [self updateDrawing];
    [self setIndicatorColor];

}
//Set indicator color and text
- (void) setIndicatorColor
{
    if(currentPlayer == 1)
    {
        playerTurnIndicator.textColor = [UIColor player1Color];
        playerTurnIndicator.text = @"Player 1 Turn";
    }
    else if(currentPlayer == 2)
    {
        playerTurnIndicator.textColor = [UIColor player2Color];
        playerTurnIndicator.text = @"Player 2 Turn";
    }
}

- (void) gameWon
{
    winnerLabel.text = [NSString stringWithFormat:@"Congradulations Player %d",currentPlayer];
    
    if(currentPlayer == 1)
    {
        winnerLabel.textColor = [UIColor player1Color];
    }else{
        winnerLabel.textColor = [UIColor player2Color];
    }
    
    
    for(int i = 0; i < [shapeArray count]; i++){
        
        for(int j = 0; j < [[shapeArray objectAtIndex:i] count]; j++){
            GameCell *gcTemp = (GameCell *)[[shapeArray objectAtIndex:i] objectAtIndex:j];
            
            if(gcTemp ->wState != currentPlayer){
                gcTemp->shapeLayer.fillColor = [UIColor backgroundColor].CGColor;
            }
            
        }
    }
}
//Set up the game over view
- (void) setUpGameOverView
{
    
}

//Update the colors method
- (void) updateDrawing{
    
    for(int i = 0; i < [shapeArray count]; i++){
        for(int j = 0; j < [[shapeArray objectAtIndex:i] count];j++){

            GameCell *gcTemp = (GameCell *)[[shapeArray objectAtIndex:i] objectAtIndex:j];
            //Dirty used to store if the drawing applies to a particular shape, if the shape is dirty it needs to be drawn
            if(gcTemp->dirty){
                gcTemp->dirty = 0;
                UIColor *toColor;

                if(gcTemp->wState == 1){
                    toColor = [UIColor player1Color];
                    
                }else if(gcTemp->wState == 2){
                    toColor = [UIColor player2Color];
                }
                gcTemp->shapeLayer.fillColor = [toColor CGColor];
                [CATransaction begin]; {
                    [CATransaction setCompletionBlock:^{
                    }];
                    CABasicAnimation *fillColorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
                    fillColorAnimation.duration = .5f;
                    fillColorAnimation.fromValue = (id)[[UIColor grayColor] CGColor];
                    fillColorAnimation.toValue = (id)[toColor CGColor];
                    fillColorAnimation.autoreverses = NO;
                    [gcTemp->shapeLayer addAnimation:fillColorAnimation forKey:@"fillColor"];
                } [CATransaction commit];
 
            }
        }
    }
}
//Check for victory functions
- (int)checkForVerticalWinner{
    
    for(int i = 0; i < shapeArray.count; i++)
        {
        NSMutableArray *tempArray = [shapeArray objectAtIndex: i];
        
        GameCell *cell = (GameCell *)[tempArray objectAtIndex: 0];
        int player = cell->wState;
        int bWon = true;
        //if the cell state isn't empty
        if(player != 0)
            {
            //Check the array
            for(int j = 0; j < tempArray.count; j++)
                {
                GameCell *thisCell = (GameCell *)[tempArray objectAtIndex: j];
                int thisState = thisCell->wState;
                //if the shape isn't the same as the player who just clicked, break out of this function
                if(player != thisState)
                    {
                    bWon = false;
                    break;
                    }
            
                }
            //otherwise return the player who has won
            if(bWon)
                {
                return player;
                }
            }
        }
    return 0;
}
- (int) checkForHorizontalWinner{
    
    for(int j = 0; j < numberofRings; j++)
        {
        int cInRow = 0;
        for(int i = 0; i < numberofWedges; i++)
            {
            NSMutableArray *tempArray = [shapeArray objectAtIndex: i];
            GameCell *thisCell = [tempArray objectAtIndex: j];
            int player = thisCell->wState;
            GameCell *nextCell = [[shapeArray objectAtIndex: (i+1)%numberofWedges] objectAtIndex: j];
            int nextState = nextCell->wState;
                
            if(player != 0)
                {
                    if(player == nextState)
                    {
                        cInRow++;
                        if(cInRow == (winningWedgeCount - 1))
                        {
                            return player;
                        }
                    }
                    else
                    {
                        cInRow = 0;
                    }
                }
            }
        }
    return 0;
}


//Potentially use this method for all victory checks by changing offset x and y accordingly
- (int) checkForDiagonalWinner: (int) direction{
    
    for(int i = 0; i < numberofWedges; i++)
        {
        int cInRow = 0;
        GameCell *thisCell = [[shapeArray objectAtIndex: i] objectAtIndex: 0];
        int thisState = thisCell->wState;
        //Set the direction which is changed depending on the direction parameter
        int offsety = 1, offsetx = 0;
            if(direction == 1){
                offsetx = 1;
            }else if(direction == -1){
                offsetx = (numberofWedges-1);
            }
        //if the place clicked isn't playerless
        if(thisState != 0)
            {
                //Loop while the winner hasn't been found yet
                for(int j = 0; j < (winningWedgeCount-1); j++)
                    {
                    
                    GameCell *nextCell = [[shapeArray objectAtIndex: ((i + offsetx)%numberofWedges)] objectAtIndex: offsety] ;
                    int nextState = nextCell->wState;
                        //if the state matches the previous one, continue
                        if(thisState == nextState)
                            {
                            cInRow++;
                            //if the victory condition has been fulfilled, return winning player
                            if(cInRow == (winningWedgeCount -1))
                                {
                                return thisState;
                                }
                            //offset the current wedge pointer
                            offsetx += direction;
                                //if the pointer points to a negative value, set to the max value
                                if(offsetx < 0){
                                    offsetx = (numberofWedges-1);
                                }
                            offsety ++;
                            }
                    }
            }
        }
    
    return 0;
}

- (IBAction)segmentClicked:(UISegmentedControl *)sender
{
    NSLog(@"Clicked me %ld", (long)sender.selectedSegmentIndex);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end


@implementation GameCell

-(id)init
{
    self = [super init];
    //state of region. 0 for blank, 1 for player one, 2 for player 2
    wState = 0;
    shapeLayer = nil;
    currentPlayer = 1;

    return self;
}

@end


