//
//  ASegmentViewController.h
//
//  Created by anders on 16/03/2014.
//  Copyright (c) 2014 anders. All rights reserved.
//

#define IS_PHONE  UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone
#define isDeviceIPad UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad

#import <UIKit/UIKit.h>

@interface ASegmentViewController : UIViewController
@property (nonatomic, strong) NSArray *viewControllers;

- (id) initWithItems:(NSArray *) items forControllers:(NSArray *) controllers;
- (void) setViewController:(int) controller;

+ (ASegmentViewController *) segViewController;
@end
