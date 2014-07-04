//
//  BeaconsTableViewController.m
//  BlueBar Beacon Locator
//
//  Created by Vladimir Petrov on 04/07/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "BeaconsTableViewController.h"
#import "BeaconTableViewCell.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface BeaconsTableViewController ()

@end

@implementation BeaconsTableViewController
{
@private
    CLLocationManager* locationManager;
    CLBeaconRegion *beaconRegion;
    CBCentralManager *centralManager;
    
    NSMutableArray* allBeacons;
}
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINavigationBar* navBar = [[self navigationController]navigationBar];
    navBar.translucent = NO;
    
    if([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    [self startForUuid:@"A0B13730-3A9A-11E3-AA6E-0800200C9A66"]; // BlueBar Beacon Factory Default UUID
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startForUuid:(NSString *)uuid
{
    allBeacons = [NSMutableArray arrayWithCapacity:20];
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    
    centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_main_queue()];
    
    
    // Check if beacon monitoring is available for this device
    if (![CLLocationManager isMonitoringAvailableForClass:[CLBeaconRegion class]]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Beacon monitoring not available" message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }
    
    NSUUID *nsUuid = [[NSUUID alloc] initWithUUIDString:uuid];
    
    beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:nsUuid identifier:@"BlueBar Beacon Region"];
    beaconRegion.notifyEntryStateOnDisplay = NO;
    beaconRegion.notifyOnEntry = NO;
    beaconRegion.notifyOnExit = NO;
    
    // Tell location manager to start monitoring for the beacon region
    [locationManager startRangingBeaconsInRegion:beaconRegion];
    
}

-(void)locationManager:(CLLocationManager*)manager
       didRangeBeacons:(NSArray*)beacons
              inRegion:(CLBeaconRegion*)region
{
    for (CLBeacon* beacon in beacons)
    {
        CLBeacon* existingBeacon = nil;
        for (CLBeacon* existing in allBeacons)
        {
            if ([[existing.proximityUUID UUIDString] isEqualToString:[beacon.proximityUUID UUIDString]]
                && [existing.major isEqualToNumber: beacon.major]
                && [existing.minor isEqualToNumber: beacon.minor])
            {
                existingBeacon = existing;
                break;
            }
        }
        
        if (!existingBeacon)
            [allBeacons addObject:beacon];
        else
        {
            NSInteger index = [allBeacons indexOfObject:existingBeacon];
            if (index != NSNotFound)
                allBeacons[index] = beacon;
        }
    }
    
    [self.tableView reloadData];
}


- (void)stop
{
    [locationManager stopRangingBeaconsInRegion:beaconRegion];
    [locationManager stopMonitoringForRegion:beaconRegion];
}

- (void) centralManagerDidUpdateState:(CBCentralManager *)central
{
    static int previousState = -1;
    
    switch ([centralManager state])
    {
        case CBCentralManagerStatePoweredOff:
        {
            /* Tell user to power ON BT for functionality, but not on first run - the Framework will alert in that instance. */
            if (previousState != -1)
            {
                NSString *title = @"Bluetooth is Off";
                NSString *message = @"Please enable Bluetooth to be able to detect available BlueBar Beacons.";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }
            break;
        }
            
        case CBCentralManagerStateUnauthorized:
        {
            if (previousState != -1)
            {
                NSString *title = @"Bluetooth is Inaccessible";
                NSString *message = @"This app is not allowed to use Bluetooth, please allow it in Settings.";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }            break;
        }
            
        case CBCentralManagerStateUnknown:
        {
            /* Bad news, let's wait for another event. */
            break;
        }
            
        case CBCentralManagerStatePoweredOn:
        {
            break;
        }
            
        case CBCentralManagerStateResetting:
        {
            break;
        }
            
        case CBCentralManagerStateUnsupported:
        {
            break;
        }
    }
    
    previousState = [centralManager state];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [allBeacons count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BeaconTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"beaconCell" forIndexPath:indexPath];

    CLBeacon* beacon = [allBeacons objectAtIndex:indexPath.row];
    
    if (beacon)
    {
        cell.Uuid.text = [beacon.proximityUUID UUIDString];
        cell.Major.text = [NSString stringWithFormat:@"Major: %@", [beacon.major stringValue]];
        cell.Minor.text = [NSString stringWithFormat:@"Minor: %@", [beacon.minor stringValue]];
        cell.Rssi.text = [NSString stringWithFormat:@"Rssi: %@", [@(beacon.rssi) stringValue]];
        cell.Zone.text = [BeaconsTableViewController stringForProximity:beacon.proximity];
    }
    
    return cell;
}

+ (NSString *)stringForProximity:(CLProximity)proximity {
    switch (proximity)
    {
        case CLProximityUnknown:    return @"Unknown";
        case CLProximityFar:        return @"Far";
        case CLProximityNear:       return @"Near";
        case CLProximityImmediate:  return @"Immediate";
        default:
            return nil;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
