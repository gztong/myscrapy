//
//  ParseClient.m
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "ParseClient.h"
#import "Question.h"
#import "GZTUtilities.h"
#import "LibraryAPI.h"
#import "Summary.h"


@implementation ParseClient

static NSArray *allTokens;

+(NSDictionary *)downloadImages{
    NSMutableDictionary *key_image = [[NSMutableDictionary alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Image"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(objects){
            for(PFObject *object in objects){
                    NSLog(@"image downloaded %lu", [[key_image allKeys] count]);
                 PFFile *userImageFile = object[@"image"];
                [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:imageData];
                        [key_image setObject:image forKey:object[@"key"]];
                    }
                }];
            }
        }
    }];
    

    return key_image;
}

+(NSArray *) getCouses{
    __block NSMutableArray *courses = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Course"];
 //   [query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (PFObject *object in objects) {
                
                Course *course = [[Course alloc] initWithCid:object[@"cid"] Title:object[@"Title"] URL:object[@"URL"] Questions:object[@"questions"] Time:object[@"time"] Tokens:object[@"tokens"] image:object[@"cid"]];
                
                [courses addObject: course];
            }
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    

    return courses;
}

+(NSArray *) getLectures{
    __block NSMutableArray *lectures = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Lecture"];
    [query orderByAscending:@"number"];
    query.limit = 1000;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
     
            for (PFObject *object in objects) {
             
                NSArray *questions = [GZTUtilities getArrayFromString:object[@"questions"]];
                Lecture *lecture = [[Lecture alloc] initWithCid:object[@"cid"] Title:object[@"Title"] date:object[@"date"] number:object[@"number"] questions: questions];
                [lectures addObject: lecture];
            }
        
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
    

    return lectures;
}



+(NSArray *) getQuestions{
    __block NSMutableArray *questions = [[NSMutableArray alloc] init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Question"];
    [query orderByAscending:@"QuestionID"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
       
            for (PFObject *object in objects) {
                NSArray *options = [GZTUtilities getArrayFromString:object[@"Choices"]];
                if(!options){
                    options = @[];
                }
                              Question *question = [[Question alloc] initWithQid:object[@"QuestionID"] desc:object[@"QuestionDescription"] subDesc:object[@"QuestionSubDescription"] options:options type: object[@"QuestionType"]];
                [questions addObject: question];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    return questions;
}


+(void)setTokens: (NSArray *)tokens forUser: (PFUser *)user{
    NSString *tokenStr = [GZTUtilities getStringFromArray:tokens];
    user[@"token"] = tokenStr;

    [user saveInBackground];
}

+(NSMutableArray *)tokensforUser: (PFUser *)user{
    NSString *tokenString = user[@"token"];
    if(!tokenString) return  [NSMutableArray new];
    NSArray *arr = [GZTUtilities getArrayFromString:tokenString];
   // NSLog(@"(in ParseClient) get tokens from user: %@", arr);
    NSMutableArray *arr1 = [[NSMutableArray alloc] initWithArray:arr];
    return arr1;
}


+(NSArray *)allTokens{
    NSMutableArray *alltokens = [[NSMutableArray alloc] init];
    for (Course *c in [[LibraryAPI sharedInstance] getCourses]){
        [alltokens addObjectsFromArray:c.tokens];
    }
    
    return alltokens;
}

+(NSArray *)checkWritableForCid:(NSString*)cid token: (NSString *)token{
    NSArray *lectures = [[LibraryAPI sharedInstance] getLectures];
    NSMutableArray *reflections = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Reflection"];
    
     [query whereKey:@"cid" equalTo: cid];
     [query whereKey:@"user" equalTo: token];
     [query orderByAscending:@"lecture_number"];

    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        if(!error){
            for(int i =0; i< [objects count]; i++){
                [reflections addObject: objects[i][@"lecture_number"]];
            }
       
            for( Lecture *lec in lectures){
                if( [reflections containsObject:lec.number]){
                    lec.answered = @"YES";
                }else{
                    lec.answered = @"NO";
                }
                
            
            }
            
                [[NSNotificationCenter defaultCenter] postNotificationName:@"answeredChecked" object:self];
          
        }

        
    }];
    
    
    return nil;
}

+(Summary *)getSummaryForLecture:(Lecture*)lec{
    PFQuery *S_query = [PFQuery queryWithClassName:@"Summarization"];
    [S_query whereKey:@"cid" equalTo: [lec cid]];
    [S_query whereKey:@"lecture_number" equalTo:[lec number]];

   __block NSMutableArray *dic_arr = [[NSMutableArray alloc] init];
    
    [S_query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error){
        NSLog(@"object %@", object[@"q1_summaries"]);

        if(!error){
            //iterate all questions of the lecture
           // int i = 0;
            for(Question *q in [[LibraryAPI sharedInstance] getQuestions]){
                
                if( ![[lec questions] containsObject:q.Qid] ) continue;
             
                NSString *name = [ NSString stringWithFormat:@"%@_summaries", [q Qid]];
                if( !object[name]) continue;
                
                NSDictionary *summary_dic = [GZTUtilities getDictionaryFromString:object[name]];
                
                [dic_arr addObject:summary_dic];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"summaryDownloaded" object:self];
        }else{

            [[NSNotificationCenter defaultCenter] postNotificationName:@"summaryDownloadedFailed" object:self];
        
        }
    }];
    
    Summary *summary = [[Summary alloc] initWith:[lec cid] number:[lec number] infoArray:dic_arr];
    
    return summary;
}

//return Dictionary of Summary of all lectures
//key: lecture number, value: Summary
+(NSDictionary *)getSummariesForCourse:(Course*)course{
    
    NSArray *lectures = [[LibraryAPI sharedInstance] getLecturesForCid:[course cid]];
    NSDictionary *num_lectures = [GZTUtilities DictionaryFromArray:lectures WithKey:@"number"];
    
    
    PFQuery *S_query = [PFQuery queryWithClassName:@"Summarization"];
    [S_query whereKey:@"cid" containsString:[course cid]];
    NSMutableDictionary *num_summary = [[NSMutableDictionary alloc] init];
    
    
    [S_query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!objects) {
            NSLog(@"The findObjects request failed.");
        } else {
            // The find succeeded.
            //iterate all summaries of lectures
            for(PFObject *object in objects){
                //iterate all questions of the summay
                NSMutableArray *dic_arr = [[NSMutableArray alloc] init];
                Lecture *lec = [num_lectures objectForKey:object[@"lecture_number"]];
                
                for(int i =0; i< [[lec questions] count]; i++){
                    NSString *name = [ NSString stringWithFormat:@"q%d_summaries", (i+1)];
                    
                    NSDictionary *summary_dic = [GZTUtilities getDictionaryFromString:object[name]];
                    [dic_arr addObject:summary_dic];
                }
                
                [num_summary setObject:dic_arr forKey:object[@"lecture_number"]];
            }
        
        }
    }];
    

    return num_summary;
}

@end
