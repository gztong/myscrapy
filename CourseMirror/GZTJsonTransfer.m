//
//  GZTJsonTransfer.m
//  CourseMirror
//
//  Created by 童罡正 on 8/3/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTJsonTransfer.h"

@implementation GZTJsonTransfer

+(NSArray *)getArrayFromString:(NSString *)string{
    
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *localError;
    NSArray *myArray = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&localError];
    
    return myArray;
}

+(NSString *)getStringFromArray:(NSArray*) myArray{
    NSError *localError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:myArray options:NSJSONWritingPrettyPrinted error:&localError];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    return jsonString;
}
@end
