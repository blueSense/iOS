//
//  CardView.m
//  ZLSwipeableViewDemo
//
//  Created by Zhixuan Lai on 11/1/14.
//  Copyright (c) 2014 Zhixuan Lai. All rights reserved.
//

#import "CardView.h"

#import "ActionBase.h"
#import "RichContentAction.h"

@interface CardView  () <UIWebViewDelegate, WKNavigationDelegate>

@end

@implementation CardView
{
@private
    ActionBase * __weak _action;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    // Shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.33;
    self.layer.shadowOffset = CGSizeMake(0, 1.5);
    self.layer.shadowRadius = 4.0;
    self.layer.shouldRasterize = YES;

    // Corner Radius
    self.layer.cornerRadius = 10.0;
    
    self.backgroundColor = [UIColor whiteColor];
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

}

- (ActionBase *)action
{
    return _action;
}

- (void)setAction:(ActionBase *)action
{
    _action = action;
    
    if ([action isKindOfClass:[RichContentAction class]])
    {
        RichContentAction *richContentAction = (RichContentAction *)action;
        
        if (!self.webview)
        {
            CGRect webViewFrame = CGRectInset(self.frame, 15.0f, 15.0f);
            
            self.webview = [[WKWebView alloc] initWithFrame:webViewFrame];
            [self.webview setNavigationDelegate:self];
            
            self.webview.contentMode = UIViewContentModeScaleAspectFit;
            self.webview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

            [self addSubview:self.webview];
        }
        
        NSURL *url = [NSURL URLWithString:richContentAction.contentUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        //Load the request in the UIWebView.
        [self.webview loadRequest:request];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Error : %@",error);
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    NSString* viewportJS = [NSString stringWithFormat:@"var myCustomViewport = 'width=%dpx'; var viewportElement = document.querySelector('meta[name=viewport]');if (viewportElement) {viewportElement.content = myCustomViewport;} else {viewportElement = document.createElement('meta'); viewportElement.name = 'viewport'; viewportElement.content = myCustomViewport;}", (int) self.webview.frame.size.width];
    
    [self.webview evaluateJavaScript:viewportJS completionHandler:^(id result, NSError *error) {        
    }];
}

@end
