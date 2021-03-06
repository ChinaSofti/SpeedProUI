//
//  SVWebTestResult.h
//  SpeedPro
//
//  Created by 徐瑞 on 16/3/4.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "SVTestResult.h"

@interface SVWebTestResult : SVTestResult

// 测试时间
@property long long testTime;

// 测试的url
@property NSString *testUrl;

// 下载大小
@property double downloadSize;

// 响应时间
@property double responseTime;

// 完整下载时间
@property double totalTime;

// 下载速度
@property double downloadSpeed;

// 当前url是否测试结束
@property BOOL finished;

@end
