//
//  SlideMenuView.m
//  SlideMenuView
//
//  Created by xdf on 4/20/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import "SlideMenuView.h"

@interface SlideMenuView ()

@property(nonatomic, strong) UIPanGestureRecognizer *rightSide;
@property(nonatomic, strong) UIPanGestureRecognizer *leftSide;
@property(nonatomic, strong) UITapGestureRecognizer *tap;
@property(nonatomic, assign) CGFloat visibleWidthLeft;
@property(nonatomic, assign) CGPoint startPoint;
@property(nonatomic, assign) BOOL isAnimated;

@end

@implementation SlideMenuView

- (id)initWithRootController:(UIViewController *)rootViewController
{
    self = [self init];
    if (self) {
        self.rootViewController = rootViewController;
    }
    [self installBackground];
    return self;
}

- (id)init
{
    self.visibleWidthLeft = self.view.bounds.size.width / 6;
    self = [super init];
    if (self) {
        self.isAnimated = NO;
    }
    return self;
}

- (void)installBackground
{
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wing.jpg"]];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.backgroundImageView.frame = self.view.frame;
    [self.view insertSubview:self.backgroundImageView atIndex:0];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

- (void)setRootViewController:(UIViewController *)rootViewController
{
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
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = (id <UIGestureRecognizerDelegate>)self;
    [self.rootViewController.view addGestureRecognizer:pan];
    self.rightSide = pan;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.rootViewController.view addGestureRecognizer:tap];
    self.tap = tap;
    tap.enabled = NO;
    
    UIPanGestureRecognizer *leftSide = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleleftSide:)];
    leftSide.delegate = (id <UIGestureRecognizerDelegate>)self;
    [self.rootViewController.view addGestureRecognizer:leftSide];
    self.leftSide = leftSide;
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

- (void)setLeftViewController:(UIViewController *)leftViewController
{
    _leftViewController = leftViewController;
    
    UIView *view = self.leftViewController.view;
    view.frame = self.view.frame;
    [self.view insertSubview:view atIndex:1];
    
    CGRect rect = self.leftViewController.view.frame;
    //rect.origin.x = -self.visibleWidthLeft;
rect.origin.x = 0;
    rect.origin.y = self.view.bounds.size.height / 4;
    rect.size.height = self.view.bounds.size.height / 2;
    rect.size.width = self.view.bounds.size.width / 2;
    
    NSLog(@"rect: %@", NSStringFromCGRect(rect));
    
    self.leftViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
    self.leftViewController.view.frame = rect;
    self.leftViewController.view.alpha = 0;
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
//    NSLog(@"NEW SIZE: %@", NSStringFromCGSize(size));
    
    NSLog(@"self.rootViewController.view.frame: %@", NSStringFromCGRect(self.rootViewController.view.frame));
    return;
    
    if (self.isAnimated) {
        NSLog(@"Need to redraw the slide menu and view controller...... isAnimated");
        
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = size.width - self.visibleWidthLeft;
        rect.origin.y = size.height / 4;
        rect.size.height = size.height / 2;
        rect.size.width = size.width / 2;
        
        CGRect nextRect = self.leftViewController.view.frame;
        nextRect.origin.x = 0;
        nextRect.origin.y = 0;
        nextRect.size.height = size.height;
        nextRect.size.width = size.width;
        
        NSLog(@"root rect: %@", NSStringFromCGRect(rect));
        NSLog(@"menu rect: %@", NSStringFromCGRect(nextRect));
        
        [UIView animateWithDuration:.5 animations:^{
//            self.rootViewController.view.frame = rect;
//            self.leftViewController.view.frame = nextRect;
        } completion:^(BOOL finished) {
            
        }];

        
    } else {
        
        NSLog(@"Need to redraw the slide menu and view controller......");
        
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.height = size.height;
        rect.size.width = size.width;
        
        CGRect nextRect = self.leftViewController.view.frame;
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
        
    }
}


#pragma mark - UIGesture Actions

