//
//  LocalData.m
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "LocalData.h"
#import "Lecture.h"

@interface LocalData(){

}

@end

@implementation LocalData

-(id)init{
 
    
    NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:@"/Documents/data.bin"]];
    self.data = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if(self.data == nil){
        NSLog(@"DATA IS NIL");
        self.data = [[Data alloc] init];
        self.data.allcourses = [ParseClient getCouses];
        self.data.alllectures = [ParseClient getLectures];
        self.data.allquestions = [ParseClient getQuestions];
        self.data.key_image =[ParseClient downloadImages];
    }else{
        NSLog(@"DATA IS init from archiving");
        NSLog(@"  self.data.key_image %@", [self.data.key_image description]);
    }
    return self;
}

- (NSArray *) getCourses{
    if(!self.data.allcourses){
        NSLog(@"get all courses nil %@",  self.data.allcourses);
       self.data.allcourses = [ParseClient getCouses];
    }
    NSLog(@"get all courses %@",  self.data.allcourses);
    
    return self.data.allcourses;
}

- (NSArray *) getLectures{
    if(!self.data.alllectures){
        self.data.alllectures = [ParseClient getLectures];
    }
    
    return self.data.alllectures;
}

-(NSArray *)getQuestions{
    if(! self.data.allquestions){
         self.data.allquestions  =  [ParseClient getQuestions];
        
    }
    
    return  self.data.allquestions;
}


-(NSArray *)getLecturesForCid: (NSString *)cid{
    if(! self.data.alllectures){
        self.data.alllectures = [ParseClient getLectures];
    }
    

    NSMutableArray *cid_Lectures = [[NSMutableArray alloc] init];
    for(Lecture *lec in self.data.alllectures){

        if( [[lec cid] isEqualToString:cid])
            [cid_Lectures addObject:lec];
    }
    
    return cid_Lectures;
}

//tobedone
- (NSArray *) getCoursesForToken: (NSString *) token{
    return self.data.allcourses;
}
- (NSArray *) getCoursesForcid: (NSString *) cid
{
    return self.data.allcourses;
}

-(void)setTokens:(NSArray *)tokens forUser:(PFUser *)user{
    NSLog(@"in settokens tokens = %@", tokens);
    if(!self.data.user_tokens){
        self.data.user_tokens = [[NSMutableDictionary alloc] init];
    }
    NSMutableArray *mtokens = [[NSMutableArray alloc] initWithArray:tokens];
    [self.data.user_tokens setObject:mtokens forKey:user[@"username"]];
}


-(void)addToken: (NSString *)token forUser: (PFUser *)user{
    
   NSMutableArray *addedTokens = [self getTokensforUser:[PFUser currentUser]];
    
    NSArray *addedCourses = [self addedCoursesForTokens:addedTokens];
    
    
    //defending code, prevent duplicated courses added
    for(Course *c in addedCourses){
        if( [c.tokens containsObject:token]){
        
            
            return;

        }
        
    }

    
    
    if( ![addedTokens containsObject: token]){
        [addedTokens addObject: token];
        [ParseClient setTokens:addedTokens forUser:user];
        [self.data.user_tokens setObject:addedTokens forKey:user[@"username"]];
        NSLog(@"%@ is added", token);
    }else{
        NSLog(@"%@ is already there", token);
    }

}


//-(NSArray *)tokensforUser: (PFUser *)user{
//    NSArray *arr = [self.data.user_tokens objectForKey:user[@"username"]];
//    if(!arr){
//        arr = [ParseClient tokensforUser:user];
//    }
//    return arr;
//}

-(NSMutableArray *)getTokensforUser:(PFUser *)user{
    NSMutableArray *arr = [self.data.user_tokens objectForKey:user[@"username"]];
    // if the array hasnt been created
    if(!arr){
        arr = [ParseClient tokensforUser:user];
        [self.data.user_tokens setObject:arr forKey:user[@"username"]];
    }
    
    
    return arr;
}

