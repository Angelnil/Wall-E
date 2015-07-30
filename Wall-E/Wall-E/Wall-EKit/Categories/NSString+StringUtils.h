//
//  NSString+StringUtils.h
//  Wall-E
//
//  Created by Angle_Yan on 15/6/3.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    bianary_2 = 0,
    bianary_8,
    bianary_16,
}BianaryType;


@interface NSString (StringUtils) <UIAlertViewDelegate>
/** 
 * 判断 string 是否为空
 */
+ (BOOL)isEmpty:(NSString *)string;
/**
 *去除两端的空格
 */
+ (NSString *)trimString:(NSString *)source;
/** 
 *转化 nil 的 string
 */
+ (NSString *)nonnilString:(NSString *)originString;

+ (NSString *)nonemptyString:(NSString *)firstString andString:(NSString *)secondString;

/**
 * 十进制转成2进制,8进制,16进制 。以及固定位数
 */
+(NSString *)changeNumber:(NSInteger)num toBinary:(BianaryType)type WithLength:(NSInteger )length;
/**
 * 2进制,8进制,16进制 转成十进制
 */
+(NSInteger)changeBinnaryStringToIntergerWith:(NSString *)binnaryString FromBinary:(BianaryType)type;

#pragma mark -- 正则表达式
/**
 *格式是否为油箱格式
 */
+ (BOOL)isEmail:(NSString *)email;
/**
 *是否为手机号码
 */
+ (BOOL)isMobilePhone:(NSString *)mobile;
/**
 *是否为用户名
 */
+ (BOOL)isUserName:(NSString *)userName;
/**
 *是否为密码格式
 */
+ (BOOL)isPassword:(NSString *)passWord;
/**
 *真是姓名格式
 */
+ (BOOL)isNickname:(NSString *)nickname;
/**
 *生分证格式
 */
+ (BOOL)isIdentityCard:(NSString *)identityCard;
/**
 *纯数字
 */
+ (BOOL)isAllNumbers:(NSString *)string;

#pragma mark --
/** */
+ (NSString *)deviceTokenFromString:(NSString *)string;
/**
 *将字符 以 separator 分割 
 */
- (NSArray *)nonemptyComponentsSeparatedByString:(NSString *)separator;
/**
 *是否包含某个字符
 */
- (BOOL)isContainString:(NSString *)subString;
/**
 *搜索 searchT 中是否包含 string
 */
+ (BOOL)searchResult:(NSString *)string searchText:(NSString *)searchT;
/**
 *距离转成 string
 */
+ (NSString *)distanceWithMeters:(NSInteger)meter;
/**
 *拨打电话
 */
+ (void)makeCall:(NSString *)phoneNumber;
#pragma mark -- UTF8编码解码
+ (NSString *)UTF8EncodedString:(NSString *)source;
+ (NSString *)UTF8DecodedString:(NSString *)source;

#pragma mark -- 格式化金额字符串
/**
 *常用的价格字符串格式化方法（默认：显示￥、显示小数点）
 */
+ (NSString *)formatPrice:(NSNumber *)price;
/**
 *常用的价格字符串格式化方法（默认：显示￥、显示小数点、元)
 */
+ (NSString *)formatPriceWithUnit:(NSNumber *)price;
+ (NSString *)formatPrice:(NSNumber *)price showMoneyTag:(BOOL)isTagUsed showDecimalPoint:(BOOL) isDecimal useUnit:(BOOL)isUnitUsed;

@end

#pragma mark - SCSD
@interface NSString (SCSD)

+ (NSString *)resBaseUrl;
+ (NSURL *)fullUrlWithPicturePath:(NSString *)picturePath;
+ (NSString *)fullPathWithPicturePath:(NSString *)picturePath;
+ (NSURL *)thumbnailUrlWithPicturePath:(NSString *)picturePath wantedWidth:(NSInteger)pictureWidth;
+ (NSString *)thumbnailPathFromOriginPath:(NSString *)picturePath;
+ (NSString *)thumbnailBigPathFromOriginPath:(NSString *)picturePath;
+ (NSString *)thumbnailPathFromOriginPath:(NSString *)picturePath wantedWidth:(NSInteger)pictureWidth;
+ (NSString *)fullPathWithAudioPath:(NSString *)audioPath;
+ (NSString *)friendlyNameForViewController:(NSString *)viewControllerClassName;

@end


#pragma mark - MD5 加密
@interface NSString (MD5)
/**
 *MD5 加密 
 */
+ (NSString *)md5FromString:(NSString *)string;
@end


#pragma mark - 3DES 加密
@interface NSString (ThreeDES)
+ (NSString*)encrypt:(NSString*)plainText withKey:(NSString*)key;
+ (NSString*)decrypt:(NSString*)encryptText withKey:(NSString*)key;
- (NSString*)sha1;
@end

