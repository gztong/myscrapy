//
//  GZTQuestionVC1.m
//  CourseMirror
//
//  Created by 童罡正 on 8/7/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTQuestionVC1.h"

@interface GZTQuestionVC1 ()

@end

@implementation GZTQuestionVC1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.label.text = self.titleText;
    self.answer = [self.textView text];
    
    //set layout
    self.textView.layer.cornerRadius = 5.0f;
   
   // self.textView.layer.border
    self.textView.layer.borderWidth = 0.5f;

 
    // HIDE keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}
-(void)dismissKeyboard {
    [self.textView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
