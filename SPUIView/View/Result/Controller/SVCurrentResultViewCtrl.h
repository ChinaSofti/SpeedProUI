//
//  SVCurrentResultViewCtrl.h
//  SPUIView
//
//  Created by Rain on 2/14/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

/**
 *  当前结果页面
 */

#import "SVCurrentResultModel.h"
#import <UIKit/UIKit.h>

@interface SVCurrentResultViewCtrl : UIViewController

@property (nonatomic, retain) UINavigationController *navigationController;

@property SVCurrentResultModel *currentResultModel;

@end