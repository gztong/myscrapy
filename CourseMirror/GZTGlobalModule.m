//  GZTGlobalModule.m
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTGlobalModule.h"

@implementation GZTGlobalModule
static NSString *selectedCid = @"";
static Lecture *selectedLecture;
static Course *selectedCourse;

static NSArray *alllectures;
static NSArray *addedCourses;

static NSString * activeToken;
static GZTSettingViewController *sc;
static GZTCourseViewController *cc;
static GZTLectureViewController *lc;
static GZTSummaryTableViewController *sumC;


+(void) setSelectedCid: (NSString *)cid{
    selectedCid = cid;
}
+(NSString *)selectedCid{
    return selectedCid;
}

+(void) setSelectedCourse: (Course *)c{
    selectedCourse = c;
}
+(Course *)selectedCourse{
    return selectedCourse;
}

+(NSArray *)allLectures{
    if (!alllectures){
        alllectures = [[LibraryAPI sharedInstance] getLectures];
    }
    
    return alllectures;
}

+(void) setSelectedLecture: (Lecture *)lec{
    selectedLecture = lec;
}
+(Lecture *)selectedLecture{
    return selectedLecture;
}



+(void) setSettingViewController: (GZTSettingViewController *)vc{
    sc = vc;
}
+(GZTSettingViewController *) settingViewController{
    return sc;
}

+(void) setCourseViewController: (GZTCourseViewController *)vc{
    cc = vc;
}
+(GZTCourseViewController*) courseViewController{
    return cc;
}

+(void) setLectureViewController: (GZTLectureViewController *)vc{
    lc = vc;
}
+(GZTLectureViewController*) LectureViewController{
    return lc;
}

//+(void) activeToken: (NSString *)token {
//    activeToken = token;
//}

+(NSString *)getActiveToken{
    NSArray *tokens =[[LibraryAPI sharedInstance] tokensforUser:[PFUser currentUser]];

    Course *c = [self selectedCourse];
    // find active token
    for(id token in tokens){
        if( [[c tokens] containsObject:token]){
            return token;
        }
    }
    
    return NULL;
}

+(void) setAddedCourses: (NSArray *)arr{
    addedCourses =arr;
}
+(NSArray *)addedCourses{
    return addedCourses;
}

+(void) setSummaryTableViewController: (GZTSummaryTableViewController *)vc{
    sumC = vc;
}
+(GZTSummaryTableViewController *) summaryTableViewController{
    return sumC;
}

@end
