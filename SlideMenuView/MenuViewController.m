//
//  MenuViewController.m
//  SlideMenuView
//
//  Created by xdf on 4/20/15.
//  Copyright (c) 2015 xdf. All rights reserved.
//

#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "MenuViewController.h"

static NSInteger kTopPadding = 20;
static NSInteger kLogoViewWidth = 60;
static NSInteger kLogoViewHeight = 60;
static NSInteger kFooterHeight = 40;
static NSInteger kBottomPadding = 20;


@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) UITableView *tableview;
@property(strong,nonatomic) UIButton *logoutButton;
@property(strong,nonatomic) UIButton *settingButton;
@property(nonatomic, strong) NSArray *titles;
@property(strong,nonatomic) FirstViewController *mainSide;

@end


@implementation MenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.titles = @[@"Messages", @"Channels", @"Users"];
    
    // Setup view details
    self.view.backgroundColor = [UIColor redColor];
    
    // Setup top logo
    self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.logoImage.backgroundColor = [UIColor clearColor];
    self.logoImage.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImage.layer.masksToBounds = YES;
    self.logoImage.frame = CGRectMake(kTopPadding, kTopPadding, kLogoViewWidth, kLogoViewHeight);
    [self.view addSubview:self.logoImage];
    
    // Setup tableview
    CGFloat tableViewWidth = self.view.bounds.size.width - (self.view.bounds.size.width / 6);
    
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,
                                                                  kTopPadding + self.logoImage.frame.size.height,
                                                                  tableViewWidth,
                                                                  self.view.bounds.size.height-kLogoViewHeight-kFooterHeight-kTopPadding-kBottomPadding)
                                                 style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    [self.view addSubview:self.tableview];
    
    // Setup footer
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kFooterHeight-kBottomPadding, tableViewWidth, kFooterHeight)];
//    footerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:footerView];
    
    // Setup logout button in footer
    self.logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, kFooterHeight)];
    [self.logoutButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.logoutButton setAlpha: .6];
//    self.logoutButton.backgroundColor = [UIColor redColor];
    [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [footerView addSubview: self.logoutButton];
    
    // Setup settings button in footer
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor blackColor];
        //cell.backgroundColor = [UIColor colorWithRed: 240.0 / 255.0 green:240.0 / 255.0 blue: 240.0 / 255.0 alpha: 0.08 * (indexPath.row + 1)];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed: 240.0 / 255.0 green:240.0 / 255.0 blue: 240.0 / 255.0 alpha: 0.1 * (indexPath.row + 1)];
        cell.textLabel.text = [NSString stringWithFormat: @"%@", self.titles[indexPath.row]];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self launchFirstView];
            break;
        case 1:
            [self launchSecondView];
            break;
        case 2:
            [self launchThirdView];
            break;
        default:
            break;
    }
}


#pragma mark - Menu View Methods

- (void)launchFirstView
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (!self.mainSide) {
        FirstViewController *mainSide = [[FirstViewController alloc] init];
        self.mainSide = mainSide;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: _mainSide];
    app.slideMenu.rootViewController = nav;
}

- (void)launchSecondView
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    SecondViewController *mainSide = [[SecondViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mainSide];
    app.slideMenu.rootViewController = nav;
}

- (void)launchThirdView
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    ThirdViewController *mainSide = [[ThirdViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mainSide];
    app.slideMenu.rootViewController = nav;
}


@end