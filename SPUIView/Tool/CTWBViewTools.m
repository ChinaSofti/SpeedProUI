//
//  CTWBViewTools.m
//  SPUIView
//
//  Created by WBapple on 16/1/25.
//  Copyright © 2016年 chinasofti. All rights reserved.
//
#import "CTWBViewTools.h"
#import "SVTextField.h"
#import "SVToast.h"
//微信分享
#import "WXApi.h"

//定义全局静态
//中奖界面的覆盖greybtn
static UIButton *greybtn;
//输入的手机号码
static SVTextField *textfield;

@implementation CTWBViewTools

#pragma mark - 通用白色圆角背景rounded background

+ (UIView *)createBackgroundViewWithFrame:(CGRect)frame cornerRadius:(CGFloat)radius
{
    //大小
    UIView *backgroundview = [[UIView alloc] initWithFrame:frame];
    //白的背景
    backgroundview.backgroundColor = [UIColor whiteColor];
    //圆角弧度
    backgroundview.layer.cornerRadius = radius;
    //子视图超出部分能够现实
    backgroundview.layer.masksToBounds = YES;

    return backgroundview;
}

#pragma mark - 标签Label

+ (UILabel *)createLabelWithFrame:(CGRect)frame
                         withFont:(CGFloat)font
                   withTitleColor:(UIColor *)color
                        withTitle:(NSString *)title
{
    //大小
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    //字体
    label.font = [UIFont systemFontOfSize:font];
    //字体颜色
    label.textColor = color;
    //内容
    label.text = title;

    return label;
}


#pragma mark - 文本输入框TextFiled
//普通的
+ (SVTextField *)createTextFieldWithFrame:(CGRect)frame
                              placeholder:(NSString *)placeholder
                                     Font:(float)font
                                fontColor:(UIColor *)color
                          characterLength:(int)characterLength
{

    //大小
    SVTextField *textField = [[SVTextField alloc] initWithFrame:frame];
    //灰色提示框
    textField.placeholder = placeholder;
    //文字对齐方式
    textField.textAlignment = NSTextAlignmentRight;
    //清除按钮
    textField.clearButtonMode = NO;
    //编辑状态下一直存在
    textField.rightViewMode = UITextFieldViewModeWhileEditing;
    //字体
    textField.font = [UIFont systemFontOfSize:font];
    //字体颜色
    textField.textColor = color;

    [textField setCharacterLength:characterLength];
    return textField;
}
//有左右视图的
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                              placeholder:(NSString *)placeholder
                                 passWord:(BOOL)YESorNO
                                 leftView:(UIView *)leftView
                                rightView:(UIView *)rightView
                                     Font:(float)font
                                fontColor:(UIColor *)color
{
    //大小
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    //灰色提示框
    textField.placeholder = placeholder;
    //文字对齐方式
    textField.textAlignment = NSTextAlignmentLeft;
    //把密码变成显示状态时有效
    textField.secureTextEntry = YESorNO;
    //边框类型
    // textField.borderStyle=UITextBorderStyleLine;
    //键盘类型
    //    textField.keyboardType=UIKeyboardTypeEmailAddress;
    //关闭首字母大写
    textField.autocapitalizationType = NO;
    //清除按钮
    textField.clearButtonMode = YES;
    //左图片
    textField.leftView = leftView;
    //左侧视图小图标
    textField.leftViewMode = UITextFieldViewModeAlways;
    //右图片
    textField.rightView = rightView;
    //编辑状态下一直存在
    textField.rightViewMode = UITextFieldViewModeWhileEditing;

    //字体
    textField.font = [UIFont systemFontOfSize:font];
    //字体颜色
    textField.textColor = color;

    return textField;
}
//带有线的
+ (UITextField *)createTextFieldWithFrame:(CGRect)frame
                              placeholder:(NSString *)placeholder
                                 passWord:(BOOL)YESorNO
                                 leftView:(UIView *)leftView
                                rightView:(UIView *)rightView
                                     Font:(float)font
                            withLineColor:(UIColor *)lineColor
                                lineWidth:(CGFloat)linewidth
{
    UITextField *textField = [self createTextFieldWithFrame:frame
                                                placeholder:placeholder
                                                   passWord:YESorNO
                                                   leftView:leftView
                                                  rightView:rightView
                                                       Font:font
                                                  fontColor:[UIColor blackColor]];

    if (lineColor)
    {
        //线条长
        CGFloat width = frame.size.width;
        if (linewidth)
        {
            width = linewidth;
        }

        UIView *lineView =
        [self lineViewWithFrame:CGRectMake (frame.origin.x, frame.size.height - 1, width, 0.5)
                      withColor:lineColor];

        [textField addSubview:lineView];
    }

    return textField;
}

