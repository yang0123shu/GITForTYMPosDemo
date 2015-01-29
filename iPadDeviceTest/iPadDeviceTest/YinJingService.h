//
//  YinJingService.h
//  YinJingService
//
//  Created by whty on 15/1/16.
//  Copyright (c) 2015年 whty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface YinJingService : NSObject

/**
 *  单例
 */
+ (YinJingService *)shareInstance;

/**
 *  获取版本号
 *
 *  @return 版本号
 */
- (NSString *)getYinJingApiVersion;

/**
 *  蓝牙：连接蓝牙设备。
 *
 *  @param device 待连接的设备，蓝牙时传递待连接的蓝牙设备对象
 *
 *  @return YES 成功  NO 失败
 */
- (BOOL)connectDevice:(CBPeripheral *)device;

/**
 *  断开蓝牙连接。
 */
- (BOOL)disconnectDevice;

/**
 *  蓝牙是否连接。
 */
- (BOOL)isDeviceConnected;

/**
 *获取外部读卡器设备ID
 */
- (NSString *)getDeviceId;

/**
 *获取设备参数
 */
- (NSDictionary *)getDeviceParams;

/**
 *更新工作密钥
 */
- (BOOL)updateCipherText:(NSString *)chipherText;

/**
 *设置AID参数
 */
- (BOOL)CMD_EmvAidManage:(int)managetype
            PbocAidParam:(NSString *)pbocAidParam
                 Version:(NSString *)version
              RepondTime:(long)repondTime;

/**
 *设置IC卡公钥参数
 */
- (BOOL)CMD_EmvPukManage:(int)managetype
            PbocPukParam:(NSString *)pbocPukParam
                 Version:(NSString *)version
              RepondTime:(long)repondTime;

/**
 *更新终端参数
 */
- (BOOL)updateDeviceParams:(Byte [])terminalTime
              MerchantCode:(Byte [])merchantCode
                TerminalID:(Byte [])terminalID
              MerchantName:(Byte [])merchantName;

/**
 *更新商户名
 */
- (BOOL)updateMerchantName:(NSString *)strname;

/**
 *获取卡号
 */
- (NSString *)getCardNumber:(int)timeout
                        Tip:(Byte [])tip;

/**
 *获取密码密文
 */
- (NSString *)getCipherText:(int)timeout
                        Tip:(Byte [])tip;

/**
 *取消当前指令
 */
- (void)cancelCurrentCommand;

/**
 *从设备输入金额
 */
- (NSString *)inputAmount:(int)timeout Tip:(Byte [])tip;

/**
 *更新工作密钥
 */
- (BOOL)updateCipherText:(Byte [])pinKey
                  MACKey:(Byte [])macKey
                  DESKey:(Byte [])desKey
                  TRKKey:(Byte [])trkKey
                 MKIndex:(int) mkIndex;

/**
 *使用传输密钥加解密数据
 */
- (NSString *)encriptData:(NSString *) data Mode:(int)mode;

/**
 *安全数据处理，计算MAC
 */
- (NSData *)processDataSecurity:(int)secureMode SrcData:(NSData *)srcData;

/**
 *EMV结束交易
 */
- (BOOL)CMD_EmvStop:(BOOL)stopLable
        RespondTime:(long)respondTime
            ResCode:(Byte)resCode;

/**
 *获取磁道或IC卡信息
 */
- (NSDictionary *)getTrackICText:(int)cardType
                          Amount:(float)amount
                     InputByUser:(BOOL)inputByUser
                         Timeout:(int)timeout
                             Tip:(Byte [])tip
                     RespondTime:(long)respondTime;


@end
