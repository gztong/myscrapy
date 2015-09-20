//
//  ParseClient.h
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Lecture.h"
#import "Course.h"
#import "Summary.h"

#import <Parse/Parse.h>

@interface ParseClient : NSObject

+(NSArray *) getCouses;
+(NSArray *) getLectures;
+(NSArray *) getQuestions;


+(void)setTokens: (NSArray *)tokens forUser: (PFUser *)user;
+(NSMutableArray *)tokensforUser: (PFUser *)user;
+(NSArray *)allTokens;
+(Summary *)getSummaryForLecture:(Lecture*)lec;
+(NSDictionary *)getSummariesForCourse:(Course*)course;
+(NSDictionary *)downloadImages;
+(NSArray *)checkWritableForCid:(NSString*)cid token: (NSString *)token;
@end