//输入框左view
+ (UIView *)viewWithFrame:(CGRect)frame withImage:(UIImage *)image withTitle:(NSString *)title
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    if (title)
    {
        //大小
        view.frame = frame;
        //图片
        UIImageView *imageV = [[UIImageView alloc] initWithImage:image];
        [view addSubview:imageV];

        UILabel *label = [[UILabel alloc]
        initWithFrame:CGRectMake (imageV.rightX + 5, imageV.originY + 5, view.width - imageV.rightX - 5, 20)];
        //内容
        label.text = title;
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = RGBACOLOR (85, 85, 86, 1);
        [view addSubview:label];
    }
    else
    {
        view.frame = CGRectMake (0, 0, image.size.width + FITWIDTH (20), image.size.height);
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        view.backgroundColor = [UIColor orangeColor];
        [view addSubview:imageView];
    }
    return view;
}

#pragma mark - 按钮Button

+ (UIButton *)createBtnWithFrame:(CGRect)frame
                       withImage:(NSString *)btnImage
                       withTitle:(NSString *)title
{
    //类型
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //大小
    button.frame = frame;
    UIImageView *topImageV =
    [[UIImageView alloc] initWithFrame:CGRectMake (0, 0, button.width, button.width)];
    //图片
    topImageV.image = [UIImage imageNamed:btnImage];

    [button addSubview:topImageV];

    UILabel *titleLabel = [[UILabel alloc]
    initWithFrame:CGRectMake (-FITWIDTH (10), topImageV.bottomY + FITWIDTH (10), button.width + FITWIDTH (20),
                              button.height - topImageV.bottomY - FITWIDTH (3))];

    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textColor = [UIColor whiteColor];

    [button addSubview:titleLabel];

    return button;
}
+ (UIButton *)createBtnWithFrame:(CGRect)frame
                       withImage:(NSString *)btnImage
                       withTitle:(NSString *)title
                    withImgFrame:(CGRect)imgFrame
                  withLabelFrame:(CGRect)labelFrame
{
    // button的大小,图片,标题
    UIButton *button = [self createBtnWithFrame:frame withImage:btnImage withTitle:title];

    for (UIView *view in button.subviews)
    {
        if ([view isKindOfClass:[UIImageView class]])
        {
            //图片大小
            view.frame = imgFrame;
        }
        if ([view isKindOfClass:[UILabel class]])
        {
            if (labelFrame.size.width)
            {
                // label大小
                view.frame = labelFrame;
            }
            else
            {
                view.frame = CGRectMake (0, imgFrame.size.height, frame.size.width,
                                         frame.size.height - imgFrame.size.height);
            }
        }
    }

    return button;
}

