//
//  BBSCoreDataViewController.m
//  NxhTest
//
//  Created by apple on 2017/12/12.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSCoreDataViewController.h"
//#import "UploadEntity+CoreDataProperties.h"

static NSString * const bbsModelName = @"BBSDataModel";
static NSString * const bbsEntityName = @"UploadEntity";
static NSString * const bbsSqliteName = @"BBSDataModel.sqlite";

#import "JWCoreDataAPI.h"
//封装方法

@interface BBSCoreDataViewController ()

@property (nonatomic,strong)NSManagedObjectContext *context;

@end

@implementation BBSCoreDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"CoreData";
    [self openTable];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//添加关联数据库
- (void)openTable{
    //1、创建模型对象
    //获取模型路径
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:bbsModelName withExtension:@"momd"];
    //根据模型文件创建模型对象
    NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    // 创建模型对象法2.从应用程序包中加载.xcdatamodeld模型文件
//    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    //2、创建持久化助理
    //利用模型对象创建助理对象，以传入NSManagedObjectModel模型方式初始化持久化存储库
    NSPersistentStoreCoordinator *persistent = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    
    NSError *error = nil;
    //数据库的名称和路径 名字最好和.xcdatamodeld文件的名字一样
    NSString *docStr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlPath = [docStr stringByAppendingPathComponent:bbsSqliteName];
    NSLog(@"path = %@", sqlPath);
    NSURL *sqlUrl = [NSURL fileURLWithPath:sqlPath];
    
    //设置数据库相关信息
    /*
     持久化存储库的类型：
     NSSQLiteStoreType  SQLite数据库
     NSBinaryStoreType  二进制平面文件
     NSInMemoryStoreType 内存库，无法永久保存数据
     虽然这3种类型的性能从速度上来说都差不多，但从数据模型中保留下来的信息却不一样
     在几乎所有的情景中，都应该采用默认设置，使用SQLite作为持久化存储库
     */
    // 添加一个持久化存储库并设置类型和路径，NSSQLiteStoreType：SQLite作为存储库
    [persistent addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:sqlUrl options:nil error:&error];
    if (error) {
        NSLog(@"添加数据库失败:%@",error);
    } else {
        NSLog(@"添加数据库成功");
    }
    
    //3、创建上下文
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    
    //设置上下文所要关联的持久化存储库——关联持久化助理
    [context setPersistentStoreCoordinator:persistent];
    
    _context = context;
    
    //4.描述实体
//    通过Core Data从数据库中取出的对象,默认情况下都是NSManagedObject对象.
//    NSManagedObject的工作模式有点类似于NSDictionary对象,通过键-值对来存取所有的实体属性.
//  setValue:forkey:存储属性值(属性名为key);
//  valueForKey:获取属性值(属性名为key).
//    每个NSManagedObject都知道自己属于哪个NSManagedObjectContext
    // 创建方式（用于插入数据使用：获得实体，改变实体各个属性值，保存后就代表插入）
    /**
     注意：不能用 alloc init方式创建
     通过传入上下文和实体名称，创建一个名称对应的实体对象
     （相当于数据库一组数据，其中含有多个字段）
     个人感觉有种先插入一个新的Entity从而获得Entity，在进行各属性赋值
     */
//    NSManagedObject *newEntity = [NSEntityDescription insertNewObjectForEntityForName:bbsEntityName inManagedObjectContext:self.context];
    
}

- (void)insert{
//    1.根据Entity名称和NSManagedObjectContext获取一个新的NSManagedObject
    NSManagedObject *newEntity = [NSEntityDescription
                                  insertNewObjectForEntityForName:bbsEntityName
                                  inManagedObjectContext:self.context];
//    2.根据Entity中的键值，一一对应通过setValue:forkey:给NSManagedObject对象赋值
    [newEntity setValue:@"" forKey:@"fileName"];//@"fileName"为任意值
//    3.保存修改
    NSError *error = nil;
    BOOL result = [self.context save:&error];
}

- (void)delete{
//    1.通过查询（设置好查询条件）请求取得需要删除的NSManagedObject的所有集合
//    2.通过for循环调用deleteObject:方法进行逐个删除（个人怀疑这个for循环会不会导致性能问题），暂时没发现其它删除方法。
//        [self.context deleteObject:entity];
//    3.保存修改
}
- (void)update{
//    1.通过查询（设置好查询条件）请求取得需要修改的NSManagedObject的所有集合
//    2.通过for循环调用NSManagedObject对象的setValue:forkey:方法给各个属性赋值
//    3.保存修改
}
- (void)read{
////    1.创建NSFetchRequest查询请求对象
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
////    2.设置需要查询的实体描述NSEntityDescription
//    NSEntityDescription *desc = [NSEntityDescription entityForName:bbsEntityName
//                                            inManagedObjectContext:self.context];
//    request.entity = desc;
////    3.设置排序顺序NSSortDescriptor对象集合(可选)
//    request.sortDescriptors = descriptorArray;
////    4.设置条件过滤（可选）
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:filterStr];
//    request.predicate = predicate;
////    5.执行查询请求
//    NSError *error = nil;
//    // NSManagedObject对象集合
//    NSArray *objs = [self.context executeFetchRequest:request error:&error];
//    // 查询结果数目
//    NSUInteger count = [self.context countForFetchRequest:request error:&error];
}

@end