-(Summary *)getSummaryForLecture:(Lecture*)lec{
//    if(!self.data.lec_summary){
//        self.data.lec_summary = [[NSMutableDictionary alloc] init];
//    }
    
//    Summary *summary = [self.data.lec_summary objectForKey:[lec Title]];
//    
//    if(!summary){
//        summary = [ParseClient getSummaryForLecture:lec];
//        [self.data.lec_summary setObject:summary forKey:[lec Title]];
//    }else{
//       [[NSNotificationCenter defaultCenter] postNotificationName:@"summaryDownloaded" object:self];
//    }
//    
    
    Summary *summary = [ParseClient getSummaryForLecture:lec];
    [self.data.lec_summary setObject:summary forKey:[lec Title]];
    
    return summary;
}

-(NSDictionary *)getSummariesForCourse:(Course*)course{
    if(! self.data.course_dicOfsummary){
        self.data.course_dicOfsummary = [[NSMutableDictionary alloc] init];
    }
    NSDictionary *dicOfsummary =  [self.data.course_dicOfsummary objectForKey:[course cid]];
    if(dicOfsummary){
        return dicOfsummary;
    }
    dicOfsummary =[ParseClient getSummariesForCourse:course];
    [self.data.course_dicOfsummary setObject:dicOfsummary forKey:[course cid]];
    
    return dicOfsummary;
}

-(NSArray *)addedCoursesForTokens: (NSArray *)tokens{
   
   NSMutableArray *addedCourses = [[NSMutableArray alloc] init];
    NSArray *allCourses = [self getCourses];
  //  NSLog(@"in localdata, allcourses  = %@", allCourses);

    for(NSString *token in tokens){
        for(Course *c in allCourses){
            if( [[c tokens] containsObject:token] && ![addedCourses containsObject:c]){
                [addedCourses addObject:c];
                break;
            }
        }
    }
    return addedCourses;
}

//
////archiving
//-(void)encodeWithCoder:(NSCoder *)aCoder{
//    [aCoder encodeObject:self.allcourses forKey:@"allcourses"];
//    [aCoder encodeObject:self.alllectures forKey:@"alllectures"];
//    [aCoder encodeObject:self.allquestions forKey:@"allquestions"];
//    [aCoder encodeObject:self.user_tokens forKey:@"user_tokens"];
//    [aCoder encodeObject:self.lec_summary forKey:@"lec_summary"];
//    [aCoder encodeObject:self.course_dicOfsummary forKey:@"course_dicOfsummary"];
//    [aCoder encodeObject:self.key_image forKey:@"key_image"];
//}
//
//-(id)initWithCoder:(NSCoder *)aDecoder{
//    self = [super init];
//    if(self){
//        _allcourses = [aDecoder decodeObjectForKey:@"allcourses"];
//        _alllectures =[aDecoder decodeObjectForKey:@"alllectures"];
//        _allquestions = [aDecoder decodeObjectForKey:@"allquestions"];
//        _user_tokens = [aDecoder decodeObjectForKey:@"user_tokens"];
//        _lec_summary = [aDecoder decodeObjectForKey:@"lec_summary"];
//        _course_dicOfsummary = [aDecoder decodeObjectForKey:@"course_dicOfsummary"];
//        _key_image = [aDecoder decodeObjectForKey:@"key_image"];
//    }
//    return  self;
//}
//
-(void)saveData{
    NSString *fileName = [NSHomeDirectory() stringByAppendingString:@"/Documents/data.bin"];
    NSData *data1 = [NSKeyedArchiver archivedDataWithRootObject:self.data];
    [data1 writeToFile:fileName atomically:YES];
}

-(NSDictionary *)downloadImages{
    if(!self.data.key_image){
        self.data.key_image = [ParseClient downloadImages];
    }
    return  self.data.key_image;
}

-(void)sync{
    NSLog(@"sync called");

    NSLog(@"DATA IS NIL");
    self.data = [[Data alloc] init];
    self.data.allcourses = [ParseClient getCouses];
    self.data.alllectures = [ParseClient getLectures];
    self.data.allquestions = [ParseClient getQuestions];
    self.data.key_image =[ParseClient downloadImages];
    
    [self saveData];
}

@end
