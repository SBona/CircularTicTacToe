//
//  SNBSettingsScreenViewController.m
//  learningXcode
//
//  Created by Stellios Bonadurer on 3/26/15.
//  Copyright (c) 2015 Stellios Bonadurer. All rights reserved.
//

#import "SNBSettingsScreenViewController.h"

@interface SNBSettingsScreenViewController ()
@end

@implementation SNBSettingsScreenViewController

@synthesize ringStepperObject, wedgeStepperObject, WedgeCountDisplay, RingCountDisplay;


- (IBAction)wedgeStepper:(UIStepper *)ctrlStepper
{
    
    //NSLog(@"New Value = %d", (int)ctrlStepper.value);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt: (int)ctrlStepper.value] forKey:@"numberOfWedges"];
    
    WedgeCountDisplay.text = [NSString stringWithFormat: @"%d", (int)ctrlStepper.value];
    
}



- (IBAction)ringStepper:(UIStepper *)ctrlStepper
{
    NSLog(@"New Value = %d", (int)ctrlStepper.value);
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt: (int)ctrlStepper.value] forKey:@"numberOfRings"];
    
    RingCountDisplay.text = [NSString stringWithFormat: @"%d", (int)ctrlStepper.value];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self wedgeStepper: wedgeStepperObject];
    [self ringStepper: ringStepperObject];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)wedgeStepperObject:(id)sender {
}
@end
