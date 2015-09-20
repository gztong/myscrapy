//
//  GZTNotificationController.m
//  CourseMirror
//
//  Created by 童罡正 on 8/5/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTNotificationController.h"
#import "LibraryAPI.h"
#import "GZTGlobalModule.h"


@interface GZTNotificationController (){
    NSString *selectedCid;
    NSArray *addedCourses;
}

@end

@implementation GZTNotificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *tokens = [[ LibraryAPI sharedInstance] tokensforUser:[PFUser currentUser]];
    addedCourses = [[LibraryAPI sharedInstance] addedCoursesForTokens:tokens];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  [addedCourses count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [addedCourses[indexPath.row] cid];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedCid = [[tableView cellForRowAtIndexPath:indexPath].textLabel text];
    
}


- (IBAction)resetMethod:(id)sender {
    
    self.textView.text = @"";
   }

- (IBAction)pushMethod:(id)sender {
    
    NSString *msg = [self.textView text];
    
    if(selectedCid && ([msg isEqualToString: @""])){
        PFPush *push = [[PFPush alloc] init];
        [push setChannel:selectedCid];
        [push setMessage:msg];
        [push sendPushInBackground];
        [[[UIAlertView alloc] initWithTitle:@"Succeeded" message:@"Notification has been pushed!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
        NSLog(@" select channel %@", selectedCid);
        
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please select a course and enter a message" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
        NSLog(@"not select channel %@", selectedCid);
    }
}
@end
