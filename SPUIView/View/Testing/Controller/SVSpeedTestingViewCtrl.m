//
//  SVSpeedTestingViewCtrl.m
//  SpeedPro
//
//  Created by WBapple on 16/3/8.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

//主View下的4个子View
#import "SVChart.h"
#import "SVCurrentResultViewCtrl.h"
#import "SVFooterView.h"
#import "SVHeaderView.h"
#import "SVLabelTools.h"
#import "SVPointView.h"
#import "SVProbeInfo.h"
#import "SVProgressView.h"
#import "SVSpeedTestingViewCtrl.h"
#import "SVSpeedView.h"

#define kVideoViewDefaultRect \
    CGRectMake (FITWIDTH (10), FITWIDTH (425), FITWIDTH (150), FITWIDTH (90))

@interface SVSpeedTestingViewCtrl ()
{

    SVHeaderView *_headerView; // 定义headerView
    SVPointView *_speedtestingView; //定义speedtestingView
    SVFooterView *_footerView; // 定义footerView

    SVChart *_chart;
    BOOL uploadFirstResult;
    BOOL downloadFirstResult;

    // 服务器地址
    UILabel *_serverLocationLabel;

    // 服务器地址的标题
    UILabel *_serverLocationTitle;

    // 服务器归属地
    UILabel *_carrierLabel;

    // 服务器归属地的标题
    UILabel *_carrierTitle;

    // 进度条
    SVProgressView *pro;

    float value;

    // 主窗口
    UIWindow *window;

    BOOL isFirstResult;
}

// 定义gy遮挡View
@property (nonatomic, strong) UIView *gyview;

@end

@implementation SVSpeedTestingViewCtrl

double _preSpeed = 0.0;

@synthesize currentResultModel;

- (id)initWithResultModel:(SVCurrentResultModel *)resultModel
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    _preSpeed = 0.0;
    currentResultModel = resultModel;

    // 获取整个屏幕的window
    window = [UIApplication sharedApplication].keyWindow;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SVInfo (@"SVSpeedTestingCtrl");

    // 初始化标题
    [super initTitleView];

    // 初始化返回按钮
    [super initBackButtonWithTarget:self action:@selector (removeButtonClicked:)];

    // 设置背景颜色
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFAFAFA"];

    // 添加方法
    [self creatHeaderView];
    [self creatSpeedTestingView];
    [self creatFooterView];
}

// 退出测试按钮点击事件
- (void)removeButtonClicked:(UIButton *)button
{
    NSString *title1 = I18N (@"Test stopped");
    NSString *title2 = I18N (@"Are you sure you want to exit the test");
    NSString *title3 = I18N (@"No");
    NSString *title4 = I18N (@"Yes");

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title1
                                                    message:title2
                                                   delegate:self
                                          cancelButtonTitle:title3
                                          otherButtonTitles:title4, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        SVInfo (@"取消了此次测试");
        [currentResultModel.navigationController popToRootViewControllerAnimated:NO];
    }
    SVInfo (@"继续测试");
}

/**
 *  初始化当前页面和全局变量
 */
- (void)initContext
{
    [_headerView updateLeftValue:@"N/A" WithUnit:@""];
    [_headerView updateMiddleValue:@"N/A" WithUnit:@""];
    [_headerView updateRightValue:@"N/A" WithUnit:@""];

    NSString *loadingStr = I18N (@"Loading...");
    [_serverLocationLabel setText:loadingStr];
    [_carrierLabel setText:loadingStr];
    [_speedtestingView updateValue:0];
    [_speedtestingView.titleLabel setText:@""];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // 设置屏幕不会休眠
    //    [UIApplication sharedApplication].idleTimerDisabled = YES;
    SVProbeInfo *probe = [[SVProbeInfo alloc] init];
    [probe setIsTesting:YES];

    // 显示tabbar 和navigationbar
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.hidden = NO;

    isFirstResult = YES;


    // 添加覆盖gyview(为了防止用户在测试的过程中点击按钮)
    // 将当前view的window设置为主窗口
    [window makeKeyAndVisible];

    // 创建一个覆盖garyView
    _gyview = [[UIView alloc] initWithFrame:CGRectMake (0, kScreenH - 50, kScreenW, 50)];

    // 设置透明度
    _gyview.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.0];

    // 添加
    [window addSubview:_gyview];

    // 初始化页面
    [self initContext];

    // 进入页面时，开始测试
    _speedTest = [[SVSpeedTest alloc] initWithView:self.currentResultModel.testId
                                     showSpeedView:nil
                                      testDelegate:self];

    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
      BOOL isOK = [_speedTest initTestContext];
      if (isOK)
      {
          [_speedTest startTest];
      }
      else
      {
          [_speedTest resetResult];
          dispatch_async (dispatch_get_main_queue (), ^{
            [self goToCurrentResultViewCtrl];
          });
      }
    });
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    for (UIView *subView in _footerView.leftView.subviews)
    {
        [subView removeFromSuperview];
    }

    uploadFirstResult = false;
    downloadFirstResult = false;

    // 当用户离开当前页面时，停止测试
    if (_speedTest)
    {
        [_speedTest stopTest];

        _insertSVDetailResultModelSQL = [_speedTest getPersistDataSQL];

        //移除覆盖gyView
        [_gyview removeFromSuperview];
    }

    [super viewWillDisappear:animated];
}