#pragma mark 普通button背景图片
//高亮和不同状态
+ (UIButton *)createBtnWithFrame:(CGRect)frame
                 backgroundImage:(NSString *)backgroundImage
               hightlightedImage:(NSString *)hightlighted
                           title:(NSString *)title
                      titleColor:(UIColor *)titleColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setBackgroundImage:[UIImage imageNamed:backgroundImage] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:hightlighted]
                      forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTintColor:titleColor];
    return button;
}
//高亮,普通,选择三种状态
+ (UIButton *)createBtnWithFrame:(CGRect)frame
                     normalImage:(NSString *)normalImage
                   highlighImage:(NSString *)highlighImage
                     seleceImage:(NSString *)selectImage
                     normalTitle:(NSString *)normalTitle
                     normalColor:(UIColor *)normalColor
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    button.frame = frame;

    [button setTitle:normalTitle forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    [button setTitleColor:normalColor forState:UIControlStateNormal];


    [button setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highlighImage] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:selectImage] forState:UIControlStateSelected];

    return button;
}
//自定义UIBarButtonItem
+ (UIBarButtonItem *)itemWithImage:(NSString *)imageName
                     selectedImage:(NSString *)selectedImageName
                            Target:(id)target
                            action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];

    [button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.size = button.currentImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

// 文字与图片有偏移
+ (UIButton *)createBtnWithFrame:(CGRect)frame
                     normalImage:(NSString *)normalImage
                   highlighImage:(NSString *)highlighImage
                     seleceImage:(NSString *)selectImage
                     normalTitle:(NSString *)normalTitle
                     normalColor:(UIColor *)normalColor
                       titleEdge:(UIEdgeInsets)titleEdge
                       imageEdge:(UIEdgeInsets)imageEdge
{
    UIButton *button = [self createBtnWithFrame:frame
                                    normalImage:normalImage
                                  highlighImage:highlighImage
                                    seleceImage:selectImage
                                    normalTitle:normalTitle
                                    normalColor:normalColor];

    // button.imageEdgeInsets = UIEdgeInsetsMake( 0, 0, -60, 0);
    //设置image在button上的位置（上top，左left，下bottom，右right）这里可以写负值，对上写－5，那么image就象上移动5个像素
    button.titleLabel.textAlignment = NSTextAlignmentCenter; //设置title的字体居中
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleEdgeInsets = titleEdge;
    button.imageEdgeInsets = imageEdge;
    //设置title在button上的位置（上top，左left，下bottom，右right）

    return button;
}

#pragma mark - 线view
//线view
+ (UIView *)lineViewWithFrame:(CGRect)frame withColor:(UIColor *)color
{
    UIView *lineView = [[UIView alloc] initWithFrame:frame];

    if (color)
    {
        lineView.backgroundColor = color;
    }
    else
    {
        lineView.backgroundColor = RGBACOLOR (103, 104, 104, 0.8);
    }

    return lineView;
}

#pragma mark - 计算文字大小

+ (CGSize)getSizeWith:(NSString *)string size:(CGSize)bigSize font:(CGFloat)font
{
    CGSize size = [string boundingRectWithSize:bigSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{
                                        NSFontAttributeName: [UIFont systemFontOfSize:font]
                                    }
                                       context:nil]
                  .size;

    return size;
}

#pragma mark -  AlertController
+ (UIAlertController *)alertViewWithTitle:(NSString *)title
                                  message:(NSString *)message
                                  okTitle:(NSString *)okTitle
                                  okClick:(void (^) (void))okClick
                              cancelTitle:(NSString *)cancelTitle
                              cancelClick:(void (^) (void))cancelClick
{
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:title
                                                                       message:message
                                                                preferredStyle:UIAlertControllerStyleAlert];

    [alertView addAction:[UIAlertAction actionWithTitle:okTitle
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *action) {
                                                  okClick ();
                                                }]];

    [alertView addAction:[UIAlertAction actionWithTitle:cancelTitle
                                                  style:UIAlertActionStyleCancel
                                                handler:^(UIAlertAction *action) {
                                                  cancelClick ();
                                                }]];

    return alertView;
}

#pragma mark ActionSheet
+ (UIActionSheet *)actionSheet
{
    UIActionSheet *actionsheet = [[UIActionSheet alloc] init];
    actionsheet.title = @"woshi actionsheet";
    return actionsheet;
}
#pragma mark - 生成图片缩略图
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;

    if (nil == image)
    {
        newimage = nil;
    }
    else
    {
        CGSize oldsize = image.size;
        CGRect rect;

        if (asize.width / asize.height > oldsize.width / oldsize.height)
        {
            rect.size.width = asize.height * oldsize.width / oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        }
        else
        {
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldsize.height / oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }

        UIGraphicsBeginImageContext (asize);

        CGContextRef context = UIGraphicsGetCurrentContext ();

        CGContextSetFillColorWithColor (context, [[UIColor clearColor] CGColor]);

        UIRectFill (CGRectMake (0, 0, asize.width, asize.height)); // clear background

        [image drawInRect:rect];

        newimage = UIGraphicsGetImageFromCurrentImageContext ();

        UIGraphicsEndImageContext ();
    }
    return newimage;
}

#pragma mark - 表情输入

+ (BOOL)isContainsEmoji:(NSString *)string
{
    __block BOOL isEomji = NO;
    [string
    enumerateSubstringsInRange:NSMakeRange (0, [string length])
                       options:NSStringEnumerationByComposedCharacterSequences
                    usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                      const unichar hs = [substring characterAtIndex:0];
                      if (0xd800 <= hs && hs <= 0xdbff)
                      {
                          if (substring.length > 1)
                          {
                              const unichar ls = [substring characterAtIndex:1];
                              const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                              if (0x1d000 <= uc && uc <= 0x1f77f)
                              {
                                  isEomji = YES;
                              }
                          }
                      }
                      else if (substring.length > 1)
                      {
                          const unichar ls = [substring characterAtIndex:1];
                          if (ls == 0x20e3)
                          {
                              isEomji = YES;
                          }
                      }
                      else
                      {
                          if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b)
                          {
                              isEomji = YES;
                          }
                          else if (0x2B05 <= hs && hs <= 0x2b07)
                          {
                              isEomji = YES;
                          }
                          else if (0x2934 <= hs && hs <= 0x2935)
                          {
                              isEomji = YES;
                          }
                          else if (0x3297 <= hs && hs <= 0x3299)
                          {
                              isEomji = YES;
                          }
                          else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 ||
                                   hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50 || hs == 0x231a)
                          {
                              isEomji = YES;
                          }
                      }
                    }];
    return isEomji;
}

