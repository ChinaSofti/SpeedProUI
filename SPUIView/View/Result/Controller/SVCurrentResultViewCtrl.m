//
//  SVCurrentResultViewCtrl.m
//  SPUIView
//
//  Created by Rain on 2/14/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import "SVCurrentResultViewCtrl.h"
#import "SVDetailViewCtrl.h"
#import "SVResultPush.h"
#import "SVTestViewCtrl.h"
#import <SPCommon/SVDBManager.h>
#import <SPCommon/SVSystemUtil.h>
#import <SPCommon/SVTimeUtil.h>
#import <SPService/SVTestContextGetter.h>
#define kFirstHederH 40
#define kLastFooterH 140
#define kCellH (kScreenW - 20) * 0.22
#define kMargin 10
#define kCornerRadius 5
#define valueFontSize 17
#define valueLableFontSize 12


@implementation SVCurrentResultViewCtrl
{
    NSMutableArray *_buttons;
    UITableView *_tableView;
    BOOL isSave;


    // 视频
    UILabel *_uvMosLabelValue;
    UILabel *_firstBufferTimeLabelValue;
    UILabel *_cuttonTimesLabelValue;

    // 网页
    UILabel *_responseLabelValue;
    UILabel *_loadLabelValue;
    UILabel *_downloadLabelValue;

    // 带宽
    UILabel *_dtDelayLabelValue;
    UILabel *_dtDownloadLabelValue;
    UILabel *_dtUploadLabelValue;


    NSString *_title1;
    NSString *_title2;
    NSString *_title3;
    NSString *_title4;
    NSString *_title5;
    NSString *_title6;
    NSString *_timeoutTitle;

    NSString *_delayTitle;
    NSString *_downloadSpeedTitle;
    NSString *_uploadSpeedTitle;
}


- (void)viewWillAppear:(BOOL)animated
{
    // 刷新视频
    if (_resultModel.uvMOS == -1)
    {
        [_uvMosLabelValue setText:_title1];
    }
    else
    {
        [_uvMosLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.uvMOS]];
    }

    if (_resultModel.firstBufferTime == -1)
    {
        [_firstBufferTimeLabelValue setText:_title1];
    }
    else
    {
        [_firstBufferTimeLabelValue setText:[NSString stringWithFormat:@"%d", _resultModel.firstBufferTime]];
    }

    if (_resultModel.cuttonTimes == -1)
    {
        [_cuttonTimesLabelValue setText:_title1];
    }
    else
    {
        [_cuttonTimesLabelValue setText:[NSString stringWithFormat:@"%d", _resultModel.cuttonTimes]];
    }

    // 刷新网页
    if (!_resultModel.responseTime || _resultModel.responseTime < 0)
    {
        [_responseLabelValue setText:_timeoutTitle];
    }
    else
    {
        [_responseLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.responseTime]];
    }

    if (!_resultModel.totalTime || _resultModel.totalTime < 0)
    {
        [_loadLabelValue setText:_timeoutTitle];
    }
    else
    {
        [_loadLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.totalTime]];
    }

    if (!_resultModel.downloadSpeed || _resultModel.downloadSpeed < 0)
    {
        [_downloadLabelValue setText:_timeoutTitle];
    }
    else
    {
        [_downloadLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.downloadSpeed]];
    }

    // 刷新带宽
    if (!_resultModel.stDelay || _resultModel.stDelay <= 0)
    {
        [_dtDelayLabelValue setText:_title1];
    }
    else
    {
        [_dtDelayLabelValue setText:[NSString stringWithFormat:@"%.0f", _resultModel.stDelay]];
    }

    if (!_resultModel.stDownloadSpeed || _resultModel.stDownloadSpeed <= 0)
    {
        [_dtDownloadLabelValue setText:_title1];
    }
    else
    {
        [_dtDownloadLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.stDownloadSpeed]];
    }

    if (!_resultModel.stUploadSpeed || _resultModel.stUploadSpeed <= 0)
    {
        [_dtUploadLabelValue setText:_title1];
    }
    else
    {
        [_dtUploadLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.stUploadSpeed]];
    }

    // 持久化测试结果
    if (!isSave)
    {
        [self persistSVSummaryResultModel];
        dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [[SVResultPush alloc] initWithURLNSString:nil
                                             testId:[[NSNumber alloc] initWithLong:_resultModel.testId]];
        });

        isSave = YES;
    }
}

