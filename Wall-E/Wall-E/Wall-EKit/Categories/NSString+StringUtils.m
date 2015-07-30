//
//  NSString+StringUtils.m
//  Wall-E
//
//  Created by Angle_Yan on 15/6/3.
//  Copyright (c) 2015年 Angelnil. All rights reserved.
//

#import "NSString+StringUtils.h"

#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "GTMBase64.h"


@implementation NSString (StringUtils)

// 正则表达式
#define EmailRegex          @"^([a-z0-9A-Z]+[-|\\.]?)+[a-z0-9A-Z]@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-zA-Z]{2,}$"
#define PhoneRegex          @"(^(01|1)[3,4,5,8][0-9])\\d{8}$"
#define UserNameRegex       @"^[A-Za-z0-9]{6,20}+$"
#define PassWordRegex       @"^[a-zA-Z0-9]{6,20}+$"
#define NicknameRegex       @"^[\u4e00-\u9fa5]{4,8}$"
#define IdentityCardRegex   @"^(\\d{14}|\\d{17})(\\d|[xX])$"
#define NumberRegex         @"^[0-9]\\d*$"
#define SpecialCharPattern  @"[!@#$%^&*?()\\s,.，　．！＠＃＄％＾＆＊（）｛｝=＿\\-—/+＋<>？]"

static NSURL *_phoneURL;

