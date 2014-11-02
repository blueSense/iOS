//
//  ActionsTableViewController.h
//  Campaign Demo
//
//  Created by Vladimir Petrov on 25/09/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IASKAppSettingsViewController.h"

@interface ActionsTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, IASKSettingsDelegate>

@property (nonatomic, retain) IASKAppSettingsViewController *appSettingsViewController;

@end
