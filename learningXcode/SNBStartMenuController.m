//
//  SNBStartMenuController.m
//  learningXcode
//
//  Created by Stellios Bonadurer on 2/11/15.
//  Copyright (c) 2015 Stellios Bonadurer. All rights reserved.
//

#import "SNBStartMenuController.h"

@interface SNBStartMenuController ()

@end

@implementation SNBStartMenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (IBAction) showDetailView:(id)sender {
    [self performSegueWithIdentifier:@"ShowDetail" sender:sender];
}
UIButton *btn = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
[btn addTarget:self action:@selector(showDetailView:) forControlEvents:UIControlEventTouchUpInside];



@end
