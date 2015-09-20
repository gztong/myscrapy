//
//  LibraryAPI.h
//  CourseMirror
//
//  Created by 童罡正 on 7/31/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "Lecture.h"
#import "Summary.h"
#import <Parse/Parse.h>

@interface LibraryAPI : NSObject
+(LibraryAPI *)sharedInstance;
-(NSArray *)getCourses;
-(Course *)getCourseForCid: (NSString *)cid;

-(NSArray *)getLectures;
-(NSArray *)getLecturesForCid: (NSString *)cid;


-(NSArray *)getQuestions;
-(void)addToken: (NSString *)token forUser: (PFUser *)user;
-(NSArray *)tokensforUser: (PFUser *)user;
-(NSArray *)allTokens;
-(void)setTokens:(NSArray *)tokens forUser:(PFUser *)user;

-(Summary *)getSummaryForLecture:(Lecture*)lec;
-(NSDictionary *)getSummariesForCourse:(Course*)course;
-(NSArray *)addedCoursesForTokens: (NSArray *)tokens;

-(NSDictionary *)downloadedImages;

-(void)sync;
-(void)saveData;

-(NSArray *)checkWritableForCid:(NSString*)cid token: (NSString *)token;
@end
