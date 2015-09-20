//
//  Data.m
//  CourseMirror
//
//  Created by 童罡正 on 8/10/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "Data.h"

@implementation Data

+ (Data*)sharedInstance
{
    static Data *_sharedInstance = nil;
    
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[Data alloc] init];
    });
    return _sharedInstance;
}

//archiving


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.allcourses forKey:@"allcourses"];
    [aCoder encodeObject:self.addedcourses  forKey:@"addedcourses"];
    [aCoder encodeObject:self.alllectures  forKey:@"alllectures"];
    [aCoder encodeObject:self.allquestions forKey:@"allquestions"];
    [aCoder encodeObject:self.user_tokens  forKey:@"user_tokens"];
    [aCoder encodeObject:self.lec_summary  forKey:@"lec_summary"];
    [aCoder encodeObject:self.course_dicOfsummary  forKey:@"course_dicOfsummary"];
    [aCoder encodeObject:self.key_image  forKey:@"key_image"];
    
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _allcourses = [aDecoder decodeObjectForKey:@"allcourses"];
        _addedcourses =[aDecoder decodeObjectForKey:@"addedcourses"];
        _alllectures = [aDecoder decodeObjectForKey:@"alllectures"];
        _allquestions = [aDecoder decodeObjectForKey:@"allquestions"];
        
        _user_tokens =[aDecoder decodeObjectForKey:@"user_tokens"];
        _lec_summary = [aDecoder decodeObjectForKey:@"lec_summary"];
        _key_image = [aDecoder decodeObjectForKey:@"key_image"];
        
    }
    return  self;
}

-(void)saveData{
    NSString *fileName = [NSHomeDirectory() stringByAppendingString:@"/Documents/localData.bin"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [data writeToFile:fileName atomically:YES];
}
@end
