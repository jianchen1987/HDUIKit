//
//  NSCharacterSet+Extension.m
//  HDUIKit
//
//  Created by VanJay on 2019/9/5.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "NSCharacterSet+HDUIKit.h"

@implementation NSCharacterSet (HDUIKit)

+ (NSCharacterSet *)hd_URLUserInputQueryAllowedCharacterSet {
    NSMutableCharacterSet *set = [NSCharacterSet URLQueryAllowedCharacterSet].mutableCopy;
    [set removeCharactersInString:@"#&="];
    return set.copy;
}

@end
