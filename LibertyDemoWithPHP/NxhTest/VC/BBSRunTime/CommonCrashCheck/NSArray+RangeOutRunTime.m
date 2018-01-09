//
//  NSArray+RangeOutRunTime.m
//  MusicBox
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 Alex.Wu. All rights reserved.
//

#import "NSArray+RangeOutRunTime.h"

#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSArray (RangeOutRunTime)

+ (void)load{
    // 交换方法
    //Check:objectAtIndex
    Method objIndexCheck = class_getClassMethod(self, @selector(objectCheckAtIndex:));
    Method objIndex = class_getClassMethod(self, @selector(objectAtIndex:));
    
    method_exchangeImplementations(objIndexCheck, objIndex);
}

- (id)objectCheckAtIndex:(NSInteger)index{
    if (self&&self.count>index) {
        return [self objectAtIndex:index];
    }else{
        NSLog(@"————————Arr_Index超出范围———————");
        return nil;
    }
}



@end
