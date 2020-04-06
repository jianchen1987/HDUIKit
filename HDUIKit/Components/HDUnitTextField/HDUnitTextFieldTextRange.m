//
//  HDUnitTextFieldTextRange.m
//  HDUIKit
//
//  Created by VanJay on 2020/4/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDUnitTextFieldTextRange.h"

@implementation HDUnitTextFieldTextRange
@dynamic range;
@synthesize start = _start, end = _end;

+ (instancetype)rangeWithRange:(NSRange)range {
    if (range.location == NSNotFound)
        return nil;

    HDUnitTextFieldTextPosition *start = [HDUnitTextFieldTextPosition positionWithOffset:range.location];
    HDUnitTextFieldTextPosition *end = [HDUnitTextFieldTextPosition positionWithOffset:range.location + range.length];
    return [self rangeWithStart:start end:end];
}

+ (instancetype)rangeWithStart:(HDUnitTextFieldTextPosition *)start end:(HDUnitTextFieldTextPosition *)end {
    if (!start || !end) return nil;
    assert(start.offset <= end.offset);
    HDUnitTextFieldTextRange *range = [[self alloc] init];
    range->_start = start;
    range->_end = end;
    return range;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [HDUnitTextFieldTextRange rangeWithStart:_start end:_end];
}

- (NSRange)range {
    return NSMakeRange(_start.offset, _end.offset - _start.offset);
}

@end
