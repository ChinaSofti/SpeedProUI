//
//  SVTestViewCtrl.m
//  SPUIView
//
//  Created by WBapple on 16/1/20.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "AlertView.h"
#import "SVCurrentResultModel.h"
#import "SVCurrentResultViewCtrl.h"
#import "SVSpeedTestingViewCtrl.h"
#import "SVTestViewCtrl.h"
#import "SVToolCell.h"
#import "SVVideoTestingCtrl.h"
#import "SVWebTestingViewCtrl.h"

#import <SPCommon/SVTimeUtil.h>
#import <SPService/SVTestContextGetter.h>
#define kFirstHederH 40
#define kLastFooterH 140

@interface SVTestViewCtrl () <SVToolCellDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *soucreMA;
@property (nonatomic, retain) NSMutableArray *selectedMA;
@property (nonatomic, retain) UIButton *testBtn;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, retain) UIView *footerView;
@end


@implementation SVTestViewCtrl

- (void)viewDidLoad
{

    [super viewDidLoad];
    SVInfo (@"SVTestViewController");

    // 1.自定义navigationItem.titleView
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

    // 2.编辑界面
    //创建一个 tableView
    // 1.style:Grouped化合的,分组的
    _tableView =
    [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // 2.设置背景颜色
    _tableView.backgroundColor = [UIColor whiteColor];
    // 3.设置 table 的行高
    //*4.设置代理
    _tableView.delegate = self;
    //*5.设置数据源
    _tableView.dataSource = self;
    // 6.设置tableView不可上下拖动
    _tableView.bounces = NO;
    // 7.定义数组展示图片
    _selectedMA = [NSMutableArray array];
    // 8.国际化
    NSString *title = I18N (@"Video Test");
    NSString *title2 = I18N (@"Web Test");
    NSString *title3 = I18N (@"Speed Test");

    NSArray *sourceA = @[
        @{
            @"img_normal": @"ic_video_label",
            @"img_selected": @"ic_video_label",
            @"title": title,
            @"rightImg_normal": @"1",
            @"rightImg_selected": @"ic_video_check"
        },
        @{
            @"img_normal": @"ic_web_label",
            @"img_selected": @"ic_web_label",
            @"title": title2,
            @"rightImg_normal": @"1",
            @"rightImg_selected": @"ic_web_check"
        },
        @{
            @"img_normal": @"ic_speed_label",
            @"img_selected": @"ic_speed_label",
            @"title": title3,
            @"rightImg_normal": @"1",
            @"rightImg_selected": @"ic_speed_check"
        }
    ];
    NSMutableArray *sourceMA = [NSMutableArray array];
    for (int i = 0; i < sourceA.count; i++)
    {
        SVToolModel *toolModel = [SVToolModel modelWithDict:sourceA[i]];
        [sourceMA addObject:toolModel];
    }
    _soucreMA = sourceMA;
    // 9.把tableView添加到 view
    [self.view addSubview:_tableView];

    SVRealReachability *realReachability = [SVRealReachability sharedInstance];
    [realReachability addDelegate:self];
    [realReachability startMonitorNetworkStatus];
}

#pragma mark - tableview的方法

//设置 tableView 的 numberOfSectionsInTableView(设置几个 section)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return _soucreMA.count;
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
    static NSString *cellId = @"cell";

    SVToolCell *cell =
    [[SVToolCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

    cell.delegate = self;
    [cell cellViewModel:_soucreMA[indexPath.section] section:indexPath.section];
    return cell;
}

//设置 tableView 的 sectionHeader
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    if (section == 0)
    {
        UIView *bgdView = [[UIView alloc] init];
        UILabel *label =
        [[UILabel alloc] initWithFrame:CGRectMake (kMargin, 0, kScreenW - kMargin, kFirstHederH)];
        NSString *title4 = I18N (@"Select Test Item");
        label.text = title4;
        label.font = [UIFont systemFontOfSize:13.0f];
        [bgdView addSubview:label];
        return bgdView;
    }

    return nil;
}

//设置tableView的 sectionFooter
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == _soucreMA.count - 1)
    {

        [self.footerView addSubview:self.testBtn];
        [self.footerView addSubview:self.button];
        return self.footerView;
    }
    return nil;
}

//设置 tableView的section 的Header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 40;
    }
    else
        return 10;
}

//设置 tableView的section 的Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == _soucreMA.count - 1)
    {
        return kLastFooterH;
    }
    else
        return CGFLOAT_MIN;
}

//设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kCellH;
}

