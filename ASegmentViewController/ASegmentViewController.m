//
//  ASegmentViewController.m
//
//  Created by anders on 16/03/2014.
//  Copyright (c) 2014 anders. All rights reserved.
//

#import "ASegmentViewController.h"

@interface ASegmentViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, weak) UIViewController *selectedViewController;
@end

@implementation ASegmentViewController
@synthesize segmentedControl, viewControllers, selectedViewController;

- (id) initWithItems:(NSArray *) items forControllers:(NSArray *) controllers
{
    self = [super init];
    if (self) {
        self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
        [self.segmentedControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
        self.navigationItem.titleView = self.segmentedControl;
        self.viewControllers = controllers;
        for(UIViewController *control in self.viewControllers)
        {
            [self addChildViewController:control];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if([self.viewControllers count])
    {
        [self.segmentedControl setSelectedSegmentIndex:0];
        [self segmentedControlSelected:self.segmentedControl];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) segmentedControlSelected:(id) sender
{
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    NSInteger index = segControl.selectedSegmentIndex;
    if(!selectedViewController)
    {
        self.selectedViewController = self.viewControllers[index];
        [self.selectedViewController didMoveToParentViewController:self];
        [self.view addSubview:self.selectedViewController.view];
    } else {
        [self transitionFromViewController:self.selectedViewController toViewController:self.viewControllers[index] duration:0.0f options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
            self.selectedViewController = self.viewControllers[index];
        }];
    }
}


@end
