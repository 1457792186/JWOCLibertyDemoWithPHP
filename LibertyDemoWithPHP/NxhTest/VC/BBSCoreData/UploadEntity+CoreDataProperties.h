//
//  UploadEntity+CoreDataProperties.h
//  NxhTest
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//
//

#import "UploadEntity+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface UploadEntity (CoreDataProperties)

+ (NSFetchRequest<UploadEntity *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *fileName;
@property (nullable, nonatomic, copy) NSString *fileSize;
@property (nonatomic) int16_t fileType;
@property (nonatomic) int16_t finishStatus;
@property (nullable, nonatomic, retain) NSData *imageData;
@property (nonatomic) int64_t time;
@property (nullable, nonatomic, copy) NSString *urlPath;

@end

NS_ASSUME_NONNULL_END
