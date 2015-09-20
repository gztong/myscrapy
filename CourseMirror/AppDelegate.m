//
//  AppDelegate.m
//  CourseMirror
//
//  Created by 童罡正 on 7/30/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "AppDelegate.h"
#import "UIColor+PDD.h"
#import "GZTLoginViewController.h"
#import "GZTCourseViewController.h"
#import "GZTSettingViewController.h"
#import <Parse/Parse.h>
#import "LibraryAPI.h"
#import "GZTGlobalModule.h"
#import "GZTUtilities.h"

@interface AppDelegate ()<UITabBarControllerDelegate>

@property (strong, nonatomic) GZTLoginViewController *loginViewController;
@property (strong, nonatomic) GZTSettingViewController *settingViewController;
@property (strong, nonatomic) GZTCourseViewController *courseViewController;

@property (strong, nonatomic) UIViewController *savedViewController;
@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    

    
    // [Optional] Power your app with Local Datastore. For more info, go to
    // https://parse.com/docs/ios_guide#localdatastore/iOS
    [Parse enableLocalDatastore];
    
    // Initialize Parse.
    [Parse setApplicationId:@"YMGbDwY7f98JJQax7ErPyQHrjdGHXLKjzGcPCpUC"
                  clientKey:@"5kwK971smxQ1FqDZy5djicIpZBTDimDET4DIwEt2"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // configure notification
//    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
//                                                    UIUserNotificationTypeBadge |
//                                                    UIUserNotificationTypeSound);
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
//                                                                             categories:nil];
//    [application registerUserNotificationSettings:settings];
//    [application registerForRemoteNotifications];

    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    
    //init root controller
    GZTCourseViewController *courseViewController = [[GZTCourseViewController alloc] init];
    UINavigationController *courseNavViewController = [[UINavigationController alloc] initWithRootViewController:courseViewController];
    [courseNavViewController.navigationBar setTranslucent:NO];
    
    GZTSettingViewController *settingViewController = [[GZTSettingViewController alloc] init];
    self.settingViewController = settingViewController;
    UINavigationController *settingsNavViewController = [[UINavigationController alloc] initWithRootViewController:settingViewController];
    [settingsNavViewController.navigationBar setTranslucent:NO];
    
    [GZTGlobalModule setCourseViewController:courseViewController];
    [GZTGlobalModule setSettingViewController:settingViewController];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[courseNavViewController,
                                              settingsNavViewController
                                              ];
    self.tabBarController.delegate = self;
    [self.tabBarController.tabBar setTranslucent:YES];
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    
    self.window.rootViewController = self.tabBarController;

    [self.window makeKeyAndVisible];

    // download data in advance

    

    if( ![PFUser currentUser] ){
        [self showLogin];
    }
    
    [GZTUtilities uploadImageWithName:@"phys_banner.png" key:@"PHYS0175"];
    return YES;
}


// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length && password.length) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {


    
    //download addedtokens and addedcourses for this user
    NSArray *tokens =  [[LibraryAPI sharedInstance] tokensforUser: user];
    NSArray *addedCourses = [[LibraryAPI sharedInstance] addedCoursesForTokens:tokens];
    
    [GZTGlobalModule setAddedCourses:addedCourses];
    
    [[LibraryAPI sharedInstance] setTokens:tokens forUser:user];
    
    
    [[GZTGlobalModule settingViewController].tableView reloadData];
    [[GZTGlobalModule courseViewController] refresh];
    
    [self.tabBarController dismissViewControllerAnimated:YES completion:NULL];
    
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to log in", nil) message:NSLocalizedString(@"Please check username and password.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}


#pragma mark - PFSignUpViewControllerDelegate

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || !field.length) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Missing Information", nil) message:NSLocalizedString(@"Make sure you fill out all of the information!", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
 //   [signUpController dismissViewControllerAnimated:YES completion:NULL];
    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    [[GZTGlobalModule settingViewController].tableView reloadData];
    [[GZTGlobalModule courseViewController] refresh];
    [self.tabBarController dismissViewControllerAnimated:YES completion:NULL];
    
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
  //  [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to sign in", nil) message:NSLocalizedString(@"The username has been existing.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"enter background");
     [[LibraryAPI sharedInstance] saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"app terminating");
    [[LibraryAPI sharedInstance] saveData];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    UINavigationController *navController = (UINavigationController *)viewController;
    UIViewController *visibleViewController = [navController visibleViewController];
    
    
    // Save currently visible view controller for follow-on checks
    self.savedViewController = visibleViewController;
}

- (void)_customizeAppearance {
    [[UIPageControl appearance] setPageIndicatorTintColor:[UIColor lightGrayColor]];
    [[UIPageControl appearance] setCurrentPageIndicatorTintColor:[UIColor pddTextColor]];
    [[UIPageControl appearance] setBackgroundColor:[UIColor clearColor]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor pddTextColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
                                      forBarPosition:UIBarPositionAny
                                          barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    [[UITabBar appearance] setTintColor:[UIColor blackColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
}


-(void)showLogin{
    [[LibraryAPI sharedInstance] sync];

    
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
    
    // Create the log in view controller
    _loginViewController = [[GZTLoginViewController alloc] init];
    [_loginViewController setDelegate:self]; // Set ourselves as the delegate
  
    
    _loginViewController.fields = PFLogInFieldsUsernameAndPassword
    | PFLogInFieldsLogInButton
    | PFLogInFieldsSignUpButton
    | PFLogInFieldsPasswordForgotten;
    
    // Create the sign up view controller
    PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [_loginViewController setSignUpController:signUpViewController];
    
    // Present the log in view controller
    [self.tabBarController presentViewController:_loginViewController animated:YES completion:NULL];
}

-(void)logout{
    [PFUser logOut];
    self.loginViewController = nil;
    [self showLogin];
}

-(void)saveCurrentState{
    [[LibraryAPI sharedInstance] saveData];
    
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

@end
