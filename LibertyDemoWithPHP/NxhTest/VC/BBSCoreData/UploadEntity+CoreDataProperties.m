//
//  UploadEntity+CoreDataProperties.m
//  NxhTest
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//
//

#import "UploadEntity+CoreDataProperties.h"

@implementation UploadEntity (CoreDataProperties)

+ (NSFetchRequest<UploadEntity *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"UploadEntity"];
}

@dynamic fileName;
@dynamic fileSize;
@dynamic fileType;
@dynamic finishStatus;
@dynamic imageData;
@dynamic time;
@dynamic urlPath;

@end
