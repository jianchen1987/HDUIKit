//
//  HDUnitTextFieldTextPosition.m
//  HDUIKit
//
//  Created by VanJay on 2020/4/4.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDUnitTextFieldTextPosition.h"

@implementation HDUnitTextFieldTextPosition

+ (instancetype)positionWithOffset:(NSInteger)offset {
    HDUnitTextFieldTextPosition *position = [[self alloc] init];
    position->_offset = offset;
    return position;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    return [HDUnitTextFieldTextPosition positionWithOffset:self.offset];
}

@end
