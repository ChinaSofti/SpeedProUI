//
//  SVAdvancedViewCtrl.m
//  SPUIView
//
//  Created by XYB on 16/2/16.
//  Copyright © 2016年 chinasofti. All rights reserved.
//
#import "SVAdvancedViewCtrl.h"
#import "SVBandWidthCtrl.h"
#import <SPService/SVAdvancedSetting.h>

@interface SVAdvancedViewCtrl ()

@end

@implementation SVAdvancedViewCtrl
{
    UITextField *_textField;
    UIButton *_button;
    UIButton *_button2;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1];

    //设置LeftBarButtonItem
    [self createLeftBarButtonItem];
    [self createUI];
    [self createUIBandwidth];
}

//进去时 隐藏tabBar
- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HideTabBar" object:nil];
}
//出来时 显示tabBar
- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowTabBar" object:nil];
}

- (void)createLeftBarButtonItem
{
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, 45, 23)];
    [button setImage:[UIImage imageNamed:@"homeindicator"] forState:UIControlStateNormal];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *back0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                           target:nil
                                                                           action:nil];
    back0.width = -15;
    self.navigationItem.leftBarButtonItems = @[back0, backButton];
    [button addTarget:self
               action:@selector (leftBackButtonClick)
     forControlEvents:UIControlEventTouchUpInside];
}

- (void)leftBackButtonClick
{
    SVAdvancedSetting *setting = [SVAdvancedSetting sharedInstance];
    [setting setScreenSize:[_textField.text floatValue]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{
    NSString *title1 = I18N (@"Screen Size:");
    NSString *title2 = I18N (@"Inch");
    // views
    UIView *views = [[UIView alloc] init];
    views.frame = CGRectMake (10, 74, kScreenW - 20, 44);
    views.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:views];

    // label屏幕尺寸
    UILabel *lableScreenSize = [[UILabel alloc] init];
    lableScreenSize.frame = CGRectMake (10, 10, 100, 20);
    lableScreenSize.text = title1;
    lableScreenSize.font = [UIFont systemFontOfSize:14];
    [views addSubview:lableScreenSize];

    SVAdvancedSetting *setting = [SVAdvancedSetting sharedInstance];

    //文本框
    _textField = [[UITextField alloc] init];
    _textField.frame = CGRectMake (100, 10, kScreenW - 125, 20);
    _textField.text = setting.getScreenSize;
    _textField.placeholder = @"请输入13英寸~100英寸的数字";
    _textField.font = [UIFont systemFontOfSize:14];
    //设置文本框类型
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    //输入键盘类型
    _textField.keyboardType = UIKeyboardTypeDecimalPad;
    [views addSubview:_textField];

    //单位(英寸)
    UILabel *lableInch = [[UILabel alloc] init];
    lableInch.frame = CGRectMake (kScreenW - 55, 10, 30, 20);
    lableInch.text = title2;
    lableInch.font = [UIFont systemFontOfSize:14];
    [views addSubview:lableInch];
}
- (void)createUIBandwidth
{
    //获取默认值
    SVSpeedTestServers *servers = [SVSpeedTestServers sharedInstance];
    SVSpeedTestServer *object = [servers getDefaultServer];
    //取数组里的值
    SVSpeedTestServer * defaultvalue = object;
    
    NSString *title1 = @"带宽测试服务器配置";
    // views2
    UIView *views2 = [[UIView alloc] init];
    views2.frame =
    CGRectMake (FITTHEIGHT (10), FITTHEIGHT (125), kScreenW - FITTHEIGHT (20), FITTHEIGHT (100));
    views2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:views2];
    // label
    UILabel *lableScreenSize = [[UILabel alloc] init];
    lableScreenSize.frame = CGRectMake (FITTHEIGHT (10), FITTHEIGHT (10), FITTHEIGHT (200), FITTHEIGHT (20));
    lableScreenSize.text = title1;
    lableScreenSize.font = [UIFont systemFontOfSize:14];
    [views2 addSubview:lableScreenSize];
    // labelview
    UIView *labelview = [[UIView alloc]
    initWithFrame:CGRectMake (FITTHEIGHT (10), FITTHEIGHT (30), FITTHEIGHT (200), FITTHEIGHT (60))];
    //        labelview.backgroundColor = [UIColor yellowColor];
    labelview.layer.cornerRadius = 5;
    [views2 addSubview:labelview];
    // label1
    UILabel *label1 = [[UILabel alloc]
    initWithFrame:CGRectMake (FITTHEIGHT (10), FITTHEIGHT (10), FITTHEIGHT (200), FITTHEIGHT (20))];
    label1.text = defaultvalue.name;
    label1.font = [UIFont systemFontOfSize:14];
    //        label1.backgroundColor = [UIColor redColor];
    label1.layer.cornerRadius = 5;
    [labelview addSubview:label1];
    // label2
    UILabel *label2 = [[UILabel alloc]
    initWithFrame:CGRectMake (FITTHEIGHT (10), FITTHEIGHT (40), FITTHEIGHT (215), FITTHEIGHT (20))];
    label2.text = defaultvalue.sponsor;
    label2.font = [UIFont systemFontOfSize:11];
    //        label2.backgroundColor = [UIColor redColor];
    label2.layer.cornerRadius = 5;
    [labelview addSubview:label2];
    // button自动
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake (FITTHEIGHT (215), FITTHEIGHT (27), FITTHEIGHT (60), FITTHEIGHT (45));
    _button.backgroundColor = [UIColor colorWithRed:51 / 255.0 green:166 / 255.0 blue:226 / 255.0 alpha:1.0];
    //设置文字
    [_button setTitle:@"自动" forState:UIControlStateNormal];
    _button.titleLabel.font = [UIFont systemFontOfSize:15];
    _button.titleLabel.textAlignment = NSTextAlignmentCenter;
    _button.layer.cornerRadius = 5;
    [_button addTarget:self
               action:@selector (BtnClicked:)
     forControlEvents:UIControlEventTouchUpInside];
    [views2 addSubview:_button];
    // button选择
    _button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    _button2.frame = CGRectMake (FITTHEIGHT (285), FITTHEIGHT (27), FITTHEIGHT (60), FITTHEIGHT (45));
    _button2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    [_button2 setTitle:@"选择" forState:UIControlStateNormal];
    _button2.titleLabel.font = [UIFont systemFontOfSize:15];
    _button2.titleLabel.textAlignment = NSTextAlignmentCenter;
    _button2.layer.cornerRadius = 5;
    [_button2 addTarget:self
                action:@selector (Btn2Clicked:)
      forControlEvents:UIControlEventTouchUpInside];
    [views2 addSubview:_button2];
}
- (void)BtnClicked:(UIButton *)button
{
    SVInfo (@"自动");
    //自动获取方法
    [self createUIBandwidth];
    _button2.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _button.backgroundColor = [UIColor colorWithRed:51 / 255.0 green:166 / 255.0 blue:226 / 255.0 alpha:1.0];
}
- (void)Btn2Clicked:(UIButton *)button2
{
    SVInfo (@"选择");
    //跳转到带宽测试服务器列表
    SVBandWidthCtrl *bandwidthCtrl = [[SVBandWidthCtrl alloc] init];
    bandwidthCtrl.title = @"带宽测试服务器列表";
    [self.navigationController pushViewController:bandwidthCtrl animated:YES];
    _button.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _button2.backgroundColor = [UIColor colorWithRed:51 / 255.0 green:166 / 255.0 blue:226 / 255.0 alpha:1.0];
}
@end
