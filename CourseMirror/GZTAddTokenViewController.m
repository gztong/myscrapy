//
//  GZTAddTokenViewController.m
//  CourseMirror
//
//  Created by 童罡正 on 8/5/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTAddTokenViewController.h"
#import "AddToken.h"
#import "ParseClient.h"
#import "GZTUtilities.h"
#import "LibraryAPI.h"
#import "GZTGlobalModule.h"
#import "NSString+FontAwesome.h"
#import "UIFont+FontAwesome.h"
#import "UIButton+PPiAwesome.h"
#import "UIAwesomeButton.h"

@interface GZTAddTokenViewController (){
    UIViewController *addTokenVC;
    NSArray *addedTokens;
    NSArray *specialTokens;
}

@end

@implementation GZTAddTokenViewController


- (void)viewDidLoad {
    specialTokens = [[NSArray alloc] initWithObjects:@"t2015", @"t2014", nil];
    [super viewDidLoad];
    
    //set button


    _addButton.layer.cornerRadius = 5.0f;
    _cancel.layer.cornerRadius = 5.0f;
    
    [self.tokenTable setDataSource:self];
    
    // HIDE keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    addedTokens = [[LibraryAPI sharedInstance] tokensforUser:[PFUser currentUser]];
    
    self.tokenTable.tableFooterView = [UIView new];

}
-(void)dismissKeyboard {
    [self.textField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addMethod:(id)sender {
    PFUser *currentUser = [PFUser currentUser];
    
    NSString *myToken = _textField.text;
    myToken = [myToken lowercaseString];

    
    BOOL valid = [GZTUtilities isString:myToken ofRegexPattern:@"[a-z][0-9][0-9][0-9][0-9]"];
    BOOL existing = [[[LibraryAPI sharedInstance] allTokens] containsObject:myToken];
    BOOL added =  [addedTokens containsObject:myToken];
    
    if(added){
        [[[UIAlertView alloc] initWithTitle:@"Token has been added" message:@"Do not add the same token again." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
    }else if(valid && existing){
        [[LibraryAPI sharedInstance] addToken:myToken forUser:currentUser];
        _textField.text = @"";
        
        [[GZTGlobalModule courseViewController] refresh];
        [self.tokenTable reloadData];

        [[[UIAlertView alloc] initWithTitle:@"Token Added" message:@"Check out your new Course!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
        
    }else{
        [[[UIAlertView alloc] initWithTitle:@"Invalid or non-existing" message:@"Please input a valid token." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Done", nil] show];
    }
    
    //notification enabled
    if([specialTokens containsObject:myToken]){
        [[GZTGlobalModule settingViewController].tableView reloadData];
    }
    [self.tokenTable reloadData];
    
}
- (IBAction)cancelMethod:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
- (IBAction)sync:(id)sender {
    [[LibraryAPI sharedInstance] sync];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return addedTokens.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    NSString *cid = [[[[LibraryAPI sharedInstance] addedCoursesForTokens:addedTokens] objectAtIndex:indexPath.row] cid];
    NSString *token = [addedTokens objectAtIndex:indexPath.row];
    
    NSString *text = [NSString stringWithFormat:@"%@   ( %@ )", token, cid] ;
    cell.textLabel.text = text;
    return cell;
}


//lift view when keyboard shows

#define kOFFSET_FOR_KEYBOARD 80.0
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
// end move up view method


@end