- (id)initWithResultModel:(SVCurrentResultModel *)resultModel
{
    self = [super init];
    if (!self)
    {
        return nil;
    }

    _resultModel = resultModel;
    _buttons = [[NSMutableArray alloc] init];
    isSave = NO;
    return self;
}

- (void)initButtons
{
    _title1 = I18N (@"Fail");
    _title2 = I18N (@"Initial buffer time");
    _title3 = I18N (@"Butter times");
    _title4 = I18N (@"Response Time");
    _title5 = I18N (@"Load duration");
    _title6 = I18N (@"Download");
    _timeoutTitle = I18N (@"Timeout");

    _delayTitle = I18N (@"Delay");
    _downloadSpeedTitle = I18N (@"Download speed");
    _uploadSpeedTitle = I18N (@"Upload speed");

    // 1.
    UIButton *_bgdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgdBtn.frame = CGRectMake (kMargin, 0, kScreenW - 2 * kMargin, kCellH);
    _bgdBtn.layer.cornerRadius = kCornerRadius * 2;
    _bgdBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgdBtn.layer.borderWidth = 1;
    [_bgdBtn addTarget:self
                action:@selector (CellVideoDetailClick:)
      forControlEvents:UIControlEventTouchUpInside];

    // 2.
    UIButton *_bgdBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgdBtn2.frame = CGRectMake (kMargin, 0, kScreenW - 2 * kMargin, kCellH);
    _bgdBtn2.layer.cornerRadius = kCornerRadius * 2;
    _bgdBtn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgdBtn2.layer.borderWidth = 1;
    [_bgdBtn2 addTarget:self
                 action:@selector (CellWebDetailClick:)
       forControlEvents:UIControlEventTouchUpInside];

    // 3.
    UIButton *_bgdBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    _bgdBtn3.frame = CGRectMake (kMargin, 0, kScreenW - 2 * kMargin, kCellH);
    _bgdBtn3.layer.cornerRadius = kCornerRadius * 2;
    _bgdBtn3.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _bgdBtn3.layer.borderWidth = 1;
    [_bgdBtn3 addTarget:self
                 action:@selector (CellSpeedDetailClick:)
       forControlEvents:UIControlEventTouchUpInside];

    if (_resultModel.videoTest == YES)
    {
        [_buttons addObject:_bgdBtn];
    }
    if (_resultModel.webTest == YES)
    {
        [_buttons addObject:_bgdBtn2];
    }
    if (_resultModel.speedTest == YES)
    {
        [_buttons addObject:_bgdBtn3];
    }


    //视屏测试
    if (_resultModel.videoTest == YES)
    {
        CGFloat imgViewWAndH = kViewH (_bgdBtn) - 3 * kViewX (_bgdBtn);
        UIImageView *_imgView = [[UIImageView alloc]
        initWithFrame:CGRectMake (kMargin * 2, (kCellH - imgViewWAndH) * 0.5, imgViewWAndH, imgViewWAndH)];
        _imgView.image = [UIImage imageNamed:@"ic_video_label"];
        [_bgdBtn addSubview:_imgView];

        UIImageView *_rightImgView =
        [[UIImageView alloc] initWithFrame:CGRectMake (kViewW (_bgdBtn) - imgViewWAndH - kMargin,
                                                       kViewY (_imgView), imgViewWAndH, imgViewWAndH)];
        [_bgdBtn addSubview:_rightImgView];

        // U-vMOS 值
        _uvMosLabelValue = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_imgView) + FITHEIGHT (15),
                                  kViewY (_imgView) - FITWIDTH (10), FITWIDTH (50), imgViewWAndH)];
        if (!_resultModel.uvMOS || _resultModel.uvMOS == -1)
        {
            [_uvMosLabelValue setText:_title1];
        }
        else
        {
            [_uvMosLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.uvMOS]];
        }

        [_uvMosLabelValue setFont:[UIFont boldSystemFontOfSize:valueFontSize]];
        [_uvMosLabelValue setTextAlignment:NSTextAlignmentCenter];
        [_uvMosLabelValue setTextColor:[UIColor orangeColor]];

        UILabel *uvMosLabel = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_imgView) + FITHEIGHT (15),
                                  kViewY (_imgView) + FITWIDTH (10), FITWIDTH (50), imgViewWAndH)];
        [uvMosLabel setText:@"U-vMOS"];
        [uvMosLabel setFont:[UIFont systemFontOfSize:valueLableFontSize]];
        [uvMosLabel setTextAlignment:NSTextAlignmentCenter];
        [_bgdBtn addSubview:_uvMosLabelValue];
        [_bgdBtn addSubview:uvMosLabel];

        // 首次缓冲时间
        _firstBufferTimeLabelValue = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_uvMosLabelValue) + FITWIDTH (10),
                                  kViewY (_imgView) - FITWIDTH (10), FITWIDTH (50), imgViewWAndH)];
        if (!_resultModel.firstBufferTime || _resultModel.firstBufferTime == -1)
        {
            [_firstBufferTimeLabelValue setText:_title1];
        }
        else
        {
            [_firstBufferTimeLabelValue setText:[NSString stringWithFormat:@"%d", _resultModel.firstBufferTime]];
        }
        [_firstBufferTimeLabelValue setFont:[UIFont boldSystemFontOfSize:valueFontSize]];
        [_firstBufferTimeLabelValue setTextAlignment:NSTextAlignmentRight];
        [_firstBufferTimeLabelValue setTextColor:[UIColor orangeColor]];

        UILabel *firstBufferTimeLabelUnit = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_uvMosLabelValue) + FITHEIGHT (57),
                                  kViewY (_imgView) + FITWIDTH (3), FITWIDTH (20), FITWIDTH (20))];
        [firstBufferTimeLabelUnit setText:@"ms"];
        [firstBufferTimeLabelUnit setFont:[UIFont systemFontOfSize:10]];
        [firstBufferTimeLabelUnit setTextAlignment:NSTextAlignmentCenter];
        [firstBufferTimeLabelUnit setTextColor:[UIColor orangeColor]];

        UILabel *firstBufferTimeLabel =
        [[UILabel alloc] initWithFrame:CGRectMake (kViewR (uvMosLabel), kViewY (_imgView) + FITWIDTH (10),
                                                   FITWIDTH (100), imgViewWAndH)];
        [firstBufferTimeLabel setText:_title2];
        [firstBufferTimeLabel setFont:[UIFont systemFontOfSize:valueLableFontSize]];
        [firstBufferTimeLabel setTextAlignment:NSTextAlignmentCenter];

        [_bgdBtn addSubview:_firstBufferTimeLabelValue];
        if (_resultModel.firstBufferTime && _resultModel.firstBufferTime >= 0)
        {
            [_bgdBtn addSubview:firstBufferTimeLabelUnit];
        }
        [_bgdBtn addSubview:firstBufferTimeLabel];

        // 卡顿次数
        _cuttonTimesLabelValue = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_firstBufferTimeLabelValue) + FITHEIGHT (45),
                                  kViewY (_imgView) - FITWIDTH (10), FITWIDTH (60), imgViewWAndH)];
        if (!_resultModel.cuttonTimes || _resultModel.cuttonTimes == -1)
        {
            [_cuttonTimesLabelValue setText:_title1];
        }
        else
        {
            [_cuttonTimesLabelValue setText:[NSString stringWithFormat:@"%d", _resultModel.cuttonTimes]];
        }
        [_cuttonTimesLabelValue setFont:[UIFont boldSystemFontOfSize:valueFontSize]];
        [_cuttonTimesLabelValue setTextAlignment:NSTextAlignmentCenter];
        [_cuttonTimesLabelValue setTextColor:[UIColor orangeColor]];

        UILabel *cuttonTimesLabel = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (firstBufferTimeLabel) - FITHEIGHT (15),
                                  kViewY (_imgView) + FITWIDTH (10), FITWIDTH (100), imgViewWAndH)];
        [cuttonTimesLabel setText:_title3];

        [cuttonTimesLabel setFont:[UIFont systemFontOfSize:valueLableFontSize]];
        [cuttonTimesLabel setTextAlignment:NSTextAlignmentCenter];
        [_bgdBtn addSubview:_cuttonTimesLabelValue];
        [_bgdBtn addSubview:cuttonTimesLabel];
    }


    //网页测试
    if (_resultModel.webTest == YES)
    {
        /*网页测试
        "Web Test"="网页测试";
        "Response Time"="响应时间";
        "Load duration"="完全加载时间";
        "Download"="下载速率";
         */
        CGFloat imgViewWAndH2 = kViewH (_bgdBtn2) - 3 * kViewX (_bgdBtn2);
        UIImageView *_imgView2 = [[UIImageView alloc]
        initWithFrame:CGRectMake (kMargin * 2, (kCellH - imgViewWAndH2) * 0.5, imgViewWAndH2, imgViewWAndH2)];
        _imgView2.image = [UIImage imageNamed:@"ic_web_label"];
        [_bgdBtn2 addSubview:_imgView2];

        UIImageView *_rightImgView2 =
        [[UIImageView alloc] initWithFrame:CGRectMake (kViewW (_bgdBtn2) - imgViewWAndH2 - kMargin,
                                                       kViewY (_imgView2), imgViewWAndH2, imgViewWAndH2)];
        [_bgdBtn2 addSubview:_rightImgView2];

        // 响应时间
        _responseLabelValue = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_imgView2) + FITHEIGHT (6),
                                  kViewY (_imgView2) - FITWIDTH (10), FITWIDTH (60), imgViewWAndH2)];
        if (!_resultModel.responseTime || _resultModel.responseTime < 0)
        {
            [_responseLabelValue setText:_timeoutTitle];
        }
        else
        {
            [_responseLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.responseTime]];
        }

        [_responseLabelValue setFont:[UIFont boldSystemFontOfSize:valueFontSize]];
        [_responseLabelValue setTextAlignment:NSTextAlignmentRight];
        [_responseLabelValue setTextColor:[UIColor orangeColor]];

        UILabel *responseLabelUnit = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_responseLabelValue) - FITWIDTH (8),
                                  kViewY (_imgView2) + FITWIDTH (3), FITWIDTH (20), FITWIDTH (20))];
        [responseLabelUnit setText:@"s"];
        [responseLabelUnit setFont:[UIFont systemFontOfSize:10]];
        [responseLabelUnit setTextAlignment:NSTextAlignmentCenter];
        [responseLabelUnit setTextColor:[UIColor orangeColor]];

        UILabel *responseLabel = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_imgView2) + FITHEIGHT (2),
                                  kViewY (_imgView2) + FITWIDTH (10), FITWIDTH (80), imgViewWAndH2)];
        [responseLabel setText:_title4];
        [responseLabel setFont:[UIFont systemFontOfSize:valueLableFontSize]];
        [responseLabel setTextAlignment:NSTextAlignmentCenter];
        [_bgdBtn2 addSubview:_responseLabelValue];
        if (_resultModel.responseTime && _resultModel.responseTime >= 0)
        {
            [_bgdBtn2 addSubview:responseLabelUnit];
        }
        [_bgdBtn2 addSubview:responseLabel];

        // 完全加载时间
        _loadLabelValue = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_responseLabelValue) + FITWIDTH (10),
                                  kViewY (_imgView2) - FITWIDTH (10), FITWIDTH (60), imgViewWAndH2)];
        if (!_resultModel.totalTime || _resultModel.totalTime < 0)
        {
            [_loadLabelValue setText:_timeoutTitle];
        }
        else
        {
            [_loadLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.totalTime]];
        }
        [_loadLabelValue setFont:[UIFont boldSystemFontOfSize:valueFontSize]];
        [_loadLabelValue setTextAlignment:NSTextAlignmentRight];
        [_loadLabelValue setTextColor:[UIColor orangeColor]];

        UILabel *loadLabelUnit = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_responseLabelValue) + FITHEIGHT (57),
                                  kViewY (_imgView2) + FITWIDTH (3), FITWIDTH (20), FITWIDTH (20))];
        [loadLabelUnit setText:@"s"];
        [loadLabelUnit setFont:[UIFont systemFontOfSize:10]];
        [loadLabelUnit setTextAlignment:NSTextAlignmentCenter];
        [loadLabelUnit setTextColor:[UIColor orangeColor]];

        UILabel *loadLabel = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (responseLabel) - FITWIDTH (20),
                                  kViewY (_imgView2) + FITWIDTH (10), FITWIDTH (80), imgViewWAndH2)];
        [loadLabel setText:_title5];
        [loadLabel setFont:[UIFont systemFontOfSize:valueLableFontSize]];
        [loadLabel setTextAlignment:NSTextAlignmentCenter];

        [_bgdBtn2 addSubview:_loadLabelValue];
        if (_resultModel.totalTime && _resultModel.totalTime >= 0)
        {
            [_bgdBtn2 addSubview:loadLabelUnit];
        }
        [_bgdBtn2 addSubview:loadLabel];

        // 下载速率
        _downloadLabelValue = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_loadLabelValue) + FITHEIGHT (10),
                                  kViewY (_imgView2) - FITWIDTH (10), FITWIDTH (60), imgViewWAndH2)];
        if (!_resultModel.downloadSpeed || _resultModel.downloadSpeed < 0)
        {
            [_downloadLabelValue setText:_title1];
        }
        else
        {
            [_downloadLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.downloadSpeed]];
        }
        [_downloadLabelValue setFont:[UIFont boldSystemFontOfSize:16]];
        [_downloadLabelValue setTextAlignment:NSTextAlignmentRight];
        [_downloadLabelValue setTextColor:[UIColor orangeColor]];

        UILabel *downloadLabelUnit = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (loadLabel) + FITHEIGHT (27),
                                  kViewY (_imgView2) + FITHEIGHT (3), FITWIDTH (20), FITWIDTH (20))];
        [downloadLabelUnit setText:@"kbps"];
        [downloadLabelUnit setFont:[UIFont systemFontOfSize:10]];
        [downloadLabelUnit setTextAlignment:NSTextAlignmentCenter];
        [downloadLabelUnit setTextColor:[UIColor orangeColor]];

        UILabel *downloadLabel = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (loadLabel) - FITHEIGHT (25),
                                  kViewY (_imgView2) + FITWIDTH (10), FITWIDTH (80), imgViewWAndH2)];
        [downloadLabel setText:_title6];

        [downloadLabel setFont:[UIFont systemFontOfSize:valueLableFontSize]];
        [downloadLabel setTextAlignment:NSTextAlignmentCenter];
        [_bgdBtn2 addSubview:_downloadLabelValue];
        if (_resultModel.downloadSpeed && _resultModel.downloadSpeed >= 0)
        {
            [_bgdBtn2 addSubview:downloadLabelUnit];
        }
        [_bgdBtn2 addSubview:downloadLabel];
    }

    // 带宽测试
    if (_resultModel.speedTest == YES)
    {
        CGFloat imgViewWAndH3 = kViewH (_bgdBtn3) - 3 * kViewX (_bgdBtn3);
        UIImageView *_imgView3 = [[UIImageView alloc]
        initWithFrame:CGRectMake (kMargin * 2, (kCellH - imgViewWAndH3) * 0.5, imgViewWAndH3, imgViewWAndH3)];
        _imgView3.image = [UIImage imageNamed:@"ic_speed_label"];
        [_bgdBtn3 addSubview:_imgView3];

        UIImageView *_rightImgView3 =
        [[UIImageView alloc] initWithFrame:CGRectMake (kViewW (_bgdBtn3) - imgViewWAndH3 - kMargin,
                                                       kViewY (_imgView3), imgViewWAndH3, imgViewWAndH3)];
        [_bgdBtn3 addSubview:_rightImgView3];


        // 时延
        _dtDelayLabelValue = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_imgView3) - FITWIDTH (10),
                                  kViewY (_imgView3) - FITWIDTH (10), FITWIDTH (50), imgViewWAndH3)];
        if (!_resultModel.stDelay || _resultModel.stDelay <= 0)
        {
            [_dtDelayLabelValue setText:_title1];
        }
        else
        {
            [_dtDelayLabelValue setText:[NSString stringWithFormat:@"%.0f", _resultModel.stDelay]];
        }

        [_dtDelayLabelValue setFont:[UIFont boldSystemFontOfSize:valueFontSize]];
        [_dtDelayLabelValue setTextAlignment:NSTextAlignmentRight];
        [_dtDelayLabelValue setTextColor:[UIColor orangeColor]];

        UILabel *delayLabelUnit = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_dtDelayLabelValue), kViewY (_imgView3) + FITWIDTH (3),
                                  FITWIDTH (20), FITWIDTH (20))];
        [delayLabelUnit setText:@"ms"];
        [delayLabelUnit setFont:[UIFont systemFontOfSize:10]];
        [delayLabelUnit setTextAlignment:NSTextAlignmentCenter];
        [delayLabelUnit setTextColor:[UIColor orangeColor]];


        UILabel *delayLabelTitle = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_imgView3) + FITHEIGHT (15),
                                  kViewY (_imgView3) + FITWIDTH (10), FITWIDTH (50), imgViewWAndH3)];
        [delayLabelTitle setText:_delayTitle];
        [delayLabelTitle setFont:[UIFont systemFontOfSize:valueLableFontSize]];
        [delayLabelTitle setTextAlignment:NSTextAlignmentCenter];


        [_bgdBtn3 addSubview:_dtDelayLabelValue];

        if (_resultModel.stDelay && _resultModel.stDelay > 0)
        {
            [_bgdBtn3 addSubview:delayLabelUnit];
        }

        [_bgdBtn3 addSubview:delayLabelTitle];

        // 下载速度
        _dtDownloadLabelValue = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_dtDelayLabelValue) + FITWIDTH (27),
                                  kViewY (_imgView3) - FITWIDTH (10), FITWIDTH (50), imgViewWAndH3)];
        if (!_resultModel.stDownloadSpeed || _resultModel.stDownloadSpeed <= 0)
        {
            [_dtDownloadLabelValue setText:_title1];
        }
        else
        {
            [_dtDownloadLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.stDownloadSpeed]];
        }

        //单位
        [_dtDownloadLabelValue setFont:[UIFont boldSystemFontOfSize:valueFontSize]];
        [_dtDownloadLabelValue setTextAlignment:NSTextAlignmentRight];
        [_dtDownloadLabelValue setTextColor:[UIColor orangeColor]];

        UILabel *downloadLabelUnit = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_dtDownloadLabelValue) - FITWIDTH (2),
                                  kViewY (_imgView3) + FITWIDTH (3), FITWIDTH (30), FITWIDTH (20))];
        [downloadLabelUnit setText:@"Mbps"];
        [downloadLabelUnit setFont:[UIFont systemFontOfSize:10]];
        [downloadLabelUnit setTextAlignment:NSTextAlignmentCenter];
        [downloadLabelUnit setTextColor:[UIColor orangeColor]];

        //下载速度四个字
        UILabel *downloadLabelTitle = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (delayLabelTitle) + FITWIDTH (5),
                                  kViewY (_imgView3) + FITWIDTH (10), FITWIDTH (85), imgViewWAndH3)];
        [downloadLabelTitle setText:_downloadSpeedTitle];
        [downloadLabelTitle setFont:[UIFont systemFontOfSize:valueLableFontSize]];
        [downloadLabelTitle setTextAlignment:NSTextAlignmentCenter];

        [_bgdBtn3 addSubview:_dtDownloadLabelValue];

        if (_resultModel.stDownloadSpeed && _resultModel.stDownloadSpeed > 0)
        {
            [_bgdBtn3 addSubview:downloadLabelUnit];
        }

        [_bgdBtn3 addSubview:downloadLabelTitle];


        // 上传速度
        _dtUploadLabelValue = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_dtDownloadLabelValue) + FITWIDTH (28),
                                  kViewY (_imgView3) - FITWIDTH (10), FITWIDTH (50), imgViewWAndH3)];

        if (!_resultModel.stUploadSpeed || _resultModel.stUploadSpeed <= 0)
        {
            [_dtUploadLabelValue setText:_title1];
        }
        else
        {
            [_dtUploadLabelValue setText:[NSString stringWithFormat:@"%.2f", _resultModel.stUploadSpeed]];
        }

        [_dtUploadLabelValue setFont:[UIFont boldSystemFontOfSize:valueFontSize]];
        [_dtUploadLabelValue setTextAlignment:NSTextAlignmentRight];
        [_dtUploadLabelValue setTextColor:[UIColor orangeColor]];

        UILabel *uploadLabelUnit = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (_dtUploadLabelValue) + FITWIDTH (1),
                                  kViewY (_imgView3) + FITWIDTH (3), FITWIDTH (30), FITWIDTH (20))];

        [uploadLabelUnit setText:@"Mbps"];
        [uploadLabelUnit setFont:[UIFont systemFontOfSize:10]];
        [uploadLabelUnit setTextAlignment:NSTextAlignmentCenter];
        [uploadLabelUnit setTextColor:[UIColor orangeColor]];

        UILabel *uploadLabelTitle = [[UILabel alloc]
        initWithFrame:CGRectMake (kViewR (downloadLabelTitle) - FITWIDTH (5),
                                  kViewY (_imgView3) + FITWIDTH (10), FITWIDTH (85), imgViewWAndH3)];
        [uploadLabelTitle setText:_uploadSpeedTitle];
        [uploadLabelTitle setFont:[UIFont systemFontOfSize:valueLableFontSize]];
        [uploadLabelTitle setTextAlignment:NSTextAlignmentCenter];

        [_bgdBtn3 addSubview:_dtUploadLabelValue];

        if (_resultModel.stUploadSpeed && _resultModel.stUploadSpeed > 0)
        {
            [_bgdBtn3 addSubview:uploadLabelUnit];
        }

        [_bgdBtn3 addSubview:uploadLabelTitle];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initBarButton];

    UIView *uiview = [[UIView alloc] initWithFrame:CGRectMake (0, 0, kScreenW, kScreenH)];
    uiview.backgroundColor = [UIColor whiteColor];
    // 7.把tableView添加到 view
    [uiview addSubview:self.buildTableView];

    // 7.把button添加到 view
    [uiview addSubview:self.buildTestBtn];

    self.view = uiview;
    // 初始化表格数据
    [self initButtons];

    // 表格重绘
    [_tableView reloadData];
}

