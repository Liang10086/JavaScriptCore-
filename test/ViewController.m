//
//  ViewController.m
//  test
//
//  Created by 王明亮 on 2018/9/25.
//  Copyright © 2018年 王明亮. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView * webView;
@property (nonatomic,weak) JSContext * context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.webView];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"html"];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    
    
    //创建两个原生button,演示调用js方法
    UIButton * btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, 200, 50);
    btn1.backgroundColor = [UIColor blackColor];
    [btn1 setTitle:@"OC调用无参JS" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(function1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    UIButton * btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2+100, 200, 50);
    btn2.backgroundColor = [UIColor blackColor];
    [btn2 setTitle:@"OC调用JS(传参)" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(function2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];

    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@",request);
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"开始加载网页");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"网页加载完毕");
    JSContext *context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"test1"] = ^(){
        NSLog(@"HTML调用oc");
    };
    context[@"test2"] = ^(){
        NSLog(@"HTML带参数调用");
        NSArray *args = [JSContext currentArguments];
    };
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"加载失败");
}
- (void)function1{
    NSLog(@"11");
    [self.webView stringByEvaluatingJavaScriptFromString:@"aaa()"];
}
- (void)function2{
    NSLog(@"22");
    [_webView stringByEvaluatingJavaScriptFromString:@"bbb(11,22);"];
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _webView.delegate = self;
    }
    return _webView;
}

@end
