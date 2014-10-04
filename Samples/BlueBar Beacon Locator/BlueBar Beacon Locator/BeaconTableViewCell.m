//
//  BeaconTableViewCell.m
//  BlueBar Beacon Locator
//
//  Created by Vladimir Petrov on 04/07/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "BeaconTableViewCell.h"

@implementation BeaconTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
