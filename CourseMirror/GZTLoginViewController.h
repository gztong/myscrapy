//
//  GZTLoginViewController.h
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import <ParseUI/PFLogInViewController.h>
#import <ParseUI/PFSignUpViewController.h>


@interface GZTLoginViewController : PFLogInViewController<PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>


@end
