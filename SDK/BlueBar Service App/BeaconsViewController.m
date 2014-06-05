/*
 File: BeaconsViewController.m

 Abstract: Display and scan for BluBar beacons

 Version: 1.0
 Copyright (C) 2014 Blue Sense Networks ltd. All Rights Reserved.
*/

#import "BeaconsViewController.h"
#import "BeaconDetailViewController.h"
#import "ApiOperations.h"
#import "BlueBarSDK.h"

@interface BeaconsViewController () <CBCentralManagerDelegate, CBPeripheralDelegate, BeaconDiscoveryDelegate, BeaconConnectionDelegate, ApiOperationsDelegate>
{
@private
    NSMutableArray *beacons;
    NSMutableArray *pendingInfo;
    NSMutableArray *unknownBeacons;

    BOOL isScanning;
}
@end

@implementation BeaconsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    beacons = [NSMutableArray arrayWithCapacity:20];
    unknownBeacons = [NSMutableArray arrayWithCapacity:20];
    isScanning = NO;

    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Scanning"];
    [refresh addTarget:self action:@selector(startScan) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
}

- (void)viewWillAppear:(BOOL)animated
{
    [beacons removeAllObjects];
    [pendingInfo removeAllObjects];
    [unknownBeacons removeAllObjects];

    [[BlueBarSDK Discovery] setDiscoveryDelegate:self];
    [[BlueBarSDK Discovery] setConnectionDelegate:self];
    [[BlueBarSDK Api] setApiDelegate:self];

    [self beginRefreshingTableView];
}

- (void)beginRefreshingTableView
{

    [self.tableView reloadData];

    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.0f];
    [self.refreshControl beginRefreshing];

    [UIView animateWithDuration:1.0f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
        self.tableView.contentOffset = CGPointMake(0, -80.0f);
    }                completion:^(BOOL finished){
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)stopRefresh
{
    [self.refreshControl endRefreshing];
}


// Use CBCentralManager to check whether the current platform/hardware supports Bluetooth LE.
- (BOOL)isLECapableHardware:(CBCentralManager *)centralManager
{
    NSString *state = nil;
    switch ([centralManager state])
    {
        case CBCentralManagerStateUnsupported:
            state = @"The platform/hardware doesn't support Bluetooth Low Energy.";
            break;
        case CBCentralManagerStateUnauthorized:
            state = @"The app is not authorized to use Bluetooth Low Energy.";
            break;
        case CBCentralManagerStatePoweredOff:
            state = @"Bluetooth is currently powered off.";
            break;
        case CBCentralManagerStatePoweredOn:
            return TRUE;
        case CBCentralManagerStateUnknown:
        default:
            return FALSE;
    }
    NSLog(@"Central manager state: %@", state);
    return FALSE;
}

- (void)startScan
{
    NSLog(@"startScan");
    isScanning = YES;

    [[BlueBarSDK Discovery] startScanning];

    [self.stopScanningButton setTitle:@"Stop Scan" forState:UIControlStateNormal];
    self.stopScanningButton.hidden = NO;
}

- (void)stopScan
{
    [[BlueBarSDK Discovery] stopScanning];
    [self stopRefresh];

    isScanning = NO;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    [self isLECapableHardware:central];
}

- (void)discoveredBeacon:(DetectedBeacon *)beacon
{
    if ([unknownBeacons containsObject:beacon])
        return;

    BOOL isNew = ![beacons containsObject:beacon];

    if (isNew)
    {
        @synchronized (pendingInfo)
        {
            BOOL isPending = [pendingInfo containsObject:beacon];
            if (!isPending)
            {
                NSLog(@"Requesting beacon details: %@", beacon.serial);

                [pendingInfo addObject:beacon];
                [[BlueBarSDK Api] requestBeaconDetails:beacon];
            }
        }
    }
    else
    {
        [self.tableView reloadData];
    }
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
    return [beacons count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BeaconCell"];

    DetectedBeacon *beacon = (beacons)[indexPath.row];

    UILabel *nameLabel = (UILabel *) [cell viewWithTag:101];
    nameLabel.text = beacon.name;

    UILabel *serialLabel = (UILabel *) [cell viewWithTag:102];
    serialLabel.text = [NSString stringWithFormat:@"%@", beacon.serial];

    UILabel *rssiLabel = (UILabel *) [cell viewWithTag:103];
    if (beacon.RSSI != nil)
        rssiLabel.text = [NSString stringWithFormat:@"%@", beacon.RSSI];
    else
        rssiLabel.text = @"";

    UIImageView *inSyncImage = (UIImageView *) [cell viewWithTag:104];
    if (beacon.configuration.isInSync)
    {
        inSyncImage.hidden = NO;
    }
    else
    {
        inSyncImage.hidden = YES;
    }

    return cell;
}

// Navigation to details

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        DetectedBeacon *beacon = beacons[indexPath.row];

        [self stopScan];

        ((BeaconDetailViewController *) segue.destinationViewController).beacon = beacon;
    }
}

- (IBAction)stopScanning:(id)sender
{
    if (isScanning)
    {
        [self stopScan];
        [self.stopScanningButton setTitle:@"Scan" forState:UIControlStateNormal];
    }
    else
    {
        [self beginRefreshingTableView];
    }
}

- (IBAction)logOut:(id)sender
{
    [self stopScan];

    [beacons removeAllObjects];
    [pendingInfo removeAllObjects];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)discoveryStatePoweredOff
{
    NSString *title = @"Bluetooth is Off";
    NSString *message = @"Bluetooth must be turned on in order to be able to manage your beacons!";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)failedToRetrieveBeaconConfigurationForBeacon:(DetectedBeacon *)beacon withError:(NSError *)error
{
    @synchronized (pendingInfo)
    {
        if ([pendingInfo containsObject:beacon])
            [pendingInfo removeObject:beacon];

        if (![unknownBeacons containsObject:beacon])
            [unknownBeacons addObject:beacon];
    }
}

- (void)retrievedBeaconConfiguration:(BeaconConfiguration *)beaconConfiguration forBeacon:(DetectedBeacon *)beacon
{
    @synchronized (pendingInfo)
    {
        beacon.configuration = beaconConfiguration;

        if (![beacons containsObject:beacon])
        {
            [beacons addObject:beacon];

            beacons = [[NSMutableArray alloc] initWithArray:[beacons sortedArrayUsingSelector:@selector(compare:)]];
        }

        if ([pendingInfo containsObject:beacon])
            [pendingInfo removeObject:beacon];
    }
}

@end
