//
//  GZTQuestionViewController.h
//  CourseMirror
//
//  Created by 童罡正 on 8/3/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GZTQuestionViewController : UIViewController<UIPageViewControllerDataSource>

- (IBAction)goToPre:(id)sender;
- (IBAction)submit:(id)sender;
- (IBAction)goToNext:(id)sender;


@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) NSArray *questions;
@property (strong, nonatomic) NSMutableDictionary *answers;


@property (weak, nonatomic) IBOutlet UIButton *pre;
@property (weak, nonatomic) IBOutlet UIButton *submit;
@property (weak, nonatomic) IBOutlet UIButton *next;

@end
