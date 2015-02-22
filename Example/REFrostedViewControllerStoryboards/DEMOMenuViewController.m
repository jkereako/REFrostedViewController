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

    self.tableView.separatorColor = [UIColor colorWithRed:150/255.0f green:161/255.0f blue:177/255.0f alpha:1.0f];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.opaque = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wgnu"
    self.tableView.tableHeaderView = ({
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 184.0f)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 40, 100, 100)];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        imageView.image = [UIImage imageNamed:@"Avatar"];
        imageView.layer.masksToBounds = YES;
        imageView.layer.cornerRadius = 50.0;
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 3.0f;
        imageView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        imageView.layer.shouldRasterize = YES;
        imageView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 150, 0, 24)];
        label.text = @"Jeff Kereakoglow";
        label.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor colorWithRed:62/255.0f
                                          green:68/255.0f
                                           blue:75/255.0f
                                          alpha:1.0f];
        [label sizeToFit];
        label.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        
        [view addSubview:imageView];
        [view addSubview:label];
        view;
#pragma clang diagnostic pop
    });
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView * __unused)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath * __unused)indexPath {
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed:62/255.0f
                                               green:68/255.0f
                                                blue:75/255.0f
                                               alpha:1.0f];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:17];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIndex {
    if (sectionIndex == 0) {
        return nil;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34)];
    view.backgroundColor = [UIColor colorWithRed:167/255.0f
                                           green:167/255.0f
                                            blue:167/255.0f
                                           alpha:0.6f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 8, 0, 0)];
    label.text = @"Friends Online";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = [UIColor clearColor];
    [label sizeToFit];
    [view addSubview:label];
    
    return view;
}

- (CGFloat)tableView:(UITableView * __unused)tableView heightForHeaderInSection:(NSInteger)sectionIndex {
    if (sectionIndex == 0) {
        return 0;
    }

    return 34;
}

#pragma mark - UITableView Datasource
- (CGFloat)tableView:(UITableView * __unused)tableView heightForRowAtIndexPath:(NSIndexPath * __unused)indexPath {
    return 54;
}

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
