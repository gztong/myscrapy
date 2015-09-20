//
//  AppDelegate.h
//  CourseMirror
//
//  Created by 童罡正 on 7/30/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/PFLogInViewController.h>
#import <ParseUI/PFSignUpViewController.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

-(void)logout;

@end

