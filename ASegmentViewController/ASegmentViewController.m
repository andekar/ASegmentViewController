//
//  ASegmentViewController.m
//
//  Created by anders on 16/03/2014.
//  Copyright (c) 2014 anders. All rights reserved.
//

#import "ASegmentViewController.h"

#define BAR_HEIGHT_IPHONE_PORTRAIT 64
#define BAR_HEIGHT_IPAD_PORTRAIT 64

#define BAR_HEIGHT_IPHONE_LANDSCAPE 52
#define BAR_HEIGHT_IPAD_LANDSCAPE 64

@interface ASegmentViewController ()
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic) NSInteger selectedIndex;
@property (nonatomic, strong) UINavigationBar * navBar;
@property (nonatomic, strong) UIView *contentView;

@end

static ASegmentViewController *SGViewController;
@implementation ASegmentViewController
@synthesize segmentedControl, viewControllers, selectedViewController, navBar;

- (id) initWithItems:(NSArray *) items forControllers:(NSArray *) controllers
{
    if(!SGViewController)
    {
        self = [super init];
        if (self) {
            
            self.segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
            [self.segmentedControl addTarget:self action:@selector(segmentedControlSelected:) forControlEvents:UIControlEventValueChanged];
            
            self.navigationItem.titleView = self.segmentedControl;
            self.viewControllers = controllers;
            self.extendedLayoutIncludesOpaqueBars = YES;
        }
        SGViewController = self;
        return self;
    }
    else
    {
        return SGViewController;
    }
}

+ (ASegmentViewController *) segViewController
{
    return SGViewController;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self fixLayout];
    
    [[self navigationItem] setTitle:@""];
}

- (void) fixLayout
{
    UIView *toView = ((UIView *)[self.contentView.subviews objectAtIndex:0]);
    if([toView isKindOfClass:[UITableView class]])
    {
        [((UITableView *)toView) setContentInset:UIEdgeInsetsFromString(@"{0,0,0,0}")];
        [((UITableView *)toView) setScrollIndicatorInsets:UIEdgeInsetsZero];
    }
    
    if([self.selectedViewController isKindOfClass:[UICollectionViewController class]])
    {
        UICollectionViewController *current = (UICollectionViewController*) self.selectedViewController;
        [current.collectionView setContentInset:UIEdgeInsetsFromString(@"{0,0,0,0}")];
        [current.collectionView setScrollIndicatorInsets:UIEdgeInsetsZero];
    }
}

- (void) loadView
{
    [super loadView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height)];
    [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:self.contentView];
    [self.view removeConstraints:[self.contentView constraints]];
    
    UIView *cv = self.contentView;
    
    NSArray *myConstraint =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cv]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cv)];
    [self.view addConstraints:myConstraint];
    
    [cv setTranslatesAutoresizingMaskIntoConstraints: NO];
    id topGuide = self.topLayoutGuide;
    NSDictionary *viewsDictionary = NSDictionaryOfVariableBindings (cv, topGuide);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat: @"V:|[topGuide][cv]|"
                                                                      options: 0
                                                                      metrics: nil
                                                                        views: viewsDictionary]];
    
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

-(CGRect) frameForContentController
{
    return CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) segmentedControlSelected:(id) sender
{
    UISegmentedControl *segControl = (UISegmentedControl *) sender;
    NSInteger index = segControl.selectedSegmentIndex;
    self.selectedIndex = index;
    UIViewController *toViewController = self.viewControllers[index];
    UIViewController *fromViewController = self.selectedViewController;
    CGRect rect = [self frameForContentController];
    
    [self addChildViewController:toViewController];
    
    [toViewController willMoveToParentViewController:self];
    
    toViewController.view.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    [toViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UIView *toView = toViewController.view;
    
    if(!selectedViewController)
    {
        self.selectedViewController = toViewController;
        [self.contentView addSubview:toViewController.view];
        NSArray *myConstraint =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toView)];
        
        [self.contentView addConstraints:myConstraint];
        myConstraint =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toView)];
        [self.contentView addConstraints:myConstraint];
        
        [toViewController didMoveToParentViewController:self];
    } else {
        [fromViewController willMoveToParentViewController:nil];
        [toViewController.view setAlpha:0.0f];
        [self transitionFromViewController:fromViewController toViewController:toViewController duration:0.0f options:UIViewAnimationOptionTransitionNone animations:^{
            [toViewController.view setAlpha:1.0];
            
        } completion:^(BOOL finished) {
            
            [toViewController.view setOpaque:NO];
            NSArray *myConstraint =[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[toView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toView)];
            [self.contentView addConstraints:myConstraint];
            myConstraint =[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[toView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(toView)];
            [self.contentView addConstraints:myConstraint];
            
            [fromViewController removeFromParentViewController];
            [fromViewController.view removeFromSuperview];
            [fromViewController didMoveToParentViewController:nil];
            
            [toViewController didMoveToParentViewController:self];
            
            self.selectedViewController = toViewController;
            
            [self fixLayout];
        }];
    }
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self fixLayout];
}

- (BOOL) shouldAutomaticallyForwardAppearanceMethods
{
    [super shouldAutomaticallyForwardRotationMethods];
    return YES;
}

-(BOOL) shouldAutomaticallyForwardRotationMethods
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void) setViewController:(int) controller
{
    if(controller != self.selectedIndex)
    {
        UISegmentedControl *segControl = self.segmentedControl;
        [segControl setSelectedSegmentIndex:controller];
        [self segmentedControlSelected:segControl];
    }
}
@end
