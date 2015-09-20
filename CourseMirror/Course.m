//
//  Course.m
//  CourseMirror
//
//  Created by 童罡正 on 7/31/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "Course.h"

@implementation Course

-(id)initWithCid:(NSString*)cid Title:(NSString*)title{
    self = [super init];
    if(self){
        _Title = title;
        _cid = cid;
        
    }
    
    return self;
}

-(id)initWithCid:(NSString *)cid Title:(NSString *)Title URL:(NSString *)URL Questions:(NSString *)questions Time:(NSString *)time Tokens:(NSString *)tokens image:(NSString *)imageName{
    self = [super init];
    if(self){
        _cid = cid;
        _Title = Title;
        _URL = URL;
        _imageName = imageName;
        
        
        //parse questions
        NSData *jsonData = [questions dataUsingEncoding:NSUTF8StringEncoding];
        NSError *localError;
        _questions = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&localError];
    
        //parse tokens
        jsonData = [tokens dataUsingEncoding:NSUTF8StringEncoding];
        _tokens = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&localError];

    }
    
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.Title forKey:@"Title"];
    [aCoder encodeObject:self.URL  forKey:@"URL"];
    [aCoder encodeObject:self.cid  forKey:@"cid"];
    [aCoder encodeObject:self.tokens  forKey:@"tokens"];
    [aCoder encodeObject:self.questions  forKey:@"questions"];
    [aCoder encodeObject:self.imageName  forKey:@"imageName"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        _Title = [aDecoder decodeObjectForKey:@"Title"];
        _URL =[aDecoder decodeObjectForKey:@"URL"];
        _cid = [aDecoder decodeObjectForKey:@"cid"];
        _tokens = [aDecoder decodeObjectForKey:@"tokens"];
        _questions = [aDecoder decodeObjectForKey:@"questions"];
        _imageName = [aDecoder decodeObjectForKey:@"imageName"];
    }
    return  self;
}

@end
