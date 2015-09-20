//
//  LocalData.h
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Course.h"
#import "Lecture.h"
#import "Summary.h"
#import "ParseClient.h"
#import "Data.h"


@interface LocalData : NSObject
//@property(nonatomic, copy, readonly) NSArray *allcourses;
//@property(nonatomic, copy, readonly) NSArray *addedcourses;
//
//@property(nonatomic, copy, readonly) NSArray *alllectures;
//@property(nonatomic, copy, readonly) NSArray *allquestions;
//
//@property(nonatomic, copy) NSMutableDictionary *user_tokens;
//@property(nonatomic, copy) NSMutableDictionary *lec_summary;
//@property(nonatomic, copy) NSMutableDictionary *course_dicOfsummary;
//@property(nonatomic, copy) NSDictionary *key_image;

@property Data *data;



- (NSArray *) getCourses;
- (NSArray *) getLectures;
-(NSArray *)getLecturesForCid: (NSString *)cid;

-(NSArray *)getQuestions;


//- (NSArray *) getCoursesForToken: (NSString *) token;
//- (NSArray *) getCoursesForcid: (NSString *) cid;

-(void)addToken: (NSString *)token forUser: (PFUser *)user;
-(NSMutableArray *)getTokensforUser:(PFUser *)user;
-(void)setTokens:(NSArray *)tokens forUser:(PFUser *)user;

-(Summary *)getSummaryForLecture:(Lecture*)lec;
-(NSDictionary *)getSummariesForCourse:(Course*)course;
-(NSArray *)addedCoursesForTokens: (NSArray *)tokens;

-(NSDictionary *)downloadImages;
-(void)sync;

-(void)saveData;
@end
