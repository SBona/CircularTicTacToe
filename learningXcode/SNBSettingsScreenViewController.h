//
//  SNBSettingsScreenViewController.h
//  learningXcode
//
//  Created by Stellios Bonadurer on 3/26/15.
//  Copyright (c) 2015 Stellios Bonadurer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNBSettingsScreenViewController : UIViewController


//Settings label setup
@property (weak, nonatomic) IBOutlet UILabel *RingCountDisplay;
@property (weak, nonatomic) IBOutlet UILabel *WedgeCountDisplay;


//Stepper setup
@property(nonatomic,retain) IBOutlet UIStepper *ringStepperObject;
@property (nonatomic, retain) IBOutlet UIStepper *wedgeStepperObject;

- (IBAction)ringStepper:(UIStepper *)sender;
- (IBAction)wedgeStepper:(UIStepper *)sender;


@property (weak, nonatomic) IBOutlet UILabel *numRingLabel;
@property (weak, nonatomic) IBOutlet UILabel *numWedgeLabel;


@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end
