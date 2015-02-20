//
//  ViewController.m
//  Kontext
//
//  Created by Vladimir Petrov on 23/12/2014.
//  Copyright (c) 2014 Blue Sense Networks. All rights reserved.
//

#import "CardsViewController.h"
#import "ZLSwipeableView.h"
#import "CardView.h"
#import "ApiConnector.h"
#import "BlueBarSDK.h"
#import "ApiOperations.h"
#import "ActionBase.h"
#import "Application.h"

@interface CardsViewController () <ZLSwipeableViewDataSource, ZLSwipeableViewDelegate, UIGestureRecognizerDelegate>

@end

@implementation CardsViewController
{
@private
    NSMutableArray *actions;
    NSInteger availableCards;
    UILabel* emptyLabel;

    Application* __weak _application;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    actions = [[NSMutableArray alloc] initWithCapacity:10];

    // Optional Delegate
    self.swipeableView.delegate = self;
    
    emptyLabel = [[UILabel alloc] initWithFrame:self.view.frame];
    emptyLabel.text = @"No messages";
    emptyLabel.numberOfLines = 0;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.layer.opacity = 0.6;
    emptyLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    [self.view addSubview: emptyLabel];
    availableCards = 0;
    
    self.swipeableView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Clear All"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(clear)];

}

- (void) viewWillAppear:(BOOL)animated
{
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    
    // Register to receive a notification when ProximitySense responds with an actionable result
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(actionReceived:) name: ApiNotification_ActionReceived object:nil];
}

- (void) clear
{
    [self.swipeableView discardAllSwipeableViews];
    availableCards = 0;
    [self updateAvailableCards];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.swipeableView setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews {
    // Required Data Source
    self.swipeableView.dataSource = self;
}

- (Application*)application{
    return _application;
}

- (void) setApplication:(Application *)application
{
    _application = application;
    
    self.navigationItem.title = application.name;
    
    [[ApiConnector instance] startForApp:application];
}

- (void) updateAvailableCards
{
    if (availableCards > 0)
        availableCards--;
    
    if (availableCards > 0)
    {
        emptyLabel.text = @"";
    }
    else
    {
        emptyLabel.text = @"No messages";
    }
}

#pragma mark - ZLSwipeableViewDelegate

- (void)swipeableView:(ZLSwipeableView *)swipeableView
         didSwipeLeft:(UIView *)view
{
    [self updateAvailableCards];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
        didSwipeRight:(UIView *)view
{
    [self updateAvailableCards];
}

- (void)swipeableView:(ZLSwipeableView *)swipeableView
       didCancelSwipe:(UIView *)view {
}


#pragma mark - ZLSwipeableViewDataSource

- (UIView *)nextViewForSwipeableView:(ZLSwipeableView *)swipeableView {

    if (actions.count > 0)
    {
        CardView *view = [[CardView alloc] initWithFrame:swipeableView.bounds];
        view.action = [actions firstObject];
        [actions removeObjectAtIndex:0];
        
        return view;
    }
    
    return nil;
}


- (void)actionReceived:(id)notificationObject
{
    ActionBase* action = ((NSNotification *)notificationObject).object;
    
    [actions addObject:action];
    emptyLabel.text = @"";
    availableCards++;
    
    [self.swipeableView loadNextSwipeableViewsIfNeeded];
}


@end
