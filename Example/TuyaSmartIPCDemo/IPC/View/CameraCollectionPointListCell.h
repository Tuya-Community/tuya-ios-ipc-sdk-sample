//
//  CameraCollectionPointListCell.h
//  TuyaSmartIPCDemo_Example
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class TYCameraCollectionPointModel;
@interface CameraCollectionPointListCell : UITableViewCell
@property (nonatomic, strong) TYCameraCollectionPointModel *model;
@property (nonatomic, copy) void (^didClickRenameButton)(TYCameraCollectionPointModel *model);
@property (nonatomic, copy) void (^didClickRemoveButton)(TYCameraCollectionPointModel *model);
@end

NS_ASSUME_NONNULL_END