#pragma mark - 开始测试按钮初始化(按钮未被选中时的状态)
//有网时候的按钮
- (UIButton *)testBtn
{
    if (_testBtn == nil)
    {
        //按钮高度
        CGFloat testBtnH = 40;
        //按钮类型
        _testBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //按钮尺寸
        _testBtn.frame = CGRectMake (kMargin * 4, kLastFooterH - testBtnH, kScreenW - kMargin * 8, testBtnH);
        //按钮背景颜色
        _testBtn.backgroundColor =
        [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.0];
        NSString *title5 = I18N (@"Begin Test");
        [_testBtn setTitle:title5 forState:UIControlStateNormal];
        //按钮点击事件
        [_testBtn addTarget:self
                     action:@selector (testBtnClick1)
           forControlEvents:UIControlEventTouchUpInside];
        //按钮圆角
        _testBtn.layer.cornerRadius = kCornerRadius;
        //设置居中
        _testBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        //按钮文字颜色和类型
        [_testBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        //按钮交互
        //设置按钮默认情况下不可交互
        _testBtn.userInteractionEnabled = NO;
        //设置默认情况下按钮不可点击方法2
        // _testBtn.enabled = NO;
    }
    return _testBtn;
}
//没网时候的按钮
- (UIButton *)button
{
    if (_button == nil)
    {
        NSString *title7 = I18N (@"Network Settings");
        _button = [[UIButton alloc]
        initWithFrame:CGRectMake (kMargin * 4, kLastFooterH - 40, kScreenW - kMargin * 8, 40)];
        [_button setTitle:title7 forState:UIControlStateNormal];
        _button.backgroundColor =
        [UIColor colorWithRed:51 / 255.0 green:166 / 255.0 blue:226 / 255.0 alpha:1.0];
        _button.userInteractionEnabled = YES;
        //按钮圆角
        _button.layer.cornerRadius = kCornerRadius;
        //设置居中
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        //按钮文字颜色和类型
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //按钮点击事件
        [_button addTarget:self
                    action:@selector (goNetworkSetting)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}
//初始化footerView
- (UIView *)footerView
{
    if (_footerView == nil)
    {
        _footerView = [[UIView alloc] init];
    }
    return _footerView;
}

/**
 *section中的cell的点击事件(按钮选中后的状态设置)
 **/

- (void)toolCellClick:(SVToolCell *)cell
{
    //设置按钮的背景色
    self.testBtn.backgroundColor =
    [UIColor colorWithRed:51 / 255.0 green:166 / 255.0 blue:226 / 255.0 alpha:1.0];
    //设置按钮可以点击
    // self.testBtn.enabled = YES;
    self.testBtn.userInteractionEnabled = YES;
    //按钮文字颜色和类型
    [_testBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //如果_selectedMA.count的值为空,添加对象
    if (!_selectedMA.count)
    {
        [_selectedMA addObject:[[NSNumber alloc] initWithInteger:cell.bgdBtn.tag]];
        return;
    }
    //遍历他是否存在过,如果存在过移除
    BOOL isInclude = NO;
    for (NSNumber *nsTag in _selectedMA)
    {
        int tag = nsTag.intValue;
        if (tag == cell.bgdBtn.tag)
        {
            [_selectedMA removeObject:nsTag];
            isInclude = YES;
            break;
        }
    }
    //判断是不是空,如果是空添加(跟第一个if是一样的)
    if (!isInclude)
    {
        [_selectedMA addObject:[[NSNumber alloc] initWithInteger:cell.bgdBtn.tag]];
    }
    //如果被选中的cell数为0(也是默认情况)
    if (!_selectedMA.count)
    {
        self.testBtn.backgroundColor =
        [UIColor colorWithRed:229 / 255.0 green:229 / 255.0 blue:229 / 255.0 alpha:1.0];
        //设置按钮不可点击
        // self.testBtn.enabled = NO;
        self.testBtn.userInteractionEnabled = NO;
        //按钮文字颜色和类型
        [_testBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
}


//按钮的点击事件
- (void)testBtnClick1
{
#pragma mark - 在这里对 数组 排序
    UITabBarController *tabBarController = self.tabBarController;
    UINavigationController *navigationController = self.navigationController;
    NSMutableArray *ctrlArray = [[NSMutableArray alloc] init];
    long testId = [SVTimeUtil currentMilliSecondStamp];

    SVCurrentResultModel *currentResultModel = [[SVCurrentResultModel alloc] init];
    [currentResultModel setNavigationController:navigationController];
    [currentResultModel setTabBarController:tabBarController];
    [currentResultModel setSelectedA:_selectedMA];
    [currentResultModel setTestId:testId];
    

    for (id selected in _selectedMA)
    {
        //定义一个cellIndex,来记录数组中哪一个第一个被选择的
        NSInteger cellIndex = ((NSNumber *)(selected)).integerValue;

        if (cellIndex == 0)
        {
            //按钮点击后alloc一个界面
            SVVideoTestingCtrl *videotestingCtrl = [[SVVideoTestingCtrl alloc] init];

            [currentResultModel setVideoTest:YES];
            [ctrlArray addObject:videotestingCtrl];
        }
        if (cellIndex == 1)
        {
            SVWebTestingViewCtrl *webtestingCtrl = [[SVWebTestingViewCtrl alloc] init];

            [currentResultModel setWebTest:YES];
            [ctrlArray addObject:webtestingCtrl];
        }
        if (cellIndex == 2)
        {
            SVSpeedTestingViewCtrl *speedtestingCtrl = [[SVSpeedTestingViewCtrl alloc] init];

            [ctrlArray addObject:speedtestingCtrl];
        }
    }

    SVCurrentResultViewCtrl *currentResultView = [[SVCurrentResultViewCtrl alloc] init];
    [ctrlArray addObject:currentResultView];

    // push界面
    if (ctrlArray)
    {
        id nextCtrl = ctrlArray[0];
        if (nextCtrl)
        {
            [ctrlArray removeObjectAtIndex:0];
            [currentResultModel setNextControllers:ctrlArray];
            [nextCtrl setCurrentResultModel:currentResultModel];
            [self.navigationController pushViewController:nextCtrl animated:YES];
        }
    }

    SVInfo (@"testBtnClick...");
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  监听网络状态变更
 *
 *  @param status 网络状态
 */
- (void)networkStatusChange:(SVRealReachabilityStatus)status
{
    //    SVInfo (@"%ld", (long)status);
    // 网络不可用，修改按钮属性
    if (status == SV_RealStatusNotReachable)
    {
        [_testBtn removeFromSuperview];
        [self.footerView addSubview:_button];
        SVInfo (@"network is not available");
    }
    else
    {
        [_button removeFromSuperview];
        [self.footerView addSubview:_testBtn];
        SVInfo (@"network is available");
    }
}

//进入设置网络界面
- (void)goNetworkSetting
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs:root=WIFI"]];
}

@end
