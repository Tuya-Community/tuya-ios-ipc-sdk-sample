//
//  TYCameraRecordListView.h
//  TuyaSmartPublic
//
//  Created by 傅浪 on 2018/4/16.
//  Copyright © 2018年 Tuya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TYCameraRecordCell.h"

@class TYCameraRecordListView, TYCameraRecordModel;

@protocol TYCameraRecordListViewDelegate <NSObject>

@optional
- (void)cameraRecordListView:(TYCameraRecordListView *)listView didSelectedRecord:(NSDictionary *)timeslice;

- (void)cameraRecordListView:(TYCameraRecordListView *)listView presentCell:(TYCameraRecordCell *)cell source:(id)source;

@end

@interface TYCameraEmptyDataView : UIView

@property (nonatomic, strong) UIImageView   *imageView;

@property (nonatomic, strong) UILabel       *textLabel;

@end

@interface TYCameraRecordListView : UIView<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@property (nonatomic, strong) TYCameraEmptyDataView *emptyDataView;

@property (nonatomic, weak) id<TYCameraRecordListViewDelegate> delegate;

@end