/**
 *  持久化汇总结果
 */
- (void)persistSVSummaryResultModel
{
    // 结果持久化
    SVDBManager *db = [SVDBManager sharedInstance];
    // 如果表不存在，则创建表
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS SVSummaryResultModel(ID integer PRIMARY KEY "
                      @"AUTOINCREMENT, testId integer, type integer, testTime integer, UvMOS "
                      @"real, loadTime integer, bandwidth real);"];

    NSString *insertSVSummaryResultModelSQL =
    [NSString stringWithFormat:@"INSERT INTO "
                               @"SVSummaryResultModel(testId,type,testTime,UvMOS,loadTime,"
                               @"bandwidth)VALUES(%ld, 0, %ld, %lf, %lf, %lf);",
                               _resultModel.testId, _resultModel.testId, _resultModel.uvMOS,
                               _resultModel.totalTime, _resultModel.stDownloadSpeed];
    // 插入汇总结果
    [db executeUpdate:insertSVSummaryResultModelSQL];
}

//设置 tableView 的 numberOfSectionsInTableView(设置几个 section)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _buttons.count;
}
//设置 tableView的 numberOfRowsInSection(设置每个section中有几个cell)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
//设置 tableView的 cellForRowIndexPath(设置每个cell内的具体内容)
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVInfo (@"indexPath -----------------------------%@", indexPath);
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aCell"];

    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"aCell"];

        //取消cell 被点中的效果
        //        cell.backgroundColor = [UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    if (_buttons.count == 0)
    {
        return cell;
    }

    UIButton *button = [_buttons objectAtIndex:indexPath.section];
    [cell addSubview:button];
    return cell;
}

