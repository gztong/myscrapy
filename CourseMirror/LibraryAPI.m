//
//  LibraryAPI.m
//  CourseMirror
//
//  Created by 童罡正 on 7/31/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "LibraryAPI.h"
#import "LocalData.h"
#import "ParseClient.h"

// Facade Pattern
@interface LibraryAPI(){
    LocalData *localData;
    ParseClient *parseClient;
    BOOL isOnline;
}

@end

@implementation LibraryAPI

//  Singleton pattern, sharedInstance only being created once
+(LibraryAPI*)sharedInstance{
    static LibraryAPI *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[LibraryAPI alloc] init];
    });
    
    return _sharedInstance;
}

-(id)init{
    self = [super init];
    if(self) {
        localData = [[LocalData alloc] init];
        parseClient = [[ParseClient alloc] init];
        isOnline = YES;  //tobedone  check connection
    }
    return self;
    
}

-(NSArray *) getCourses{
    return [localData getCourses];
}


-(NSArray *)getLectures{
    return [localData getLectures];
}

-(NSArray *)getLecturesForCid: (NSString *)cid{
    return [localData getLecturesForCid: cid];
}

-(NSArray *)getQuestions{
    return [localData getQuestions];
}

-(void)addToken: (NSString *)token forUser: (PFUser *)user{
    [localData addToken:token forUser:user];
}


-(NSArray *)tokensforUser: (PFUser *)user{
    return  [localData getTokensforUser: user];
}

-(void)setTokens:(NSArray *)tokens forUser:(PFUser *)user{
    NSLog(@"================================================");
    [localData setTokens:tokens forUser:user];
}


-(NSArray *)allTokens{
    return [ParseClient allTokens];
}

-(Summary *)getSummaryForLecture:(Lecture*)lec{
    return  [localData getSummaryForLecture:lec];
}

-(NSDictionary *)getSummariesForCourse:(Course*)course{
    return  [localData getSummariesForCourse:course];
}

-(Course *)getCourseForCid: (NSString *)cid{

    for(Course *c in [self getCourses]){
        if( [[c cid] isEqualToString:cid]){
            return c;
        }
    }
    return nil;
}

-(NSArray *)addedCoursesForTokens: (NSArray *)tokens{
    return  [localData addedCoursesForTokens:tokens];
}
-(NSDictionary *)downloadedImages{
    return [localData downloadImages];
}

-(void)sync{
    [localData sync];
}

-(void)saveData{
    [localData saveData];
}


-(NSArray *)checkWritableForCid:(NSString*)cid token: (NSString *)token{
    return [ParseClient checkWritableForCid:cid token:token];
}
@end
