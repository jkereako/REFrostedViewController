//
//  DEMONavigationController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMONavigationController.h"

@interface DEMONavigationController ()

@end

@implementation DEMONavigationController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(panGestureRecognized:)]];
}

#pragma mark - Gesture recognizer
- (void)panGestureRecognized:(UIPanGestureRecognizer * __unused)sender {
    // Dismiss keyboard
    [self.view endEditing:YES];
    [self.frostedViewController.view endEditing:YES];

    // Present the view controller
    [self.frostedViewController presentMenuViewController];
}

@end
