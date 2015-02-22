//
//  REMenuItemSelectionSegue.m
//  REFrostedViewControllerStoryboards
//
//  Created by Jeffrey Kereakoglow on 2/22/15.
//  Copyright (c) 2015 Roman Efimov. All rights reserved.
//

#import "REMenuItemSelectionSegue.h"
#import "REFrostedViewController.h"

@implementation REMenuItemSelectionSegue

-(void)perform {
    UINavigationController *navigationController;

    // Find the navigation controller we set in prepareForSegue:
    navigationController = (UINavigationController *)((UIViewController *)self.sourceViewController).frostedViewController.contentViewController;

    /// Set it to the destination controller
    navigationController .viewControllers = @[self.destinationViewController];

    // Hide the menu controller
    [((UIViewController *)self.sourceViewController).frostedViewController hideMenuViewController];
}

@end
