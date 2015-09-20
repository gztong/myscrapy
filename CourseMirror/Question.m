//
//  Question.m
//  CourseMirror
//
//  Created by 童罡正 on 7/31/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "Question.h"

@implementation Question

-(id)initWithQid: (NSString*)QuestionID desc:(NSString*)QuestionDescription subDesc:(NSString*)QuestionSubDescription options:(NSArray*)options type: (id)type{
    
    self = [super init];
    if(self){
        _Qid = QuestionID;
        _desc = QuestionDescription;
        _subDesc = QuestionSubDescription;
        _type = type;
        _options = options;
        
    }
    
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.Qid forKey:@"Qid"];
    [aCoder encodeObject:self.desc  forKey:@"desc"];
    [aCoder encodeObject:self.subDesc  forKey:@"subDesc"];
    [aCoder encodeObject:self.options  forKey:@"options"];
     [aCoder encodeObject:self.type  forKey:@"type"];
}


- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _Qid = [aDecoder decodeObjectForKey:@"Qid"];
        _desc =[aDecoder decodeObjectForKey:@"desc"];
        _subDesc = [aDecoder decodeObjectForKey:@"subDesc"];
        _options = [aDecoder decodeObjectForKey:@"options"];
        _type = [aDecoder decodeObjectForKey:@"type"];

    }
    return  self;
}

@end

