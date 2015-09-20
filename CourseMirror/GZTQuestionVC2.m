//
//  GZTQuestionVC2.m
//  CourseMirror
//
//  Created by 童罡正 on 8/7/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTQuestionVC2.h"

@interface GZTQuestionVC2 ()

@end

@implementation GZTQuestionVC2


- (void)viewDidLoad {
    [super viewDidLoad];
    if(!_options){
      _options = [NSArray new];
    }
  
    //_options= [[NSArray alloc] initWithObjects:@"Slightly",@"Somewhat",@"Moderately",@"Mostly", @"Completely", nil];
    self.label.text = self.titleText;
    [_table setDelegate:self];
    [_table setDataSource:self];
       // Do any additional setup after loading the view.
    
   _table.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"reload table %lu",[_options count] );
    return [_options count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    cell.textLabel.text =  [_options objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _answer = [[tableView cellForRowAtIndexPath:indexPath] textLabel].text;
    
}

-(void)update {
    [_table reloadData];
    
    NSLog(@"~~~~~update called %lu", (unsigned long)[_options count]);
}
@end