//字符串判空
+ (BOOL)isEmpty:(NSString *)string {
    //空格也算是空
    return !([string length] && [[string stringByReplacingOccurrencesOfString:@" " withString:@""] length]);
}
// 去除两端的空格
+ (NSString *)trimString:(NSString *)source {
    if (source == nil) {
        return @"";
    }
    return [source stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
// 转化 nil 的 string
+ (NSString *)nonnilString:(NSString *)originString {
    if ( ! originString) {
        return @"";
    }
    return originString;
}
//
+ (NSString *)nonemptyString:(NSString *)firstString andString:(NSString *)secondString {
    //去掉所有的空格
    if ([firstString length] && [[firstString stringByReplacingOccurrencesOfString:@" " withString:@""] length]) {
        return firstString;
    }
    if ([secondString length] && [[secondString stringByReplacingOccurrencesOfString:@" " withString:@""] length]) {
        return secondString;
    }
    return @"";
}

/**
 * 十进制转成2进制,8进制,16进制 。以及固定位数
 */
+(NSString *)changeNumber:(NSInteger)num toBinary:(BianaryType)type WithLength:(NSInteger )length {
    NSMutableString *binaryString = [NSMutableString string];
    NSInteger system = 2;
    if (type == bianary_2) {
        system = 2;
    } else if (type == bianary_8) {
        system = 8;
    } else if (type == bianary_16) {
        system = 16;
    }
    NSInteger remainder = 0;
    do {
        remainder = num%system;
        NSString *remaString = [NSString stringWithFormat:@"%d",remainder];
        if (remainder > 10) {
            switch (remainder) {
                case 10:
                    remaString = @"A";
                    break;
                case 11:
                    remaString = @"B";
                    break;
                case 12:
                    remaString = @"C";
                    break;
                case 13:
                    remaString = @"D";
                    break;
                case 14:
                    remaString = @"E";
                    break;
                case 15:
                    remaString = @"F";
                    break;
                default:
                    break;
            }
        }
        [binaryString insertString:remaString atIndex:0];
        num = num/system;
    } while (num != 0);
    if (binaryString.length < length) {
        NSInteger count = length-binaryString.length;
        for (int i = 0; i < count; i ++) {
            [binaryString insertString:@"0" atIndex:0];
        }
    }
    return binaryString;
}

/**
 * 2进制,8进制,16进制 转成十进制
 */
+(NSInteger)changeBinnaryStringToIntergerWith:(NSString *)binnaryString FromBinary:(BianaryType)type {
    NSInteger inter = 0;
    NSInteger length = binnaryString.length;
    NSInteger system = 2;
    if (type == bianary_2) {
        system = 2;
    } else if (type == bianary_8) {
        system = 8;
    } else if (type == bianary_16) {
        system = 16;
    }
    for (int i = length; i > 0; i --) {
        NSInteger number = 0;
        NSString *numStr = [binnaryString substringWithRange:NSMakeRange(length-i, 1)];
        if (numStr.intValue == 0 && ![numStr isEqualToString:@"0"]) {
            if ([numStr isEqualToString:@"A"]) {
                number = 10;
            } else if ([numStr isEqualToString:@"B"]){
                number = 11;
            } else if ([numStr isEqualToString:@"C"]){
                number = 12;
            } else if ([numStr isEqualToString:@"D"]){
                number = 13;
            } else if ([numStr isEqualToString:@"E"]){
                number = 14;
            } else if ([numStr isEqualToString:@"F"]){
                number = 15;
            }
        } else {
            number = numStr.intValue;
        }
        if (number != 0) {
            inter += number*powl(system, i-1);
        }
    }
    return inter;
}

#pragma mark - 正则表达式
//邮箱
+ (BOOL)isEmail:(NSString *)email {
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", EmailRegex];
    return [emailTest evaluateWithObject:email];
}
//手机号码验证
+ (BOOL)isMobilePhone:(NSString *)mobile {
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PhoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}
//用户名
+ (BOOL)isUserName:(NSString *)name {
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",UserNameRegex];
    BOOL B = [userNamePredicate evaluateWithObject:name];
    return B;
}
//密码
+ (BOOL)isPassword:(NSString *)passWord {
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PassWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

//昵称
+ (BOOL)isNickname:(NSString *)nickname {
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",NicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}
//身份证号
+ (BOOL)isIdentityCard:(NSString *)identityCard {
    if (identityCard.length <= 0) {
        return NO;
    }
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",IdentityCardRegex];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

//是否全为数字
+ (BOOL)isAllNumbers:(NSString *)string {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",NumberRegex];
    return [predicate evaluateWithObject:string];
    return YES;
}

//
+ (NSString *)deviceTokenFromString:(NSString *)string {
    NSString *deviceToken = [string stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"< >"]];
    deviceToken = [deviceToken stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [self nonnilString:[deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""]];
}
//将字符串分割
- (NSArray *)nonemptyComponentsSeparatedByString:(NSString *)separator {
    NSMutableArray *components = [NSMutableArray array];
    for (NSString *component in [self componentsSeparatedByString:separator]) {
        if ( ! [NSString isEmpty:component]) {
            [components addObject:component];
        }
    }
    return components;
}
//包含某字符串
- (BOOL)isContainString:(NSString *)subString {
    return [self rangeOfString:subString].location != NSNotFound;
}
// 搜索 searchT 中是否包含 string
+ (BOOL)searchResult:(NSString *)string searchText:(NSString *)searchT {
    NSComparisonResult result = [string compare:searchT
                                        options:NSCaseInsensitiveSearch
                                          range:NSMakeRange(0, searchT.length)];
    if (result == NSOrderedSame) {
        return YES;
    }
    else {
        return NO;
    }
}

//距离转化
+ (NSString *)distanceWithMeters:(NSInteger)meter {
    return [NSString stringWithFormat:@"%d%@", (meter > 1000 ? meter / 1000  : meter), (meter > 1000 ? @"千米" : @"米")];
}

#pragma mark UTF8编码解码
+ (NSString *)UTF8EncodedString:(NSString *)source {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)source,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8));
}
+ (NSString *)UTF8DecodedString:(NSString *)source {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (CFStringRef)source,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}

#pragma mark 格式化字符串

//常用的价格字符串格式化方法（默认：显示￥、显示小数点）
+ (NSString *)formatPrice:(NSNumber *)price {
    return [self formatPrice:price showMoneyTag:YES showDecimalPoint:YES useUnit:NO];
}

//常用的价格字符串格式化方法（默认：显示￥、显示小数点、显示元）
+ (NSString *)formatPriceWithUnit:(NSNumber *)price {
    return [self formatPrice:price showMoneyTag:YES showDecimalPoint:YES useUnit:YES];
}

//格式化价格字符串输出
+ (NSString *)formatPrice:(NSNumber *)price showMoneyTag:(BOOL)isTagUsed showDecimalPoint:(BOOL) isDecimal useUnit:(BOOL)isUnitUsed {
    NSString *formatedPrice = @"";
    //是否保留2位小数
    if (isDecimal) {
        formatedPrice = [NSString stringWithFormat:@"%0.2f", [price doubleValue]];
    } else {
        formatedPrice = [NSString stringWithFormat:@"%ld", (long)[price integerValue]];
    }
    //是否添加前缀 ￥
    if (isTagUsed) {
        formatedPrice = [NSString stringWithFormat:@"￥%@", formatedPrice];
    }
    //是否添加后缀 元
    if(isUnitUsed) {
        formatedPrice = [NSString stringWithFormat:@"%@元", formatedPrice];
    }
    return formatedPrice;
}


#pragma mark -- 打电话

+ (void)makeCall:(NSString *)phoneNumber {
    if ([self isEmpty:phoneNumber]) {
        return;
    }
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];//去掉-
    _phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",[self trimString:phoneNumber]]];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[NSString stringWithFormat:@"确定要拨打电话：%@？", phoneNumber] delegate:self cancelButtonTitle:@"" otherButtonTitles:@"", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        //消失
    } else {
        [[UIApplication sharedApplication] openURL:_phoneURL];
    }
}

