//
//  SVSettingsViewCtrl.m
//  SPUIView
//
//  Created by WBapple on 16/1/20.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "SVAboutViewCtrl.h"
#import "SVAdvancedViewCtrl.h"
#import "SVBWSettingViewCtrl.h"
#import "SVFAQViewCtrl.h"
#import "SVIPAndISPGetter.h"
#import "SVLanguageSettingViewCtrl.h"
#import "SVLogViewController.h"
#import "SVPrivacyCtrl.h"
#import "SVProbeInfo.h"
#import "SVQRCodeViewCtrl.h"
#import "SVRealReachability.h"
#import "SVSettingsViewCtrl.h"
#import "SVUploadFile.h"
//上传日志提示
#import "SVToast.h"

@interface SVSettingsViewCtrl () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *grey;
@property (nonatomic, strong) UIWindow *window;
@end

@implementation SVSettingsViewCtrl
{
    UITableViewCell *_networkcell;
    NSArray *_array;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSArray *array = [_networkcell subviews];
    for (UIView *view in array)
    {
        [view removeFromSuperview];
    }
    [self setNetworkImageAndType];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SVInfo (@"SVSettingsView");
    self.view.backgroundColor = [UIColor colorWithHexString:@"#fafafa"];
    //初始化控制器
    [self initwithctrl];
    // 创建一个 tableView, style:Grouped化合的,分组的
    _tableView = [self createTableViewWithRect:CGRectMake (FITWIDTH (22), 0, kScreenW - FITWIDTH (44),
                                                           kScreenH - FITHEIGHT (144))
                                     WithStyle:UITableViewStyleGrouped
                                     WithColor:[UIColor colorWithHexString:@"#fafafa"]
                                  WithDelegate:self
                                WithDataSource:self];

    // 把tableView添加到 view
    [self.view addSubview:_tableView];
}
//初始化控制器
- (void)initwithctrl
{
    NSString *title2 = I18N (@"About");
    NSString *title3 = I18N (@"QR Code");
    NSString *title4 = I18N (@"FAQ");
    NSString *title5 = I18N (@"Language Settings");
    NSString *title6 = I18N (@"Privacy Statemtent");
    NSString *title7 = I18N (@"Upload Logs");
    NSString *title8 = I18N (@"Advanced Settings");
    //初始化所有控制器
    SVAboutViewCtrl *about = [[SVAboutViewCtrl alloc] init];
    about.title = title2;
    SVQRCodeViewCtrl *QRCode = [[SVQRCodeViewCtrl alloc] init];
    QRCode.title = title3;
    SVFAQViewCtrl *faq = [[SVFAQViewCtrl alloc] init];
    faq.title = title4;
    SVLanguageSettingViewCtrl *languageSetting = [[SVLanguageSettingViewCtrl alloc] init];
    languageSetting.title = title5;
    SVPrivacyCtrl *privacyCtrl = [[SVPrivacyCtrl alloc] init];
    privacyCtrl.title = title6;
    SVLogViewController *logContr = [[SVLogViewController alloc] init];
    logContr.title = title7;
    SVAdvancedViewCtrl *advanced = [[SVAdvancedViewCtrl alloc] init];
    advanced.title = title8;
    //初始化控制器数组
    _array = [[NSArray alloc]
    initWithObjects:about, QRCode, faq, languageSetting, privacyCtrl, logContr, advanced, nil];
}
//创建UI
- (void)setNetworkImageAndType
{
    if (!_networkcell)
    {
        return;
    }
    NSString *title1 = I18N (@"Current Connection:");

    //准备字符串
    SVProbeInfo *probeInfo = [SVProbeInfo sharedInstance];
    NSString *carrier = probeInfo.isp;
    NSString *type = [probeInfo getBandwidthType];
    int bandwidthTypeIndex = [type intValue];
    NSString *Bandwidth = [probeInfo getBandwidth];
    NSString *title21 = I18N (@"Carrier");
    NSString *title22;
    /*
     !value11
     value11 == nil
     value11.length == 0
     */
    if ([carrier isEqualToString:@""] || !carrier)
    {
        title22 = I18N (@"Unknown");
    }
    else
    {
        title22 = carrier;
    }
    NSString *title23 = I18N (@"bandwidth type");
    NSString *titlea = I18N (@"Unknown");
    NSString *titleb = I18N (@"Fiber");
    NSString *titlec = I18N (@"Copper");
    NSString *title25 = I18N (@"Bandwidth package");
    NSString *title26;
    if ([Bandwidth isEqualToString:@""] || !Bandwidth)
    {
        title26 = I18N (@"Unknown");
    }
    else
    {
        title26 = [NSString stringWithFormat:@"%@M", Bandwidth];
    }

    SVRealReachability *realReachablity = [SVRealReachability sharedInstance];
    SVRealReachabilityStatus status = [realReachablity getNetworkStatus];

    NSString *title2;
    if (bandwidthTypeIndex == 0 && status == SV_RealStatusViaWiFi)
    {
        title2 = [NSString stringWithFormat:@"%@:  %@,%@:  %@,%@:  %@", title21, title22, title23,
                                            titlea, title25, title26];
    }
    if (bandwidthTypeIndex == 1 && status == SV_RealStatusViaWiFi)
    {
        title2 = [NSString stringWithFormat:@"%@:  %@,%@:  %@,%@:  %@", title21, title22, title23,
                                            titleb, title25, title26];
    }
    if (bandwidthTypeIndex == 2 && status == SV_RealStatusViaWiFi)
    {
        title2 = [NSString stringWithFormat:@"%@:  %@,%@:  %@,%@:  %@", title21, title22, title23,
                                            titlec, title25, title26];
    }

    if (bandwidthTypeIndex == 0 && status != SV_RealStatusViaWiFi)
    {
        title2 = [NSString stringWithFormat:@"%@:  %@", title21, title22];
    }
    if (bandwidthTypeIndex == 1 && status != SV_RealStatusViaWiFi)
    {
        title2 = [NSString stringWithFormat:@"%@:  %@", title21, title22];
    }
    if (bandwidthTypeIndex == 2 && status != SV_RealStatusViaWiFi)
    {
        title2 = [NSString stringWithFormat:@"%@:  %@", title21, title22];
    }


    UIImage *image1 = [UIImage imageNamed:@"ic_settings_mobile"];
    if (status == SV_RealStatusViaWiFi)
    {
        image1 = [UIImage imageNamed:@"ic_settings_wifi"];
    }

    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image1];
    imageView1.frame = CGRectMake (FITWIDTH (33), FITHEIGHT (33), FITHEIGHT (173), FITHEIGHT (173));
    [_networkcell addSubview:imageView1];

    UILabel *label11 = [[UILabel alloc] init];
    label11.text = title1;
    //设置字体和是否加粗
    label11.font = [UIFont systemFontOfSize:pixelToFontsize (54)];
    //    label11.backgroundColor = [UIColor redColor];
    label11.frame =
    CGRectMake (FITWIDTH (230), FITHEIGHT (43), [CTWBViewTools fitWidthToView:label11], FITHEIGHT (58));
    [_networkcell addSubview:label11];

    UILabel *label111 =
    [[UILabel alloc] initWithFrame:CGRectMake (label11.originX + label11.width, FITHEIGHT (43),
                                               FITWIDTH (300), FITHEIGHT (58))];

    //        label111.backgroundColor  = [UIColor blueColor];
    label111.text = I18N (@"Mobile Network");
    if (status == SV_RealStatusViaWiFi)
    {
        label111.text = I18N (@"WiFi");
    }

    //设置字体和是否加粗
    label111.font = [UIFont systemFontOfSize:pixelToFontsize (42)];
    //    label111.backgroundColor = [UIColor redColor];
    [_networkcell addSubview:label111];

    UILabel *label22 = [[UILabel alloc] init];
    label22.text = title2;
    label22.frame = CGRectMake (FITWIDTH (230), label111.bottomY, FITWIDTH (660), FITHEIGHT (150));
    label22.numberOfLines = 0;
    //    label22.backgroundColor = [UIColor blueColor];
    label22.font = [UIFont systemFontOfSize:pixelToFontsize (36)];
    [_networkcell addSubview:label22];
}
#pragma mark - tableview代理方法
//设置 tableView 的 numberOfSectionsInTableView(设置几个 section)
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
//设置 tableView的 numberOfRowsInSection(设置每个section中有几个cell)
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
        return _array.count;
}

