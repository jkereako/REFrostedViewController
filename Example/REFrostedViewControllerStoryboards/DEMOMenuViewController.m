//
//  DEMOMenuViewController.m
//  REFrostedViewControllerStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOMenuViewController.h"
#import "DEMOHomeViewController.h"
#import "DEMOSecondViewController.h"
#import "UIViewController+REFrostedViewController.h"
#import "DEMONavigationController.h"

@interface DEMOMenuViewController ()

@property (nonatomic, weak, readwrite) IBOutlet UIImageView *avatar;
@property (nonatomic, weak, readwrite) IBOutlet UILabel *avatarLabel;
@property (nonatomic, readwrite) NSArray *dataSource;

@end

@implementation DEMOMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set up tableview data source
                        // Section 1
    self.dataSource = @[@[@"Home", @"Profile", @"Chats"],
                        // Section 2
                        @[@"John Appleseed", @"John Doe", @"Test User"]];

    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.cornerRadius = 50.0;
    self.avatar.layer.borderColor = [UIColor whiteColor].CGColor;
    self.avatar.layer.borderWidth = 3.0f;
    self.avatar.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.avatar.layer.shouldRasterize = YES;
    self.avatar.clipsToBounds = YES;
}

#pragma mark - UITableView Delegate
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger __unused)sectionIndex {
    return (UIView *)[tableView dequeueReusableCellWithIdentifier:@"sectionHeader"];
}

- (CGFloat)tableView:(UITableView * __unused)tableView heightForHeaderInSection:(NSInteger)sectionIndex {
    if (!sectionIndex) {
        return 0;
    }

    return 34.0f;
}

- (CGFloat)tableView:(UITableView * __unused)tableView heightForRowAtIndexPath:(NSIndexPath * __unused)indexPath {
    return 54.0f;
}

#pragma mark - UITableView Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView * __unused)tableView {
    return (NSInteger)self.dataSource.count;
}

- (NSInteger)tableView:(UITableView * __unused)tableView numberOfRowsInSection:(NSInteger __unused)sectionIndex {
    return (NSInteger)((NSArray *)self.dataSource[(NSUInteger)sectionIndex]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    NSString *title;

    title = self.dataSource[(NSUInteger)indexPath.section][(NSUInteger)indexPath.row];

    if ([title isEqualToString:@"Home"]) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"home"];
    }

    else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"second"];
    }

    cell.textLabel.text = title;
    
    return cell;
}
#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString * __unused)identifier sender:(__unused UITableViewCell *)sender {
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue * __unused)segue sender:(UITableViewCell * __unused)sender {
    // Boilerplate garbage.
    // You must have these 2 lines of code in your implementation of
    // prepareForSegue:sender:
    DEMONavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentController"];

    self.frostedViewController.contentViewController = navigationController;
}

@end
