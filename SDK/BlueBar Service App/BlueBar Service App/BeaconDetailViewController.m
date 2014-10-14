//
//  BSNDetailViewController.m
//  BlueBar Service App
//
//  Created by Vladimir Petrov on 03/02/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "BeaconDiscovery.h"
#import "BeaconDetailViewController.h"
#import "BlueBarSDK.h"
#import "CalibrateViewController.h"

#define MODE_INITIAL 0
#define MODE_CONNECTING 1
#define MODE_UPDATING 2
#define MODE_CONNECTING_TO_UPDATE 3
#define MODE_BAD_PIN 4
#define MODE_REFRESHING 5
#define MODE_RECONNECTING 6

@interface BeaconDetailViewController () < UITextFieldDelegate, UIAlertViewDelegate, BeaconDiscoveryDelegate, BeaconConnectionDelegate, BeaconConfigurationServiceDelegate, ApiOperationsDelegate >
{
@private
    int mode;
}

@property ( strong, nonatomic ) UIPopoverController *masterPopoverController;
@property ( strong, nonatomic ) MBProgressHUD *hud;

- (void)configureView;
@end

@implementation BeaconDetailViewController

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)sliderValueChanged:(UISlider *)sender
{
    int val = sender.value;
    if (sender == self.signalStrengthSlider)
    {
        self.beacon.configuration.signalStrength = [[NSNumber alloc] initWithInt:val];
        self.signalStrength.text = [NSString stringWithFormat:@"%d", self.beacon.configuration.signalStrength.intValue];
    }

    if (sender == self.advIntervalSlider)
    {
        int interval = val * 16;
        self.beacon.configuration.advertisementInterval = [[NSNumber alloc] initWithInt:interval];
        self.advInterval.text = [NSString stringWithFormat:@"%d", val * 10];
    }

    [self refreshStatus];
}

- (void)setBeacon:(DetectedBeacon *)newBeacon
{
    if (_beacon != newBeacon)
    {
        _beacon = newBeacon;
    }

    if (self.masterPopoverController != nil)
    {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)displayErrorMessage:(NSString *)title withMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)setMode:(int)nextMode
{
    switch (nextMode)
    {
        case MODE_INITIAL:
            [self.hud hide:YES];
            [[BlueBarSDK Discovery] disconnectBeacon:self.beacon];
            break;
        case MODE_CONNECTING:
            self.hud.labelText = @"Connecting...";
            [self.hud show:YES];
            break;
        case MODE_UPDATING:
        case MODE_CONNECTING_TO_UPDATE:
            self.hud.labelText = @"Updating...";
            [self.hud show:YES];
            break;
        case MODE_REFRESHING:
            self.hud.labelText = @"Refreshing...";
            [self.hud show:YES];
            break;
        default:
            break;
    }

    mode = nextMode;
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.beacon)
    {
        self.name.text = self.beacon.name;
        self.serial.text = self.beacon.serial;
        if (self.beacon.configuration.battery.unsignedShortValue != 0)
            self.battery.text = [NSString stringWithFormat:@"%d", self.beacon.configuration.battery.unsignedShortValue];
        else
            self.battery.text = @"N/A";

        self.uuid.text = self.beacon.configuration.uuid;
        self.uuid.delegate = self;

        self.major.text = [NSString stringWithFormat:@"%d", self.beacon.configuration.major.unsignedShortValue];
        self.major.delegate = self;

        self.minor.text = [NSString stringWithFormat:@"%d", self.beacon.configuration.minor.unsignedShortValue];
        self.minor.delegate = self;

        self.advInterval.text = [NSString stringWithFormat:@"%d", (int) (self.beacon.configuration.advertisementInterval.unsignedIntValue / 1.6)];
        self.advIntervalSlider.value = self.beacon.configuration.advertisementInterval.unsignedIntValue / 16.0;

        self.signalStrength.text = [NSString stringWithFormat:@"%d", self.beacon.configuration.signalStrength.unsignedCharValue];
        self.signalStrengthSlider.value = self.beacon.configuration.signalStrength.unsignedCharValue;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
    
    self.scrollView.contentSize = CGSizeMake(320, 550);
}

