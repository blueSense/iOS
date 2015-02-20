//
//  AppsTableViewController.m
//  Campaign Demo
//
//  Created by Vladimir Petrov on 23/01/2015.
//  Copyright (c) 2015 Blue Sense Networks. All rights reserved.
//

#import "AppsTableViewController.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "CardsViewController.h"
#import "ApiConnector.h"
#import "Application.h"

@interface AppsTableViewController ()

@end

@implementation AppsTableViewController
{
@private
    UILabel* emptyLabel;
    MBProgressHUD *hud;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationsLoaded:) name:AppNotification_ApplicationsLoaded object:nil];
    
    UIImage* logoffButtonImage = [UIImage imageNamed:@"logoff"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:logoffButtonImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(back)];

    UIImage* reloadButtonImage = [UIImage imageNamed:@"reload"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:reloadButtonImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(reload)];


    emptyLabel = [[UILabel alloc] initWithFrame:self.tableView.frame];
    emptyLabel.text = @"No applications loaded";
    emptyLabel.numberOfLines = 0;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.layer.opacity = 0.6;
    
    self.tableView.backgroundView = emptyLabel;

}

- (void) reload
{
    [hud show:YES];
    
    [[ApiConnector instance] loadApplications];
}

- (void) back
{
    [[NSNotificationCenter defaultCenter] postNotificationName:AppNotification_UserSignedOut object:nil];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Loading applications...";
    
    [[ApiConnector instance] loadApplications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)applicationsLoaded: (NSNotification*)notification
{
    [hud hide:YES];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger count = [ApiConnector instance].applications.count;
    
    if (count > 0)
        emptyLabel.text = @"";
    else
        emptyLabel.text = @"No applications loaded";

    // Return the number of rows in the section.
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"appCell" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"appCell"];
    }
    
    // Configure the cell.
    Application* app = [[ApiConnector instance].applications objectAtIndex:indexPath.row];
    cell.textLabel.text = app.name;
    cell.detailTextLabel.text = app.appDescription;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"appDetail" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"appDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Application *app = [ApiConnector instance].applications[indexPath.row];
        
        ((CardsViewController *) segue.destinationViewController).application = app;
    }
}

@end
