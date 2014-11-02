//
//  ActionsTableViewController.m
//  Campaign Demo
//
//  Created by Vladimir Petrov on 25/09/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//


#import "ActionsTableViewController.h"
#import "ActionTableViewCell.h"

#import "BlueBarSDK.h"
#import "ApiOperations.h"
#import "ActionBase.h"
#import "MesageAction.h"
#import "KeyValueAction.h"
#import "PresenceAction.h"

@implementation NSString (Empty)

- (BOOL) empty{
    return ([[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]length] == 0);
}

@end

@interface ActionsTableViewController () <UITableViewDataSource, UITableViewDelegate, IASKSettingsDelegate>

@end

@implementation ActionsTableViewController
{
@private
    NSMutableArray *actions;
    UILabel* emptyLabel;
}

@synthesize appSettingsViewController;

- (void)viewDidLoad {
    [super viewDidLoad];

    actions = [[NSMutableArray alloc] initWithCapacity:10];

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear All"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(clearMessages)];

    UIImage* btnImage = [UIImage imageNamed:@"gears"];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:btnImage
                                                               landscapeImagePhone:btnImage
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                             action:@selector(openSettings)];
    
    emptyLabel = [[UILabel alloc] initWithFrame:self.tableView.frame];
    emptyLabel.text = @"No messages received yet, if this takes too long, please check application configuration that you have  provided correct Application Id and Private Key, and also make sure you have setup corresponding campaign actions in ProximitySense.";
    emptyLabel.numberOfLines = 0;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.layer.opacity = 0.6;

    self.tableView.backgroundView = emptyLabel;
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString* applicationId = [[NSUserDefaults standardUserDefaults] objectForKey:@"applicationId_preference"];
    NSString* privateKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"privateKey_preference"];
    
    if ([applicationId empty] || [privateKey empty])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Application configuration needed" message:@"You need to specify Application API credentials first!" delegate:self cancelButtonTitle:@"Umm, OK" otherButtonTitles:nil];
        
        [alert addButtonWithTitle:@"OK"];
        [alert show];
        
        [self openSettings];
    }
    else
    {
        [self configureSdkWithApplicationId:applicationId andPrivateKey:privateKey];
    }
}

#pragma mark - BlueBarSDK configuration

- (void) configureSdkWithApplicationId:(NSString *)applicationId andPrivateKey: (NSString *)privateKey
{
    [BlueBarSDK InitializeWithApplicationId:applicationId andPrivateKey:privateKey];
    
    //appSpecificId is a string value that represents the app's user identity.
    //Can be email, LinkedIn profile id, twitter handle, UUID etc, in short anything that you use to identify your users.
    //This value is used in the analytics panel to detect different users and to remember who has proximity activations
    [BlueBarSDK Api].session.appSpecificId = [[NSUUID alloc]init].UUIDString;
    
    //userMetadata is an additional NSDictionary of values, to assign to the specific appUserId. For example, it can contain fields such as
    // name, last name, email, profile photo url, in short anything you wish to display in the user analytics panel
    // Those fields can be used subsequently to create sophisticated usage reports and custom proximity actions
    NSArray *keys = [NSArray arrayWithObjects:@"first_name", @"last_name", @"email", nil];
    NSArray *objs = [NSArray arrayWithObjects:@"John", @"Doe", @"john_doe@somewhere.com", nil];
    [BlueBarSDK Api].session.userMetadata = [NSDictionary dictionaryWithObjects:objs forKeys:keys];

    // Register to receive a notification when ProximitySense responds with an actionable result
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionReceived:) name:ApiNotification_ActionReceived object:nil];
    
    // Start ranging for factory default Blue Sense Networks BlueBar Beacon UUID
    [[BlueBarSDK Ranging] startForUuid:@"A0B13730-3A9A-11E3-AA6E-0800200C9A66"];
}


- (IASKAppSettingsViewController*)appSettingsViewController {
    if (!appSettingsViewController) {
        appSettingsViewController = [[IASKAppSettingsViewController alloc] init];
        appSettingsViewController.delegate = self;
    }
    
    return appSettingsViewController;
}

- (void)openSettings
{
    self.appSettingsViewController.showCreditsFooter = NO;
    
    self.appSettingsViewController.showDoneButton = YES;
    self.appSettingsViewController.neverShowPrivacySettings = YES;
    self.appSettingsViewController.navigationItem.hidesBackButton = YES;
    
    [self.navigationController pushViewController:self.appSettingsViewController animated:YES];

}

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController*)sender
{
    [self.navigationController popViewControllerAnimated:YES];
  
    NSString* applicationId = [[NSUserDefaults standardUserDefaults] objectForKey:@"applicationId_preference"];
    NSString* privateKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"privateKey_preference"];
    
    if (![applicationId empty] && ![privateKey empty])
    {
        [self clearMessages];
        
        [self configureSdkWithApplicationId:applicationId andPrivateKey:privateKey];
    }
    else
    {
        [self.tableView reloadData];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation) fromInterfaceOrientation
{
    [self.tableView reloadData];
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
    emptyLabel.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

@end
