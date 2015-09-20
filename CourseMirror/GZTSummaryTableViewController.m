//
//  GZTSummaryTableViewController.m
//  F8 Developer Conference
//
//  Created by 童罡正 on 4/3/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//
//{"Sources": [["c0249", "c0260", "c0257", "c0243", "c0244", "c1980", "c0236", "0175c"], ["c0260", "c0267", "c0257", "c0255", "c0244", "0175c"], ["c0257", "t0003", "0175c"], ["c0244"]], "weight": [8, 6, 3, 1], "summaryText": ["the gauss ' law for magnetic fields", "the most interesting point about monday 's lecture the cylindrical symmetry while utilizing ampere 's law and how we were able to derive the magnetic field", "most interesting point", "the most interesting part of today"]}

#import "GZTSummaryTableViewController.h"
#import "GZTGlobalModule.h"
#import "LibraryAPI.h"
#import "Question.h"
#import "Summary.h"
#import <Parse/Parse.h>
#import "GZTUtilities.h"

@interface GZTSummaryTableViewController (){
    Summary *summary;
    
    Lecture *lecture;
    NSMutableArray *allSummaryTexts; //stores summary info dictionaries for all questions
    
    
    NSArray *sectionSummaries;
    NSArray *sectionWeights;
    

    NSMutableArray *summaryTextsArray;
    NSArray *summariesSectionTitles;
    NSMutableArray *questionTitles;
    UIActivityIndicatorView *activityView;
}

@end

@implementation GZTSummaryTableViewController



- (id)initWithStyle:(UITableViewStyle)style Lecture: (Lecture*)lec
{
    self = [super initWithStyle:style];
    if (self) {
        // loading indicator
        activityView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        activityView.center=self.view.center;
        [activityView startAnimating];
        [self.view addSubview:activityView];
        
        lecture = lec;
        allSummaryTexts = [[NSMutableArray alloc] init];
        
        summary = [[LibraryAPI sharedInstance] getSummaryForLecture:lec];
        
        for(NSDictionary *q_summary in [summary infoDictionaryArray]){
            NSArray *arr = [q_summary objectForKey:@"summaryText"];
            [allSummaryTexts addObject:arr];
        }

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"summaryDownloaded" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFailed:) name:@"summaryDownloadedFailed" object:nil];
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView.emptyDataSetDelegate = self;
//    self.tableView.emptyDataSetSource = self;
    
    // Hide extra table cell separators
    self.tableView.tableFooterView = [UIView new];
    
    

    
    
    questionTitles = [[NSMutableArray alloc] init];
    
    for(NSString *qid in [GZTGlobalModule selectedLecture].questions ){
        
        for( Question *q in [[LibraryAPI sharedInstance] getQuestions] ){
            //filter out multiple choice
            if ( [q.type isEqualToNumber:@2] ) continue;
            if( [[q Qid] isEqual:qid]){
                [questionTitles addObject:[q desc]];
                break;
            }
        }
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections, which is number of questions
    return [summary infoDictionaryArray].count;
    
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    NSString *question = [questionTitles objectAtIndex:section];
    
    CGSize size = CGSizeMake(290,9999);
    CGRect textRect = [question
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}
                       context:nil];
    
    UITextView *textV=[[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, textRect.size.height+30)];
    
    textV.font = [UIFont systemFontOfSize:18.0];
    textV.text= question;
    textV.textColor=[UIColor blackColor];
    textV.editable=NO;
    textV.scrollEnabled = NO;
    textV.backgroundColor = [UIColor lightGrayColor];
    return  textV;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[allSummaryTexts objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *summarytext = [allSummaryTexts[indexPath.section]  objectAtIndex:indexPath.row];
    
   // NSString *weight = [ [allSummaries[indexPath.section] objectForKey:@"weight"] objectAtIndex: indexPath.row];
    
    CGSize size = CGSizeMake(290,9999);
    CGRect textRect = [summarytext
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                       context:nil];
    
    UITextView *textV=[[UITextView alloc] initWithFrame:CGRectMake(5, 5, 290, textRect.size.height+30)];
    
    textV.font = [UIFont systemFontOfSize:16.0];
    textV.text= [NSString stringWithFormat:@"%@", summarytext];
    //textV.text= [NSString stringWithFormat:@"%@ (%@)", summarytext, weight];
    textV.textColor=[UIColor blackColor];
    textV.editable=NO;
    textV.scrollEnabled = NO;
    [cell.contentView addSubview:textV];
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *summarytext = [allSummaryTexts[indexPath.section]  objectAtIndex:indexPath.row];
    
    CGSize size = CGSizeMake(290,9999);
    CGRect textRect = [summarytext
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}
                       context:nil];
    
    return textRect.size.height+25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    NSString *question = [questionTitles objectAtIndex:section];
    
    CGSize size = CGSizeMake(290,9999);
    CGRect textRect = [question
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]}
                       context:nil];
    
    
    return textRect.size.height+25;

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSLog(@"Clicked button index 0");
        [self.navigationController popViewControllerAnimated:YES];
        } else {
        NSLog(@"Clicked button index other than 0");
        // Add another action here
    }
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"Summaries are not available now. Please come back later.";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return  [[NSAttributedString alloc] initWithString:text attributes:attributes];

}

- (void)refresh:(NSNotification *)notification {
    NSLog(@"refresh in sum called~~");
    [activityView stopAnimating];
   
    for(NSDictionary *q_summary in [summary infoDictionaryArray]){
        NSArray *arr = [q_summary objectForKey:@"summaryText"];
        [allSummaryTexts addObject:arr];
    }
    
    [self.tableView reloadData];
    
}

- (void)downloadFailed:(NSNotification *)notification {
    NSLog(@"downloadFailed in sum called");
    [activityView removeFromSuperview];
    
    UIImage *emptyImg = [UIImage imageNamed:@"empty"];
    
    UIImageView *emptyView = [[UIImageView alloc] initWithFrame:self.view.frame];
    emptyView.image = emptyImg;
    
    [emptyView setContentMode:UIViewContentModeScaleAspectFit];
    [emptyView setClipsToBounds:YES];
    
    [self.view addSubview:emptyView];
}


-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

@end
