//
//  ExecTime.m
//  CallBar
//
//  Created by apple on 15/6/10.
//  Copyright (c) 2015年 CloudRoom. All rights reserved.
//

#import "ExecTime.h"
#import <mach/mach_time.h>

@implementation ExecTime

+ (CGFloat)execTimeBlock:(execTimeBlock)block
{
    mach_timebase_info_data_t info;
    
    if (mach_timebase_info(&info) != KERN_SUCCESS)
    {
        return -1.0;
    }
    
    uint64_t start = mach_absolute_time ();
    
    block ();
    
    uint64_t end = mach_absolute_time ();
    
    uint64_t elapsed = end - start;
    
    uint64_t nanos = elapsed * info.numer / info.denom;
    
    return (CGFloat)nanos / NSEC_PER_SEC;
}

@end
