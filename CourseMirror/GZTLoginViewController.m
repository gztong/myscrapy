//
//  GZTLoginViewController.m
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTLoginViewController.h"
#import "GZTGlobalModule.h"
#import "AppDelegate.h"

@implementation GZTLoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CourseMirror.png"]]];
     [self.signUpController.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CourseMirror.png"]]];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
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
     NSLog(@"++++++++++++++++");
//    [[GZTGlobalModule settingViewController] viewDidLoad];
//    [[GZTGlobalModule courseViewController] viewDidLoad];
    
//    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    [[delegate tabBarController] viewDidLoad];
    
    
    
    //download addedtokens and addedcourses for this user
    NSArray *tokens =  [[LibraryAPI sharedInstance] tokensforUser: user];
    NSArray *addedCourses = [[LibraryAPI sharedInstance] addedCoursesForTokens:tokens];
    
    [GZTGlobalModule setAddedCourses:addedCourses];
    
    [[LibraryAPI sharedInstance] setTokens:tokens forUser:user];
    NSLog(@"++++++++++++++++");
    [[GZTGlobalModule courseViewController] refresh];

    [logInController dismissViewControllerAnimated:NO completion:NULL];
    [self dismissViewControllerAnimated:NO completion:NULL];

    

    
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to log in", nil) message:NSLocalizedString(@"Make sure your username and password are correct.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
    NSLog(@"Failed to log in...");
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
    
    NSArray *tokens =  [[LibraryAPI sharedInstance] tokensforUser: user];
    [[LibraryAPI sharedInstance] addedCoursesForTokens:tokens];
    
    // go to add token view  tobedone
    
    [signUpController dismissViewControllerAnimated:YES completion:NULL];
    [self dismissViewControllerAnimated:YES completion:NULL];

}
//
//// Sent to the delegate when the sign up attempt fails.
//- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
//    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to sign in", nil) message:NSLocalizedString(@"The username has been existing.", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil] show];
//
//    NSLog(@"Failed to sign up...");
//}
//
//// Sent to the delegate when the sign up screen is dismissed.
//- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
//    NSLog(@"User dismissed the signUpViewController");
//}
//




@end
