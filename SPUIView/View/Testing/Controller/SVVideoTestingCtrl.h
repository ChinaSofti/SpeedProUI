//
//  SVVideoTestingCtrl.h
//  SPUIView
//
//  Created by WBapple on 16/1/20.
//  Copyright © 2016年 chinasofti. All rights reserved.
//


/**
 *  视频测试中界面
 */

#import "SVCurrentResultModel.h"
#import <SPService/SVVideoTest.h>
#import <UIKit/UIKit.h>

@interface SVVideoTestingCtrl : UIViewController <SVVideoTestDelegate>

@property (nonatomic, retain) NSArray *selectedA;

@property (nonatomic, retain) UINavigationController *navigationController;

@property UITabBarController *tabBarController;

@property SVCurrentResultModel *currentResultModel;
@end