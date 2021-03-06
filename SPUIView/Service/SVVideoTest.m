//
//  SVVideoTest.m
//  SPUIView
//
//  Created by Rain on 2/6/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//
#import "SVDBManager.h"
#import "SVIPAndISPGetter.h"
#import "SVLog.h"
#import "SVProbeInfo.h"
#import "SVTestContextGetter.h"
#import "SVTimeUtil.h"
#import "SVVideoPlayer.h"
#import "SVVideoSegement.h"
#import "SVVideoTest.h"
#import "SVYoukuVideoPlayer.h"
#import "SVYoutubeVideoPlayer2.h"

@implementation SVVideoTest
{
    @private

    // 测试ID
    long long _testId;

    //播放视频的 UIView 组建
    UIView *_showVideoView;

    // 视频地址
    NSString *_videoPath;

    // 视频播放器
    SVVideoPlayer *_videoPlayer;

    // 测试状态
    TestStatus testStatus;

    // SQL 语句
    NSString *insertSVDetailResultModelSQL;
}

@synthesize testResult, testContext;

/**
 *  初始化视频测试对象，初始化必须放在UI主线程中进行
 *
 *  @param testId        测试ID
 *  @param showVideoView UIView 用于显示播放视频
 *
 *  @return 视频测试对象
 */
- (id)initWithView:(long long)testId
     showVideoView:(UIView *)showVideoView
      testDelegate:(id<SVVideoTestDelegate>)testDelegate
{
    self = [super init];
    if (!self)
    {
        return nil;
    }

    _testId = testId;
    _showVideoView = showVideoView;
    testStatus = TEST_TESTING;

    if (!_videoPlayer)
    {

        SVTestContextGetter *contextGetter = [SVTestContextGetter sharedInstance];
        BOOL isYoutube = [contextGetter isYoutube];
        //        BOOL isYoutube = true;
        if (isYoutube)
        {
            //初始化播放器
            _videoPlayer =
            [[SVYoutubeVideoPlayer2 alloc] initWithView:_showVideoView testDelegate:testDelegate];
        }
        else
        {
            //初始化播放器
            _videoPlayer =
            [[SVYoukuVideoPlayer alloc] initWithView:_showVideoView testDelegate:testDelegate];
        }
    }
    SVInfo (@"SVVideoTest testID:%lld  showVideoView:%@", testId, showVideoView);
    return self;
}

/**
 *  初始化TestContext
 */
- (BOOL)initTestContext
{
    @try
    {
        // 初始化TestResult
        if (!testResult)
        {
            testResult = [[SVVideoTestResult alloc] init];
            [testResult setTestId:_testId];
            [testResult setTestTime:_testId];
        }

        // 初始化TestContext
        SVTestContextGetter *contextGetter = [SVTestContextGetter sharedInstance];
        testContext = [contextGetter getVideoContext];
        if (!testContext)
        {
            [testResult setErrorCode:1];
            SVError (@"test[testId=%lld] fail. there is no test context", _testId);
            return false;
        }
        return true;
    }
    @catch (NSException *exception)
    {
        SVError (@"init test context fail:%@", exception);
        testStatus = TEST_ERROR;
        return false;
    }
}

/**
 *  开始测试
 */
- (BOOL)startTest
{
    @try
    {
        @synchronized (_showVideoView)
        {
            if (testStatus == TEST_TESTING)
            {
                // 开始播放视频
                [_videoPlayer setTestContext:testContext];
                [_videoPlayer setTestResult:testResult];
                [_videoPlayer play];
            }
        }

        while (!_videoPlayer.isFinished)
        {
            [NSThread sleepForTimeInterval:0.1];
        }

        SVInfo (@"test[%lld] finished", _testId);
    }
    @catch (NSException *exception)
    {
        SVError (@"start test video fail:%@", exception);
        testStatus = TEST_ERROR;
        return false;
    }

    return true;
}

/**
 *   停止测试
 */
- (BOOL)stopTest
{
    @synchronized (_showVideoView)
    {
        if (testStatus == TEST_TESTING)
        {
            testStatus = TEST_FINISHED;
        }

        if (_videoPlayer)
        {
            @try
            {
                //初始化播放器
                [_videoPlayer stop];
                SVInfo (@"stop test [testId=%lld]", _testId);
            }
            @catch (NSException *exception)
            {
                SVError (@"stop play video fail. %@", exception);
                return false;
            }
        }
    }

    if (testResult)
    {
        if (testContext.testStatus == TEST_ERROR)
        {
            [self resetResult];
        }
        else
        {
            // 持久化结果明细
            [self persistSVDetailResultModel];
            SVInfo (@"persist test[testId=%lld] result success", _testId);
        }
    }

    return true;
}

