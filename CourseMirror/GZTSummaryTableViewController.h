//
//  GZTSummaryTableViewController.h
//
//  Created by 童罡正 on 4/3/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Lecture.h"
#import "DZNEmptyDataSet/Source/UIScrollView+EmptyDataSet.h"


@interface GZTSummaryTableViewController : UITableViewController<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

- (id)initWithStyle:(UITableViewStyle)style Lecture: (Lecture*)lec;



@end
