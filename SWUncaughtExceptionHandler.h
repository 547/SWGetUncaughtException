//
//  SWUncaughtExceptionHandler.h
//  NSURLSessionTest
//
//  Created by mac on 16/3/17.
//  Copyright © 2016年 Seven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SWUncaughtExceptionHandler : NSObject
//c的函数
void getUncaughtException(NSException *exception);//获取为捕获的异常
void installUncaughtException(void);




@end
