//
//  UIColor+ARGBString.m
//  
//
//  Created by Angle_Yan on 15/6/3.
//
//

#import "UIColor+ARGBString.h"
#import "NSString+StringUtils.h"


#define DEFAULT_VOID_COLOR [UIColor whiteColor]

@implementation UIColor (ARGBString)

+ (NSArray *)colorsWithARGBString:(NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    
    //例子，stringToConvert #ffffff
    if ([cString length] < 6){
        return [NSArray arrayWithObjects:DEFAULT_VOID_COLOR, nil];//如果非十六进制，返回白色
    }
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];//去掉头
    if ([cString length] != 6)//去头非十六进制，返回白色
        return [NSArray arrayWithObjects:DEFAULT_VOID_COLOR, nil];
    //分别取RGB的值
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [NSArray arrayWithObjects:[UIColor colorWithRed:((float) r / 255.0f)
                                                     green:((float) g / 255.0f)
                                                      blue:((float) b / 255.0f)
                                                     alpha:1.0f],
            [UIColor colorWithRed:((float) (r>40 ? r-30 : r) / 255.0f)
                            green:((float) (g>40 ? g-30 : g) / 255.0f)
                             blue:((float) (b>40 ? b-30 : b) / 255.0f)
                            alpha:1.0f],
            nil];
}


+ (UIColor *)colorWithARGBString:(NSString *) stringToConvert alpha:(CGFloat)alpha{
    
    if([NSString isEmpty:stringToConvert])
        return DEFAULT_VOID_COLOR;
    
    stringToConvert = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];//字符串处理
    
    //例子，stringToConvert #ffffff
    if ([stringToConvert length] < 6){
        return DEFAULT_VOID_COLOR;//如果非十六进制，返回白色
    }
    if ([stringToConvert hasPrefix:@"#"])
        stringToConvert = [stringToConvert substringFromIndex:1];//去掉头
    if ([stringToConvert length] != 6)//去头非十六进制，返回白色
        return DEFAULT_VOID_COLOR;
    
    unsigned int r, g, b;
    //NSScanner把扫描出的制定的字符串转换成Int类型
    [[NSScanner scannerWithString:[stringToConvert substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[stringToConvert substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[stringToConvert substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

+ (UIColor *)colorWithARGBString:(NSString *) stringToConvert
{
    return [UIColor colorWithARGBString:stringToConvert alpha:1.0];
}



+(UILabel *)initWithFrame:(CGRect)_frame String:(NSString *)_string Font:(UIFont *)_font TextAlignment:(NSTextAlignment)_textAlignment;
{
    UILabel *label = [[UILabel alloc] initWithFrame:_frame];
    label.text = _string;
    label.textAlignment = _textAlignment;
    label.font = _font;
    return label;
}


- (NSMutableAttributedString *)mutableColorString:(NSString *)string colorString:(NSString *)colorString color:(UIColor *)color font:(UIFont *)font
{
    return [UIColor mutableColorString:string colorStrings:[NSArray arrayWithObject:colorString] colors:[NSArray arrayWithObject:color] font:[NSArray arrayWithObject:font]];
}


//属性文本－设置
+ (NSMutableAttributedString *)mutableColorString:(NSString *)string colorStrings:(NSArray *)colorStrings colors:(NSArray *)colors font:(NSArray *)font
{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    
    for (int i = 0 ;i < colorStrings.count;i++) {
        NSString *s = [colorStrings objectAtIndex:i];
        long start = 0;
        while (start < string.length) {//遍历整个字符串中某个带颜色子字符串
            NSRange searchIn = NSMakeRange(start,str.length - start);
            NSRange range = [string rangeOfString:s options:NSLiteralSearch range:searchIn];
            start = range.location + range.length;
            if (colors.count > i){
                [str addAttribute:NSForegroundColorAttributeName value:[colors objectAtIndex:i] range:range];
                [str addAttribute:NSFontAttributeName value:[font objectAtIndex:i] range:range];
            }
            else
            {
                [str addAttribute:NSForegroundColorAttributeName value:[colors lastObject] range:range];
                [str addAttribute:NSFontAttributeName value:[font lastObject] range:range];
                
            }
        }
    }
    
    return str;
}

+ (NSMutableAttributedString *)attributedString:(NSString *)string lineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, string.length)];
    return attributedString;
}

+ (NSMutableAttributedString *)attributedString:(NSMutableAttributedString *)string addLineSpace:(CGFloat)lineSpace
{
    NSMutableAttributedString *attributedString = string;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, string.length)];
    return attributedString;
}

@end