@end


#pragma mark - SCSD
@implementation NSString (SCSD)

//
#define ImageThumbSizeNormal 200
#define ImageThumbSizeBig    400

static NSDictionary *viewControllerNames;
static NSString *_homePath;
static NSString *_resBaseUrl;

+ (void)initialize {
    viewControllerNames = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"viewControllerName" ofType:@"plist"]];
    _homePath = NSHomeDirectory();
}

+ (NSString *)homePath {
    return _homePath;
}

+ (NSString *)resBaseUrl {
    return _resBaseUrl;
}

+ (NSURL *)fullUrlWithPicturePath:(NSString *)picturePath {
    if ([NSString isEmpty:picturePath]) {
        return nil;
    }
    return [NSURL URLWithString:[self fullPathWithPicturePath:picturePath]];
}

+ (NSURL *)thumbnailUrlWithPicturePath:(NSString *)picturePath wantedWidth:(NSInteger)pictureWidth {
    if ([NSString isEmpty:picturePath]) {
        return nil;
    }
    return [NSURL URLWithString:[self thumbnailPathFromOriginPath:picturePath wantedWidth:pictureWidth]];
}

+ (NSString *)fullPathWithPicturePath:(NSString *)picturePath {
    NSString *newPicturePath = [self trimString:picturePath];//去掉字符串的空格
    if ([NSString isEmpty:newPicturePath]) {
        return @"";
    }
    NSString *suffixPath = [newPicturePath stringByReplacingOccurrencesOfString:[NSString resBaseUrl] withString:@""];
    NSString *fullPath = [[[NSString resBaseUrl] stringByAppendingString:suffixPath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"full picture path = %@", fullPath);
    return fullPath;
}

+ (NSString *)thumbnailPathFromOriginPath:(NSString *)picturePath {
    return [self thumbnailPathFromOriginPath:picturePath wantedWidth:ImageThumbSizeNormal];
}

+ (NSString *)thumbnailBigPathFromOriginPath:(NSString *)picturePath {
    return [self thumbnailPathFromOriginPath:picturePath wantedWidth:ImageThumbSizeBig];
}

+ (NSString *)thumbnailPathFromOriginPath:(NSString *)picturePath wantedWidth:(NSInteger)pictureWidth {
    if ( ! [picturePath hasSuffix:@"."]) {
        NSMutableString *thumbPath = [NSMutableString stringWithFormat:@"%@", picturePath];
        NSRange rangeOfDot = [thumbPath rangeOfString:@"." options:NSBackwardsSearch];
        [thumbPath insertString:[NSString stringWithFormat:@"_%ldx%ld", (long)pictureWidth, (long)pictureWidth]
                        atIndex:rangeOfDot.location == NSNotFound ? [thumbPath length] : rangeOfDot.location];
        
        return [self fullPathWithPicturePath:thumbPath];
    }
    return [self fullPathWithPicturePath:picturePath];
}

+ (NSString *)fullPathWithAudioPath:(NSString *)audioPath {
    if ([audioPath rangeOfString:[self homePath]].length) {     //本地路径
        return audioPath;
    }
    NSString *suffixPath = [audioPath stringByReplacingOccurrencesOfString:[NSString resBaseUrl] withString:@""];
    if ( ! suffixPath) {
        return @"";
    }
    return [[NSString resBaseUrl] stringByAppendingString:suffixPath];
}

+ (NSString *)friendlyNameForViewController:(NSString *)viewControllerClassName {
    NSString *viewControllerName = viewControllerNames[viewControllerClassName];
    if ( ! viewControllerName) {
        viewControllerName = [viewControllerClassName copy];
    }
    return viewControllerName;
}

@end


#pragma mark - MD5 加密
@implementation NSString (MD5)
//md5加密
+ (NSString *)md5FromString:(NSString *)string {
    if ([NSString isEmpty:string]) {
        return @"";
    }
    const char *str = [string UTF8String];
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *md5String = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                           r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    return md5String;
}
@end


#pragma mark - ThreeDES 加密
@implementation NSString (ThreeDES)

// 3des 加密
#define gkey               @"b0326c4f1e0e2c2970584b14a5a36d1886b4b115"
#define gIv                @"01234567"
#define kSecrectKeyLength  24

+ (NSString*)encrypt:(NSString*)plainText withKey:(NSString*)key{
    const char *cstr = [key cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:cstr length:key.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(keyData.bytes, (CC_LONG)keyData.length, digest);
    
    uint8_t keyByte[kSecrectKeyLength];
    for (int i=0; i<16; i++) {
        keyByte[i] = digest[i];
    }
    for (int i=0; i<8; i++) {
        keyByte[16+i] = digest[i];
    }
    
    NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
    size_t plainTextBufferSize = [data length];
    const void *vplainText = (const void *)[data bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) keyByte;
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCEncrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
    NSString *result = [GTMBase64 stringByEncodingData:myData];
    return result;
}

+ (NSString*)decrypt:(NSString*)encryptText withKey:(NSString*)key{
    
    const char *cstr = [key cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:key.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    uint8_t keyByte[kSecrectKeyLength];
    for (int i=0; i<16; i++) {
        keyByte[i] = digest[i];
    }
    for (int i=0; i<8; i++) {
        keyByte[16+i] = digest[i];
    }
    
    NSData *encryptData = [GTMBase64 decodeData:[encryptText dataUsingEncoding:NSUTF8StringEncoding]];
    size_t plainTextBufferSize = [encryptData length];
    const void *vplainText = [encryptData bytes];
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *) keyByte;
    NSLog(@"kkk %s",vkey);
    const void *vinitVec = (const void *) [gIv UTF8String];
    
    ccStatus = CCCrypt(kCCDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySize3DES,
                       vinitVec,
                       vplainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    
    NSString *result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                     length:(NSUInteger)movedBytes] encoding:NSUTF8StringEncoding];
    return result;
}

- (NSString*) sha1
{
    const char *cstr = [self cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
}

@end


