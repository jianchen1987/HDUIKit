//
//  NSString+HD_Util.m
//  HDUIKit
//
//  Created by VanJay on 2019/6/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "HDCommonDefines.h"
#import "NSString+HD_Util.h"

@implementation NSString (URL)
- (NSString *)hd_URLEncodedString {
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [self stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];

    return encodeUrl;
}

- (NSString *)hd_URLDecodedString {
    NSString *decodedString = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)self, CFSTR(""));
    return decodedString;
}
@end

@implementation NSString (JSON)

+ (NSString *)hd_convertWithJSONData:(id)infoDict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted  // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];

    NSString *jsonString = @"";

    if (!jsonData) {
        HDLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符

    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];

    return jsonString;
}

- (NSDictionary *)hd_dictionary {
    if (self == nil) {
        return nil;
    }
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if (err) {
        NSLog(@"json解析失败：%@", err);
        return nil;
    }
    return dic;
}

@end

@implementation NSString (ByteNum)

- (int)hd_byteNum {
    int num = 0;

    for (int i = 0; i < [self length]; i++) {

        NSString *word = [self substringWithRange:NSMakeRange(i, 1)];
        if ([word lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3) {
            num += 2;
        } else {
            num += 1;
        }
    }

    return num;
}

- (NSString *)hd_subStringByByteWithMaxLength:(NSInteger)maxLength {

    if (self.hd_byteNum <= maxLength) {
        return [[self mutableCopy] copy];
    }

    NSMutableString *subStr = [[NSMutableString alloc] init];

    for (int i = 0; i < [self length]; i++) {

        NSString *word = [self substringWithRange:NSMakeRange(i, 1)];
        if (subStr.hd_byteNum + word.hd_byteNum > maxLength) {
            break;
        }
        [subStr appendString:word];
    }

    return subStr;
}

@end

@implementation NSString (HTML)
- (NSString *)hd_stringForDealingWithNewLine {

    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"<br />" withString:@"\n"];
    string = [string stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];

    return string;
}
@end

@implementation NSString (Extension)

+ (NSString *)hd_groupedThousandsDigitStringWithStr:(NSString *)digitString {

    return [self hd_groupedDigitStringWithStr:digitString unitLength:3 sepStr:@","];
}

+ (NSString *)hd_groupedDigitStringWithStr:(NSString *)digitString unitLength:(NSUInteger)unitLength sepStr:(NSString *)sepStr {

    unitLength = unitLength == 0 ? 3 : unitLength;
    sepStr = sepStr.length <= 0 ? @"," : sepStr;

    // 判断小数部位
    NSRange rangeOfPoint = [digitString rangeOfString:@"."];
    NSString *pointStr = @"";
    if (rangeOfPoint.length >= 1) {
        pointStr = [digitString substringFromIndex:rangeOfPoint.location];
    }

    // 去掉小数部位
    digitString = [digitString substringToIndex:rangeOfPoint.location];

    // 去掉小数位后长度小于3直接返回原字符
    if (digitString.length <= unitLength) return [digitString stringByAppendingString:pointStr];

    NSMutableString *processString = [NSMutableString stringWithString:digitString];

    NSInteger location = processString.length - unitLength;
    NSMutableArray *processArray = [NSMutableArray array];
    while (location >= 0) {
        NSString *temp = [processString substringWithRange:NSMakeRange(location, unitLength)];

        [processArray addObject:temp];
        if (location < unitLength && location > 0) {
            NSString *t = [processString substringWithRange:NSMakeRange(0, location)];
            [processArray addObject:t];
        }
        location -= unitLength;
    }

    NSMutableArray *resultsArray = [NSMutableArray array];
    NSInteger k = 0;
    for (NSString *str in processArray) {
        k++;
        NSMutableString *tmp = [NSMutableString stringWithString:str];
        if (str.length > unitLength - 1 && k < processArray.count) {
            [tmp insertString:sepStr atIndex:0];
            [resultsArray addObject:tmp];
        } else {
            [resultsArray addObject:tmp];
        }
    }

    NSMutableString *resultString = [NSMutableString string];
    for (NSInteger i = resultsArray.count - 1; i >= 0; i--) {
        NSString *tmp = [resultsArray objectAtIndex:i];
        [resultString appendString:tmp];
    }

    return [resultString stringByAppendingString:pointStr];
}

- (NSArray<NSString *> *)hd_charArray {
    NSMutableArray<NSString *> *arr = [NSMutableArray arrayWithCapacity:self.length];
    for (int i = 0; i < self.length; i++) {
        NSString *singleChar = [NSString stringWithFormat:@"%C", [self characterAtIndex:i]];
        [arr addObject:singleChar];
    }
    return arr;
}

- (NSString *)hd_componentsSeparatedStringByString:(NSString *)separator unitLength:(NSInteger)unitLength {

    if (self.length <= 0) return self;

    NSInteger count = self.length / unitLength;
    if (self.length % unitLength != 0) {
        count += 1;
    }

    NSMutableArray<NSString *> *surStrArr = [NSMutableArray arrayWithCapacity:count];
    for (short i = 0; i < count; i++) {
        NSString *subStr = @"";
        if (self.length > i * unitLength + unitLength) {
            subStr = [self substringWithRange:NSMakeRange(i * unitLength, unitLength)];
        } else {
            subStr = [self substringFromIndex:i * unitLength];
        }

        [surStrArr addObject:subStr];
    }

    return [surStrArr componentsJoinedByString:separator];
}

- (NSString *)hd_timeTo12HoursFormat {
    if (self.length <= 0) return self;

    NSString *separatedStr;
    if ([self rangeOfString:@":"].location != NSNotFound) {
        separatedStr = @":";
    } else if ([self rangeOfString:@"："].location != NSNotFound) {
        separatedStr = @"：";
    } else {
        return self;
    }
    NSMutableArray<NSString *> *array = [NSMutableArray arrayWithArray:[self componentsSeparatedByString:separatedStr]];
    // 备份
    NSString *hour = array[0].copy;
    array[0] = [NSString stringWithFormat:@"%02zd", hour.integerValue == 12 ? hour.integerValue : (hour.integerValue % 12)];
    NSString *time = [array componentsJoinedByString:@":"];
    return [NSString stringWithFormat:@"%@ %@", time, hour.integerValue > 12 ? @"PM" : @"AM"];
}
@end

@implementation NSString (Filter)
- (NSString *)hd_replaceDoubleSpaceToOneSpace {
    NSString *detailText = [self stringByReplacingOccurrencesOfString:@"  " withString:@" "];
    if ([detailText rangeOfString:@"  "].length) {
        return [detailText hd_replaceDoubleSpaceToOneSpace];
    }
    return detailText;
}
@end
