//
//  SlideMenuContainerView.h
//  SlideMenu
//
//  Copyright (c) 2015. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuContainerView : UIViewController

@property(nonatomic, strong) UIViewController *menuViewController;
@property(nonatomic, strong) UIViewController *rootViewController;
@property(nonatomic, strong) UIImageView *backgroundImageView;

- (id)initWithRootController:(UIViewController *)rootViewController;

@end