#pragma mark - 取消searchbar背景色/图片

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake (0, 0, size.width, size.height);
    UIGraphicsBeginImageContext (rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext ();

    CGContextSetFillColorWithColor (context, [color CGColor]);
    CGContextFillRect (context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext ();
    UIGraphicsEndImageContext ();

    return image;
}

#pragma mark - 分享的点击事件

+ (void)shareClicked:(UIButton *)button
{
    NSString *title8 = I18N (@"Share on");
    NSString *title9 = I18N (@"Cancel");
    NSString *title10 = I18N (@"WeChat");
    NSString *title11 = I18N (@"Moments");
    //获取整个屏幕的window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *_grey = [[UIView alloc] initWithFrame:CGRectMake (0, 0, kScreenW, kScreenH)];
    _grey.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    //创建一个分享到sharetoview
    UIView *sharetoview =
    [[UIView alloc] initWithFrame:CGRectMake (0, kScreenH - FITHEIGHT (580), kScreenW, FITHEIGHT (580))];
    sharetoview.backgroundColor = [UIColor whiteColor];
    //创建一个分享到label
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake (0, 0, kScreenW, kScreenH / 10)];
    label.text = title8;
    label.font = [UIFont systemFontOfSize:pixelToFontsize (54)];
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    //创建一个显示取消的label2
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake (0, FITHEIGHT (43), kScreenW, kScreenH / 2)];
    label2.text = title9;
    label2.font = [UIFont systemFontOfSize:pixelToFontsize (54)];
    label2.textColor = [UIColor colorWithRed:0.179 green:0.625 blue:1.000 alpha:1.000];
    label2.textAlignment = NSTextAlignmentCenter;
    //创建2个分享按钮
    UIButton *button1 =
    [[UIButton alloc] initWithFrame:CGRectMake (kScreenW / 2 - FITWIDTH (305), kScreenH - FITHEIGHT (405),
                                                FITWIDTH (202), FITHEIGHT (202))];
    [button1 setImage:[UIImage imageNamed:@"share_to_wechat"] forState:UIControlStateNormal];
    [button1 addTarget:self
                action:@selector (Button1Click:)
      forControlEvents:UIControlEventTouchUpInside];
    UIButton *button2 =
    [[UIButton alloc] initWithFrame:CGRectMake (kScreenW / 2 + FITWIDTH (129), kScreenH - FITHEIGHT (405),
                                                FITWIDTH (202), FITHEIGHT (202))];
    [button2 setImage:[UIImage imageNamed:@"share_to_wechatmoments"] forState:UIControlStateNormal];
    [button2 addTarget:self
                action:@selector (Button2Click:)
      forControlEvents:UIControlEventTouchUpInside];
    //添加2个label
    //创建一个显示微信的label3
    UILabel *label3 = [[UILabel alloc]
    initWithFrame:CGRectMake (kScreenW / 2 - FITWIDTH (300), kScreenH / 10 + FITHEIGHT (202),
                              FITWIDTH (200), FITHEIGHT (58))];
    label3.text = title10;
    //    label3.backgroundColor = [UIColor redColor];
    label3.font = [UIFont systemFontOfSize:pixelToFontsize (45)];
    label3.textColor = [UIColor lightGrayColor];
    label3.textAlignment = NSTextAlignmentCenter;
    //创建一个显示微信朋友圈的label4
    UILabel *label4 = [[UILabel alloc]
    initWithFrame:CGRectMake (kScreenW / 2 + FITWIDTH (43), kScreenH / 10 + FITHEIGHT (202),
                              FITWIDTH (377), FITHEIGHT (58))];
    label4.text = title11;
    label4.font = [UIFont systemFontOfSize:pixelToFontsize (45)];
    label4.textColor = [UIColor lightGrayColor];
    label4.textAlignment = NSTextAlignmentCenter;

    //创建取消button
    UIButton *button3 = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, kScreenW, kScreenH)];
    [button3 addTarget:self
                action:@selector (Button3Click:)
      forControlEvents:UIControlEventTouchUpInside];
    //添加
    [sharetoview addSubview:label];
    [sharetoview addSubview:label2];
    [sharetoview addSubview:label3];
    [sharetoview addSubview:label4];
    [_grey addSubview:sharetoview];
    [window addSubview:_grey];
    [_grey addSubview:button3];
    [_grey addSubview:button1];
    [_grey addSubview:button2];
}
//微信群组的分享方法实现
+ (void)Button1Click:(UIButton *)btn
{

    //创建一个0-100的随机数
    int randomx = arc4random () % 101;
    NSLog (@"随机数是:-------------%d", randomx);
    //字符串拼接1
    NSString *titlea = I18N (@"I am at the ");
    NSString *titleb1 = I18N (@"Mastery");
    NSString *titleb2 = I18N (@"Expertise");
    NSString *titleb3 = I18N (@"Proficiency");
    NSString *titleb4 = I18N (@"Competence");
    NSString *titleb5 = I18N (@"Novice");
    NSString *titlec = I18N (@" level.What is yours?");
    NSString *titleA1 = [[NSString alloc] initWithFormat:@"%@%@%@", titlea, titleb1, titlec];
    NSString *titleA2 = [[NSString alloc] initWithFormat:@"%@%@%@", titlea, titleb2, titlec];
    NSString *titleA3 = [[NSString alloc] initWithFormat:@"%@%@%@", titlea, titleb3, titlec];
    NSString *titleA4 = [[NSString alloc] initWithFormat:@"%@%@%@", titlea, titleb4, titlec];
    NSString *titleA5 = [[NSString alloc] initWithFormat:@"%@%@%@", titlea, titleb5, titlec];
    //字符串拼接2
    NSString *titley = I18N (@"I have defeated ");
    NSString *titlez =
    I18N (@"% of all users in the Red Envelope  War.Come on and test how fast you are!");
    NSString *titleB = [[NSString alloc] initWithFormat:@"%@%d%@", titley, randomx, titlez];

    NSString *kLinkURL = @"http://58.60.106.185:12210";
    NSString *kLinkTitle1 = titleA1;
    NSString *kLinkTitle2 = titleA2;
    NSString *kLinkTitle3 = titleA3;
    NSString *kLinkTitle4 = titleA4;
    NSString *kLinkTitle5 = titleA5;
    NSString *kLinkDescription = titleB;
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO; //不使用文本信息
    sendReq.scene = 0; // 0 = 好友列表 1 = 朋友圈 2 = 收藏

    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    //根据随机数判断要分享的标题
    if (randomx >= 95)
    {
        urlMessage.title = kLinkTitle1; //分享标题
    }
    if (randomx >= 80 && randomx <= 95)
    {
        urlMessage.title = kLinkTitle2; //分享标题
    }
    if (randomx >= 60 && randomx <= 80)
    {
        urlMessage.title = kLinkTitle3; //分享标题
    }
    if (randomx >= 10 && randomx <= 60)
    {
        urlMessage.title = kLinkTitle4; //分享标题
    }
    if (randomx >= 0 && randomx <= 10)
    {
        urlMessage.title = kLinkTitle5; //分享标题
    }
    urlMessage.description = kLinkDescription; //分享描述
    //根据随机数显示压缩图片
    NSString *str11 = I18N (@"share_image_frist_english");
    NSString *str21 = I18N (@"share_image_second_english");
    NSString *str31 = I18N (@"share_image_thrid_english");
    NSString *str41 = I18N (@"share_image_forth_english");
    NSString *str51 = I18N (@"share_image_last_english");
    //分享图片,使用SDK的setThumbImage方法可压缩图片大小
    if (randomx >= 95)
    {
        [urlMessage setThumbImage:[UIImage imageNamed:str11]];
    }
    if (randomx >= 80 && randomx <= 95)
    {
        [urlMessage setThumbImage:[UIImage imageNamed:str21]];
    }
    if (randomx >= 60 && randomx <= 80)
    {
        [urlMessage setThumbImage:[UIImage imageNamed:str31]];
    }
    if (randomx >= 10 && randomx <= 60)
    {
        [urlMessage setThumbImage:[UIImage imageNamed:str41]];
    }
    if (randomx >= 0 && randomx <= 10)
    {
        [urlMessage setThumbImage:[UIImage imageNamed:str51]];
    }

    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = kLinkURL; //分享链接

    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;

    //发送分享信息
    [WXApi sendReq:sendReq];

    //点击按钮按钮移除
    [btn.superview removeFromSuperview];

    //#pragma mark - 第二次网络请求
    //    //分享成功后,请求抽奖,服务器返回中了几等奖
    //    if ([WXApi sendReq:sendReq] == YES)
    //    {
    //#pragma mark -返回一个值A{1,2,3,0对应的是一等奖,二等奖,三等奖,没中奖}
    //        //        sendUrl
    //        //如果抽奖值为1/2/3
    //        [self creatWinUI:nil];
    //        //如果抽奖值为0
    //        //        [self creatLoseUI:nil];
    //    }
    //    if ([WXApi sendReq:sendReq] == NO)
    //    {
    //        [self creatLoseUI:nil];
    //    }
}
//微信朋友圈的分享方法实现
+ (void)Button2Click:(UIButton *)btn
{
    //创建一个0-100的随机数
    int randomx = arc4random () % 101;
    NSLog (@"随机数是:-------------%d", randomx);
    //字符串拼接1
    NSString *titlea = I18N (@"I am at the ");
    NSString *titleb1 = I18N (@"Mastery");
    NSString *titleb2 = I18N (@"Expertise");
    NSString *titleb3 = I18N (@"Proficiency");
    NSString *titleb4 = I18N (@"Competence");
    NSString *titleb5 = I18N (@"Novice");
    NSString *titlec = I18N (@" level.What is yours?");
    NSString *titleA1 = [[NSString alloc] initWithFormat:@"%@%@%@", titlea, titleb1, titlec];
    NSString *titleA2 = [[NSString alloc] initWithFormat:@"%@%@%@", titlea, titleb2, titlec];
    NSString *titleA3 = [[NSString alloc] initWithFormat:@"%@%@%@", titlea, titleb3, titlec];
    NSString *titleA4 = [[NSString alloc] initWithFormat:@"%@%@%@", titlea, titleb4, titlec];
    NSString *titleA5 = [[NSString alloc] initWithFormat:@"%@%@%@", titlea, titleb5, titlec];
    //字符串拼接2
    NSString *titlew = I18N (@"I have defeated ");
    NSString *titlez =
    I18N (@"% of all users in the Red Envelope  War.Come on and test how fast you are!");
    NSString *titleB = [[NSString alloc] initWithFormat:@"%@%d%@", titlew, randomx, titlez];

    NSString *kLinkURL = @"http://58.60.106.185:12210";
    NSString *kLinkTitle1 = titleA1;
    NSString *kLinkTitle2 = titleA2;
    NSString *kLinkTitle3 = titleA3;
    NSString *kLinkTitle4 = titleA4;
    NSString *kLinkTitle5 = titleA5;
    NSString *kLinkDescription = titleB;
    //创建发送对象实例
    SendMessageToWXReq *sendReq = [[SendMessageToWXReq alloc] init];
    sendReq.bText = NO; //不使用文本信息
    sendReq.scene = 1; // 0 = 好友列表 1 = 朋友圈 2 = 收藏

    //创建分享内容对象
    WXMediaMessage *urlMessage = [WXMediaMessage message];
    //根据随机数判断要分享的标题
    if (randomx >= 95)
    {
        urlMessage.title = kLinkTitle1; //分享标题
    }
    if (randomx >= 80 && randomx <= 95)
    {
        urlMessage.title = kLinkTitle2; //分享标题
    }
    if (randomx >= 60 && randomx <= 80)
    {
        urlMessage.title = kLinkTitle3; //分享标题
    }
    if (randomx >= 10 && randomx <= 60)
    {
        urlMessage.title = kLinkTitle4; //分享标题
    }
    if (randomx >= 0 && randomx <= 10)
    {
        urlMessage.title = kLinkTitle5; //分享标题
    }
    urlMessage.description = kLinkDescription; //分享描述
    NSString *str11 = I18N (@"share_image_frist_english");
    NSString *str21 = I18N (@"share_image_second_english");
    NSString *str31 = I18N (@"share_image_thrid_english");
    NSString *str41 = I18N (@"share_image_forth_english");
    NSString *str51 = I18N (@"share_image_last_english");
    //根据随机数显示压缩图片
    //分享图片,使用SDK的setThumbImage方法可压缩图片大小
    if (randomx >= 95)
    {
        [urlMessage setThumbImage:[UIImage imageNamed:str11]];
    }
    if (randomx >= 80 && randomx <= 95)
    {
        [urlMessage setThumbImage:[UIImage imageNamed:str21]];
    }
    if (randomx >= 60 && randomx <= 80)
    {
        [urlMessage setThumbImage:[UIImage imageNamed:str31]];
    }
    if (randomx >= 10 && randomx <= 60)
    {
        [urlMessage setThumbImage:[UIImage imageNamed:str41]];
    }
    if (randomx >= 0 && randomx <= 10)
    {
        [urlMessage setThumbImage:[UIImage imageNamed:str51]];
    }

    //创建多媒体对象
    WXWebpageObject *webObj = [WXWebpageObject object];
    webObj.webpageUrl = kLinkURL; //分享链接

    //完成发送对象实例
    urlMessage.mediaObject = webObj;
    sendReq.message = urlMessage;

    //发送分享信息
    [WXApi sendReq:sendReq];

    //点击按钮按钮移除
    [btn.superview removeFromSuperview];

    //#pragma mark - 第二次网络请求
    //    //分享成功后,请求抽奖,服务器返回中了几等奖
    //    if ([WXApi sendReq:sendReq] == YES)
    //    {
    //#pragma mark -返回一个值A{1,2,3,0对应的是一等奖,二等奖,三等奖,没中奖}
    //        //        sendUrl
    //        //如果抽奖值为1/2/3
    //        [self creatWinUI:nil];
    //        //如果抽奖值为0
    //        //        [self creatLoseUI:nil];
    //    }
    //    if ([WXApi sendReq:sendReq] == NO)
    //    {
    //        [self creatLoseUI:nil];
    //    }
}
//取消方法实现
+ (void)Button3Click:(UIButton *)btn
{
    [btn.superview removeFromSuperview];
}

