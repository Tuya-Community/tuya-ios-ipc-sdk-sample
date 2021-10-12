//
//  CameraMessageViewController.m
//  TuyaSmartIPCDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "CameraMessageViewController.h"
#import <TYEncryptImage/TYEncryptImage.h>
#import <TuyaSmartCameraKit/TuyaSmartCameraKit.h>

@interface CameraMessageViewController ()<UITableViewDelegate, UITableViewDataSource>
    
@property (nonatomic, strong) TuyaSmartCameraMessage *cameraMessage;

@property (nonatomic, strong) NSArray<TuyaSmartCameraMessageSchemeModel *> *schemeModels;

@property (nonatomic, strong) UISegmentedControl *segmentedControl;

@property (nonatomic, strong) UITableView *messageTableView;

@property (nonatomic, strong) NSArray<TuyaSmartCameraMessageModel *> *messageModelList;

@end

@implementation CameraMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.messageTableView];
    [self.cameraMessage getMessageSchemes:^(NSArray<TuyaSmartCameraMessageSchemeModel *> *result) {
        self.schemeModels = result;
        [self setupSegmentedControl];
        [self reloadMessageListWithScheme:result.firstObject];
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    }
}

- (NSString *)titleForCenterItem {
    return NSLocalizedStringFromTable(@"ipc_panel_button_message", @"IPCLocalizable", @"");
}

- (void)setupSegmentedControl {
    NSMutableArray *titles = [NSMutableArray new];
    [self.schemeModels enumerateObjectsUsingBlock:^(TuyaSmartCameraMessageSchemeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [titles addObject:obj.describe];
    }];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:titles];
    _segmentedControl.selectedSegmentIndex = 0;
    [self.view addSubview:_segmentedControl];
    _segmentedControl.frame = CGRectMake(0, CGRectGetMaxY(self.navigationController.navigationBar.frame), self.view.frame.size.width, 44);
    [_segmentedControl addTarget:self action:@selector(segmentedControlValueChanged) forControlEvents:UIControlEventValueChanged];
}

- (void)segmentedControlValueChanged {
    NSInteger index = self.segmentedControl.selectedSegmentIndex;
    TuyaSmartCameraMessageSchemeModel *schemeModel = [self.schemeModels objectAtIndex:index];
    [self reloadMessageListWithScheme:schemeModel];
}

- (void)reloadMessageListWithScheme:(TuyaSmartCameraMessageSchemeModel *)schemeModel {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:@"2019-09-17"];
    [self.cameraMessage messagesWithMessageCodes:schemeModel.msgCodes Offset:0 limit:20 startTime:[date timeIntervalSince1970] endTime:[[NSDate new] timeIntervalSince1970] success:^(NSArray<TuyaSmartCameraMessageModel *> *result) {
        self.messageModelList = result;
        [self.messageTableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

#pragma mark - message table view

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messageModelList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    TuyaSmartCameraMessageModel *messageModel = [self.messageModelList objectAtIndex:indexPath.row];
    NSArray *components = [messageModel.attachPic componentsSeparatedByString:@"@"];
    if (components.count != 2) {
        [cell.imageView ty_setImageWithURL:[NSURL URLWithString:messageModel.attachPic] placeholderImage:[self placeHolder]];
        
    }else {
        [cell.imageView ty_setAESImageWithPath:components.firstObject encryptKey:components.lastObject placeholderImage:[self placeHolder]];
    }
    cell.imageView.frame = CGRectMake(0, 0, 88, 50);
    cell.textLabel.text = messageModel.msgTitle;
    cell.detailTextLabel.text = messageModel.msgContent;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UIImage *)placeHolder {
    static UIImage *image = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIGraphicsBeginImageContext(CGSizeMake(88, 50));
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    });
    return image;
}

- (TuyaSmartCameraMessage *)cameraMessage {
    if (!_cameraMessage) {
        _cameraMessage = [[TuyaSmartCameraMessage alloc] initWithDeviceId:self.devId timeZone:[NSTimeZone defaultTimeZone]];
    }
    return _cameraMessage;
}

- (UITableView *)messageTableView {
    if (!_messageTableView) {
        CGFloat top = CGRectGetMaxY(self.navigationController.navigationBar.frame) + 44;
        CGFloat height = self.view.size.height - top;
        _messageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, top, self.view.size.width, height) style:UITableViewStylePlain];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
    }
    return _messageTableView;
}

@end
