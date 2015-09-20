//
//  GZTQuestionVC2.h
//  CourseMirror
//
//  Created by 童罡正 on 8/7/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZTQuestionVC2 : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property NSArray *options;
@property NSString *answer;

@property NSUInteger pageIndex;
@property NSString *titleText;

-(void)update ;
@end
