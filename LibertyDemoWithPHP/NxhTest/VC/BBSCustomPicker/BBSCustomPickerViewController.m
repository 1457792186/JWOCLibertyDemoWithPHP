//
//  BBSCustomPickerViewController.m
//  NxhTest
//
//  Created by apple on 2017/10/25.
//  Copyright © 2017年 UgoMedia. All rights reserved.
//

#import "BBSCustomPickerViewController.h"
#import "DatePickerView.h"                //修改时间
#import "BBSChooseCityView.h"             //修改地址

@interface BBSCustomPickerViewController ()

@property(nonatomic,strong)DatePickerView * datepicker;
@property(nonatomic,strong)BBSChooseCityView * citypicker;

@end

@implementation BBSCustomPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setPickerView];
    [self setCityPiskerView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.datepicker removeFromSuperview];
        [self.citypicker removeFromSuperview];
    }];
}


#pragma mark - DatePicker
//创建视图
- (void)setPickerView{
    if (!self.datepicker) {
        __block  DatePickerView*datePicker=[[DatePickerView alloc]initWithCustomeHeight:215];
        self.datepicker=datePicker;
        __weak typeof(datePicker)weakDatePicker = datePicker;
        __weak typeof(self)weakSelf = self;
        
        datePicker.confirmBlock= ^(NSString *choseDate, NSString *restDate) {
            NSLog(@"choseDate = %@,restDate = %@",choseDate,restDate);
            
            //如果日期大于现在  return  提醒不能大于现在
            NSString * chooseDate = choseDate;
            NSString * nowDate = [self getNowTime];
            NSInteger compareResult= [self compareDate:chooseDate withDate:nowDate];
            if (compareResult!=1) {
                UIAlertAction * cancelBtn = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil];
                UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:@"请正确选择您的生日\n日期大于现在" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:cancelBtn];
                [self presentViewController:alertController animated:YES completion:nil];
                return ;
            }else{
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        };
        
        datePicker.cannelBlock = ^(){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
        
        self.datepicker.frame=CGRectMake(0, SCREENHEIGHT -215, SCREENWIDTH, 215);
    }
    
    UIWindow*window=[UIApplication sharedApplication].keyWindow;
    [window addSubview:self.datepicker];
}

//获取当前时间
- (NSString*)getNowTime{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    return dateString;
}

//比较两个时间
- (NSInteger)compareDate:(NSString*)firstDate withDate:(NSString*)compareDate{
    NSInteger resultCount;
    NSDateFormatter * dateFormate = [[NSDateFormatter alloc] init];
    [dateFormate setDateFormat:@"yyyy-MM-dd"];
    NSDate * dateFirst = [dateFormate dateFromString:firstDate];
    NSDate * dateCompare = [dateFormate dateFromString:compareDate];
    NSComparisonResult result = [dateFirst compare:dateCompare];
    switch (result){
            //date02比date01大
        case NSOrderedAscending: resultCount=1; break;
            //date02比date01小
        case NSOrderedDescending: resultCount=-1; break;
            //date02=date01
        case NSOrderedSame: resultCount=0; break;
        default: NSLog(@"erorr dates %@, %@", dateCompare, dateFirst); break;
    }
    return resultCount;
}

#pragma mark - CityPicker
//创建视图
- (void)setCityPiskerView{
    if (!self.citypicker) {
        __weak typeof(self)weakSelf = self;
        
        self.citypicker = [[BBSChooseCityView alloc] initWithCustomeHeight:160.f];
        self.citypicker.touchConfirmBlock = ^(NSDictionary *valueDic) {
            NSLog(@"cityInfo = %@",valueDic);
        };
        
        self.citypicker.touchCancelBlock = ^(){
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        };
    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.citypicker];
}


@end
