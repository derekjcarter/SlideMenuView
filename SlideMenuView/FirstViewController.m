//
//  FirstViewController.m
//

#import "FirstViewController.h"

@interface FirstViewController ()

@property (readwrite, assign) BOOL isShowingLandscapeView;
@property (readwrite, assign) BOOL previousOrientation;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.title = @"Messages";
    self.navigationController.view.backgroundColor = [UIColor lightGrayColor];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    NSLog(@"FirstViewController | viewWillTransitionToSize");
}

- (void)orientationChanged:(NSNotification *)notification
{
    return;
    
    // Resize navigationBar accordingly
    CGRect newNavBarFrame = self.navigationController.navigationBar.frame;
    newNavBarFrame.origin.y = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.navigationController.navigationBar.frame = newNavBarFrame;
    
    NSLog(@"newNavBarFrame: %@", NSStringFromCGRect(newNavBarFrame));
    
    /*
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation) &&
        !self.isShowingLandscapeView)
    {
        self.isShowingLandscapeView = YES;
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation) &&
             self.isShowingLandscapeView)
    {
        self.isShowingLandscapeView = NO;
    }
    
    if (self.previousOrientation != self.isShowingLandscapeView){
        if (self.isShowingLandscapeView){
            NSLog(@"FirstViewController | Orientation Change Occur: Landscape Mode");
        }
        else {
            NSLog(@"FirstViewController | Orientation Change Occur: Portrait Mode");
        }
    }
    
    self.previousOrientation = self.isShowingLandscapeView;
     */
}


@end
