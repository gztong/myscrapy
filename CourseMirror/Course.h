//
//  Course.h
//  CourseMirror
//
//  Created by 童罡正 on 7/31/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Course : NSObject<NSCoding>
@property (nonatomic, copy, readonly) NSString *Title, *URL, *cid;
@property (nonatomic, copy, readonly) NSArray *tokens,  *questions;
@property (nonatomic, copy, readonly) NSString *imageName;

-(id)initWithCid:(NSString*)cid Title:(NSString*)Title;

-(id)initWithCid:(NSString*)cid Title:(NSString*)Title URL:(NSString *)URL Questions: (NSString *)questions Time: (NSString *)time Tokens:(NSString *)tokens image:(NSString *)imageName;

@end
