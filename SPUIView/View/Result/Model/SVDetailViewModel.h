//
//  SVDetailViewModel.h
//  SPUIView
//
//  Created by Rain on 2/16/16.
//  Copyright © 2016 chinasofti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVDetailViewModel : NSObject

// sQuality会话得分：截止到当前的会话期间，视频质量得分，包含之前的所有采样周期
@property NSString *sQualitySession;
// sInteraction会话得分：截止到当前的会话期间，交互体验得分，包含之前的所有采样周期
@property NSString *sInteractionSession;
// sView会话得分：截止到当前的会话期间，观看体验得分，包含之前的所有采样周期
@property NSString *sViewSession;
// U-vMOS会话得分：截止到当前的会话期间，U-vMOS综合得分，包含之前的所有采样周期
@property NSString *UvMOSSession;
@property NSString *firstBufferTime; // 首次缓冲时间
@property NSString *videoCuttonTimes; // 视频卡顿次数
@property NSString *videoCuttonTotalTime; // 视频卡顿总时长
@property NSString *downloadSpeed; // 下载速率
@property NSString *frameRate; // 视频帧率
@property NSString *bitrate; // 视频码率
@property NSString *screenSize; // 屏幕尺寸
@property NSString *videoResolution; // 视频分辨率即：videoWidth * videoHeight
@property NSString *videoSegementURLString; // 视频地址
@property NSString *videoSegemnetLocation; // 视频分片位置
@property NSString *videoSegemnetISP; // 视频分片所属运营商
// 采集器信息
@property NSString *isp;
@property NSString *location;
@property NSString *signedBandwidth;
@property NSString *networkType;
@property NSString *singnal;
@property NSString *testTime;

@end
