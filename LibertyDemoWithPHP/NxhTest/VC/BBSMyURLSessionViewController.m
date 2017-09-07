//
//  BBSMyURLSessionViewController.m
//  NxhTest
//
//  Created by apple on 2017/8/18.
//  Copyright © 2017年 JiangWei. All rights reserved.
//

#import "BBSMyURLSessionViewController.h"


#define BaseURL @"http://127.0.0.1/tp5/public/index/"
//测试域名为本地，与git中的ThinkPHPLearn中的app\demoAPI\controller\index.php中的read方法配套使用;

@interface BBSMyURLSessionViewController ()<NSURLSessionDataDelegate>

@property (strong,nonatomic)UITextView * dataTextView;

@end

@implementation BBSMyURLSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"本地数据库连接PHP测试";
    
    _dataTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT/3.f, SCREENWIDTH, SCREENHEIGHT*2/3.f)];
    _dataTextView.textColor = [UIColor blackColor];
    _dataTextView.backgroundColor = [UIColor greenColor];
    _dataTextView.editable = NO;
    [self.view addSubview:_dataTextView];
    
    //urlSession链接
    [self urlConnection];
    
    //urlSession链接配置代理
    [self urlConnectionWithDeledate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"%@",_dataTextView.text);
    }];
}

#pragma mark - NSURLSession Connect
//urlSession链接
- (void)urlConnection{
    NSString * api = [NSString stringWithFormat:@"%@demoAPI/index/read/",BaseURL];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"id=2" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    // 由于要先对request先行处理,我们通过request初始化task
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            //            数据处理
            NSString *jsonstring=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                _dataTextView.text = [NSString stringWithString:jsonstring];
            });
            //            json解析
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",jsonData);
        }
    }];
    
    [task resume];
}



#pragma mark - NSURLSession Connect With  Delegate
//urlSession链接配置代理
- (void)urlConnectionWithDeledate{
    NSString * api = [NSString stringWithFormat:@"%@demoAPI/index/read/",BaseURL];
    NSURL *url = [NSURL URLWithString:api];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.HTTPBody = [@"id=2" dataUsingEncoding:NSUTF8StringEncoding];
    
    //设置NSURLSessionDataDelegate代理
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                          delegate:self
                                                     delegateQueue:[[NSOperationQueue alloc] init]];
    
    // 由于要先对request先行处理,我们通过request初始化task
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            //            数据处理
            NSString *jsonstring=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//            _dataTextView.text = [NSString stringWithString:jsonstring];
            //            json解析
            NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            NSLog(@"%@",jsonData);
        }
    }];
    
    [task resume];
}

#pragma mark - NSURLSessionDataDelegate
// 1.接收到服务器的响应
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    // 允许处理服务器的响应，才会继续接收服务器返回的数据
    completionHandler(NSURLSessionResponseAllow);
}

// 2.接收到服务器的数据（可能调用多次）
- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    // 处理每次接收的数据
}

// 3.请求成功或者失败（如果失败，error有值）
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    // 请求完成,成功或者失败的处理
}

@end
