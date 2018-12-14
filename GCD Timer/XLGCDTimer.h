//
//  XLGCDTimer.h
//  GCD Timer
//
//  Created by XL Yuen on 2018/12/14.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface XLGCDTimer : NSObject



/**
 GCD 定时器：使用 block

 @param interval 时间间隔
 @param start 开始延迟的时间
 @param repeats 是否重复执行任务
 @param block 执行任务 block
 @return 返回一个定时器字符串名称，用于后续需要取消并移除定时器
 */
+ (NSString *)xl_timerNameWithTimeInterval:(NSTimeInterval)interval
                                     start:(NSTimeInterval)start
                                   repeats:(BOOL)repeats
                                     block:(void (^)(void))block;


/**
 GCD 定时器：target

 @param interval 时间间隔
 @param start 开始延迟的时间
 @param repeats 是否重复执行任务
 @param target target
 @param selector 方法
 @return 返回一个定时器字符串名称，用于后续需要取消并移除定时器
 */
+ (NSString *)xl_timerNameWithTimeInterval:(NSTimeInterval)interval
                                     start:(NSTimeInterval)start
                                   repeats:(BOOL)repeats
                                    target:(id)target
                                  selector:(SEL)selector;


/**
 取消 GCD 定时器

 @param name 定时器字符串名称
 */
+ (void)xl_cancelTimerWithTimerName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