#pragma mark - 中奖UI
+ (void)creatWinUI:(UIButton *)button
{
    NSString *title1 = I18N (@"Congratulations");
#pragma mark - -----------需要根据随机数进行字符串拼接
    NSString *title21 = I18N (@"You have won ");
    NSString *title22 = I18N (@"100-yuan");
    NSString *title23 = I18N (@" top up");
    NSString *title2 = [NSString stringWithFormat:@"%@%@%@", title21, title22, title23];
    NSString *title3 = I18N (@"Enter a phone number");
    NSString *title4 = I18N (@"Send");
    NSString *title5 = I18N (@"Contact:123456@Huawei.com");

    //获取整个屏幕的window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //创建一个覆盖garybutton
    greybtn = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, kScreenW, kScreenH)];
    greybtn.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    [greybtn addTarget:self
                action:@selector (numBackClick:)
      forControlEvents:UIControlEventTouchUpInside];
    //创建一个图片
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageview.size = CGSizeMake (kScreenW * 0.9, kScreenH);
    imageview.image = [UIImage imageNamed:@"draw_background"];
    imageview.center = CGPointMake (greybtn.frame.size.width / 2, greybtn.frame.size.height / 2);
    //创建一个label
    UILabel *label = [[UILabel alloc] init];
    label.text = title1;
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor yellowColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.size = CGSizeMake (200, 20);
    label.centerX = imageview.centerX / 1.08;
    label.centerY = imageview.centerY / 1.87;
    //创建关闭按钮
    UIButton *closebtn = [[UIButton alloc] init];
    [closebtn setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    closebtn.size = CGSizeMake (20, 20);
    closebtn.centerX = greybtn.centerX / 0.65;
    closebtn.centerY = greybtn.centerY / 1.86;
    [closebtn addTarget:self
                 action:@selector (greybtnBack)
       forControlEvents:UIControlEventTouchUpInside];
    //创建一个label2
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = title2;
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor yellowColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.size = CGSizeMake (200, 20);
    label2.centerX = imageview.centerX / 1.1;
    label2.centerY = imageview.centerY / 1.37;
    //创建一个textlabel
    textfield = [[SVTextField alloc] init];
    textfield.size = CGSizeMake (150, 20);
    textfield.centerX = imageview.centerX;
    textfield.centerY = imageview.centerY / 1.2;
    textfield.font = [UIFont systemFontOfSize:12];
    textfield.textAlignment = NSTextAlignmentCenter;
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.placeholder = title3;
    textfield.keyboardType = UIKeyboardTypePhonePad;
    [textfield setCharacterLength:11];
    //圆角弧度
    textfield.layer.cornerRadius = 10;
    //子视图超出部分能够现实
    textfield.layer.masksToBounds = YES;
    //添加textfield实时监听的方法
    [textfield addTarget:self
                  action:@selector (textFieldEditChanged:)
        forControlEvents:UIControlEventEditingChanged];
    //创建一个图片2
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageview2.size = CGSizeMake (kScreenW * 0.25, kScreenH * 0.15);
    imageview2.image = [UIImage imageNamed:@"draw_person"];
    imageview2.center = CGPointMake (greybtn.frame.size.width / 2.3, greybtn.frame.size.height / 2);
    //创建一个btn3
    UIButton *btn3 = [[UIButton alloc] init];
    [btn3 setTitle:title4 forState:UIControlStateNormal];
    [btn3 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:13];
    btn3.backgroundColor = [UIColor yellowColor];
    btn3.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn3.size = CGSizeMake (70, 30);
    btn3.centerX = greybtn.centerX;
    btn3.centerY = greybtn.centerY / 0.8;
    [btn3 addTarget:self
              action:@selector (sendClick:)
    forControlEvents:UIControlEventTouchUpInside];
    //创建一个label3
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = title5;
    label3.font = [UIFont systemFontOfSize:10];
    label3.textColor = [UIColor yellowColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.size = CGSizeMake (200, 20);
    label3.centerX = imageview.centerX / 1.08;
    label3.centerY = imageview.centerY / 0.73;
    //添加
    [greybtn addSubview:imageview];
    [imageview addSubview:label];
    [imageview addSubview:label2];
    [imageview addSubview:imageview2];
    [imageview addSubview:label3];
    [greybtn addSubview:textfield];
    [greybtn addSubview:closebtn];
    [greybtn addSubview:btn3];
    [window addSubview:greybtn];
}

#pragma mark - 没中奖UI
+ (void)creatLoseUI:(UIButton *)button
{
    NSString *title1 = I18N (@"Thanks for participation");
    NSString *title2 = I18N (@"Sorry for not getting the prize.");
    NSString *title3 = I18N (@"Try again.");
    NSString *title4 = I18N (@"Continue Test");
    //获取整个屏幕的window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    //创建一个覆盖garybutton
    greybtn = [[UIButton alloc] initWithFrame:CGRectMake (0, 0, kScreenW, kScreenH)];
    greybtn.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.3];
    //创建一个图片
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageview.size = CGSizeMake (kScreenW * 0.9, kScreenH);
    imageview.image = [UIImage imageNamed:@"draw_background"];
    imageview.center = CGPointMake (greybtn.frame.size.width / 2, greybtn.frame.size.height / 2);
    //创建关闭按钮
    UIButton *closebtn = [[UIButton alloc] init];
    [closebtn setImage:[UIImage imageNamed:@"close_btn"] forState:UIControlStateNormal];
    closebtn.size = CGSizeMake (20, 20);
    closebtn.centerX = greybtn.centerX / 0.63;
    closebtn.centerY = greybtn.centerY / 1.86;
    [closebtn addTarget:self
                 action:@selector (greybtnBack)
       forControlEvents:UIControlEventTouchUpInside];
    //创建一个label
    UILabel *label = [[UILabel alloc] init];
    label.text = title1;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor yellowColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.size = CGSizeMake (200, 20);
    label.centerX = imageview.centerX / 1.08;
    label.centerY = imageview.centerY / 1.87;
    //创建一个label2
    UILabel *label2 = [[UILabel alloc] init];
    label2.text = title2;
    label2.font = [UIFont systemFontOfSize:12];
    label2.textColor = [UIColor yellowColor];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.size = CGSizeMake (200, 20);
    label2.centerX = imageview.centerX / 1.1;
    label2.centerY = imageview.centerY / 1.1;
    //创建一个label3
    UILabel *label3 = [[UILabel alloc] init];
    label3.text = title3;
    label3.font = [UIFont systemFontOfSize:12];
    label3.textColor = [UIColor yellowColor];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.size = CGSizeMake (200, 20);
    label3.centerX = imageview.centerX / 1.1;
    label3.centerY = imageview.centerY;
    //创建一个button
    UIButton *btn = [[UIButton alloc] init];
    [btn setTitle:title4 forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.backgroundColor = [UIColor yellowColor];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.size = CGSizeMake (100, 30);
    btn.centerX = greybtn.centerX;
    btn.centerY = greybtn.centerY / 0.8;
    [btn addTarget:self
              action:@selector (greybtnBack)
    forControlEvents:UIControlEventTouchUpInside];
    //添加
    [imageview addSubview:label];
    [imageview addSubview:label2];
    [imageview addSubview:label3];
    [greybtn addSubview:imageview];
    [greybtn addSubview:btn];
    [greybtn addSubview:closebtn];
    [window addSubview:greybtn];
}
//退出键盘
+ (void)numBackClick:(UIButton *)btn
{
    [textfield resignFirstResponder];
}
//移除greybtnView
+ (void)greybtnBack
{
    [greybtn removeFromSuperview];
}
//发送号码方法
+ (void)sendClick:(UIButton *)btn
{
    NSString *title1 = I18N (@"Invalid phone number");
    NSString *title2 = I18N (@"A working day for you to recharge");
    //如果只不是11位手机号提示手机号无效
    if (textfield.text.length == 11)
    {
        [greybtn removeFromSuperview];
        [SVToast showWithText:title2];
        //获取textfield的值
        [self textFieldEditChanged:textfield.text];
#pragma mark - -----------第三次网络请求,发送手机号码到服务器
        NSLog (@"--------------%@", textfield.text);
    }
    else
    {
        [SVToast showWithText:title1];
    }
    //退出键盘
    [textfield resignFirstResponder];
}
//添加输入改变的方法
+ (void)textFieldEditChanged:(UITextField *)textField
{
    //    NSLog (@"textfield text %@", textField.text);
}


@end
