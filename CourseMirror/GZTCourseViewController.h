//
//  GZTCourseViewController.h
//  CourseMirror
//
//  Created by 童罡正 on 7/31/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LibraryAPI.h"
#import <SlackTextViewController/SLKTextView.h>
#import "DZNEmptyDataSet/Source/UIScrollView+EmptyDataSet.h"

@interface GZTCourseViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate, DZNEmptyDataSetDelegate, DZNEmptyDataSetSource>
@property NSInteger numberOfLecture;
@property (strong, nonatomic) NSArray *lectures;
@property (weak, nonatomic)  UITableView *courseTableView;
- (void)refresh;
//@property (strong, nonatomic) NSString *selectedCourse;


@end
