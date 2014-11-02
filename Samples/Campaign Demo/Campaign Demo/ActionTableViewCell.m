//
//  ActionTableViewCell.m
//  Campaign Demo
//
//  Created by Vladimir Petrov on 02/10/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "ActionTableViewCell.h"
#import "ActionBase.h"
#import "MesageAction.h"
#import "PresenceAction.h"
#import "KeyValueAction.h"

@implementation ActionTableViewCell
{
@private
    ActionBase * __weak _action;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self sizeToFit];
    }

    return self;
}

- (ActionBase *)action
{
    return _action;
}

- (void)setAction:(ActionBase *)action
{
    _action = action;

    if ([action isKindOfClass:[MessageAction class]])
    {
        MessageAction *messageAction = (MessageAction *)action;

        self.title.text = @"Message";
        self.content.text = messageAction.messageBody;
    }
    else
    if ([action isKindOfClass:[PresenceAction class]])
    {
        PresenceAction *presenceAction = (PresenceAction *)action;

        self.title.text = @"Presence";
        self.content.text = presenceAction.presence;
    }
    else
    if ([action isKindOfClass:[KeyValueAction class]])
    {
        KeyValueAction *keyValueAction = (KeyValueAction *)action;

        self.title.text = @"KeyValue";
        self.content.text = keyValueAction.metadata.description;
    }
    else
    {
        self.title.text = @"Unknown";
        self.content.text = @"N/A";
    }
}

+ (CGFloat)estimatedCellHeight
{
    return 120.0f;
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
