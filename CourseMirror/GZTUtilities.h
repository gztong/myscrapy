//
//  Some handy functions
//
//  GZTUtilities.h
//  CourseMirror
//
//  Created by 童罡正 on 8/3/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GZTUtilities : NSObject

+(NSDictionary *)indexKeyedDictionaryFromArray:(NSArray *)array;

//  Convert an array of objects to a dictionary whose key is certain field of the object
//  Parameter: NSArray, NSString
//  Return: NSDictionary
+(NSDictionary *) DictionaryFromArray: (NSArray*)array WithKey:(NSString *)key;

+(NSArray *)getArrayFromString:(NSString *)string;
+(NSString *)getStringFromArray:(NSArray*) myArray;
+(NSDictionary*)getDictionaryFromString:(NSString*)string;

+(BOOL)isString:(NSString*)string ofRegexPattern:(NSString*)pattern;

+(void)uploadImageWithName:(NSString*)name key:(NSString*)key;


+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

+(void)updateParse;
@end
