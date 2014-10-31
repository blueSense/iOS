//
//  ActionsTableViewController.m
//  Campaign Demo
//
//  Created by Vladimir Petrov on 25/09/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//


#import "ActionsTableViewController.h"
#import "ActionTableViewCell.h"

#import "ApiOperations.h"
#import "ActionBase.h"
#import "MesageAction.h"
#import "KeyValueAction.h"
#import "PresenceAction.h"

@interface ActionsTableViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation ActionsTableViewController
{
@private
    NSMutableArray *actions;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    actions = [[NSMutableArray alloc] initWithCapacity:10];

    // Register to receive a notification when ProximitySense returns an action
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionReceived:) name:ApiNotification_ActionReceived object:nil];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear All"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(clearMessages)];
}

- (void)clearMessages
{
    [actions removeAllObjects];
    [self.tableView reloadData];
}

- (void)actionReceived:(id)notificationObject
{
    ActionBase* action = ((NSNotification *)notificationObject).object;

    NSString* title = @"";
    NSString* body = @"";
    
    if ([action isKindOfClass:[MessageAction class]])
    {
        MessageAction *messageAction = (MessageAction *)action;
        
        title = @"Message";
        body = messageAction.messageBody;
    }
    else
        if ([action isKindOfClass:[PresenceAction class]])
        {
            PresenceAction *presenceAction = (PresenceAction *)action;
            
            title = @"Presence";
            body = presenceAction.presence;
        }
        else
            if ([action isKindOfClass:[KeyValueAction class]])
            {
                KeyValueAction *keyValueAction = (KeyValueAction *)action;
                
                title = @"KeyValue";
                body = keyValueAction.metadata.description;
            }
            else
            {
                title = @"Unknown";
                body = @"N/A";
            }
    
    // Schedule the notification
    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
    
    localNotification.alertBody = body;
    localNotification.alertAction = @"New message";
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    localNotification.applicationIconBadgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber] + 1;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];

    
    [actions addObject:action];
    [[self tableView] reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [actions count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id object = [actions objectAtIndex:indexPath.row];
    ActionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"actionCell"];
    [cell setAction:object];

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Retrieve our object to give to our size manager.
    id action = [actions objectAtIndex:indexPath.row];

    CGFloat height = 60.0f;

    if ([action isKindOfClass:[MessageAction class]])
    {
        height = 120.0f;
    }
    else
    if ([action isKindOfClass:[PresenceAction class]])
    {
        height = 60.0f;
    }
    else
    if ([action isKindOfClass:[KeyValueAction class]])
    {
        height = 160.0f;
    }

    return height;
}

// If you have very complex cells or a large number implementing this method speeds up initial load time.
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ActionTableViewCell estimatedCellHeight];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
