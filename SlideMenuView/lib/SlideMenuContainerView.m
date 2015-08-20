//
//  SlideMenuView.m
//  SlideMenu
//
//  Copyright (c) 2015. All rights reserved.
//

#import "SlideMenuContainerView.h"

@interface SlideMenuContainerView ()

@property(nonatomic, strong) UIPanGestureRecognizer *rightSide;
@property(nonatomic, strong) UIPanGestureRecognizer *leftSide;
@property(nonatomic, strong) UITapGestureRecognizer *tap;
@property(nonatomic, assign) CGFloat visibleWidthLeft;
@property(nonatomic, assign) CGPoint startPoint;
@property(nonatomic, assign) BOOL isAnimated;
@property(nonatomic, assign) BOOL showMenuOffset;

@end

@implementation SlideMenuContainerView

- (id)initWithRootController:(UIViewController *)rootViewController
{
    if (self = [super init]) {
        self.isAnimated = NO;
        self.showMenuOffset = YES;
        
        self.visibleWidthLeft = self.view.bounds.size.width / 6;
        self.rootViewController = rootViewController;
        
        self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.backgroundImageView.frame = self.view.frame;
        [self.view insertSubview:self.backgroundImageView atIndex:0];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    NSLog(@"viewDidLayoutSubviews");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setMenuViewController:(UIViewController *)menuViewController
{
    NSLog(@"setMenuViewController");
    
    _menuViewController = menuViewController;
    
    UIView *view = self.menuViewController.view;
    view.frame = self.view.frame;
    view.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:view atIndex:1];
    
    CGRect rect = self.menuViewController.view.frame;
    if (self.showMenuOffset) {
        rect.origin.x = -self.visibleWidthLeft;
    } else {
        rect.origin.x = 0;
    }
    rect.origin.y = self.view.bounds.size.height / 4;
    rect.size.height = self.view.bounds.size.height / 2;
    rect.size.width = self.view.bounds.size.width / 2;
    
    self.menuViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.menuViewController.view.frame = rect;
    self.menuViewController.view.alpha = 0;
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    NSLog(@"setRootViewController");
    
    if (_rootViewController) {
        [_rootViewController.view removeFromSuperview];
        _rootViewController = nil;
    }
    _rootViewController = rootViewController;
    if (self.rootViewController) {
        UIView *view = self.rootViewController.view;
        view.frame = self.view.frame;
        [self.view insertSubview:view atIndex:2];
        [self addMenuItem];
    }
    UIPanGestureRecognizer *rightPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightPan:)];
    rightPan.delegate = (id <UIGestureRecognizerDelegate>)self;
    [self.rootViewController.view addGestureRecognizer:rightPan];
    self.rightSide = rightPan;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.rootViewController.view addGestureRecognizer:tap];
    self.tap = tap;
    tap.enabled = NO;
    
    UIPanGestureRecognizer *leftPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleLeftPan:)];
    leftPan.delegate = (id <UIGestureRecognizerDelegate>)self;
    [self.rootViewController.view addGestureRecognizer:leftPan];
    self.leftSide = leftPan;
    self.leftSide.enabled = NO;
    if (self.isAnimated) {
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = self.view.bounds.size.width - self.visibleWidthLeft;
        rect.origin.y = self.view.bounds.size.height / 4;
        rect.size.height = self.view.bounds.size.height / 2;
        rect.size.width = self.view.bounds.size.width / 2;
        self.rootViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
        self.rootViewController.view.frame = rect;
        [self slideOutAnimate];
    }
}

- (void)addMenuItem
{
    UIViewController *mainViewcontroller = nil;
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.rootViewController;
        mainViewcontroller = nav.viewControllers.firstObject;
    }
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(slideOutAnimate)];
    mainViewcontroller.navigationItem.leftBarButtonItem = barItem;
}

