//
//  DeviceDetailTableViewController.h
//  TuyaSmartIPCDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceDetailTableViewController : UITableViewController
@property (strong, nonatomic) TuyaSmartDevice *device;
@end

NS_ASSUME_NONNULL_END
