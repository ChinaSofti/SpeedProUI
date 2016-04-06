//
//  SVHttpsUtils.m
//  SpeedPro
//
//  Created by 徐瑞 on 16/4/5.
//  Copyright © 2016年 Huawei. All rights reserved.
//

#import "SVHttpsUtils.h"

@implementation SVHttpsUtils
{
    // 证书数组
    NSArray *trustedCerArr;

    // 失败次数
    int failCount;

    // URL请求对象
    NSURLRequest *urlRequest;

    // 响应数据
    NSMutableData *_allData;
}

- (id)initWithRequest:(NSURLRequest *)request
{
    self = [super init];
    if (!self)
    {
        return nil;
    }

    urlRequest = request;

    // 导入证书
    NSString *p12 = [[NSBundle mainBundle] pathForResource:@"testClient" ofType:@"p12"];
    NSData *cerData = [NSData dataWithContentsOfFile:p12];
    SecCertificateRef certificate = SecCertificateCreateWithData (NULL, (__bridge CFDataRef) (cerData));
    trustedCerArr = @[(__bridge_transfer id)certificate];

    return self;
}

- (void)sendHttpsRequest
{
    // 发送数据
    [NSURLConnection
    sendAsynchronousRequest:urlRequest
                      queue:[[NSOperationQueue alloc] init]
          completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {

            // 发送失败时继续请求
            if (connectionError && failCount < 3)
            {
                SVError (@"result push error:%@", connectionError);
                failCount++;
                [self sendHttpsRequest];
                return;
            }

            // 请求失败重试3次，然后弹出提示框
            if (failCount >= 3)
            {
                //                dispatch_async (dispatch_get_main_queue (), ^{
                //                  [self showAlertView];
                //                });
                SVInfo (@"result push failed！");
                return;
            }

            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            SVInfo (@"result push success %@", result);
          }];
}

// 初始化弹出框并显示
- (void)showAlertView
{
    UIAlertView *warningView =
    [[UIAlertView alloc] initWithTitle:@""
                               message:I18N (@"Upload the test result failed, continue?")
                              delegate:self
                     cancelButtonTitle:I18N (@"Cancel")
                     otherButtonTitles:I18N (@"Continue"), nil];
    [warningView setTag:100];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:warningView];
    [warningView show];
}

// 点击按钮时间
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // 判断是否是需要处理的alertView
    if (alertView.tag != 100)
    {
        return;
    }

    // 继续按钮的index是1
    if (buttonIndex == 1)
    {
        // 点击继续时，将failCount重置，然后继续发送请求
        failCount = 0;
        [self sendHttpsRequest];

        // 让alertView消失
        [alertView dismissWithClickedButtonIndex:0 animated:NO];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (error)
    {
        SVError (@"request URL:%@ fail.  Error:%@", urlRequest.URL.absoluteString, error);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (data)
    {
        if (!_allData)
        {
            _allData = [[NSMutableData alloc] init];
        }

        [_allData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if (_allData)
    {
        NSLog (@"request finished. data length:%zd", _allData.length);
    }
    else
    {
        NSLog (@"request finished. data length:0");
    }
}

// 回调
- (void)connection:(NSURLConnection *)connection
willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
    // 获取trust object
    SecTrustRef trust = challenge.protectionSpace.serverTrust;
    SecTrustResultType result;

    // 注意：这里将之前导入的证书设置成下面验证的Trust Object的anchor certificate
    SecTrustSetAnchorCertificates (trust, (__bridge CFArrayRef)trustedCerArr);

    // SecTrustEvaluate会查找前面SecTrustSetAnchorCertificates设置的证书或者系统默认提供的证书，对trust进行验证
    OSStatus status = SecTrustEvaluate (trust, &result);
    if (status == errSecSuccess && (result == kSecTrustResultProceed || result == kSecTrustResultUnspecified))
    {

        // 验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
        NSURLCredential *cred = [NSURLCredential credentialForTrust:trust];
        [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
    }
    else
    {
        // 验证失败，取消这次验证流程
        [challenge.sender cancelAuthenticationChallenge:challenge];
        SVError (@"Certificate authentication failure!");
    }
}

//- (void)connection:(NSURLConnection *)connection
// didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
//{
//    [challenge.sender useCredential:[NSURLCredential
//    credentialForTrust:challenge.protectionSpace.serverTrust]
//         forAuthenticationChallenge:challenge];
//}
//
//- (BOOL)connection:(NSURLConnection *)connection
// canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
//{
//    return [protectionSpace.authenticationMethod
//    isEqualToString:NSURLAuthenticationMethodServerTrust];
//}

@end