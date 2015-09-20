//
//  Question.h
//  CourseMirror
//
//  Created by 童罡正 on 7/31/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Question : NSObject<NSCoding>
@property (nonatomic, copy, readonly) NSString *Qid;
@property (nonatomic, copy, readonly) NSString *desc, *subDesc;
@property (nonatomic, copy, readonly) NSArray *options;

@property (nonatomic, readonly) id type;

-(id)initWithQid: (NSString*)QuestionID desc:(NSString*)QuestionDescription subDesc:(NSString*)QuestionSubDescription options:(NSArray*)options type: (id)type;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end

