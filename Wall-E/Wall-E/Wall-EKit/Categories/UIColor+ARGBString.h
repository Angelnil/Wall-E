//
//  UIColor+ARGBString.h
//  
//
//  Created by Angle_Yan on 15/6/3.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (ARGBString)

/** 根据十六进制字符串得到默认颜色以及高亮颜色,一般用于按钮
 @param 十六进制字符串 eg: '#FFFFFF'
 @return 颜色数组，第一个为默认颜色
 */
+ (NSArray *)colorsWithARGBString:(NSString *) stringToConvert;


/** 根据十六进制字符串得到颜色
 @param 十六进制字符串 eg: '#FFFFFF'
 @return UIColor
 */
+ (UIColor *)colorWithARGBString:(NSString *) stringToConvert;
+ (UIColor *)colorWithARGBString:(NSString *) stringToConvert alpha:(CGFloat)alpha;


@end
