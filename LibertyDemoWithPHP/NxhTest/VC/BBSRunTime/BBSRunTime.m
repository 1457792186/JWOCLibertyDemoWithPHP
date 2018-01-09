//
//  BBSRunTime.m
//  NxhTest
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 UgoMedia. All rights reserved.
//

#import "BBSRunTime.h"
#import <objc/message.h>
#import <objc/runtime.h>

//测试类
#import "BBSTest.h"


@implementation BBSRunTime

/*
 runtime.h是运行时最重要的文件，其中包含了对运行时进行操作的方法。 主要包括：
 /// An opaque type that represents a method in a class definition. 一个类型，代表着类定义中的一个方法
 typedef struct objc_method *Method;
 
 /// An opaque type that represents an instance variable.代表实例(对象)的变量
 typedef struct objc_ivar *Ivar;
 
 /// An opaque type that represents a category.代表一个分类
 typedef struct objc_category *Category;
 
 /// An opaque type that represents an Objective-C declared property.代表OC声明的属性
 typedef struct objc_property *objc_property_t;
 
 // Class代表一个类，它在objc.h中这样定义的  typedef struct objc_class *Class;
 struct objc_class {
 Class isa  OBJC_ISA_AVAILABILITY;
 
 #if !__OBJC2__
 Class super_class                                        OBJC2_UNAVAILABLE;
 const char *name                                         OBJC2_UNAVAILABLE;
 long version                                             OBJC2_UNAVAILABLE;
 long info                                                OBJC2_UNAVAILABLE;
 long instance_size                                       OBJC2_UNAVAILABLE;
 struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
 struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
 struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
 struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
 #endif
 
 } OBJC2_UNAVAILABLE;
 
 
 
 这些类型的定义，对一个类进行了完全的分解，将类定义或者对象的每一个部分都抽象为一个类型type，对操作一个类属性和方法非常方便。OBJC2_UNAVAILABLE标记的属性是Ojective-C 2.0不支持的,但实际上可以用响应的函数获取这些属性，例如：如果想要获取Class的name属性，可以按如下方法获取:
 
 
 Class classPerson = Person.class;
 // printf("%s\n", classPerson->name); //用这种方法已经不能获取name了 因为OBJC2_UNAVAILABLE
 const char *cname  = class_getName(classPerson);
 printf("%s", cname); // 输出:Person
 
 
 */


#pragma mark - 发送消息
/*
 方法调用的本质，就是让对象发送消息。
 
 objc_msgSend,只有对象才能发送消息，因此以objc开头.
 
 使用消息机制前提，必须导入#import <objc/message.h>
 
 消息机制简单使用
 */
- (void)main{
    BBSTest * test = [[BBSTest alloc]init];
    
//     本质：让对象发送消息
    objc_msgSend(test,@selector(eat));
    //类似[test eat];
    
/*
 报错：
 objc_msgSend()报错Too many arguments to function call ,expected 0,have3
 设置：
 Build Setting--> Apple LLVM 6.0 - Preprocessing--> Enable Strict Checking of objc_msgSend Calls  改为 NO
 */
    
    objc_msgSend([BBSTest class],@selector(eat));
    //类似[BBSTest eat];
    //类似[[BBSTest class] eat];
}


#pragma mark - 交换方法
/*
 交换方法实现的需求场景：自己创建了一个功能性的方法，在项目中多次被引用，当项目的需求发生改变时，要使用另一种功能代替这个功能，要求是不改变旧的项目(也就是不改变原来方法的实现)。
 
 可以在类的分类中，再写一个新的方法(是符合新的需求的),然后交换两个方法的实现。这样，在不改变项目的代码，而只是增加了新的代码 的情况下，就完成了项目的改进。
 
 交换两个方法的实现一般写在类的load方法里面，因为load方法会在程序运行前加载一次，而initialize方法会在类或者子类在 第一次使用的时候调用，当有分类的时候会调用多次。
 */
+ (void)load{
    // 交换方法
    
    // 获取imageWithName方法地址
    Method isSubClassWithName = class_getClassMethod(self, @selector(isMemberOfWithNameClass:));
    
    // 获取isMemberOfClass方法地址
    Method isSubClass = class_getClassMethod(self, @selector(isMemberOfClass:));
    
    // 交换方法地址，相当于交换实现方式
    method_exchangeImplementations(isSubClassWithName, isSubClass);
}

// 不能在分类中重写系统方法isMemberOfClass，因为会把系统的功能给覆盖掉，而且分类中不能调用super.
- (BOOL)isMemberOfWithNameClass:(__unsafe_unretained Class)class{
    BOOL isSubClass = [self isMemberOfClass:class];
    
    NSLog(@"%@",isSubClass?@"是子类":@"非子类");
    
    return isSubClass;
}

#pragma mark - 类\对象的关联对象-设置属性
/*
 关联对象不是为类\对象添加属性或者成员变量(因为在设置关联后也无法通过ivarList或者propertyList取得) ，而是为类添加一个相关的对象，通常用于存储类信息，例如存储类的属性列表数组，为将来字典转模型的方便。
 */

// 定义关联的key
static const char *key = "aname";

//使用方式一：给分类添加属性
//类似set、get方法
- (NSString *)aname{
    // 根据关联的key，获取关联的值。
    return objc_getAssociatedObject(self, key);
}

