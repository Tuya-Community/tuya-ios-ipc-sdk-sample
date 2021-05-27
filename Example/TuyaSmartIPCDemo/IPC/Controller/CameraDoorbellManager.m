//
//  CameraDoorbellManager.m
//  TuyaSmartIPCDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "CameraDoorbellManager.h"
#import "CameraDoorbellViewController.h"

@interface CameraDoorbellManager ()<TuyaSmartDoorBellObserver>

@property (nonatomic, weak) UIAlertController *alertVc;

@property (nonatomic, copy) NSString *messageId;

@end

@implementation CameraDoorbellManager

+ (instancetype)sharedInstance {
    static CameraDoorbellManager *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [CameraDoorbellManager new];
        [_instance setupDoorBellMannager];
    });
    return _instance;;
}

- (void)setupDoorBellMannager {
    TuyaSmartDoorBellManager *manager = [TuyaSmartDoorBellManager sharedInstance];
    manager.ignoreWhenCalling = YES;
    manager.doorbellRingTimeOut = 30;
}

- (void)addDoorbellObserver {
    [[TuyaSmartDoorBellManager sharedInstance] addObserver:self];
}

- (void)removeDoorbellObserver {
    [[TuyaSmartDoorBellManager sharedInstance] removeObserver:self];
}

- (void)hangupDoorBellCall {
    [[TuyaSmartDoorBellManager sharedInstance] hangupDoorBellCall:self.messageId];
}

#pragma mark - TuyaSmartDoorBellObserver

- (void)doorBellCall:(TuyaSmartDoorBellCallModel *)callModel didReceivedFromDevice:(TuyaSmartDeviceModel *)deviceModel {
    self.messageId = callModel.messageId;
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedStringFromTable(@"Dollbell is ringing", @"IPCLocalizable", @"") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Answer", @"IPCLocalizable", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        CameraDoorbellViewController *vc = [[CameraDoorbellViewController alloc] initWithDeviceId:deviceModel.devId];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        
        [[TuyaSmartDoorBellManager sharedInstance] answerDoorBellCall:self.messageId];
        
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [tp_topMostViewController() presentViewController:nav animated:YES completion:nil];
        
    }];
    [alertVc addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"Hangup", @"IPCLocalizable", @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[TuyaSmartDoorBellManager sharedInstance] hangupDoorBellCall:self.messageId];
        
    }];
    [alertVc addAction:action2];
    
    [tp_topMostViewController() presentViewController:alertVc animated:YES completion:nil];
    self.alertVc = alertVc;
}

- (void)doorBellCallDidRefuse:(TuyaSmartDoorBellCallModel *)callModel {
    [self.alertVc dismissViewControllerAnimated:YES completion:^{
        [self showAlertWithMessage:@"doorBellCallDidRefuse"];
    }];
}

- (void)doorBellCallDidHangUp:(TuyaSmartDoorBellCallModel *)callModel {
    [self.alertVc dismissViewControllerAnimated:YES completion:^{
        [self showAlertWithMessage:@"doorBellCallDidHangUp"];
    }];
}

- (void)doorBellCallDidAnsweredByOther:(TuyaSmartDoorBellCallModel *)callModel {
    [self.alertVc dismissViewControllerAnimated:YES completion:^{
        [self showAlertWithMessage:@"doorBellCallDidAnsweredByOther"];
    }];
}

- (void)doorBellCallDidCanceled:(TuyaSmartDoorBellCallModel *)callModel timeOut:(BOOL)isTimeOut {
    [self.alertVc dismissViewControllerAnimated:YES completion:^{
        if (isTimeOut) {
            [self showAlertWithMessage:NSLocalizedStringFromTable(@"Dollbell is ringing timeOut", @"IPCLocalizable", @"")];
        } else {
            [self showAlertWithMessage:NSLocalizedStringFromTable(@"The device has canceled doorbell ringing", @"IPCLocalizable", @"")];
        }
    }];
}

- (void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"ty_smart_scene_pop_know", @"IPCLocalizable", @"") style:UIAlertActionStyleCancel handler:nil]];
    [tp_topMostViewController() presentViewController:alertVc animated:YES completion:nil];
}

@end