// 设置 tableView 的行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return FITHEIGHT (130) * 2;
    }
    else
        return FITHEIGHT (130);
}

//设置 tableView的 cellForRowIndexPath(设置每个cell内的具体内容)
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";

    UITableViewCell *cell =
    [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];

    //取消cell 被点中的效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    //设置每个cell的内容
    if (indexPath.section == 0)
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        if (indexPath.row == 0)
        {
            _networkcell = cell;
            [self setNetworkImageAndType];
        }
    }
    else
    {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.font = [UIFont systemFontOfSize:pixelToFontsize (42)];
        cell.textLabel.textColor = [UIColor colorWithHexString:@"#000000"];
        UIViewController *crtl = [_array objectAtIndex:indexPath.row];
        cell.textLabel.text = crtl.title;

        if (indexPath.row == 1)
        {
            //添加二维码缩略图
            UIImageView *imageView =
            [[UIImageView alloc] initWithFrame:CGRectMake (kScreenW - FITWIDTH (220), FITHEIGHT (37),
                                                           FITHEIGHT (56), FITHEIGHT (56))];
            imageView.image = [UIImage imageNamed:@"litimg56"];
            [cell addSubview:imageView];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //当前连接
    if (indexPath.section == 0)
    {
        SVBWSettingViewCtrl *bandwidthSetting = [[SVBWSettingViewCtrl alloc] init];
        bandwidthSetting.title = I18N (@"Bandwidth Settings");
        [self.navigationController pushViewController:bandwidthSetting animated:YES];
    }

    if (indexPath.section == 1)
    {
        if (indexPath.row == 5)
        {
            [self UploadClicked];
            return;
        }
        UIViewController *viewCtrl = _array[indexPath.row];
        [self.navigationController pushViewController:viewCtrl animated:YES];
    }
}
//设置 tableView的section 的Header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return FITHEIGHT (48);
    }
    else
        return FITHEIGHT (30);
}
//设置 tableView的section 的Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - 上传日志按钮的点击事件
- (void)UploadClicked

{
    NSString *title1 = I18N (@"Upload Logs");
    NSString *title2 = I18N (@"Do you want to upload logs?");
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
        //上传日志
        SVInfo (@"开始上传日志");
        dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [self uploadLogFile];
        });
    }
}

//上传成功与失败判断
- (void)uploadLogFile
{
    SVLog *log = [SVLog sharedInstance];
    NSString *filePath = [log compressLogFiles];
    SVInfo (@"upload log file:%@", filePath);
    SVUploadFile *upload = [[SVUploadFile alloc] init];
    // 设置上报日志过程显示Toast提示用户上报进度
    [upload setShowToast:TRUE];
    [upload uploadFile:filePath];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
