//
//  CourseCellTableViewCell.h
//  CourseMirror
//
//  Created by 童罡正 on 8/2/15.
//  Copyright (c) 2015 Gangzheng Tong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseCellTableViewCell : UITableViewCell
@property(nonatomic, weak) IBOutlet UILabel *title;

@property(nonatomic, weak) IBOutlet UILabel *cid;
@property(nonatomic, weak) IBOutlet UIImageView *thumbnailImageView;

@end