- (void)handleleftSide:(UIPanGestureRecognizer *)leftSide
{
    NSLog(@"handleleftSide");
    
    CGPoint locationPoint = [leftSide locationInView:self.view];
    CGFloat offsetX = - (locationPoint.x - self.startPoint.x);
    if (leftSide.state == UIGestureRecognizerStateChanged) {
        
        if (locationPoint.x - self.startPoint.x <= -6) {
            //CGFloat leftOffsetX = offsetX * self.visibleWidthLeft / (self.view.bounds.size.width - self.visibleWidthLeft);
CGFloat leftOffsetX = offsetX / (self.view.bounds.size.width);
            CGFloat rootZoom = (offsetX / (self.view.bounds.size.width - self.visibleWidthLeft)) * 0.5;
//CGFloat rootZoom = offsetX / (self.view.bounds.size.width) * 0.5;
            CGRect rootRect = self.rootViewController.view.frame;
            rootRect.origin.x = [UIScreen mainScreen].bounds.size.width - self.visibleWidthLeft - offsetX;
//rootRect.origin.x = [UIScreen mainScreen].bounds.size.width - offsetX;
            self.rootViewController.view.frame = rootRect;
            self.rootViewController.view.transform = CGAffineTransformMakeScale(0.5 + rootZoom, 0.5 +rootZoom);
            CGRect leftRect = self.leftViewController.view.frame;
            leftRect.origin.x = -leftOffsetX;
            self.leftViewController.view.frame = leftRect;
            self.leftViewController.view.transform = CGAffineTransformMakeScale(1 - rootZoom, 1 - rootZoom);
            self.leftViewController.view.alpha = 1.0 - offsetX / (self.view.bounds.size.width - self.visibleWidthLeft) * 1.0;
        } else {
            return;
        }
        
        if (offsetX >= (self.view.bounds.size.width - self.visibleWidthLeft)) {
            leftSide.enabled = NO;
        }
        
    } else if (leftSide.state == UIGestureRecognizerStateCancelled || leftSide.state == UIGestureRecognizerStateEnded) {
        if (offsetX >= [UIScreen mainScreen].bounds.size.width / 2) {
            
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = 0;
            rect.origin.y = 0;
            rect.size.height = self.view.bounds.size.height;
            rect.size.width =  self.view.bounds.size.width;
            
            CGRect nextRect = self.leftViewController.view.frame;
            //nextRect.origin.x = -self.visibleWidthLeft;
nextRect.origin.x = 0;
            nextRect.origin.y = self.view.bounds.size.height / 4;
            nextRect.size.height = self.view.bounds.size.height / 2;
            nextRect.size.width = self.view.bounds.size.width / 2;
            
            [UIView animateWithDuration:.5 animations:^{
                self.rootViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                self.rootViewController.view.frame = rect;
                self.leftViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                self.leftViewController.view.frame = nextRect;
                self.leftViewController.view.alpha = 0;
            } completion:^(BOOL finished) {
                self.isAnimated = !self.isAnimated;
                self.rightSide.enabled = YES;
                self.leftSide.enabled = NO;
                self.tap.enabled = NO;
                [self rootIsScrolling:YES];
            }];
            
        } else {
            
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = self.view.bounds.size.width - self.visibleWidthLeft;
            rect.origin.y = self.view.bounds.size.height / 4;
            rect.size.height = self.view.bounds.size.height / 2;
            rect.size.width = self.view.bounds.size.width / 2;
            
            CGRect nextRect = self.leftViewController.view.frame;
            nextRect.origin.x = 0;
            nextRect.origin.y = 0;
            nextRect.size.height = self.view.bounds.size.height;
            nextRect.size.width = self.view.bounds.size.width;
            
            [UIView animateWithDuration:0.5 animations:^{
                self.rootViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                self.rootViewController.view.frame = rect;
                self.leftViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                self.leftViewController.view.frame = nextRect;
                self.leftViewController.view.alpha = 1;
            } completion:^(BOOL finished) {
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
    if (self.isAnimated) {
        [self slideOutAnimate];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)pan
{
    CGPoint locationPoint = [pan locationInView:self.view];
    CGFloat offsetX = locationPoint.x - self.startPoint.x;
    if (pan.state == UIGestureRecognizerStateChanged) {
        
        if (locationPoint.x - self.startPoint.x >= 6) {
            //CGFloat leftOffsetX = offsetX * self.visibleWidthLeft / (self.view.bounds.size.width - self.visibleWidthLeft);
CGFloat leftOffsetX = offsetX / (self.view.bounds.size.width);
            //CGFloat rootZoom = offsetX/(self.view.bounds.size.width - self.visibleWidthLeft) * 0.5;
CGFloat rootZoom = offsetX/(self.view.bounds.size.width) * 0.5;
            CGRect rootRect = self.rootViewController.view.frame;
            rootRect.origin.x = offsetX;
            self.rootViewController.view.frame = rootRect;
            self.rootViewController.view.transform = CGAffineTransformMakeScale(1 - rootZoom, 1 - rootZoom);
            CGRect leftRect = self.leftViewController.view.frame;
            //leftRect.origin.x = leftOffsetX - self.visibleWidthLeft;
leftRect.origin.x = leftOffsetX;
            leftRect.size.width = self.view.bounds.size.width / 2 + leftOffsetX * self.view.bounds.size.width / 2 / self.visibleWidthLeft;
            self.leftViewController.view.frame = leftRect;
            self.leftViewController.view.transform = CGAffineTransformMakeScale(0.5 + rootZoom , 0.5 + rootZoom);
            self.leftViewController.view.alpha = offsetX/(self.view.bounds.size.width - self.visibleWidthLeft) * 1.0;
        } else {
            return;
        }
        
        if (offsetX >= (self.view.bounds.size.width - self.visibleWidthLeft)) {
            pan.enabled = NO;
        }
        
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        
        if (offsetX >= [UIScreen mainScreen].bounds.size.width / 2) {
            
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = self.view.bounds.size.width - self.visibleWidthLeft;
            rect.origin.y = self.view.bounds.size.height / 4;
            rect.size.height = self.view.bounds.size.height / 2;
            rect.size.width = self.view.bounds.size.width / 2;
            
            CGRect nextRect = self.leftViewController.view.frame;
            nextRect.origin.x = 0;
            nextRect.origin.y = 0;
            nextRect.size.height = self.view.bounds.size.height;
            nextRect.size.width = self.view.bounds.size.width;
            
            [UIView animateWithDuration:0.5 animations:^{
                self.rootViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                self.rootViewController.view.frame = rect;
                self.leftViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                self.leftViewController.view.frame = nextRect;
                self.leftViewController.view.alpha = 1;
            } completion:^(BOOL finished) {
                self.isAnimated = YES;
                self.leftSide.enabled = YES;
                self.tap.enabled = YES;
                [self rootIsScrolling:NO];
            }];
            
        } else {
            
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = 0;
            rect.origin.y = 0;
            rect.size.height = self.view.bounds.size.height;
            rect.size.width = self.view.bounds.size.width;
            
            CGRect nextRect = self.leftViewController.view.frame;
            //nextRect.origin.x = -self.visibleWidthLeft;
nextRect.origin.x = 0;
            nextRect.origin.y = self.view.bounds.size.height / 4;
            nextRect.size.height = self.view.bounds.size.height / 2;
            nextRect.size.width = self.view.bounds.size.width / 2;
            
            [UIView animateWithDuration:0.5 animations:^{
                self.rootViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                self.rootViewController.view.frame = rect;
                self.leftViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
                self.leftViewController.view.frame = nextRect;
                self.leftViewController.view.alpha = 0;
            } completion:^(BOOL finished) {
                self.isAnimated = NO;
                self.tap.enabled = NO;
            }];
        }
        
    }
}

- (void)slideOutAnimate
{
    if (!self.isAnimated) {
        
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = [UIScreen mainScreen].bounds.size.width - self.visibleWidthLeft;
        rect.origin.y = self.view.bounds.size.height / 4;
        rect.size.height = self.view.bounds.size.height / 2;
        rect.size.width = self.view.bounds.size.width / 2;
        
        CGRect nextRect = self.leftViewController.view.frame;
        nextRect.origin.x = 0;
        nextRect.origin.y = 0;
        nextRect.size.height = self.view.bounds.size.height;
        nextRect.size.width = self.view.bounds.size.width;
        
        NSLog(@"!self.isAnimated = rect: %@", NSStringFromCGRect(rect));
        NSLog(@"nextRect: %@", NSStringFromCGRect(nextRect));
        
        [UIView animateWithDuration:.5 animations:^{
            self.rootViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
            self.rootViewController.view.frame = rect;
            self.leftViewController.view.transform = CGAffineTransformMakeScale(1, 1);
            self.leftViewController.view.frame = nextRect;
            self.leftViewController.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            self.isAnimated = !self.isAnimated;
            self.leftSide.enabled = YES;
            self.tap.enabled = YES;
            [self rootIsScrolling:NO];
        }];
        
    } else {
        
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.height = self.view.bounds.size.height;
        rect.size.width = self.view.bounds.size.width;
        
        CGRect nextRect = self.leftViewController.view.frame;
        //nextRect.origin.x = -self.visibleWidthLeft;
nextRect.origin.x = 0;
        nextRect.origin.y = self.view.bounds.size.height / 4;
        nextRect.size.height = self.view.bounds.size.height / 2;
        nextRect.size.width = self.view.bounds.size.width / 2;
        
        NSLog(@"self.isAnimated = rect: %@", NSStringFromCGRect(rect));
        NSLog(@"nextRect: %@", NSStringFromCGRect(nextRect));
        
        [UIView animateWithDuration:.5 animations:^{
            self.rootViewController.view.transform = CGAffineTransformMakeScale(1, 1);
            self.rootViewController.view.frame = rect;
            self.leftViewController.view.transform = CGAffineTransformMakeScale(0.5, 0.5);
            self.leftViewController.view.frame = nextRect;
            self.leftViewController.view.alpha = 0;
        } completion:^(BOOL finished) {
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
    return YES;
}



@end
