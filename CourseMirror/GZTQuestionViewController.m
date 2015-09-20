
//
//  GZTQuestionViewController.m
//  CourseMirror
//
//  Created by 童罡正 on 8/3/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTQuestionViewController.h"
#import "LibraryAPI.h"
#import "GZTQuestionVC1.h"
#import "GZTQuestionVC2.h"
#import "Question.h"
#import "QuestionView1Cell.h"
#import "GZTGlobalModule.h"


@interface GZTQuestionViewController (){
    NSMutableArray *contentVCs;
    BOOL completed;
    int currentIndex;
}

@end

@implementation GZTQuestionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    completed = false;

    //set button
    _pre.layer.cornerRadius = 5.0f;
    _next.layer.cornerRadius = 5.0f;
    _submit.layer.cornerRadius = 5.0f;
    _pre.layer.opacity = 0.4f;
    _pre.enabled = NO;
    _submit.hidden = YES;
    
    _answers = [[NSMutableDictionary alloc] init];
    
    
    // get array of Question
    // filter question for the lecture
    
    _questions = [[GZTGlobalModule selectedLecture] questions];
    NSMutableArray *questionsForLec = [[NSMutableArray alloc] init];
    for( NSString *qStr in _questions){
        for(Question *q in [[LibraryAPI sharedInstance] getQuestions]){
            if( [[q Qid] isEqualToString:qStr]){
                [questionsForLec addObject:q];
                break;
            }
        }
    }
    _questions = questionsForLec;
    
    
    contentVCs = [[NSMutableArray alloc] init];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GZTMain"
                                                             bundle: nil];

    //build content controller array based on question type
    for(Question *q in _questions){
        // multiply choice
              if([q.type isEqualToNumber:@2]){
            GZTQuestionVC2 *vc2 = [storyboard instantiateViewControllerWithIdentifier:@"QuestionVC2"];
            
            vc2.titleText =[q desc];
            vc2.options = [q options];
                  [vc2 update];
            
          //  NSLog(@" vc2.label.text = [q desc]; = %@", [q desc]);
            
            //tobedone
            [contentVCs addObject:vc2];
        }else{
        // if( q.type == 1 ){
       
            GZTQuestionVC1 *vc1 = [storyboard instantiateViewControllerWithIdentifier:@"QuestionVC1"];
            vc1.titleText =[q desc];
            [contentVCs addObject:vc1];
        }
    }// end building views array
    
    
    // Create page view controller
    self.pageViewController = [storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    
    UIViewController *startingViewController = [contentVCs objectAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 130);
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:_pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    
    

//    UIAwesomeButton *button4 = [[UIAwesomeButton alloc] initWithFrame:CGRectMake(10, 400, 280, 50) text:@"Test" icon:nil textAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:[UIColor whiteColor],@"IconFont":[UIFont fontWithName:@"fontawesome" size:40]} andIconPosition:IconPositionLeft];
//    [button4 setBackgroundColor:[UIColor colorWithRed:205.0f/255 green:35.0f/255 blue:44.0f/255 alpha:1.0] forUIControlState:UIControlStateNormal];
//    [button4 setBackgroundColor:[UIColor colorWithRed:244.0f/255 green:61.0f/255 blue:91.0f/255 alpha:1.0] forUIControlState:UIControlStateHighlighted];
//    [button4 setRadius:3.0];
//    [button4 setSeparation:10];
//    [button4 setTextAlignment:NSTextAlignmentLeft];
//    [button4 setActionBlock:^{
//        NSLog(@"Working!");
//    }];

   
    
    currentIndex = 0;

}


- (IBAction)goToPre:(id)sender {
    _submit.hidden = YES;
    _next.layer.opacity = 1.0F;
    _next.enabled = YES;
    if(currentIndex == 0){
        NSLog(@"first page");
//        _pre.layer.opacity = 0.4f;
//        _pre.enabled = NO;
    }else{
        currentIndex --;
        if(currentIndex == 0){
        _pre.layer.opacity = 0.4f;
        _pre.enabled = NO;
            //in first page
        }
        [self.pageViewController setViewControllers:@[contentVCs[currentIndex]] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];

    }
}


- (IBAction)goToNext:(id)sender {
    _pre.layer.opacity = 1.0f;
    _pre.enabled = YES;

    if(currentIndex == [contentVCs count]-1){
        NSLog(@"last page");
      //  _submit.hidden = NO;
    }else{
        currentIndex ++;
        if(currentIndex == [contentVCs count]-1){
            //in last page
            _next.layer.opacity = 0.4F;
            _next.enabled = NO;
            _submit.hidden = NO;
        }
        [self.pageViewController setViewControllers:@[contentVCs[currentIndex]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}


- (IBAction)submit:(id)sender {
    NSLog(@"submit pressed");
    
    int index = 0;
    for(Question *q in _questions){
        NSString *ans;
        
        if( [q.type isEqualToNumber:@1] ){
            ans = [[(GZTQuestionVC1*)contentVCs[index] textView] text];
        }else{
            ans = [contentVCs[index] answer];
        }
        
        if(!ans || [ans isEqualToString:@""]){
              [[[UIAlertView alloc] initWithTitle:@"Not Completed." message:@"Please answer all questions." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
            break;
        }
        [_answers setObject:ans forKey: [q Qid]];
        index ++;
    }
    //completed
    if(index ==  [contentVCs count]){
        index = 0;
        NSLog(@"[[GZTGlobalModule selectedLecture] number] %@",  [[GZTGlobalModule selectedLecture] number]);
        
        PFObject *reflection = [PFObject objectWithClassName:@"Reflection"];
        
        reflection[@"lecture_number"] = [[GZTGlobalModule selectedLecture] number];
        
        reflection[@"cid"] = [[GZTGlobalModule selectedLecture] cid];
        reflection[@"user"] =[GZTGlobalModule getActiveToken];
        for(Question *q in _questions){
            reflection[[q Qid]] = [_answers objectForKey:[q Qid]];

            index ++;
            //[NSString stringWithFormat:@"%@||Rating: %d", s0, (int)i0];
        }
    [reflection saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            // The object has been saved.
            [[[UIAlertView alloc] initWithTitle:@"Submitted" message:@"Thank you!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
            [GZTGlobalModule selectedLecture].answered = @"YES";
            [[GZTGlobalModule LectureViewController] refresh];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please check network!" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];            }
    }];
        
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSLog(@"Clicked button index other than 0");
        // Add another action here
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
