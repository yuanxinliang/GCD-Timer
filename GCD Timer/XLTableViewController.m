//
//  XLTableViewController.m
//  GCD Timer
//
//  Created by XL Yuen on 2018/12/14.
//  Copyright © 2018 XL Yuen. All rights reserved.
//

#import "XLTableViewController.h"
#import "XLGCDTimer.h"

@interface XLTableViewController ()

@property (nonatomic, copy) NSString *GCDTimerBlock;
@property (nonatomic, copy) NSString *GCDTimerTarget;

@end

@implementation XLTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (!self.GCDTimerBlock) {
            [self creatGCDTimerBlock];
        } else {
            [self alert:@"定时器（Block）已有，如需要创建，先取消当前定时器。（这里为了测试方便定时器取消，其实定时器是可以创建N个的。）"];
        }
    } else if (indexPath.row == 1) {
        if (self.GCDTimerBlock) {
            [self cancelGCDTimerBlock];
        } else {
            [self alert:@"没有定时器需要取消，请开启一个定时器。"];
        }
    } else if (indexPath.row == 2) {
        if (!self.GCDTimerTarget) {
            [self creatGCDTimerTarget];
        } else {
            [self alert:@"定时器（Target）已有，如需要创建，先取消当前定时器。（这里为了测试方便定时器取消，其实定时器是可以创建N个的）"]; //
        }
    } else if (indexPath.row == 3) {
        if (self.GCDTimerTarget) {
            [self cancelGCDTimerTarget];
        } else {
            [self alert:@"没有定时器需要取消，请开启一个定时器。"];
        }
    }
}

- (void)creatGCDTimerBlock {
    self.GCDTimerBlock = [XLGCDTimer xl_timerNameWithTimeInterval:1 start:0 repeats:YES block:^{
        NSLog(@"GCD定时器（Block）");
    }];
}

- (void)cancelGCDTimerBlock {
    [XLGCDTimer xl_cancelTimerWithTimerName:self.GCDTimerBlock];
    self.GCDTimerBlock = nil;
    NSLog(@"取消GCD定时器（Block）");
}

- (void)creatGCDTimerTarget {
    self.GCDTimerTarget = [XLGCDTimer xl_timerNameWithTimeInterval:1 start:0 repeats:YES target:self selector:@selector(timerSelector)];
}

- (void)timerSelector {
    NSLog(@"GCD定时器（Target）");
}

- (void)cancelGCDTimerTarget {
    [XLGCDTimer xl_cancelTimerWithTimerName:self.GCDTimerTarget];
    self.GCDTimerTarget = nil;
    NSLog(@"取消GCD定时器（Target）");
}

- (void)alert:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
