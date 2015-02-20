//
//  CardView.h
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

#import "ActionBase.h"

@interface CardView : UIView

@property (nonatomic, weak) ActionBase* action;
@property (nonatomic, strong) WKWebView* webview;

@end
