//
//  DEMOHomeViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOHomeViewController.h"

@interface DEMOHomeViewController ()

- (IBAction)showMenuAction:(UIBarButtonItem *)sender;

@end

@implementation DEMOHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Change the value to have the menu slide from another direction. The
    // default direction is left
    self.frostedViewController.direction = REFrostedViewControllerDirectionLeft;
}

- (IBAction)showMenuAction:(UIBarButtonItem * __unused)sender {
    // Dismiss keyboard
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];

    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

@end
