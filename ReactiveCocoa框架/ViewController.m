//
//  ViewController.m
//  ReactiveCocoa框架
//
//  Created by apple on 15/10/18.
//  Copyright © 2015年 小码哥. All rights reserved.
//

#import "ViewController.h"

#import "ReactiveCocoa.h"

#import "RACReturnSignal.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

@implementation ViewController
// 前面拼接xmg
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 创建信号中信号
    RACSubject *signalOfSignals = [RACSubject subject];
    
    // 创建信号
    RACSubject *signal = [RACSubject subject];
    
    // 通过订阅signalOfSignals拿到signal发送值
    
//    [[signalOfSignals flattenMap:^RACStream *(id value) {
//        return value;
//    }] subscribeNext:^(id x) {
//       
//        NSLog(@"%@",x);
//    }];
    
    [signalOfSignals.flatten subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
    }];
    
    
    // 信号中的信号发送信号
    [signalOfSignals sendNext:signal];
    
    [signal sendNext:@"123"];
    [signal sendNext:@"321"];
    
    
    
}

// 用于普通信号,信号发出普通值
- (void)map
{
    [[_textField.rac_textSignal map:^id(id value) {
        // value:源信号的内容
        // 返回值,就是处理源信号的内容,直接返回
        return [NSString stringWithFormat:@"----xmg%@",value];
        
    }] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
}

// 信号中信号,signalOfSignals
- (void)flattenMap
{
    [[_textField.rac_textSignal flattenMap:^RACStream *(id value) {
        // value:源信号的内容
        value = [NSString stringWithFormat:@"xmg%@",value];
        // 返回值:信号,把处理完的值包装成信号返回出去
        return [RACReturnSignal return:value];
    }] subscribeNext:^(id x) {
        // 订阅[RACReturnSignal return:value发送值
        
        // x:绑定信号的值
        NSLog(@"%@",x);
    }];
}


@end