#pragma mark - 创建头headerView

- (void)creatHeaderView
{
    // 初始化默认值
    NSMutableDictionary *defalutValue = [[NSMutableDictionary alloc] init];
    [defalutValue setValue:[UIFont systemFontOfSize:pixelToFontsize (36)] forKey:@"labelFontSize"];
    [defalutValue setValue:[UIColor colorWithHexString:@"#000000"] forKey:@"labelColor"];
    [defalutValue setValue:[UIFont systemFontOfSize:pixelToFontsize (60)] forKey:@"valueFontSize"];
    [defalutValue setValue:[UIColor colorWithHexString:@"#FC5F45"] forKey:@"valueColor"];
    [defalutValue setValue:[UIFont systemFontOfSize:pixelToFontsize (33)] forKey:@"unitFontSize"];
    [defalutValue setValue:[UIColor colorWithHexString:@"#FC5F45"] forKey:@"unitColor"];
    [defalutValue setValue:@"N/A" forKey:@"leftDefaultValue"];
    [defalutValue setValue:I18N (@"Delay") forKey:@"leftTitle"];
    [defalutValue setValue:@"" forKey:@"leftUnit"];
    [defalutValue setValue:@"N/A" forKey:@"middleDefaultValue"];
    [defalutValue setValue:I18N (@"Download Speed") forKey:@"middleTitle"];
    [defalutValue setValue:@"" forKey:@"middleUnit"];
    [defalutValue setValue:@"N/A" forKey:@"rightDefaultValue"];
    [defalutValue setValue:I18N (@"Upload speed") forKey:@"rightTitle"];
    [defalutValue setValue:@"" forKey:@"rightUnit"];


    // 初始化headerView
    _headerView = [[SVHeaderView alloc] initWithDic:defalutValue];

    // 把headerView添加到中整个视图上
    [self.view addSubview:_headerView];
}

#pragma mark - 创建测试中speedtestingView

- (void)creatSpeedTestingView
{
    // 初始化默认值
    NSMutableDictionary *defalutValue = [[NSMutableDictionary alloc] init];
    [defalutValue setValue:I18N (@"Download") forKey:@"title"];
    [defalutValue setValue:@"0.00" forKey:@"defaultValue"];
    [defalutValue setValue:@"Mbps" forKey:@"unit"];
    [defalutValue setValue:@"speed" forKey:@"testType"];

    // 初始化整个testingView
    _speedtestingView = [[SVPointView alloc] initWithDic:defalutValue];
    [_speedtestingView start];

    [self.view addSubview:_speedtestingView];
}

#pragma mark - 创建尾footerView