//设置 tableView 的 sectionHeader蓝色 的header的有无
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
//设置tableView的 sectionFooter黑色 的Footer的有无
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

//设置 tableView的section 的Header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
//设置 tableView的section 的Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellH;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UITableView *)buildTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake (0, 0, kScreenW, 500)
                                              style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 2.设置背景颜色
    _tableView.backgroundColor = [UIColor whiteColor];
    //*4.设置代理
    _tableView.delegate = self;
    //*5.设置数据源
    _tableView.dataSource = self;
    // 6.设置tableView不可上下拖动
    _tableView.bounces = NO;
    return _tableView;
}

/**
 *进入视频测试结果详情界面
 **/

- (void)CellVideoDetailClick:(UIButton *)sender
{
    [self CellDetailClick:sender testType:@"0"];
}

/**
 *cell的点击事件进入详情界面
 **/

- (void)CellWebDetailClick:(UIButton *)sender
{
    [self CellDetailClick:sender testType:@"1"];
}

/**
 *cell的点击事件进入详情界面
 **/

- (void)CellSpeedDetailClick:(UIButton *)sender
{
    [self CellDetailClick:sender testType:@"2"];
}

/**
 *cell的点击事件进入详情界面
 **/

- (void)CellDetailClick:(UIButton *)sender testType:(NSString *)testType
{
    // cell被点击
    SVInfo (@"cell-------dianjile");

    //按钮点击后alloc一个界面
    SVDetailViewCtrl *detailViewCtrl = [[SVDetailViewCtrl alloc] init];
    [detailViewCtrl setTestId:_resultModel.testId];
    [detailViewCtrl setTestType:testType];

    //隐藏hidesBottomBarWhenPushed
    self.hidesBottomBarWhenPushed = YES;

    // push界面
    [self.navigationController pushViewController:detailViewCtrl animated:YES];

    //返回时显示hidesBottomBarWhenPushed
    self.hidesBottomBarWhenPushed = NO;
}

