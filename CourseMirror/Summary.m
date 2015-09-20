//
//  Summary.m
//  CourseMirror
//
//  Created by 童罡正 on 8/6/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "Summary.h"

@implementation Summary

-(id)initWith:(NSString*)cid number:(NSString*)num infoArray:(NSArray*)infoArray{
    
    self= [super init];
    
    if(self){
        _cid = cid;
        _lec_num = num;
        _infoDictionaryArray = infoArray;
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.cid forKey:@"cid"];
    [aCoder encodeObject:self.lec_num  forKey:@"lec_num"];
    [aCoder encodeObject:self.infoDictionaryArray  forKey:@"infoDictionaryArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _cid = [aDecoder decodeObjectForKey:@"cid"];
        _lec_num =[aDecoder decodeObjectForKey:@"lec_num"];
        _infoDictionaryArray = [aDecoder decodeObjectForKey:@"infoDictionaryArray"];
    }
    return  self;
}



-(NSArray *)getTextArray{
    if(! _infoDictionaryArray) return nil;
    
    
    
    
    return nil;
}

@end
