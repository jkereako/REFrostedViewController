//
//  DEMOSecondViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOSecondViewController.h"

@interface DEMOSecondViewController ()

- (IBAction)showMenuAction:(UIBarButtonItem *)sender;

@end

@implementation DEMOSecondViewController

- (IBAction)showMenuAction:(UIBarButtonItem * __unused)sender {
    // Dismiss keyboard
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];
    
    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

@end
