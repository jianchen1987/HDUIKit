//
//  NSString+HD_Util.h
//  HDUIKit
//
//  Created by VanJay on 2019/6/18.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (URL)

- (NSString *)hd_URLEncodedString;
- (NSString *)hd_URLDecodedString;
@end

@interface NSString (JSON)

+ (NSString *)hd_convertWithJSONData:(id)infoDict;

+ (NSDictionary *)hd_dictionaryWithJsonString:(NSString *)jsonString;

@end

@interface NSString (ByteNum)
/// 计算字符串的字节数(汉字占两个)
@property (nonatomic, assign, readonly) int hd_byteNum;

// 从字符串中截取指定字节数 超出的不要
- (NSString *)hd_subStringByByteWithMaxLength:(NSInteger)maxLength;
@end

@interface NSString (HTML)

/// 支持换行
- (NSString *)hd_stringForDealingWithNewLine;
@end

@interface NSString (Extension)

/**
 *  将一个数字转为千位分隔符隔开的字符串
 *
 *  @param digitString 原字符串
 *
 *  @return 千位隔开的字符串
 */
+ (NSString *)hd_groupedThousandsDigitStringWithStr:(NSString *)digitString;
+ (NSString *)hd_groupedDigitStringWithStr:(NSString *)digitString unitLength:(NSUInteger)unitLength sepStr:(NSString *)sepStr;

/// 分割成单个字符数组
@property (nonatomic, copy, readonly) NSArray<NSString *> *hd_charArray;

/**
 根据特定长度分开
 
 @param separator 分隔字符
 @param unitLength 单位长度
 */
- (NSString *)hd_componentsSeparatedStringByString:(NSString *)separator unitLength:(NSInteger)unitLength;

/// 转字典
@property (nonatomic, copy, readonly) NSDictionary *hd_dictionary;

/** 时间转12小时制 */
@property (nullable, readonly, copy) NSString *hd_timeTo12HoursFormat;
@end

@interface NSString (Filter)
/// 连续两个空格转一个
@property (nonatomic, copy, readonly) NSString *hd_replaceDoubleSpaceToOneSpace;
@end

NS_ASSUME_NONNULL_END
