//
//  GZTUser.m
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTUser.h"


@implementation GZTUser

-(id)init{
    self = [super init];
    
    if(self){
        self.myUser = [PFUser currentUser];
    }
    
    //parse user tokens
    NSError *jsonError;
    NSData* jsonData = [self.myUser[@"token"] dataUsingEncoding:NSUTF8StringEncoding];
    if(jsonData){
        self.tokens = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&jsonError];
    }
    
    return self;
}
@end
