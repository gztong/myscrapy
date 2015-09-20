//
//  GZTLectureViewController.h
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZTLectureViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, copy, readonly) NSString* cid;


-(void)refresh;

@end