- (void)rootIsScrolling:(BOOL)isScroll
{
    UIViewController *mainViewcontroller = nil;
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.rootViewController;
        mainViewcontroller = nav.viewControllers.firstObject;
        mainViewcontroller.view.userInteractionEnabled = isScroll;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    return;
    
    // Testing orientation changes below.....................................
    
    self.rootViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
    CGRect rect = self.rootViewController.view.frame;
    rect.origin.x = size.width - self.visibleWidthLeft;
    rect.origin.y = size.height / 4;
    rect.size.height = size.height / 2;
    rect.size.width = size.width / 2;
    
    NSLog(@"NEW SIZE: %@", NSStringFromCGSize(size));
    
    NSLog(@"self.rootViewController.view.frame: %@", NSStringFromCGRect(self.rootViewController.view.frame));
    NSLog(@"new rect: %@", NSStringFromCGRect(rect));
    
    self.rootViewController.view.frame = rect;
    self.rootViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    

    return;
    
    if (self.isAnimated) {
        NSLog(@"Need to redraw the slide menu and view controller...... isAnimated");
        
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = size.width - self.visibleWidthLeft;
        rect.origin.y = size.height / 4;
        rect.size.height = size.height / 2;
        rect.size.width = size.width / 2;
        
        CGRect nextRect = self.menuViewController.view.frame;
        nextRect.origin.x = 0;
        nextRect.origin.y = 0;
        nextRect.size.height = size.height;
        nextRect.size.width = size.width;
        
        NSLog(@"root rect: %@", NSStringFromCGRect(rect));
        NSLog(@"menu rect: %@", NSStringFromCGRect(nextRect));
        
//        self.menuViewController.view.frame = nextRect;
        
        
        [UIView animateWithDuration:.5
                         animations:^{
                             //self.rootViewController.view.frame = rect;
                             //self.menuViewController.view.frame = nextRect;
                         }
                         completion:^(BOOL finished) {
                             
                         }];

        
        
    } else {
        
        NSLog(@"Need to redraw the slide menu and view controller......");
        
        /*
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.height = size.height;
        rect.size.width = size.width;
        
        CGRect nextRect = self.menuViewController.view.frame;
        nextRect.origin.x = -self.visibleWidthLeft;
        nextRect.origin.y = size.height / 4;
        nextRect.size.height = size.height / 2;
        nextRect.size.width = size.width / 2;
        
        NSLog(@"root rect: %@", NSStringFromCGRect(rect));
        NSLog(@"menu rect: %@", NSStringFromCGRect(nextRect));
        
        [UIView animateWithDuration:.5 animations:^{
            //            self.rootViewController.view.frame = rect;
            //            self.leftViewController.view.frame = nextRect;
        } completion:^(BOOL finished) {
            
        }];
         */
        
    }
    
    
}


#pragma mark - UIGesture Actions

- (void)handleRightPan:(UIPanGestureRecognizer *)pan
{
//    NSLog(@"handleRightPan");
    
    CGPoint locationPoint = [pan locationInView:self.view];
    CGFloat offsetX = locationPoint.x - self.startPoint.x;
    
    // Is panning
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (locationPoint.x - self.startPoint.x >= 6) {
            CGFloat leftOffsetX;
            CGFloat rootZoom;
            if (self.showMenuOffset) {
                leftOffsetX = offsetX * self.visibleWidthLeft / (self.view.bounds.size.width - self.visibleWidthLeft);
                rootZoom = offsetX / (self.view.bounds.size.width - self.visibleWidthLeft) * 0.5;
            } else {
                leftOffsetX = offsetX / (self.view.bounds.size.width);
                rootZoom = offsetX / (self.view.bounds.size.width) * 0.5;
            }
            CGRect rootRect = self.rootViewController.view.frame;
            rootRect.origin.x = offsetX;
            self.rootViewController.view.frame = rootRect;
            self.rootViewController.view.transform = CGAffineTransformMakeScale(1 - rootZoom, 1 - rootZoom);
            
            CGRect leftRect = self.menuViewController.view.frame;
            if (self.showMenuOffset) {
                leftRect.origin.x = leftOffsetX - self.visibleWidthLeft;
            } else {
                leftRect.origin.x = leftOffsetX;
            }
            leftRect.size.width = (self.view.bounds.size.width / 2) + leftOffsetX * self.view.bounds.size.width / 2 / self.visibleWidthLeft;
            self.menuViewController.view.frame = leftRect;
            self.menuViewController.view.transform = CGAffineTransformMakeScale(0.5 + rootZoom , 0.5 + rootZoom);
            self.menuViewController.view.alpha = offsetX/(self.view.bounds.size.width - self.visibleWidthLeft) * 1.0;
        } else {
            return;
        }
        
        // Disable panning is offset gets to the edge of bounds
        if (offsetX >= (self.view.bounds.size.width - self.visibleWidthLeft)) {
            pan.enabled = NO;
        }
        
    }
    
    // Panning has ended
    else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        
        // If offset is greater than 16% of screen
        if (offsetX >= [UIScreen mainScreen].bounds.size.width / 6) {
            
            // New root controller frame
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = self.view.bounds.size.width - self.visibleWidthLeft;
            rect.origin.y = self.view.bounds.size.height / 4;
            rect.size.height = self.view.bounds.size.height / 2;
            rect.size.width = self.view.bounds.size.width / 2;
            
            // New menu controller frame
            CGRect nextRect = self.menuViewController.view.frame;
            nextRect.origin.x = 0;
            nextRect.origin.y = 0;
            nextRect.size.height = self.view.bounds.size.height;
            nextRect.size.width = self.view.bounds.size.width;
            
            // Do animations
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.rootViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                 self.rootViewController.view.frame = rect;
                                 self.menuViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                                 self.menuViewController.view.frame = nextRect;
                                 self.menuViewController.view.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 self.isAnimated = YES;
                                 self.leftSide.enabled = YES;
                                 self.tap.enabled = YES;
                                 [self rootIsScrolling:NO];
                             }];
            
        }
        
        // Offset is less than 16% so spring back
        else {
            
            // Show status bar
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            
            // New root controller frame
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = 0;
            rect.origin.y = 0;
            rect.size.height = self.view.bounds.size.height;
            rect.size.width = self.view.bounds.size.width;
            
            // New menu controller frame
            CGRect nextRect = self.menuViewController.view.frame;
            if (self.showMenuOffset) {
                nextRect.origin.x = -self.visibleWidthLeft;
            } else {
                nextRect.origin.x = 0;
            }
            nextRect.origin.y = self.view.bounds.size.height / 4;
            nextRect.size.height = self.view.bounds.size.height / 2;
            nextRect.size.width = self.view.bounds.size.width / 2;
            
            // Do animations
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.rootViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                                 self.rootViewController.view.frame = rect;
                                 self.menuViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                 self.menuViewController.view.frame = nextRect;
                                 self.menuViewController.view.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 self.isAnimated = NO;
                                 self.tap.enabled = NO;
                             }];
        }
        
    }
}

