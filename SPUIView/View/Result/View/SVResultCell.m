//
//  SVResultCell.m
//  SPUIView
//
//  Created by 许彦彬 on 16/1/25.
//  Copyright © 2016年 chinasofti. All rights reserved.
//
#define Gap 8
#define CellHeight (kScreenW - 20) * 0.19
#define LabelHeight 20
#define TimeHeight 10
#define CornerRadius 5

#import "SVResultCell.h"
#import <SPCommon/SVTimeUtil.h>
#import <SPService/SVSummaryResultModel.h>

@interface SVResultCell ()

@property (nonatomic, strong) UIImageView *imgViewType;
@property (nonatomic, strong) UILabel *testDate;
@property (nonatomic, strong) UILabel *testTime;
@property (nonatomic, strong) UILabel *videoMOS;
@property (nonatomic, strong) UILabel *loadTime;
@property (nonatomic, strong) UILabel *bandWidth;

@end

@implementation SVResultCell

@synthesize resultModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addUI];
    }
    return self;
}
//类型
- (UIImageView *)imgViewType
{
    if (_imgViewType == nil)
    {
        _imgViewType = [[UIImageView alloc] init];
        _imgViewType.frame =
        CGRectMake (Gap * 3.3, (CellHeight - LabelHeight) / 2, kScreenW / 15, kScreenH / 25);
    }
    return _imgViewType;
}
//时间——月日
- (UILabel *)testDate
{
    if (_testDate == nil)
    {
        _testDate = [[UILabel alloc] init];
        _testDate.frame = CGRectMake (kScreenW / 5 - FITHEIGHT (12),
                                      (CellHeight - LabelHeight - TimeHeight) / 2, kScreenW / 5, LabelHeight);
        _testDate.textColor = [UIColor blackColor];
        _testDate.font = [UIFont systemFontOfSize:13];
        _testDate.textAlignment = NSTextAlignmentCenter;
    }
    return _testDate;
}
//时间——时分秒
- (UILabel *)testTime
{
    if (_testTime == nil)
    {
        _testTime = [[UILabel alloc] init];
        _testTime.frame = CGRectMake (kScreenW / 5 - FITHEIGHT (12),
                                      (CellHeight - LabelHeight - TimeHeight) / 2 + LabelHeight,
                                      kScreenW / 5, LabelHeight);
        _testTime.textColor = [UIColor blackColor];
        _testTime.font = [UIFont systemFontOfSize:11];
        _testTime.textAlignment = NSTextAlignmentCenter;
    }
    return _testTime;
}
// U-vMOS
- (UILabel *)videoMOS
{
    if (_videoMOS == nil)
    {
        _videoMOS = [[UILabel alloc] init];
        _videoMOS.frame = CGRectMake (kScreenW * 2 / 5 - FITHEIGHT (12),
                                      (CellHeight - LabelHeight) / 2, kScreenW / 5, LabelHeight);
        _videoMOS.textColor = [UIColor blackColor];
        _videoMOS.font = [UIFont systemFontOfSize:13];
        _videoMOS.textAlignment = NSTextAlignmentCenter;
    }
    return _videoMOS;
}

//首次缓冲时间
- (UILabel *)loadTime
{
    if (_loadTime == nil)
    {
        _loadTime = [[UILabel alloc] init];
        _loadTime.frame = CGRectMake (kScreenW * 3 / 5 - FITHEIGHT (12),
                                      (CellHeight - LabelHeight) / 2, kScreenW / 6, LabelHeight);
        _loadTime.textColor = [UIColor blackColor];
        _loadTime.font = [UIFont systemFontOfSize:13];
        _loadTime.textAlignment = NSTextAlignmentCenter;
    }
    return _loadTime;
}
//速率
- (UILabel *)bandWidth
{
    if (_bandWidth == nil)
    {
        _bandWidth = [[UILabel alloc] init];
        _bandWidth.frame = CGRectMake (kScreenW * 4 / 5 - FITHEIGHT (30),
                                       (CellHeight - LabelHeight) / 2, kScreenW / 4, LabelHeight);
        _bandWidth.textColor = [UIColor blackColor];
        _bandWidth.font = [UIFont systemFontOfSize:13];
        _bandWidth.textAlignment = NSTextAlignmentCenter;
    }
    return _bandWidth;
}

