//
//  GZTLectureViewController.m
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTLectureViewController.h"
#import "UIColor+PDD.h"
#import "LibraryAPI.h"
#import "GZTGlobalModule.h"
#import "GZTLectureCell.h"
#import "GZTUtilities.h"
#import "GZTQuestionViewController.h"
#import "GZTSummaryTableViewController.h"
#import "NSString+FontAwesome.h"

@interface GZTLectureViewController (){
    UITableView *lecTable;
    UIView *banner;
    NSArray *lectures;
    
}

@end

@implementation GZTLectureViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //add observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh:) name:@"answeredChecked" object:nil];

    
    //get lectures for cid
    NSString *cid = [GZTGlobalModule selectedCid];
    NSString *title = [[GZTGlobalModule selectedCourse] Title];
    
    
    lectures = [[LibraryAPI sharedInstance] getLecturesForCid:cid];
    
    //create banner image view
    banner = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 120)];
    UIImage *img = [[[LibraryAPI sharedInstance] downloadedImages] objectForKey:cid];
    UIImageView *bannerImgview = [[UIImageView alloc] initWithImage: img];
    bannerImgview.alpha = 0.2;
    UILabel *lable  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-10, 120)];
    lable.text = title;
    lable.font = [UIFont systemFontOfSize:20.f];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.numberOfLines = 0;
    
    [banner addSubview:bannerImgview];
    [self.view addSubview:banner];
    [self.view addSubview:lable];

   
    //create lecture table
    lecTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 120, self.view.frame.size.width, self.view.frame.size.height-180) style:UITableViewStylePlain];
    lecTable.delegate = self;
    lecTable.dataSource = self;
    lecTable.backgroundView = nil;
    
    [self.view addSubview:lecTable];
    
    
    
    [[LibraryAPI sharedInstance] checkWritableForCid:cid token:[GZTGlobalModule getActiveToken]];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:cid];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [lectures count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"cell";
    GZTLectureCell *cell = (GZTLectureCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GZTLectureCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    // Configure the cell to show lectures
    NSDate *lectureDate = [lectures[indexPath.row] date];
    NSDate *now = [NSDate date];
    NSDate *twoDayAgo = [now dateByAddingTimeInterval:-60*60*24*2];

    NSString *statusIcon;
    cell.status1.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20.f];
    cell.status1.textColor = [UIColor grayColor];
    
    if([lectureDate compare:twoDayAgo] == NSOrderedAscending || [[(Lecture*)lectures[indexPath.row] answered] isEqualToString:@"YES"]){
        // lectureDate is earlier than twoDayAgo
        statusIcon = [NSString fontAwesomeIconStringForEnum:FAIconOk];
        cell.statusStr = @"closed";
    }else if([lectureDate compare:now] == NSOrderedDescending){
        // lectureDate is later than twoDayAgo
        statusIcon = [NSString fontAwesomeIconStringForEnum:FAIconLock];
        cell.statusStr = @"upcoming";
    }else{
        statusIcon = [NSString fontAwesomeIconStringForEnum:FAIconPencil];
        cell.statusStr = @"open";
    }
    
    cell.status1.text = statusIcon;
    cell.title.text = [lectures[indexPath.row] Title];

    cell.number.text = [NSString stringWithFormat:@"%@",[lectures[indexPath.row] number]];

    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy"];
    NSString *dateStr = [format stringFromDate:[lectures[indexPath.row] date]];
    cell.date.text =  dateStr;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GZTLectureCell *cell = (GZTLectureCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    //store selected lecture
    NSString *number = [lectures[indexPath.row] number];
    
    NSDictionary *d = [GZTUtilities DictionaryFromArray:lectures WithKey:@"number"];
    [GZTGlobalModule setSelectedLecture: [d objectForKey:number]];

    if( [cell.statusStr isEqualToString:@"closed"]){
        
       // GZTSummaryTableViewController   *SController = [[GZTSummaryTableViewController alloc] init];
        
        GZTSummaryTableViewController   *SController = [[GZTSummaryTableViewController alloc] initWithStyle:UITableViewStylePlain Lecture:[d objectForKey:number]];
        SController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:SController animated:YES];
        
        [GZTGlobalModule setSummaryTableViewController:SController];

    }else if([cell.statusStr isEqualToString:@"open"]){ 
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GZTMain"
                                                             bundle: nil];
        
       GZTQuestionViewController *QController = [storyboard instantiateViewControllerWithIdentifier:@"QuestionViewController"];


        QController.hidesBottomBarWhenPushed = YES;
        
        [self.navigationController pushViewController:QController animated:YES];

    }else{
        [[[UIAlertView alloc] initWithTitle:@"Not Open!" message:@"You can't write reflection for upcoming lectures." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GZTLectureCell" owner:self options:nil];
    
    return   ((GZTLectureCell*)[nib objectAtIndex:0]).frame.size.height
    ;
}

-(void)refresh{

    [lecTable reloadData];
}

- (void)refresh:(NSNotification *)notification {
    NSLog(@"refresh in lec called");
    [lecTable reloadData];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
}

@end
