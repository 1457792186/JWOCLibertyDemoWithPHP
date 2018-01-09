//
//  NSMutableArray+RangeOutRunTime.m
//  MusicBox
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 Alex.Wu. All rights reserved.
//

#import "NSMutableArray+RangeOutRunTime.h"

#import <objc/message.h>
#import <objc/runtime.h>

@implementation NSMutableArray (RangeOutRunTime)

+ (void)load{
    // 交换方法
    
    //Check:removeObjectAtIndex
    Method removeObjCheck = class_getClassMethod(self, @selector(removeCheckObjectAtIndex:));
    Method removeObj = class_getClassMethod(self, @selector(removeObjectAtIndex:));
    method_exchangeImplementations(removeObjCheck, removeObj);
    //Check:addObject
    Method addObjCheck = class_getClassMethod(self, @selector(addObjCheck:));
    Method addObj = class_getClassMethod(self, @selector(addObject:));
    method_exchangeImplementations(addObjCheck, addObj);
    //Check:insertObject:atIndex
    Method insertObjCheck = class_getClassMethod(self, @selector(insertObjectCheck:atIndex:));
    Method insertObj = class_getClassMethod(self, @selector(insertObject:atIndex:));
    method_exchangeImplementations(insertObjCheck, insertObj);
    
}

//+ (void)exchangeMethod:(SEL)fun withMethod:(SEL)exFun{
//    Method function = class_getClassMethod(self, @selector(fun));
//    Method exchengeFunction = class_getClassMethod(self, @selector(exFun));
//
//    method_exchangeImplementations(function, exchengeFunction);
//}

- (void)removeCheckObjectAtIndex:(NSInteger)index{
    if (self&&self.count>index) {
        [self removeObjectAtIndex:index];
    }else{
        NSLog(@"————————Arr_Index超出范围———————");
    }
}

- (void)addObjCheck:(id)obj{
    if (self&&obj) {
        [self addObject:obj];
    }else{
        NSLog(@"————————Arr_Obj为空———————");
    }
}

- (void)insertObjectCheck:(id)obj atIndex:(NSInteger)index{
    if (self&&obj&&self.count>index) {
        [self insertObject:obj atIndex:index];
    }else{
        if (obj) {
            NSLog(@"————————Arr_Index超出范围———————");
        }else{
            NSLog(@"————————Arr_Obj为空———————");
        }
    }
}


@end
