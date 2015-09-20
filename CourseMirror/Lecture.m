
//
//  Lecture.m
//  CourseMirror
//
//  Created by 童罡正 on 7/31/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "Lecture.h"

@implementation Lecture

-(id)initWithCid:(NSString*)cid Title:(NSString*)title date: (NSString *)date number:(id)number questions: (NSArray *)questions{
    self = [super init];
    if(self){
        _dateStr = date;
        _cid = cid;
        _Title = title;
        _number = number;
        _questions = questions;
        _answered = @"no";
        //create date object
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *lectureDate = [dateFormatter dateFromString:date];
        _date = lectureDate;
    }
    return self;
    
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.Title forKey:@"Title"];
    [aCoder encodeObject:self.date  forKey:@"date"];
    [aCoder encodeObject:self.cid  forKey:@"cid"];
    [aCoder encodeObject:self.questions  forKey:@"questions"];
    [aCoder encodeObject:self.number  forKey:@"number"];
    [aCoder encodeObject:self.answered  forKey:@"answered"];
    [aCoder encodeObject:self.dateStr  forKey:@"dateStr"];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _Title = [aDecoder decodeObjectForKey:@"Title"];
        _date =[aDecoder decodeObjectForKey:@"date"];
        _cid = [aDecoder decodeObjectForKey:@"cid"];
        _questions = [aDecoder decodeObjectForKey:@"questions"];
        _number = [aDecoder decodeObjectForKey:@"number"];
        _answered = [aDecoder decodeObjectForKey:@"answered"];
        _dateStr = [aDecoder decodeObjectForKey:@"dateStr"];
        
    }
    return  self;
}
@end
