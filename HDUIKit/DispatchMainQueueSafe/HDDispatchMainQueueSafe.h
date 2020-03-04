//
//  HDDispatchMainQueueSafe.h
//  customer
//
//  Created by VanJay on 2018/8/18.
//  Copyright © 2018年 chaos network technology. All rights reserved.
//

#ifndef __TGDispatchMainQueueSafe__
#define __TGDispatchMainQueueSafe__

#include <stdio.h>

typedef void (^Cblock)(void);

#ifndef dispatch_main_async_safe
void dispatch_main_async_safe(Cblock block);
#endif

#ifndef dispatch_main_sync_safe
void dispatch_main_sync_safe(Cblock block);
#endif

#endif
