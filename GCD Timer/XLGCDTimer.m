//
//  XLGCDTimer.m
//  GCD Timer
//
//  Created by XL Yuen on 2018/12/14.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import "XLGCDTimer.h"

@implementation XLGCDTimer

static NSMutableDictionary *timers_;
dispatch_semaphore_t semaphore_;

+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timers_ = [NSMutableDictionary dictionary];
        semaphore_ = dispatch_semaphore_create(1);
    });
}

+ (NSString *)xl_timerNameWithTimeInterval:(NSTimeInterval)interval start:(NSTimeInterval)start repeats:(BOOL)repeats block:(void (^)(void))block {
    
    if (!block || start < 0 || (interval <= 0 && repeats)) return nil;

    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 创建定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    // 设置时间
    dispatch_source_set_timer(timer,
                              dispatch_time(DISPATCH_TIME_NOW, start * NSEC_PER_SEC),
                              interval * NSEC_PER_SEC, 0);
    
    // 保证线程安全
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    
    // 定时器的唯一标识
    NSString *name = [NSString stringWithFormat:@"%zd", timers_.count];
    // 存放到字典中
    timers_[name] = timer;
    
    // 保证线程安全
    dispatch_semaphore_signal(semaphore_);
    
    dispatch_source_set_event_handler(timer, ^{
        block();
        if (!repeats) { // 如果定时器任务不重复，则执行一下就取消定时器
            [self xl_cancelTimerWithTimerName:name];
        }
    });
    
    // 启动定时器
    dispatch_resume(timer);
    
    return name;
}

+ (NSString *)xl_timerNameWithTimeInterval:(NSTimeInterval)interval start:(NSTimeInterval)start repeats:(BOOL)repeats target:(id)target selector:(SEL)selector {
    
    if (!target || !selector) return nil;
    
    NSString *timerName = [self xl_timerNameWithTimeInterval:interval start:start repeats:repeats block:^{
        if ([target respondsToSelector:selector]) {
            // 取消警告 clang diagnostic
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [target performSelector:selector];
#pragma clang diagnostic pop
        }
    }];
    
    return timerName;
}

+ (void)xl_cancelTimerWithTimerName:(NSString *)name {
    
    if (name.length == 0) return;
    // 保证线程安全
    dispatch_semaphore_wait(semaphore_, DISPATCH_TIME_FOREVER);
    
    dispatch_source_t timer = timers_[name];
    
    if (timer) {
        dispatch_source_cancel(timer);
        [timers_ removeObjectForKey:name];
    }
    // 保证线程安全
    dispatch_semaphore_signal(semaphore_);
}

@end