/**
 *   停止测试前的准备工作
 */
- (BOOL)prepareStopTest
{
    @synchronized (_showVideoView)
    {
        if (testStatus == TEST_TESTING)
        {
            testStatus = TEST_FINISHED;
        }

        if (_videoPlayer)
        {
            @try
            {
                // 暂停播放
                [_videoPlayer pause];
            }
            @catch (NSException *exception)
            {
                SVError (@"pause play video fail. %@", exception);
                return false;
            }
        }
    }

    return true;
}

/**
 *  获取持久化数据的SQL语句
 *
 *  @return SQL语句
 */
- (NSString *)getPersistDataSQL
{
    return insertSVDetailResultModelSQL;
}

/**
 *  持久化结果明细
 */
- (void)persistSVDetailResultModel
{
    //    SVDBManager *db = [SVDBManager sharedInstance];
    @try
    {
        //        // 如果表不存在，则创建表
        //        [db executeUpdate:@"CREATE TABLE IF NOT EXISTS SVDetailResultModel(ID integer
        //        PRIMARY KEY "
        //                          @"AUTOINCREMENT, testId integer, testType integer, testResult
        //                          text, "
        //                          @"testContext text, probeInfo text);"];

        insertSVDetailResultModelSQL =
        [NSString stringWithFormat:@"INSERT INTO "
                                   @"SVDetailResultModel (testId,testType,testResult, testContext, "
                                   @"probeInfo) VALUES(%lld, %d, "
                                   @"'%@', '%@', '%@');",
                                   _testId, VIDEO, [self testResultToJsonString],
                                   [self testContextToJsonString], [self testProbeInfo]];
        // 插入结果明细
        //        [db executeUpdate:insertSVDetailResultModelSQL];
    }
    @catch (NSException *exception)
    {
        SVError (@"execute insert SVDetailResultModel SQL[%@] fail. Exception:  %@",
                 insertSVDetailResultModelSQL, exception);
    }
}


- (NSString *)testProbeInfo
{
    SVProbeInfo *probeInfo = [SVProbeInfo sharedInstance];

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    SVIPAndISP *ipAndISP = [[SVIPAndISPGetter sharedInstance] getIPAndISP];
    if (!ipAndISP)
    {
        return @"";
    }

    [dictionary setObject:!ipAndISP.isp ? @"" : ipAndISP.isp forKey:@"isp"];
    [dictionary setObject:!probeInfo.ip ? @"" : probeInfo.ip forKey:@"ip"];
    int networkType = !probeInfo.networkType ? 1 : probeInfo.networkType;
    [dictionary setObject:[[NSNumber alloc] initWithInt:networkType] forKey:@"networkType"];
    NSString *bandwidth = [probeInfo getBandwidth];
    [dictionary setObject:!bandwidth ? @"" : bandwidth forKey:@"signedBandwidth"];

    return [self dictionaryToJsonString:dictionary];
}

- (NSString *)testResultToJsonString
{
    float sQualitySession = !testResult.sQualitySession ? 0 : testResult.sQualitySession;
    float sInteractionSession = !testResult.sInteractionSession ? 0 : testResult.sInteractionSession;
    float sViewSession = !testResult.sViewSession ? 0 : testResult.sViewSession;
    float UvMOSSession = !testResult.UvMOSSession ? 0 : testResult.UvMOSSession;
    float firstBufferTime = !testResult.firstBufferTime ? 0 : testResult.firstBufferTime;
    int videoCuttonTimes = !testResult.videoCuttonTimes ? 0 : testResult.videoCuttonTimes;
    int videoCuttonTotalTime = !testResult.videoCuttonTotalTime ? 0 : testResult.videoCuttonTotalTime;
    float downloadSpeed = !testResult.downloadSpeed ? 0 : testResult.downloadSpeed;
    float maxDownloadSpeed = !testResult.maxDownloadSpeed ? 0 : testResult.maxDownloadSpeed;
    int videoWidth = !testResult.videoWidth ? 0 : testResult.videoWidth;
    int videoHeight = !testResult.videoHeight ? 0 : testResult.videoHeight;
    float frameRate = !testResult.frameRate ? 0 : testResult.frameRate;
    float bitrate = !testResult.bitrate ? 0 : testResult.bitrate;
    float screenSize = !testResult.screenSize ? 0 : testResult.screenSize;
    int playDuration = !testResult.videoPlayTime ? 0 : testResult.videoPlayTime;
    int errorCode = !testResult.errorCode ? 0 : testResult.errorCode;

    NSString *videoResolution = !testResult.videoResolution ? @"" : testResult.videoResolution;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    [dictionary setObject:[[NSNumber alloc] initWithLongLong:testResult.testTime]
                   forKey:@"testTime"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:sQualitySession]
                   forKey:@"sQualitySession"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:sInteractionSession]
                   forKey:@"sInteractionSession"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:sViewSession] forKey:@"sViewSession"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:UvMOSSession] forKey:@"UvMOSSession"];
    [dictionary setObject:[[NSNumber alloc] initWithLong:firstBufferTime]
                   forKey:@"firstBufferTime"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:videoCuttonTimes]
                   forKey:@"videoCuttonTimes"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:videoCuttonTotalTime]
                   forKey:@"videoCuttonTotalTime"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:downloadSpeed] forKey:@"downloadSpeed"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:maxDownloadSpeed]
                   forKey:@"maxDownloadSpeed"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:videoWidth] forKey:@"videoWidth"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:videoHeight] forKey:@"videoHeight"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:frameRate] forKey:@"frameRate"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:bitrate] forKey:@"bitrate"];
    [dictionary setObject:[[NSNumber alloc] initWithFloat:screenSize] forKey:@"screenSize"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:playDuration] forKey:@"playDuration"];
    [dictionary setObject:videoResolution forKey:@"videoResolution"];
    [dictionary setObject:[[NSNumber alloc] initWithInt:errorCode] forKey:@"errorCode"];
    return [self dictionaryToJsonString:dictionary];
}