- (void)handleLeftPan:(UIPanGestureRecognizer *)leftSide
{
//    NSLog(@"handleLeftPan");
    
    CGPoint locationPoint = [leftSide locationInView:self.view];
    CGFloat offsetX = - (locationPoint.x - self.startPoint.x);
    
    // Is panning
    if (leftSide.state == UIGestureRecognizerStateChanged) {
        
        if (locationPoint.x - self.startPoint.x <= -6) {
            CGFloat leftOffsetX;
            CGFloat rootZoom;
            if (self.showMenuOffset) {
                leftOffsetX = offsetX * self.visibleWidthLeft / (self.view.bounds.size.width - self.visibleWidthLeft);
                rootZoom = (offsetX / (self.view.bounds.size.width - self.visibleWidthLeft)) * 0.5;
            } else {
                leftOffsetX = offsetX / (self.view.bounds.size.width);
                rootZoom = offsetX / (self.view.bounds.size.width) * 0.5;
            }
            CGRect rootRect = self.rootViewController.view.frame;
            if (self.showMenuOffset) {
                rootRect.origin.x = [UIScreen mainScreen].bounds.size.width - self.visibleWidthLeft - offsetX;
            } else {
                rootRect.origin.x = [UIScreen mainScreen].bounds.size.width - offsetX;
            }
            self.rootViewController.view.frame = rootRect;
            self.rootViewController.view.transform = CGAffineTransformMakeScale(0.5 + rootZoom, 0.5 +rootZoom);
            
            CGRect leftRect = self.menuViewController.view.frame;
            leftRect.origin.x = -leftOffsetX;
            self.menuViewController.view.frame = leftRect;
            self.menuViewController.view.transform = CGAffineTransformMakeScale(1 - rootZoom, 1 - rootZoom);
            self.menuViewController.view.alpha = 1.0 - offsetX / (self.view.bounds.size.width - self.visibleWidthLeft) * 1.0;
        } else {
            return;
        }
        
        // Disable panning is offset gets to the edge of bounds
        if (offsetX >= (self.view.bounds.size.width - self.visibleWidthLeft)) {
            leftSide.enabled = NO;
        }
        
    }
    
    // Panning has ended
    else if (leftSide.state == UIGestureRecognizerStateCancelled || leftSide.state == UIGestureRecognizerStateEnded) {
        
        // If offset is greater than 33% of screen
        if (offsetX >= [UIScreen mainScreen].bounds.size.width / 3) {
            
            // Show status bar
            [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
            
            // New root controller frame
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = 0;
            rect.origin.y = 0;
            rect.size.height = self.view.bounds.size.height;
            rect.size.width =  self.view.bounds.size.width;
            
            // New menu controller frame
            CGRect nextRect = self.menuViewController.view.frame;
            if (self.showMenuOffset) {
                nextRect.origin.x = -self.visibleWidthLeft;
            } else {
                nextRect.origin.x = 0;
            }
            nextRect.origin.y = self.view.bounds.size.height / 4;
            nextRect.size.height = self.view.bounds.size.height / 2;
            nextRect.size.width = self.view.bounds.size.width / 2;
            
            // Do animations
            [UIView animateWithDuration:.5
                             animations:^{
                                 self.rootViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                                 self.rootViewController.view.frame = rect;
                                 self.menuViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                 self.menuViewController.view.frame = nextRect;
                                 self.menuViewController.view.alpha = 0;
                             }
                             completion:^(BOOL finished) {
                                 self.isAnimated = !self.isAnimated;
                                 self.rightSide.enabled = YES;
                                 self.leftSide.enabled = NO;
                                 self.tap.enabled = NO;
                                 [self rootIsScrolling:YES];
                             }];
            
        }
        
        // Offset is less than 33%
        else {
            
            // New root controller frame
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = self.view.bounds.size.width - self.visibleWidthLeft;
            rect.origin.y = self.view.bounds.size.height / 4;
            rect.size.height = self.view.bounds.size.height / 2;
            rect.size.width = self.view.bounds.size.width / 2;
            
            // New menu controller frame
            CGRect nextRect = self.menuViewController.view.frame;
            nextRect.origin.x = 0;
            nextRect.origin.y = 0;
            nextRect.size.height = self.view.bounds.size.height;
            nextRect.size.width = self.view.bounds.size.width;
            
            // Do animations
            [UIView animateWithDuration:0.5
                             animations:^{
                                 self.rootViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                                 self.rootViewController.view.frame = rect;
                                 self.menuViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                                 self.menuViewController.view.frame = nextRect;
                                 self.menuViewController.view.alpha = 1;
                             }
                             completion:^(BOOL finished) {
                                 self.isAnimated = YES;
                                 self.leftSide.enabled = YES;
                                 self.tap.enabled = YES;
                                 [self rootIsScrolling:NO];
                             }];
        }
    }
}

- (void)handleTap:(UITapGestureRecognizer *)tap
{
//    NSLog(@"handleTap");
    
    if (self.isAnimated) {
        [self slideOutAnimate];
    }
}

- (void)slideOutAnimate
{
//    NSLog(@"slideOutAnimate");
    
    // Menu is not shown
    if (!self.isAnimated) {
        
        // Hide status bar
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
        // New root controller frame
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = [UIScreen mainScreen].bounds.size.width - self.visibleWidthLeft;
        rect.origin.y = self.view.bounds.size.height / 4;
        rect.size.height = self.view.bounds.size.height / 2;
        rect.size.width = self.view.bounds.size.width / 2;
        
        // New menu controller frame
        CGRect nextRect = self.menuViewController.view.frame;
        nextRect.origin.x = 0;
        nextRect.origin.y = 0;
        nextRect.size.height = self.view.bounds.size.height;
        nextRect.size.width = self.view.bounds.size.width;
        
        // Do animations
        [UIView animateWithDuration:.5
                         animations:^{
                             self.rootViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                             self.rootViewController.view.frame = rect;
                             self.menuViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                             self.menuViewController.view.frame = nextRect;
                             self.menuViewController.view.alpha = 1.0;
                         }
                         completion:^(BOOL finished) {
                             self.isAnimated = !self.isAnimated;
                             self.leftSide.enabled = YES;
                             self.tap.enabled = YES;
                             [self rootIsScrolling:NO];
                         }];
        
    }
    
    // Menu is shown
    else {
        
        // Show status bar
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
        
        // New root controller frame
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.height = self.view.bounds.size.height;
        rect.size.width = self.view.bounds.size.width;
        
        // New menu controller frame
        CGRect nextRect = self.menuViewController.view.frame;
        if (self.showMenuOffset) {
            nextRect.origin.x = -self.visibleWidthLeft;
        } else {
            nextRect.origin.x = 0;
        }
        nextRect.origin.y = self.view.bounds.size.height / 4;
        nextRect.size.height = self.view.bounds.size.height / 2;
        nextRect.size.width = self.view.bounds.size.width / 2;
        
        // Do animations
        [UIView animateWithDuration:.5
                         animations:^{
                             self.rootViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                             self.rootViewController.view.frame = rect;
                             self.menuViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                             self.menuViewController.view.frame = nextRect;
                             self.menuViewController.view.alpha = 0;
                         }
                         completion:^(BOOL finished) {
                             self.isAnimated = !self.isAnimated;
                             self.rightSide.enabled = YES;
                             self.leftSide.enabled = NO;
                             self.tap.enabled = NO;
                             [self rootIsScrolling:YES];
                         }];
    }
}


#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    self.startPoint = [gestureRecognizer locationInView:self.view];
    if (gestureRecognizer == self.rightSide) {
        if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.rootViewController;
            NSArray *viewControllers = nav.viewControllers;
            if (viewControllers.count > 1) {
                return NO;
            }
        }
    }

    // Hide status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    return YES;
}

@end
