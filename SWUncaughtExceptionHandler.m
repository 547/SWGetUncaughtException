//
//  SWUncaughtExceptionHandler.m
//  NSURLSessionTest
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 Seven. All rights reserved.
//

#import "SWUncaughtExceptionHandler.h"
#import <execinfo.h>
#import <libkern/OSAtomic.h>
#import <UIKit/UIKit.h>

@implementation SWUncaughtExceptionHandler

@end
void getUncaughtException(NSException *exception)
{
    //1.一旦进入到该方法 那么程序是肯定要挂掉的 要及时的整理崩溃日志，崩溃版本，崩溃设备，以及崩溃时间  及时的发送给服务器
    NSString *deviceName= [UIDevice currentDevice].name;//获取设备的名称例如："My iPhone"
    NSString *model = [UIDevice currentDevice].model;//获取设备 例如：@"iPhone", @"iPod touch"
    NSString *systemVersion = [UIDevice currentDevice].systemVersion;//获取设备的系统版本如：@"4.0"
    NSString *systemName = [UIDevice currentDevice].systemName;//获取设备系统名称如：ios
    NSDate *now = [NSDate date];//获取发生崩溃时间
    
    //2.获取程序崩溃的原因等相关信息
    /*
     @property (readonly, copy) NSString *name;==异常类型
     @property (nullable, readonly, copy) NSString *reason;==非常重要，崩溃的原因
     @property (nullable, readonly, copy) NSDictionary *userInfo;==用户信息
     
     @property (readonly, copy) NSArray<NSNumber *> *callStackReturnAddresses;
     @property (readonly, copy) NSArray<NSString *> *callStackSymbols;==得到当前调用栈信息
     */
    NSString *exName=exception.name;
    NSString *exReason=exception.reason;
    NSArray *addresses=exception.callStackReturnAddresses;
    NSArray *symbols=exception.callStackSymbols;
    //3.将程序崩溃前获取得到的异常信息发送到公司的服务器为异常提供的专用接口
    //3.或者发送到开发者的邮箱，不过此种方式需要得到用户的许可，因为iOS不能后台发送短信或者邮件，会弹出发送邮件的界面，只有用户点击了发送才可发送。 不过，此种方式最符合苹果的以用户至上的原则。
    
    //异常的所有信息==即要返回到服务器或邮箱的异常信息
    NSString *exInfo=[NSString stringWithFormat:@"设备名称：%@\n设备：%@\n设备的系统版本:%@\n设备系统名称:%@\n发生崩溃时间:%@\n异常类型:%@\n崩溃的原因:%@\n当前调用栈信息:%@\n当前调用栈地址：%@\n",deviceName,model,systemVersion,systemName,now,exName,exReason,symbols,addresses];
    NSLog(@"%@",exInfo);
    
    //把异常信息发至开发者邮箱
    NSString *urlStr=[NSString stringWithFormat:@"mailto://1093031562@qq.com?subject=bug报告，感谢您的配合！&body=%@",exInfo];
    NSURL *url=[NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [[UIApplication sharedApplication]openURL:url];
}

void installUncaughtException(void)
{
    NSSetUncaughtExceptionHandler(&getUncaughtException);
}