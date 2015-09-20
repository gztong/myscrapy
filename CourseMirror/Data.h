//
//  Data.h
//  CourseMirror
//
//  Created by 童罡正 on 8/10/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Data : NSObject<NSCoding>

@property NSArray *allcourses;
@property NSArray *addedcourses;

@property NSArray *alllectures;
@property NSArray *allquestions;

@property NSMutableDictionary *user_tokens;
@property NSMutableDictionary *lec_summary;
@property NSMutableDictionary *course_dicOfsummary;
@property NSDictionary *key_image;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;


@end
