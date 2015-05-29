//
//  SNBStartScreenViewController.m
//  learningXcode
//
//  Created by Stellios Bonadurer on 2/11/15.
//  Copyright (c) 2015 Stellios Bonadurer. All rights reserved.
//

#import "SNBStartScreenViewController.h"

UIColor *backgroundColor = nil;

SNBStartScreenViewController *vSplashScreen;

@interface SNBStartScreenViewController ()

@end
@implementation SNBStartScreenViewController



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
    
    //Get the number of rings from the global library
    //NSNumber *ringValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfRings"];
    //if it doesn't exist, set it to the default of 4
    //if(ringValue == nil){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt: 4] forKey:@"numberOfRings"];
    
    //Same as above with number of wedges
   // NSNumber *wedgeValue = [[NSUserDefaults standardUserDefaults] objectForKey:@"numberOfWedges"];
    //if(wedgeValue == nil){
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt: 6] forKey:@"numberOfWedges"];
    
    //Rectangle object to stonre the screen size
    CGRect rc = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
    
    //Set global variables for the standard circle drawing
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt: rc.size.width/2] forKey:@"circleRadius"];
    
    //since you cannot store UIColor objects in nsuserdefaults, hacky workaround
    
    
    vSplashScreen = self;
    // Do any additional setup after loading the view.
    
    UIView *canvas = [[UIView alloc]initWithFrame:rc];
    canvas.backgroundColor = [UIColor clearColor];
    canvas.clipsToBounds = YES;
    [self.view addSubview:canvas];
    [self.view sendSubviewToBack:canvas];
    
    
    CAShapeLayer *backgroundCircle = [CAShapeLayer layer];
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    
    circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(rc.size.width/2,rc.size.height/2)
                                                radius:[[[NSUserDefaults standardUserDefaults] objectForKey:@"circleRadius" ] intValue ]
                                                //radius:circleRadius
                                            startAngle:0
                                              endAngle: 2* M_PI
                                             clockwise:YES];
    [circlePath closePath];
    backgroundCircle.path = circlePath.CGPath;
    
    backgroundCircle.fillColor = [UIColor colorWithRed:(120/255.0) green:(100/255.0) blue:(79/255.0) alpha:(1)].CGColor;    backgroundCircle.strokeColor = NULL;
    
    [canvas.layer addSublayer: backgroundCircle];
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

@end
