//
//  Summary.h
//  CourseMirror
//
//  Created by 童罡正 on 8/6/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

//formatting of infoDictionary
//{"Sources": [["e0659", "e0162", "e3801", "e3451", "e5865", "e1226", "e2909", "e3345", "e7594", "e2509"], ["e4254", "e7951", "e1520", "e3991", "e1100", "e2909", "e3290", "e4639", "e3141"], ["e1993", "e1517", "e1923", "e5658", "e0806", "e1234", "e4521", "e6969"], ["e0387", "e1959", "e3249", "e5219", "e3126", "e2171", "e1903"]], "weight": [10, 9, 8, 7], "summaryText": ["a with p value", "steps for type 1 error", "p value and hypothesis testing", "alternative steps for critical point and significance level"]}


#import <Foundation/Foundation.h>

@interface Summary : NSObject<NSCoding>
@property (nonatomic, copy, readonly) NSString *cid, *lec_num;
@property (nonatomic, copy, readonly) NSArray *infoDictionaryArray;


-(id)initWith:(NSString*)cid number:(NSString*)num infoArray:(NSArray*)infoArray;

- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
