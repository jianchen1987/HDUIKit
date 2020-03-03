//
//  NSObject+NSPointerArray+HD.h
//  HDUIKit
//
//  Created by VanJay on 2020/1/9.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSPointerArray (HDUIKit)

- (NSUInteger)hd_indexOfPointer:(nullable void *)pointer;
- (BOOL)hd_containsPointer:(nullable void *)pointer;
@end
