//
//  MenuViewController.m
//  SlideMenu
//
//  Copyright (c) 2015. All rights reserved.
//

#import "MenuViewController.h"
#import "AppDelegate.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "FourthViewController.h"
#import "FifthViewController.h"


static NSInteger kTopPadding = 20;
static NSInteger kLogoViewWidth = 60;
static NSInteger kLogoViewHeight = 60;
static NSInteger kFooterHeight = 40;
static NSInteger kBottomPadding = 20;


@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property(strong,nonatomic) UITableView *tableview;
@property(strong,nonatomic) UIView *footerView;
@property(strong,nonatomic) UIButton *logoutButton;
@property(strong,nonatomic) UIButton *settingButton;
@property(nonatomic, strong) NSArray *titles;
@property(strong,nonatomic) FirstViewController *mainSide;

@end


@implementation MenuViewController

- (void)viewDidLoad_WITH_AUTO_LAYOUT
{
    [super viewDidLoad];
    self.titles = @[@"Messages", @"Channels", @"Teams", @"Users", @"Announcements", @"Settings", @"Logout", @"Privacy", @"etc..."];
    
    // Setup view details
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;
    
    // Setup top logo
    self.logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    self.logoImage.translatesAutoresizingMaskIntoConstraints = NO;
    self.logoImage.backgroundColor = [UIColor clearColor];
    self.logoImage.contentMode = UIViewContentModeScaleAspectFit;
    self.logoImage.layer.masksToBounds = YES;
    [self.view addSubview:self.logoImage];
    
    // Setup tableview
    self.tableview = [[UITableView alloc] initWithFrame:CGRectNull style:UITableViewStylePlain];
    self.tableview.translatesAutoresizingMaskIntoConstraints = NO;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.backgroundColor = [UIColor clearColor];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    //[self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:self.tableview];
    
    /*
    // Setup footer
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kFooterHeight-kBottomPadding, tableViewWidth, kFooterHeight)];
    footerView.translatesAutoresizingMaskIntoConstraints = NO;
    footerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:footerView];
    
    // Setup logout button in footer
    self.logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, kFooterHeight)];
    self.logoutButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.logoutButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.logoutButton setAlpha: .6];
    self.logoutButton.backgroundColor = [UIColor clearColor];
    [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    //[footerView addSubview: self.logoutButton];
    
    // Setup settings button in footer
    // ... Not yet added...
    */
    
    // Constraint views
    NSDictionary* views = NSDictionaryOfVariableBindings(_logoImage, _tableview);
    NSDictionary* metrics = @{
                              @"topPadding" : @(kTopPadding),
                              @"logoImageWidth" : @(kLogoViewWidth),
                              @"logoImageHeight" : @(kLogoViewHeight),
                              @"tableViewWidth" : @(self.view.bounds.size.width - (self.view.bounds.size.width / 6)),
                              @"footerViewWidth" : @(80),
                              @"footerViewHeight" : @(kFooterHeight),
                              @"bottomPadding" : @(kBottomPadding),
                              };
    
    // Horizontal constraints
    //[footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_logoutButton(==footerViewWidth)]" options:0 metrics:metrics views:views]];
    //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[footerView(==tableViewWidth)]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_logoImage(==logoImageWidth)]" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableview(==tableViewWidth)]" options:0 metrics:metrics views:views]];
    
    // Vertical constraints
    //[footerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_logoutButton]|" options:0 metrics:metrics views:views]];
    //[self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-topPadding-[_logoImage(==logoImageHeight)][_tableview]-[footerView(==footerViewHeight)]|" options:0 metrics:metrics views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_logoImage(==logoImageHeight)][_tableview]|" options:0 metrics:metrics views:views]];
    
}

- (void)viewDidLoad //_WITHOUT_AUTO_LAYOUT
{
    [super viewDidLoad];
    self.titles = @[@"Messages", @"Channels", @"Teams", @"Users", @"Announcements", @"Settings", @"Logout", @"Privacy", @"etc..."];
    
    // Setup view details
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBarHidden = YES;
    
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
    //[self.tableview selectRowAtIndexPath:[NSIndexPath indexPathForItem:self.selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    [self.view addSubview:self.tableview];
    
    /*
    // Setup footer
    self.footerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-kFooterHeight-kBottomPadding, self.view.frame.size.width, kFooterHeight)];
    self.footerView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.footerView];
    
    // Setup logout button in footer
    self.logoutButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 80, kFooterHeight)];
    [self.logoutButton setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    [self.logoutButton setAlpha: .6];
    self.logoutButton.backgroundColor = [UIColor redColor];
    [self.logoutButton setTitle:@"Logout" forState:UIControlStateNormal];
    [self.footerView addSubview: self.logoutButton];
    
    // Setup settings button in footer
    // ... Not yet added...
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}


#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [self.tableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = [NSString stringWithFormat: @"%@", self.titles[indexPath.row]];
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.2];
        
        //cell.imageView.image = [UIImage imageNamed:@"logo"]; // Use this for the icon.. resize it though
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
    // Do not highlight row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
        case 3:
            [self launchFourthView];
            break;
        case 4:
            [self launchFifthView];
            break;
        default:
            break;
    }
}


#pragma mark - Menu View Methods

- (void)launchFirstView
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.mainSide = [[FirstViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: self.mainSide];
    app.slideMenuContainerView.rootViewController = nav;
}

- (void)launchSecondView
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    SecondViewController *mainSide = [[SecondViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mainSide];
    app.slideMenuContainerView.rootViewController = nav;
}

- (void)launchThirdView
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    ThirdViewController *mainSide = [[ThirdViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mainSide];
    app.slideMenuContainerView.rootViewController = nav;
}

- (void)launchFourthView
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    FourthViewController *mainSide = [[FourthViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mainSide];
    app.slideMenuContainerView.rootViewController = nav;
}

- (void)launchFifthView
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    FifthViewController *mainSide = [[FifthViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mainSide];
    app.slideMenuContainerView.rootViewController = nav;
}


@end