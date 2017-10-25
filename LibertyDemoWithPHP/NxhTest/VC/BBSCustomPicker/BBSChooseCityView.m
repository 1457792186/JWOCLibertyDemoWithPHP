//
//  YWChooseSexView.m
//  YuWa
//
//  Created by 蒋威 on 2016/11/14.
//  Copyright © 2016年 蒋威. All rights reserved.
//

#import "BBSChooseCityView.h"

@interface BBSChooseCityView()<UIPickerViewDelegate,UIPickerViewDataSource>

@property(nonatomic,strong)NSMutableDictionary * cityDic;
@property(nonatomic,strong)NSMutableArray * cityArr;
@property(nonatomic,strong)NSMutableDictionary * selectedCityDic;

@end
@implementation BBSChooseCityView

-(BBSChooseCityView*)initWithCustomeHeight:(CGFloat)height{
    self=[super initWithFrame:CGRectMake(0, 0, SCREENWIDTH, height=height<200?200:height)];
    if (self) {
        [self cityDicSet];
        
        self.selectedCityDic=nil;
        
        self.backgroundColor=[UIColor whiteColor];
        self.layer.borderWidth=1;
        self.layer.borderColor=[UIColor colorWithWhite:0 alpha:0.05].CGColor;
        
        //创建按钮
        UIButton*cannel=[UIButton buttonWithType:UIButtonTypeCustom];
        cannel.frame=CGRectMake(20, 0, 50, 40);
        [cannel setTitle:@"取消" forState:UIControlStateNormal];
        [cannel setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:0];
        cannel.tag=1;
        [cannel addTarget:self action:@selector(cannelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cannel];
        
        UIButton*confirm=[UIButton buttonWithType:UIButtonTypeCustom];
        confirm.frame=CGRectMake(SCREENWIDTH-70, 0, 50, 40);
        [confirm setTitle:@"确定" forState:0];
        [confirm setTitleColor:[UIColor colorWithRed:0 green:183/255.0 blue:231/255.0 alpha:1] forState:0];
        confirm.tag=2;
        [confirm addTarget:self action:@selector(cannelOrConfirm:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirm];
        
        _pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, height-40)];
        _pickerView.backgroundColor=[UIColor whiteColor];
        self.pickerView.delegate = self;
        self.pickerView.dataSource = self;
        [self addSubview:_pickerView];
        
    }
    
    return self;
}

- (void)cityDicSet{
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"Setting" ofType:@"plist"];
    NSDictionary * dataDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    _cityDic = [NSMutableDictionary dictionaryWithDictionary:dataDic[@"CityArr"]];
    _cityArr = [NSMutableArray arrayWithArray:_cityDic[@"1"]];
}

-(void)cannelOrConfirm:(UIButton*)sender{
    if (sender.tag==1) {
        if (_touchCancelBlock) {
            self.touchCancelBlock();
        }
    }else{
        if (_touchCancelBlock) {
            self.touchConfirmBlock(self.selectedCityDic);
        }
         self.touchCancelBlock();
    }
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return _cityArr.count;
    }
    
    if (self.selectedCityDic) {
        return 3;
    }else{
        return 0;
    }
    
}
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return [[_cityArr objectAtIndex:row] objectForKey:@"f_description"];
    }
    NSArray*array=@[@"男",@"女",@"未知"];
    return array[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
}

//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *){
//
//}

@end
