//
//  TSVideoContext.m
//  TaskService
//
//  Created by Rain on 1/28/16.
//  Copyright © 2016 Huawei. All rights reserved.
//

#import "SVVideoTestContext.h"

/**
 * 视频Context
 *
 - returns: 视频Context
 */

@implementation SVVideoTestContext

@synthesize urlArray, videoURLString, videoSegementInfo, videoPlayDuration, videoClarity, vid;

/**
 *  初始化后做一下操作。用于子类进行重写
 */
- (void)handleAfterInit
{
    // do nothing
}

/**
 *  设置URLs字符串
 *
 *  @param videoURLsString URLs字符串
 */
- (void)setVideoURLsString:(NSString *)videoURLsString
{
    urlArray = [[NSMutableArray alloc] init];
    NSArray *urlArrayTemp = [videoURLsString componentsSeparatedByString:@"\r\n"];
    for (NSString *url in urlArrayTemp)
    {
        // 过滤掉为空的url
        if (!url || [url isEqualToString:@""])
        {
            continue;
        }

        [urlArray addObject:url];
    }
    if (urlArray)
    {
        int index = arc4random () % urlArray.count;
        videoURLString = [urlArray objectAtIndex:index];
    }
}

@end