- (void)setAname:(NSString *)aname{
    // 第一个参数：给哪个对象添加关联
    // 第二个参数：关联的key，通过这个key获取
    // 第三个参数：关联的value
    // 第四个参数:关联的策略
    objc_setAssociatedObject(self, key, aname, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

//使用方式二：给对象添加关联对象
//类似赋值属性
- (void)aaAction{
    NSObject * test = [[NSObject alloc]init];
    
    // 传递多参数
    objc_setAssociatedObject(test, "suppliers_id", @"1", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(test, "warehouse_id", @"2", OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //类似于test.suppliers_id = @"1";test.warehouse_id= @"2";  只是未使用@property而是使用运行时进行设置
    
    //获取对应参数
    NSString *warehouse_id = objc_getAssociatedObject(test, "warehouse_id");//获取结果：2
    NSString *suppliers_id = objc_getAssociatedObject(test, "suppliers_id");//获取结果：1
    NSLog(@"warehouse_id is %@",warehouse_id);
    NSLog(@"suppliers_id is %@",suppliers_id);
}
/*
 objc_setAssociatedObject方法的参数解释:
 
 第一个参数id object, 当前对象
 第二个参数const void *key, 关联的key，是c字符串
 第三个参数id value, 被关联的对象的值
 第四个参数objc_AssociationPolicy policy关联引用的规则
 */

#pragma mark - 动态添加方法
/*
 开发使用场景：如果一个类方法非常多，加载类到内存的时候也比较耗费资源，需要给每个方法生成映射表，可以使用动态给某个类，添加方法解决。
 
 经典面试题：有没有使用performSelector，其实主要想问你有没有动态添加过方法。
 */

- (void)addFunction{
    BBSRunTime * test = [[BBSRunTime alloc]init];//不一定是BBSRunTime类，只是方便下面方法展示，如AAA类
    // 默认test，没有实现drink方法，可以通过performSelector调用，但是会报错。
    // 动态添加方法就不会报错
    [test performSelector:@selector(drink)];
}

//AAA类内添加下列方法适配
// void(*)()
// 默认方法都有两个隐式参数，
void drink(id self,SEL sel)
{
    NSLog(@"%@ %@",self,NSStringFromSelector(sel));
}

// 当一个对象调用未实现的方法，会调用这个方法处理,并且会把对应的方法列表传过来.
// 刚好可以用来判断，未实现的方法是不是我们想要动态添加的方法
+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(drink)) {
        // 动态添加drink方法
        
        // 第一个参数：给哪个类添加方法
        // 第二个参数：添加方法的方法编号
        // 第三个参数：添加方法的函数实现（函数地址）
        // 第四个参数：函数的类型，(返回值+参数类型) v:void @:对象->self :表示SEL->_cmd
        class_addMethod(self, @selector(drink), drink, "v@:");
    }
    return [super resolveInstanceMethod:sel];
}


#pragma mark - 字典转模型KVC实现
/*
 KVC：把字典中所有值给模型的属性赋值。这个是要求字典中的Key,必须要在模型里能找到相应的值，如果找不到就会报错。基本原理如
 */
- (void)KVCTest:(NSDictionary*)dict with:(id)item{
    // KVC原理:
    // 1.遍历字典中所有key,去模型中查找有没有对应的属性
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        // 2.去模型中查找有没有对应属性 KVC
        // key:source value:来自即刻笔记
        // [item setValue:@"来自即刻笔记" forKey:@"source"]
        [item setValue:value forKey:key];
    }];
    
//    但是，在实际开发中，从字典中取值,不一定要全部取出来。因此，我们可以通过重写KVC 中的 forUndefinedKey这个方法，就不会进行报错处理
    
}

// 重写系统方法? 1.想给系统方法添加额外功能 2.不想要系统方法实现
// 系统找不到就会调用这个方法,报错
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

//另外，可以通过runtime的方式去实现。把KVC的原理倒过来，通过遍历模型的值，从字典中取值
// Ivar:成员变量 以下划线开头
// Property:属性
+ (instancetype)modelWithDict:(NSDictionary *)dict{
    id objc = [[self alloc] init];
    
    // runtime:根据模型中属性,去字典中取出对应的value给模型属性赋值
    // 1.获取模型中所有成员变量 key
    // 获取哪个类的成员变量
    // count:成员变量个数
    unsigned int count = 0;
    // 获取成员变量数组
    Ivar *ivarList = class_copyIvarList(self, &count);
    
    // 遍历所有成员变量
    for (int i = 0; i < count; i++) {
        // 获取成员变量
        Ivar ivar = ivarList[i];
        
        // 获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        // 获取成员变量类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        // @\"User\" -> User
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        ivarType = [ivarType stringByReplacingOccurrencesOfString:@"@" withString:@""];
        // 获取key
        NSString *key = [ivarName substringFromIndex:1];
        
        // 去字典中查找对应value
        // key:user  value:NSDictionary
        
        id value = dict[key];
        
        // 二级转换:判断下value是否是字典,如果是,字典转换层对应的模型
        // 并且是自定义对象才需要转换
        if ([value isKindOfClass:[NSDictionary class]] && ![ivarType hasPrefix:@"NS"]) {
            // 字典转换成模型 userDict => User模型
            // 转换成哪个模型
            
            // 获取类
            Class modelClass = NSClassFromString(ivarType);
            
            value = [modelClass modelWithDict:value];
        }
        
        // 给模型中属性赋值
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    
    return objc;
}

#pragma mark - 面试题
/*
 说说什么是runtime
 
 1>OC 是一个全动态语言，OC 的一切都是基于 Runtime 实现的
 平时编写的OC代码, 在程序运行过程中, 其实最终都是转成了runtime的C语言代码, runtime算是OC的幕后工作者
 比如:
 
 OC :
 [[Person alloc] init]
 runtime :
 objc_msgSend(objc_msgSend("Person" , "alloc"), "init")
 
 
 2>runtime是一套比较底层的纯C语言API, 属于1个C语言库, 包含了很多底层的C语言API
 3>runtimeAPI的实现是用 C++ 开发的(源码中的实现文件都是mm)，是一套苹果开源的框架
 */


@end

