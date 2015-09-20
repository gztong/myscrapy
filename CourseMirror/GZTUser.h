//
//  GZTUser.h
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface GZTUser : NSObject
@property (nonatomic, copy, readonly) NSString *userName;
@property (nonatomic, copy) NSMutableArray *tokens;
@property (nonatomic, copy) PFUser *myUser;


@end