- (void)viewWillAppear:(BOOL)animated
{
    [[BlueBarSDK Discovery] setDiscoveryDelegate:self];
    [[BlueBarSDK Discovery] setConnectionDelegate:self];
    [[BlueBarSDK Api] setApiDelegate:self];

    [self configureView];

    self.status.hidden = YES;

    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;

    [self setMode:MODE_CONNECTING];

    [[BlueBarSDK Discovery] connectBeacon:self.beacon];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    CalibrateViewController* calibrateViewController = [segue destinationViewController];
    
    if (calibrateViewController){
        [calibrateViewController setBeacon: self.beacon];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (IBAction)refresh:(id)sender
{
    [self setMode:MODE_REFRESHING];

    [[BlueBarSDK Api] requestBeaconDetails:self.beacon];
}

- (IBAction)update:(id)sender
{
    NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:self.uuid.text];
    if (!uuid)
    {
        [self displayErrorMessage:@"Error" withMessage:@"Invalid UUID format!"];
        return;
    }

    int major = [self.major.text intValue];
    NSString *majorStr = [NSString stringWithFormat:@"%d", major];
    if (![majorStr isEqualToString:self.major.text] || major > 65535 || major < 0)
    {
        [self displayErrorMessage:@"Error" withMessage:@"Invalid major number format! Please enter an integer number in the range from 0 to 65535"];
        return;
    }

    int minor = [self.minor.text intValue];
    NSString *minorStr = [NSString stringWithFormat:@"%d", minor];
    if (![minorStr isEqualToString:self.minor.text] || minor > 65535 || minor < 0)
    {
        [self displayErrorMessage:@"Error" withMessage:@"Invalid minor number format! Please enter an integer number in the range from 0 to 65535"];
        return;
    }

    self.beacon.configuration.uuid = uuid.UUIDString;
    self.beacon.configuration.major = [[NSNumber alloc] initWithInt:major];
    self.beacon.configuration.minor = [[NSNumber alloc] initWithInt:minor];

    if (self.beacon.peripheral.state == CBPeripheralStateConnected)
    {
        [self setMode:MODE_UPDATING];
        [self.beacon.service updateConfiguration:self.beacon.configuration];
    }
    else
    {
        [self setMode:MODE_CONNECTING_TO_UPDATE];
        [[BlueBarSDK Discovery] connectBeacon:self.beacon];
    }
}

- (void)retrievedBeaconConfiguration:(BeaconConfiguration *)beaconConfiguration forBeacon:(DetectedBeacon *)beacon
{
    if (beacon != self.beacon)
        return;

    self.beacon.name = beaconConfiguration.name;
    self.beacon.serial = beaconConfiguration.serial;
    self.beacon.configuration = beaconConfiguration;

    [self configureView];
    [self refreshStatus];

    [self setMode:MODE_INITIAL];
}

- (void)failedToRetrieveBeaconConfigurationForBeacon:(DetectedBeacon *)beacon withError:(NSError *)error
{
    if (beacon != self.beacon)
        return;

    NSString *title = @"Error";
    NSString *message = @"Can not retrieve beacon configuration, please check you are connected to internet!";

    [self displayErrorMessage:title withMessage:message];

    [self setMode:MODE_INITIAL];
}

- (IBAction)disconnect:(id)sender
{
    [self setMode:MODE_INITIAL];
    [[BlueBarSDK Discovery] disconnectBeacon:self.beacon];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)discoveryStatePoweredOff
{
    NSString *title = @"Bluetooth is Off";
    NSString *message = @"Bluetooth must be turned on in order to be able to manage your beacons!";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

- (void)connectedToBeacon:(DetectedBeacon *)beacon
{
    NSLog(@"Connected to %@", beacon.peripheral);

    switch (mode)
    {
        case MODE_CONNECTING:
        case MODE_CONNECTING_TO_UPDATE:
        {
            [self.beacon.service setServiceDelegate:self];
        }
            break;
        default:
            break;
    }
}

- (void)disconnectedFromBeacon:(DetectedBeacon *)beacon withError:(NSError *)error
{
    NSLog(@"Disconnected from %@", beacon.peripheral);

    switch (mode)
    {
        case MODE_BAD_PIN:
        {
            self.beacon.configuration.initialSetupDone = YES;
            [self setMode:MODE_CONNECTING_TO_UPDATE];
            [[BlueBarSDK Discovery] connectBeacon:self.beacon];
        }
            break;
        default:
            if (error)
            {
                [self failedToConnect:beacon withError:error];
            }
            break;
    }
}

- (BOOL)displayMismatch:(UITextField *)textBox isMatch:(BOOL)isMatch
{
    if (isMatch)
    {
        textBox.textColor = [UIColor blackColor];
    }
    else
        textBox.textColor = [UIColor redColor];

    return isMatch;
}

- (void)refreshStatus
{
    self.battery.text = [NSString stringWithFormat:@"%d%%", self.beacon.service.battery];

    BOOL uuidUpdated = [self.beacon.configuration.uuid caseInsensitiveCompare:self.beacon.service.uuid] == NSOrderedSame;
    BOOL allMatch = YES;

    allMatch = [self displayMismatch:self.uuid isMatch:uuidUpdated] && allMatch;
    allMatch = [self displayMismatch:self.major isMatch:(self.beacon.configuration.major.unsignedShortValue == self.beacon.service.major)] && allMatch;
    allMatch = [self displayMismatch:self.minor isMatch:(self.beacon.configuration.minor.unsignedShortValue == self.beacon.service.minor)] && allMatch;
    allMatch = [self displayMismatch:self.advInterval isMatch:(self.beacon.configuration.advertisementInterval.shortValue == self.beacon.service.advertisementInterval)] && allMatch;
    allMatch = [self displayMismatch:self.signalStrength isMatch:(self.beacon.configuration.signalStrength.charValue == self.beacon.service.signalStrength)] && allMatch;

    self.status.hidden = NO;

    if (allMatch)
    {
        self.beacon.configuration.isInSync = YES;
        self.status.text = @"Beacon configuration is up to date";
        self.status.textColor = [UIColor colorWithRed:18.0 / 255.0 green:212.0 / 255.0 blue:42.0 / 255.0 alpha:1.0];
    }
    else
    {
        self.beacon.configuration.isInSync = NO;
        self.status.text = @"Current beacon configuration is out of date, tap Update to synchronize";
        self.status.textColor = [UIColor redColor];
    }
    
    if (self.beacon.configuration.calibrationChanged)
    {
        self.status.text = @"Beacon calibration changed, tap Update to synchronize";
        self.status.textColor = [UIColor redColor];
    }
}

- (void)doneReading
{
    switch (mode)
    {
        case MODE_CONNECTING:
        {
            [self refreshStatus];
            [self setMode:MODE_INITIAL];
        }
            break;
        case MODE_CONNECTING_TO_UPDATE:
        {
            [self setMode:MODE_UPDATING];
            [self.beacon.service updateConfiguration:self.beacon.configuration];
        }
            break;
        case MODE_UPDATING:
        {
            [[BlueBarSDK Api] updateBeaconDetails:self.beacon];

            [self refreshStatus];
            [self setMode:MODE_INITIAL];
        }
            break;
        default:
            break;
    }
}

- (void)errorBadPin
{
    if (mode == MODE_UPDATING && !self.beacon.configuration.initialSetupDone)
    {
        [self setMode:MODE_BAD_PIN];
    }
}

- (void)failedToConnect:(DetectedBeacon *)beacon withError:(NSError *)error
{
    NSString *title = @"Beacon Connection failed";
    NSString *message;

    switch (error.code)
    {
        case 0:
            message = @"Unknown error! This usually indicates a bad state of iOS's Bluetooth stack. Please restart your phone and try again.";
            break;
        case 7:
            message = @"Device disconnected, please try again.";
            switch (mode)
            {
                case MODE_CONNECTING:
                {
                    [self setMode:MODE_RECONNECTING];
                    [[BlueBarSDK Discovery] connectBeacon:beacon];
                }
                return;
                case MODE_UPDATING:
                {
                    [self setMode:MODE_BAD_PIN];
                    [self disconnectedFromBeacon:beacon withError:error];
                    return;
                }
                default:
                    break;
            }
            break;
        case 15:
            message = @"Pairing failed! Please try again.";
            break;
        default:
            message = @"Connection failed, please try again. If you are unable to connect even after a few attempts, please clear all pairing from Settings/Bluettoth and restart your phone.";
        break;
    }

    [self displayErrorMessage:title withMessage:message];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self disconnect:self];
}

@end
