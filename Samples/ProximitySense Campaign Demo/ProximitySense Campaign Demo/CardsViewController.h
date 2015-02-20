//
//  ViewController.h
//  Kontext
//
//  Created by Vladimir Petrov on 23/12/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Application;
@class ZLSwipeableView;

@interface CardsViewController : UIViewController

@property (strong, nonatomic) IBOutlet ZLSwipeableView *swipeableView;

@property (nonatomic, weak) Application* application;

@end