//
- (UIButton *)bgdBtn
{
    if (_bgdBtn == nil)
    {
        _bgdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _bgdBtn.frame = CGRectMake (Gap, 0, kScreenW - 2 * Gap, CellHeight);
        _bgdBtn.layer.cornerRadius = CornerRadius * 2;
        _bgdBtn.layer.borderColor = [UIColor colorWithWhite:200 / 255.0 alpha:0.5].CGColor;
        _bgdBtn.layer.borderWidth = 1;
        [_bgdBtn addTarget:self
                    action:@selector (bgdBtnClick:)
          forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgdBtn;
}

- (void)bgdBtnClick:(UIButton *)button
{
    if (self.cellBlock)
    {

        _cellBlock ();
    }
}

- (void)addUI
{
    [self.contentView addSubview:self.bgdBtn];

    [self.bgdBtn addSubview:self.imgViewType];

    [self.bgdBtn addSubview:self.testDate];

    [self.bgdBtn addSubview:self.testTime];

    [self.bgdBtn addSubview:self.videoMOS];

    [self.bgdBtn addSubview:self.loadTime];

    [self.bgdBtn addSubview:self.bandWidth];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setResultModel:(SVSummaryResultModel *)_resultModel
{
    // WIFI 0  Mobile 1
    if ([_resultModel.type isEqualToString:@"0"])
    {
        self.imgViewType.image = [UIImage imageNamed:@"ic_network_type_wifi"];
    }
    else if ([_resultModel.type isEqualToString:@"1"])
    {
        self.imgViewType.image = [UIImage imageNamed:@"ic_network_type_mobile"];
    }

    NSString *testTime = _resultModel.testTime;
    //    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:([testTime longLongValue] /
    //    1000)];
    //
    //    NSDateFormatter *dataFormater = [[NSDateFormatter alloc] init];
    //    [dataFormater setDateStyle:NSDateFormatterMediumStyle];
    //    [dataFormater setTimeStyle:NSDateFormatterShortStyle];
    //    [dataFormater setDateFormat:@"MM/dd"];
    //
    //    NSDateFormatter *timeFormater = [[NSDateFormatter alloc] init];
    //    [timeFormater setDateStyle:NSDateFormatterMediumStyle];
    //    [timeFormater setTimeStyle:NSDateFormatterShortStyle];
    //    [timeFormater setDateFormat:@"HH:mm:ss"];

    //    SVInfo (@"date1:%@", [dataFormater stringFromDate:date]);
    //    SVInfo (@"time1:%@", [timeFormater stringFromDate:date]);
    self.testDate.text =
    [SVTimeUtil formatDateByMilliSecond:[testTime longLongValue] / 1000 formatStr:@"MM/dd"];
    self.testTime.text =
    [SVTimeUtil formatDateByMilliSecond:[testTime longLongValue] / 1000 formatStr:@"HH:mm:ss"];

    // 显示指标值，-1的显示--
    float uvmos = [_resultModel.UvMOS floatValue];
    if (uvmos == -1.0f)
    {
        self.videoMOS.text = @"--";
    }
    else
    {
        self.videoMOS.text = [NSString stringWithFormat:@"%.2f", uvmos];
    }

    double totalTime = [_resultModel.loadTime doubleValue];
    if (totalTime == -1.0f)
    {
        self.loadTime.text = @"--";
    }
    else
    {
        self.loadTime.text = [NSString stringWithFormat:@"%.2fs", totalTime];
    }

    double bandWidth = [_resultModel.bandwidth doubleValue];
    if (bandWidth == -1.0f)
    {
        self.bandWidth.text = @"--";
    }
    else
    {
        self.bandWidth.text = [NSString stringWithFormat:@"%.2fKbps", bandWidth];
    }
}

@end
