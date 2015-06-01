//
//  SNBViewController.h
//  learningXcode
//
//  Created by Stellios Bonadurer on 12/18/14.
//  Copyright (c) 2014 Stellios Bonadurer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>



@interface SNBViewController : UIViewController
{
NSMutableArray *shapeArray;
NSMutableArray *secondaryArray;
NSMutableArray *winnerArray;
UIView *gameOver;
}

@property(nonatomic,retain) IBOutlet UILabel *WinnerLabel;
@property(nonatomic,retain) IBOutlet UIView *viewGameOver, *viewGameBoard;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentNumberOfPlayers;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;



- (IBAction)Restart:(id)sender;
- (IBAction)segmentClicked:(UISegmentedControl *)sender;

@end


@interface GameCell : NSObject
{
    @public
    CAShapeLayer *shapeLayer;
    int wState;
    int dirty;
    
}

@end
//Player object to store color and potentially add a 3rd player
@interface player : NSObject
{
    @public
    struct CGColor *playerColor;
    
    
}

-(id)init;

@end