/**
 *开始测试按钮初始化(按钮未被选中时的状态)
 **/

- (UIButton *)buildTestBtn
{
    NSString *title1 = I18N (@"Test Again");
    //按钮高度
    CGFloat testBtnH = 50;
    //按钮类型
    UIButton *_reTestButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //按钮尺寸
    _reTestButton.frame = CGRectMake (kMargin * 4, kScreenH - 200, kScreenW - kMargin * 8, testBtnH);
    //按钮圆角
    _reTestButton.layer.cornerRadius = kCornerRadius;
    //设置按钮的背景色
    _reTestButton.backgroundColor =
    [UIColor colorWithRed:51 / 255.0 green:166 / 255.0 blue:226 / 255.0 alpha:1.0];
    //按钮文字颜色和类型
    [_reTestButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //设置居中
    _reTestButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    //按钮文字和类型
    [_reTestButton setTitle:title1 forState:UIControlStateNormal];
    //按钮点击事件
    [_reTestButton addTarget:self
                      action:@selector (testBtnClick)
            forControlEvents:UIControlEventTouchUpInside];

    return _reTestButton;
}

/**
 *  初始化barbutton
 */
- (void)initBarButton
{
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake (0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
    //设置图片大小
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake (0, 0, 100, 30)];
    //设置图片名称
    imageView.image = [UIImage imageNamed:@"speed_pro"];
    //让图片适应
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //把图片添加到navigationItem.titleView
    self.navigationItem.titleView = imageView;
    //电池显示不了,设置样式让电池显示
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, 45, 23)];
    [button setImage:[UIImage imageNamed:@"homeindicator"] forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *back0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil
                                                                           action:nil];
    back0.width = -15;
    self.navigationItem.leftBarButtonItems = @[back0, backButton];

    [button addTarget:self
               action:@selector (backBtnClik)
     forControlEvents:UIControlEventTouchUpInside];

    //为了保持平衡添加一个leftBtn
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, 44, 44)];
    UIBarButtonItem *backButton1 = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem = backButton1;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

/**
 *  返回重新测试页面
 */
- (void)testBtnClick
{
    SVInfo (@"back to testting view");
    [[_resultModel navigationController] popToRootViewControllerAnimated:NO];

    // 将已经推送完成的controller重新放入待推送的controller数组
    [_resultModel copyCompleteCtrlToCtrlArray];

    // 每次重新测试需要将testId重置一下
    [_resultModel setTestId:[SVTimeUtil currentMilliSecondStamp]];

    // 将结果保存标志位设置为no
    isSave = NO;

    // 重新测试
    [_resultModel pushNextCtrl];
}

/**
 *  回退到测试页面
 */
- (void)backBtnClik
{
    SVInfo (@"back to test view");
    [[_resultModel navigationController] popToRootViewControllerAnimated:NO];
}

@end
