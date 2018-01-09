//
//  NSMutableDictionary+RangeOutRunTime.m
//  NxhTest
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 UgoMedia. All rights reserved.
//

#import "NSMutableDictionary+RangeOutRunTime.h"

#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSMutableDictionary (RangeOutRunTime)

+ (void)load{
    // 交换方法
    //Check:addObj
    Method addObjCheck = class_getClassMethod(self, @selector(setValueCheck:forKey:));
    
    Method addObj = class_getClassMethod(self, @selector(setValue:forKey:));
    ;
    method_exchangeImplementations(addObjCheck, addObj);
}

- (void)setValueCheck:(id)value forKey:(NSString *)key{
    if (self&&value&&key) {
        [self setValue:value forKey:key];
    }else{
        NSLog(@"————————Dic_Obj为空———————");
    }
}

@end
