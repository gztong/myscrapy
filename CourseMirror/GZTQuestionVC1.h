//
//  GZTQuestionVC1.h
//  CourseMirror
//
//  Created by 童罡正 on 8/7/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GZTQuestionVC1 : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *answer;

@end
