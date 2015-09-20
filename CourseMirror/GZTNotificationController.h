//
//  GZTNotificationController.h
//  CourseMirror
//
//  Created by 童罡正 on 8/5/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZTNotificationController : UIViewController<UITableViewDataSource, UITableViewDelegate>


@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *pushButton;

- (IBAction)resetMethod:(id)sender;
- (IBAction)pushMethod:(id)sender;



@end
