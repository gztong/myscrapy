//
//  GZTSettingViewController.m
//  CourseMirror
//
//  Created by 童罡正 on 7/31/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTSettingViewController.h"
#import <Parse/Parse.h>
#import "PDDAboutViewController.h"
#import "GZTNotificationController.h"
#import "PDDWebViewController.h"
#import "GZTAddTokenViewController.h"
#import "AppDelegate.h"

@implementation GZTSettingViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Settings";
        self.tabBarItem.title = @"Settings";
        self.tabBarItem.image = [UIImage imageNamed:@"gear"];
      //  self.tableView.backgroundColor = [UIColor pddContentBackgroundColor];
       // self.tableView.separatorColor = [UIColor pddSeparatorColor];
        self.tableView.separatorInset = UIEdgeInsetsZero;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Hide extra table cell separators
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UITableViewDataSource and UITableViewDelegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView

{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
       // cell.textLabel.textColor = [UIColor pddTextColor];
    }
    switch (indexPath.row) {
        case 0:
        {
            //if user tokens contain "t2015"
            if(true){
                cell.textLabel.text = @"About";
            }else{
                cell.textLabel.text = @"Push Notification";
            }
            break;
        }
        case 1:
        {
            cell.textLabel.text = @"CourseMirror Website";
            break;
        }
        case 2:
        {
            cell.textLabel.text = @"Add New Token";
            break;
        }
        case 3:
        {
            PFUser *currentUser = [PFUser currentUser];
            
            cell.textLabel.text =[NSString stringWithFormat:@"%@%@", @"Log Out ", currentUser.username];
            break;
        }
        default:
            break;
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
        {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if([cell.textLabel.text isEqualToString:@"About"]){
                PDDAboutViewController *aboutViewController = [[PDDAboutViewController alloc] init];
                [self.navigationController pushViewController:aboutViewController animated:YES];
                
                aboutViewController.hidesBottomBarWhenPushed = YES;
            }else{
             
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GZTMain"
                                                                     bundle: nil];
                GZTNotificationController *notificationVC =  [storyboard instantiateViewControllerWithIdentifier:@"NotificationVC"];
                
                
                [self.navigationController pushViewController:notificationVC animated:YES];
                break;

            }
            
            
            break;
        }
        case 1:
        {
            
            PDDWebViewController  *webView = [[PDDWebViewController alloc] initWithURL:@"http://www.coursemirror.com" title:@"CourseMIRROR"];
            webView.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController: webView animated:YES];
            
            break;
        }
        case 2:
        {
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"GZTMain"
                                                                 bundle: nil];
           GZTAddTokenViewController *addTokenVC = [storyboard instantiateViewControllerWithIdentifier:@"addTokenVC"];
            [self presentViewController:addTokenVC animated:YES completion:nil];
            
//            [self.navigationController pushViewController:addTokenVC animated:YES];
            break;
        }
        case 3:
        {
            AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate logout];
            [self.tableView reloadData];
            break;
        }
            
        default:
            break;
    }
}




@end
