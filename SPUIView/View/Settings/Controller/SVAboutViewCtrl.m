//
//  SVAboutViewCtrl.m
//  SPUIView
//
//  Created by XYB on 16/2/16.
//  Copyright © 2016年 chinasofti. All rights reserved.
//

#import "SVAboutViewCtrl.h"
#import <SPCommon/SVLog.h>

@interface SVAboutViewCtrl ()
@end

@implementation SVAboutViewCtrl

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    //设置LeftBarButtonItem
    [self createLeftBarButtonItem];

    [self createUI];
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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI
{

    //添加imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake (0, 0, 80, 80)];
    imageView.image = [UIImage imageNamed:@"icon"];
    //创建手势添加的View
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake (40, 100, 80, 80)];
    [view addSubview:imageView];
    [self.view addSubview:view];

    //添加手势
    //单击
    UITapGestureRecognizer *singTap = [[UITapGestureRecognizer alloc] init];
    [singTap addTarget:self action:@selector (handleSingTap)];
    [singTap setNumberOfTapsRequired:1];
    [view addGestureRecognizer:singTap];
    //双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] init];
    [doubleTap addTarget:self action:@selector (handleDoubleTap)];
    [doubleTap setNumberOfTapsRequired:2];
    [view addGestureRecognizer:doubleTap];
    //区分单双击
    [singTap requireGestureRecognizerToFail:doubleTap];

    //添加LabSpeedPro
    UILabel *labSpeedPro = [[UILabel alloc]
    initWithFrame:CGRectMake (CGRectGetMaxX (view.frame) + 20, view.frame.origin.y, 120, 44)];
    labSpeedPro.text = @"SpeedPro";
    labSpeedPro.textColor = [UIColor blackColor];
    labSpeedPro.font = [UIFont systemFontOfSize:22]; //采用系统默认文字设置大小
    //[UIFont fontWithName:@"Arial" size:30];//设置文字类型与大小
    [self.view addSubview:labSpeedPro];

    //添加LabV0.00.32
    UILabel *labV = [[UILabel alloc]
    initWithFrame:CGRectMake (CGRectGetMaxX (view.frame) + 20, view.frame.origin.y + 45, 120, 44)];
    labV.text = @"V0.0.1";
    labV.textColor = [UIColor grayColor];
    labV.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:labV];

    //添加ViewLine
    UIView *viewLine = [[UIImageView alloc] initWithFrame:CGRectMake (40, 200, kScreenW - 80, 1)];
    viewLine.backgroundColor = [UIColor grayColor];
    viewLine.alpha = 0.2;
    [self.view addSubview:viewLine];

    //添加LabCopyright
    UILabel *labCopyright = [[UILabel alloc]
    initWithFrame:CGRectMake (viewLine.frame.origin.x, viewLine.frame.origin.y + 20, kScreenW - 80, 44)];
    labCopyright.text = @"Copyright @ Huawei Software Technologies Co.,";
    labCopyright.textColor = [UIColor grayColor];
    labCopyright.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labCopyright];

    //添加LabLtd
    UILabel *labLtd =
    [[UILabel alloc] initWithFrame:CGRectMake (labCopyright.frame.origin.x,
                                               labCopyright.frame.origin.y + 20, kScreenW - 80, 44)];
    labLtd.text = @"Ltd. 2016-2018.";
    labLtd.textColor = [UIColor grayColor];
    labLtd.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labLtd];

    //添加LabAllRights
    UILabel *labAllRights = [[UILabel alloc]
    initWithFrame:CGRectMake (labLtd.frame.origin.x, labLtd.frame.origin.y + 25, kScreenW - 80, 44)];
    labAllRights.text = @"All rights reserved.";
    labAllRights.textColor = [UIColor grayColor];
    labAllRights.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:labAllRights];
}
/**
 *  单击事件
 */
- (void)handleSingTap
{
    SVInfo (@"单击了");
}
/**
 *  双击事件
 */
- (void)handleDoubleTap
{
    SVInfo (@"双击了");
}
@end
