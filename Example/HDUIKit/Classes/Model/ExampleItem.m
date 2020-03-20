//
//  ExampleItem.m
//  HDUIKitComponents
//
//  Created by VanJay on 2020/2/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "ExampleItem.h"

@implementation ExampleItem
+ (instancetype)itemWithDesc:(NSString *)desc destVcName:(NSString *)destVcName {
    ExampleItem *item = [[self alloc] init];
    item.desc = desc;
    item.destVcName = destVcName;
    return item;
}
@end