- (NSString *)testContextToJsonString
{
    NSString *videoURLString = !testContext.videoURLString ? @"" : testContext.videoURLString;
    int videoPlayDuration = !testContext.videoPlayDuration ? 60 : testContext.videoPlayDuration;
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];

    [dictionary setObject:[NSNumber numberWithInt:videoPlayDuration] forKey:@"videoPlayDuration"];
    [dictionary setObject:videoURLString forKey:@"videoURL"];

    for (SVVideoSegement *segement in testContext.videoSegementInfo)
    {
        NSMutableDictionary *segementDic = [[NSMutableDictionary alloc] init];
        int videoSegementSize = !segement.size ? 0 : segement.size;
        int videoSegementDuration = !segement.duration ? 0 : segement.duration;
        float videoSegementBitrate = !segement.bitrate ? 0 : segement.bitrate;
        NSString *videoSegementIP = !segement.videoIP ? @"" : segement.videoIP;
        NSString *videoSegemnetLocation = !segement.videoLocation ? @"" : segement.videoLocation;
        NSString *videoSegemnetISP = !segement.videoISP ? @"" : segement.videoISP;

        [segementDic setObject:[[NSNumber alloc] initWithInt:videoSegementSize]
                        forKey:@"videoSegementSize"];
        [segementDic setObject:[[NSNumber alloc] initWithLong:videoSegementDuration]
                        forKey:@"videoSegementDuration"];
        [segementDic setObject:[[NSNumber alloc] initWithFloat:videoSegementBitrate]
                        forKey:@"videoSegementBitrate"];
        [segementDic setObject:videoSegementIP forKey:@"videoSegementIP"];
        [segementDic setObject:videoSegemnetLocation forKey:@"videoSegemnetLocation"];
        [segementDic setObject:videoSegemnetISP forKey:@"videoSegemnetISP"];

        NSString *segementJsonStr = [self dictionaryToJsonString:segementDic];

        // 将%替换为%%，防止转json时将%当特殊字符处理
        NSString *segementUrl = segement.videoSegementURLStr;
        segementUrl = [segementUrl stringByReplacingOccurrencesOfString:@"%" withString:@"%%"];
        [dictionary setValue:segementJsonStr forKey:segementUrl];
    }

    return [self dictionaryToJsonString:dictionary];
}

// 将字典转换成json字符串
- (NSString *)dictionaryToJsonString:(NSMutableDictionary *)dictionary
{
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    if (error)
    {
        SVError (@"%@", error);
        return @"";
    }
    else
    {
        NSString *resultJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        return resultJson;
    }
}

/**
 *  重置结果
 */
- (void)resetResult
{
    SVInfo (@"reset videotest result.");

    testResult.sQualitySession = -1;
    testResult.sInteractionSession = -1;
    testResult.UvMOSSession = -1;
    testResult.sViewSession = -1;
    testResult.firstBufferTime = -1;
    testResult.videoCuttonTimes = -1;
    testResult.videoCuttonTotalTime = -1;
    testResult.downloadSpeed = -1;
    testResult.maxDownloadSpeed = -1;
    testResult.videoWidth = -1;
    testResult.videoHeight = -1;
    testResult.frameRate = -1;
    testResult.bitrate = -1;
    testResult.screenSize = -1;
    testResult.videoPlayTime = -1;
    if (testResult.errorCode == 0)
    {
        testResult.errorCode = 3;
    }


    [self persistSVDetailResultModel];
}

@end
