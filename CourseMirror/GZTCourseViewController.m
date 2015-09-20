//
//  GZTCourseViewController.m
//  CourseMirror
//
//  Created by 童罡正 on 7/31/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTCourseViewController.h"
#import "UIColor+PDD.h"
#import "Course.h"
#import "CourseCellTableViewCell.h"
#import "GZTLectureViewController.h"
#import "GZTGlobalModule.h"
#import "GZTUtilities.h"
#import "GZTAddTokenViewController.h"
#import "UIImage+ResizeAdditions.h"

@interface GZTCourseViewController (){
    NSDictionary *cid_token;
    NSArray *addedCourse ;
}

@end

@implementation GZTCourseViewController

-(id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle: style];
    if(self){
       
        
        self.title = @"Courses";
        self.tabBarItem.title = @"Courses";
        self.tabBarItem.image = [UIImage imageNamed:@"course"];
    //    self.tableView.backgroundColor = [UIColor pddContentBackgroundColor];
        self.tableView.separatorColor = [UIColor pddSeparatorColor];
        self.tableView.separatorInset = UIEdgeInsetsZero;
        [self refresh];
    }
//    NSLog(@"ViewdidLoad in C vc %@", addedCourse);
    
    return self;
}


-(void) viewDidLoad{
    [super viewDidLoad];
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    // set refresh control
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor blackColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(refresh)
                  forControlEvents:UIControlEventValueChanged];
    
    // Hide extra table cell separators
    self.tableView.tableFooterView = [UIView new];

    self.tableView.separatorColor = [UIColor clearColor];

   // [self refresh];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [addedCourse count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CourseCellTableViewCell *cell = (CourseCellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.title.text =[(Course*)addedCourse[indexPath.row] Title];
    cell.cid.text =[(Course*)addedCourse[indexPath.row] cid];
    
   // UIImage *img = [[[LibraryAPI sharedInstance] downloadedImages] objectForKey:[(Course*)addedCourse[indexPath.row] cid]];
    UIImage *img = [UIImage imageNamed:@"seal"];
    
   // UIImage *thumbnailImage = [img thumbnailImage:70.0f transparentBorder:0.0f cornerRadius:10.0f interpolationQuality:kCGInterpolationDefault];
    
    [cell.thumbnailImageView clipsToBounds];
    [cell.thumbnailImageView setNeedsDisplay];
    cell.thumbnailImageView.image = img;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CourseCellTableViewCell *cell = (CourseCellTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    NSString *cid = cell.cid.text;
    
    //store selected cid and course
    NSDictionary *d = [GZTUtilities DictionaryFromArray:addedCourse WithKey:@"cid"];
    [GZTGlobalModule setSelectedCid:cid];
    [GZTGlobalModule setSelectedCourse:[d objectForKey:cid]];
    
 //   Course *course = [[LibraryAPI sharedInstance] getCourseForCid:cid];
//    [[LibraryAPI sharedInstance] getSummariesForCourse:course];
    
    // go to lecture view
    GZTLectureViewController *lectureViewController = [[GZTLectureViewController alloc] init];
    lectureViewController.hidesBottomBarWhenPushed = YES;
    
    [GZTGlobalModule setLectureViewController:lectureViewController];
    [self.navigationController pushViewController:(UIViewController *)lectureViewController animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CourseCell" owner:self options:nil];
    
    return   ((CourseCellTableViewCell*)[nib objectAtIndex:0]).frame.size.height
;
}





- (void)refresh{
    if(![PFUser currentUser]){
        [self.refreshControl endRefreshing];
//        NSLog(@"! current user");
        return;
    }
    NSArray *tokens = [[LibraryAPI sharedInstance] tokensforUser:[PFUser currentUser]];
    if(!tokens){
        NSLog(@"token is nil");
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
        addedCourse = @[];
        return;
    }
    
  //  addedCourse = [GZTGlobalModule addedCourses];
    addedCourse = [[LibraryAPI sharedInstance] addedCoursesForTokens:tokens];
    NSLog(@"after refresh, addedcourses  = %@", addedCourse);

    [self.tableView reloadData];
    [self.view setNeedsDisplay];
    
    [self.refreshControl endRefreshing];

}

-(UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView{

    
    return [UIImage imageNamed:@"CourseMirror"];
}

-(NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView{
    NSString *text = @"No courses added.";
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:16.0], NSForegroundColorAttributeName: [UIColor darkGrayColor]};
    
    return  [[NSAttributedString alloc] initWithString:text attributes:attributes];
    
}


//- (UIImage *)buttonImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state{
//    UIImage *img = [UIImage imageNamed:@"addToken"];
//    
//    img = [GZTUtilities imageWithImage:img scaledToSize:CGSizeMake(200.f, 40.f)];
//    return  img;
//}

-(BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView{
    return  YES;
}

//-(void)emptyDataSetDidTapButton:(UIScrollView *)scrollView{
//    // present add token view controller
//    NSLog(@"button tap");
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GZTMain"
//                                                         bundle: nil];
//    GZTAddTokenViewController *addTokenVC = [storyboard instantiateViewControllerWithIdentifier:@"addTokenVC"];
//    
//    [self presentViewController:addTokenVC animated:YES completion:nil];
//    
//}



@end