- (void)creatFooterView
{
    //初始化headerView
    _footerView = [[SVFooterView alloc] init];

    // 初始化服务器地址的label
    _serverLocationLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (50), FITHEIGHT (10), FITWIDTH (446), FITHEIGHT (50))
                withFont:pixelToFontsize (44)
          withTitleColor:[UIColor colorWithHexString:@"#000000"]
               withTitle:@""];

    // 初始化服务器地址标题的label
    _serverLocationTitle = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (50), _serverLocationLabel.bottomY + FITHEIGHT (16),
                                     FITWIDTH (446), FITWIDTH (34))
                withFont:pixelToFontsize (36)
          withTitleColor:[UIColor colorWithHexString:@"#000000"]
               withTitle:I18N (@"Server Location")];

    // 初始化服务器归属地的label
    _carrierLabel = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (50), _serverLocationTitle.bottomY + FITHEIGHT (28),
                                     FITWIDTH (446), FITWIDTH (50))
                withFont:pixelToFontsize (39)
          withTitleColor:[UIColor colorWithHexString:@"#000000"]
               withTitle:@""];

    // 初始化服务器归属地标题的label
    _carrierTitle = [CTWBViewTools
    createLabelWithFrame:CGRectMake (FITWIDTH (50), _carrierLabel.bottomY + FITHEIGHT (16),
                                     FITWIDTH (446), FITHEIGHT (50))
                withFont:pixelToFontsize (36)
          withTitleColor:[UIColor colorWithHexString:@"#000000"]
               withTitle:I18N (@"Carrier")];


    // 设置Label对齐
    _serverLocationLabel.textAlignment = NSTextAlignmentLeft;
    _serverLocationTitle.textAlignment = NSTextAlignmentLeft;
    _carrierTitle.textAlignment = NSTextAlignmentLeft;
    _carrierLabel.textAlignment = NSTextAlignmentLeft;


    // 将所有label放入右侧的View
    [_footerView.rightView addSubview:_serverLocationLabel];
    [_footerView.rightView addSubview:_serverLocationTitle];
    [_footerView.rightView addSubview:_carrierTitle];
    [_footerView.rightView addSubview:_carrierLabel];

    //初始化
    [_footerView.leftView setBackgroundColor:[UIColor colorWithHexString:@"#FFFAFAFA"]];

    [self.view addSubview:_footerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 随机数 范围在[from,to）
- (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random () % (to - from + 1)));
}
/**********************************以下为UI数据层代码**********************************/
- (void)updateTestResultDelegate:(SVSpeedTestContext *)testContext
                      testResult:(SVSpeedTestResult *)testResult
{
    NSString *uploadTitle = I18N (@"Upload");
    NSString *downTitle = I18N (@"Download");

    dispatch_async (dispatch_get_main_queue (), ^{

      // 如果时延小于0，则认为测试失败，直接返回
      double delay = testResult.delay;
      if (delay < 0)
      {
          [_headerView updateLeftValue:[NSString stringWithFormat:@"%@", I18N (@"Timeout")]
                              WithUnit:@""];
          return;
      }

      // 收到第一次结果时，初始化进度条
      if (isFirstResult)
      {
          pro = [[SVProgressView alloc] initWithheight:NavBarH];
          value = 0.0;
          [self.view addSubview:pro];
          [pro bindTimerTotalTime:22];
          isFirstResult = NO;
      }

      // 如果测试结束，则初始化测试结果，并跳转到当前结果页面
      if (testContext.testStatus == TEST_FINISHED)
      {
          //柱状图
          [pro setProgress:1.0];
          [pro removeFromSuperview];

          [self initCurrentResultModel:testResult];
          [self goToCurrentResultViewCtrl];
          return;
      }

      // 服务器归属地和运营商
      if (testResult.isp)
      {
          if (testResult.isp.isp)
          {
              _carrierLabel.text = testResult.isp.isp;

              // label自动换行
              [SVLabelTools wrapForLabel:_carrierLabel nextLabel:_carrierTitle];
          }
          if (testResult.isp.city)
          {
              _serverLocationLabel.text = testResult.isp.city;
          }
      }

      // 显示时延
      [_headerView updateLeftValue:[NSString stringWithFormat:@"%.0f", testResult.delay]
                          WithUnit:@"ms"];

      // 如果是汇总结果，直接使用
      double speed = testResult.isUpload ? testResult.uploadSpeed : testResult.downloadSpeed;

      // 如果是测试中结果，则需要计算，并显示线图
      if (!testResult.isSummeryResult && !testResult.isSecResult)
      {
          speed = _preSpeed + [self getRandomNumber:-_preSpeed to:_preSpeed] * 1.0 / 100;
      }
      [_speedtestingView updateValue:speed];

      // 如果是汇总结果，说明测试结束，将表盘指针改为0
      if (testResult.isSummeryResult)
      {
          [_speedtestingView updateValue:0];
      }

      if (testResult.isUpload)
      {
          [_headerView updateRightValue:[NSString stringWithFormat:@"%.2f", speed]
                               WithUnit:@"Mbps"];
          _speedtestingView.titleLabel.text = uploadTitle;
      }
      else
      {
          [_headerView updateMiddleValue:[NSString stringWithFormat:@"%.2f", speed]
                                WithUnit:@"Mbps"];
          _speedtestingView.titleLabel.text = downTitle;
      }

      // 计算线图数据
      if (testResult.isSecResult)
      {
          _preSpeed = speed;
          if (testResult.isUpload)
          {
              if (!uploadFirstResult)
              {
                  if (_chart)
                  {
                      [_chart removeFromSuperview];
                  }

                  _chart = [[SVChart alloc] initWithView:_footerView.leftView];
                  uploadFirstResult = true;
              }
          }
          else
          {
              if (!downloadFirstResult)
              {
                  if (_chart)
                  {
                      [_chart removeFromSuperview];
                  }

                  _chart = [[SVChart alloc] initWithView:_footerView.leftView];
                  downloadFirstResult = true;
              }
          }

          // 线图数据秒级
          [_chart addValue:speed];
          SVInfo (@"isSecResult:%.2f", speed);
      }
    });
}

- (void)initCurrentResultModel:(SVSpeedTestResult *)testResult
{
    currentResultModel.testId = testResult.testId;
    currentResultModel.stDelay = testResult.delay;
    currentResultModel.stDownloadSpeed = testResult.downloadSpeed == 0 ? -1 : testResult.downloadSpeed;
    currentResultModel.stUploadSpeed = testResult.uploadSpeed;
    if (testResult.isp)
    {
        if (testResult.isp.isp)
        {
            currentResultModel.stIsp = testResult.isp.isp;
        }
        if (testResult.isp.city)
        {
            currentResultModel.stLocation = testResult.isp.city;
        }
    }
}

- (void)goToCurrentResultViewCtrl
{
    // push界面
    [currentResultModel pushNextCtrl];
}

/**
 * 停止测试
 */
- (void)stopTest
{
    // 停止测试例
    [_speedTest stopTest];

    // 停止进度条的定时器
    if (pro)
    {
        [pro cancelTimer];
    }
}

/**
 * 重置测试结果
 */
- (void)resetResult
{
    [_speedTest resetResult];
}

@end