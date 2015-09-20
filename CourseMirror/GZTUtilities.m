//
//  GZTUtilities.m
//  CourseMirror
//
//  Created by 童罡正 on 8/3/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import "GZTUtilities.h"
#import <Parse/Parse.h>
#import "GZTGlobalModule.h"

@implementation GZTUtilities


//  Convert an array of objects to a dictionary whose key is the index
+ (NSDictionary *) indexKeyedDictionaryFromArray:(NSArray *)array
{
    id objectInstance;
    NSUInteger indexKey = 0U;
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (objectInstance in array)
        [mutableDictionary setObject:objectInstance forKey:[NSNumber numberWithUnsignedInt:indexKey++]];
    
    return (NSDictionary *)mutableDictionary;
}



//+(NSArray *)arrayFromObjects: (NSArray*)array forField:(id)field{
//    NSMutableArray *newArray = [[NSMutableArray alloc] init
//                                ];
//    for(id object in array){
//        [newArray addObject:[object field];
//    }
//        
//    return newArray;
//}



//  Convert an array of objects to a dictionary whose key is certain field of the object
//  Parameter: NSArray, NSString
//  Return: NSDictionary
+ (NSDictionary *) DictionaryFromArray: (NSArray*)array WithKey:(NSString *)key
{
    NSDictionary* dict = [NSDictionary dictionaryWithObjects:array
                                                     forKeys:[array valueForKey:key]];
    
    return (NSDictionary *)dict;
}

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


+(void)updateParse{
    //update Lecture class with certain value from Course class
    
    // download data in advance
    NSArray * cs = [[LibraryAPI sharedInstance] getCourses];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Lecture"];
    [query orderByAscending:@"cid"];

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            for (PFObject *object in objects) {
                for(Course* c in cs){
                    if( [c.cid isEqualToString:object[@"cid"]]){
                        NSLog(@"Successfully find questions %@", [c.questions description]);

                        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:c.questions options:NSJSONWritingPrettyPrinted error:&error];
                        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        
                        object[@"questions"] = jsonString;
                        break;
                    }
                }
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        NSLog(@"been saved");
                    } else {
                        // There was a problem, check error.description
                    }
                }];            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


+(BOOL)isString:(NSString*)string ofRegexPattern:(NSString*)pattern{
    NSError *error;
    NSRegularExpression *tokenFormat = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSUInteger numberOfMatches = [tokenFormat numberOfMatchesInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if(numberOfMatches == 1) return true;
    
    return false;
    
}

+(NSDictionary*)getDictionaryFromString:(NSString*)string{
    NSDictionary *dic;
    NSError *jsonError;
    NSData* jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    if(jsonData){
        dic = [NSJSONSerialization
                                     JSONObjectWithData: jsonData
                                     options: NSJSONReadingMutableContainers
                                     error: &jsonError];
    }

    return dic;
}

+(void)uploadImageWithName:(NSString*)name key:(NSString*)key{
    UIImage *image = [UIImage imageNamed: name];
   NSData *imageData = UIImageJPEGRepresentation(image, 1);
    
    PFFile *imageFile = [PFFile fileWithName:name data:imageData];
    
    PFObject *userPhoto = [PFObject objectWithClassName:@"Image"];
    userPhoto[@"image"] = imageFile;
    userPhoto[@"key"] = key;
    NSLog(@"upload image called");
    [userPhoto saveInBackground];
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
