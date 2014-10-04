//
//  ActionTableViewCell.h
//  Campaign Demo
//
//  Created by Vladimir Petrov on 02/10/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ActionCellData;
@class ActionBase;

@interface ActionTableViewCell : UITableViewCell

@property (nonatomic, weak) ActionBase* action;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *content;

+ (CGFloat)estimatedCellHeight;

@end
