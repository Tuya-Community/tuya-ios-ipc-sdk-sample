//
//  CameraPTZControlView.m
//  TuyaSmartIPCDemo_Example
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "CameraPTZControlView.h"
#import <TuyaSmartCameraKit/TuyaSmartCameraKit.h>

@interface CameraPTZControlView ()<TuyaSmartPTZManagerDeletate>
@property (nonatomic, strong) TuyaSmartPTZManager *ptzManager;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *confirmBtn;
@end

@implementation CameraPTZControlView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    CGFloat btnWidth = 60;
    CGFloat btnHeight = 30;
    CGFloat horizonMargin = 30;
    CGFloat verticalMargin = 30;
    CGFloat centerX = self.bounds.size.width*0.5-30;
    CGFloat centerY = self.bounds.size.height*0.5-50;
    
    UIButton *upBtn = [self creatButtonWithTitle:NSLocalizedStringFromTable(@"UP", @"IPCLocalizable", @"") tag:TuyaSmartPTZControlDirectionUp];
    [self addSubview:upBtn];
    upBtn.frame = CGRectMake(centerX-0.5*btnWidth, centerY-btnHeight-verticalMargin, btnWidth, btnHeight);
    
    UIButton *downBtn = [self creatButtonWithTitle:NSLocalizedStringFromTable(@"DOWN", @"IPCLocalizable", @"") tag:TuyaSmartPTZControlDirectionDown];
    [self addSubview:downBtn];
    downBtn.frame = CGRectMake(centerX-0.5*btnWidth, centerY+verticalMargin, btnWidth, btnHeight);
    
    UIButton *leftBtn = [self creatButtonWithTitle:NSLocalizedStringFromTable(@"LEFT", @"IPCLocalizable", @"") tag:TuyaSmartPTZControlDirectionLeft];
    [self addSubview:leftBtn];
    leftBtn.frame = CGRectMake(centerX-btnWidth-horizonMargin, centerY-btnHeight*0.5, btnWidth, btnHeight);
    
    UIButton *rightBtn = [self creatButtonWithTitle:NSLocalizedStringFromTable(@"RIGHT", @"IPCLocalizable", @"") tag:TuyaSmartPTZControlDirectionRight];
    [self addSubview:rightBtn];
    rightBtn.frame = CGRectMake(centerX+horizonMargin, centerY-btnHeight*0.5, btnWidth, btnHeight);
    
    // Zoom In Button
    UIButton *biggerBtn = [self getDefaultButtonWithTitle:NSLocalizedStringFromTable(@"ZOOM IN", @"IPCLocalizable", @"")];
    [self addSubview:biggerBtn];
    biggerBtn.frame = CGRectMake(rightBtn.frame.origin.x+btnWidth+30, upBtn.frame.origin.y, btnWidth+20, btnHeight);
    [biggerBtn addTarget:self action:@selector(biggerBtnStart:) forControlEvents:UIControlEventTouchDown];
    [biggerBtn addTarget:self action:@selector(biggerBtnEnd:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    // Zoom Out Button
    UIButton *smallerBtn = [self getDefaultButtonWithTitle:NSLocalizedStringFromTable(@"ZOOM OUT", @"IPCLocalizable", @"")];
    [self addSubview:smallerBtn];
    smallerBtn.frame = CGRectMake(biggerBtn.frame.origin.x, rightBtn.frame.origin.y, btnWidth+20, btnHeight);
    [smallerBtn addTarget:self action:@selector(smallerBtnStart:) forControlEvents:UIControlEventTouchDown];
    [smallerBtn addTarget:self action:@selector(smallerBtnEnd:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    // Add Collection Point
    UIButton *addCPBtn = [self getDefaultButtonWithTitle:NSLocalizedStringFromTable(@"Add Collection Point", @"IPCLocalizable", @"")];
    [self addSubview:addCPBtn];
    addCPBtn.frame = CGRectMake(centerX+20-100, downBtn.frame.origin.y+btnHeight+30, 160, btnHeight);
    [addCPBtn addTarget:self action:@selector(addCollectionPoint:) forControlEvents:UIControlEventTouchUpInside];
    
    // Preset Point
    UIButton *presetBtn1 = [self getDefaultButtonWithTitle:NSLocalizedStringFromTable(@"Saved As Preset1", @"IPCLocalizable", @"")];
    [self addSubview:presetBtn1];
    presetBtn1.frame = CGRectMake(addCPBtn.origin.x, addCPBtn.frame.origin.y + addCPBtn.frame.size.height + 10, 160, btnHeight);
    [presetBtn1 addTarget:self action:@selector(presetBtn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *presetBtn2 = [self getDefaultButtonWithTitle:NSLocalizedStringFromTable(@"Saved As Preset2", @"IPCLocalizable", @"")];
    [self addSubview:presetBtn2];
    presetBtn2.frame = CGRectMake(presetBtn1.origin.x, presetBtn1.frame.origin.y + presetBtn1.frame.size.height + 10, 160, btnHeight);
    [presetBtn2 addTarget:self action:@selector(presetBtn2Click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.coverView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.coverView];
    self.coverView.backgroundColor = [UIColor whiteColor];
    self.coverView.hidden = YES;
    
    //Add Collection Point， Input name
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(UIScreen.mainScreen.bounds.size.width*0.5-100-20, 4, 200, btnHeight)];
    NSString *str = NSLocalizedStringFromTable(@"Input Name", @"IPCLocalizable", @"");
    textField.placeholder = [NSString stringWithFormat:@" %@", str];
    textField.font = [UIFont systemFontOfSize:13.0];
    textField.backgroundColor = [UIColor lightGrayColor];
    [self.coverView addSubview:textField];
    self.textField = textField;
    
    //Confirm Button
    UIButton *confirmBtn = [self getDefaultButtonWithTitle:NSLocalizedStringFromTable(@"Confirm", @"IPCLocalizable", @"")];
    [self.coverView addSubview:confirmBtn];
    confirmBtn.frame = CGRectMake(UIScreen.mainScreen.bounds.size.width*0.5-100-20, btnHeight + 8, 200, btnHeight);
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.confirmBtn = confirmBtn;
    
    UIButton *cancelBtn = [self getDefaultButtonWithTitle:NSLocalizedStringFromTable(@"Cancel", @"IPCLocalizable", @"")];
    [self.coverView addSubview:cancelBtn];
    CGRect confirmFrame = confirmBtn.frame;
    cancelBtn.frame = CGRectMake(confirmFrame.origin.x+confirmFrame.size.width+10, 4, 60, 88);
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Actions

- (void)addCollectionPoint:(UIButton *)btn {
    if (![self.ptzManager isSupportCollectionPoint]) {
        NSLog(@"Not support");
        return;
    }
    
    // 输入名称
    [self showInputView];
}

- (void)showInputView {
    self.coverView.hidden = NO;
    [self.textField becomeFirstResponder];
}

#pragma mark - Api impl

- (void)directionBtnStart:(UIButton *)btn {
    if (![self.ptzManager isSupportPTZControl]) {
        NSLog(@"Not support PTZ Control");
        return;
    }
    
    TuyaSmartPTZControlDirection direction = (TuyaSmartPTZControlDirection)btn.tag;
    [self.ptzManager startPTZWithDirection:direction success:^(id result) {
            
    } failure:^(NSError *error) {
        
    }];
}

- (void)directionBtnEnd:(UIButton *)btn {
    if (![self.ptzManager isSupportPTZControl]) {
        NSLog(@"Not support PTZ Control");
        return;
    }
    
    [self.ptzManager stopPTZWithSuccess:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)startPTZZoomWithIsEnlarge:(BOOL)isEnlarge {
    if (![self.ptzManager isSupportZoomAction]) {
        NSLog(@"Not support Zoom Action");
        return;
    }
    
    [self.ptzManager startPTZZoomWithIsEnlarge:isEnlarge success:^(id result) {
            
    } failure:^(NSError *error) {
        
    }];
}

- (void)stopPTZZoom {
    if (![self.ptzManager isSupportZoomAction]) {
        NSLog(@"Not support Zoom Action");
        return;
    }
    
    [self.ptzManager stopZoomActionWithSuccess:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)biggerBtnStart:(UIButton *)btn {
    [self startPTZZoomWithIsEnlarge:YES];
}

- (void)biggerBtnEnd:(UIButton *)btn {
    [self stopPTZZoom];
}

- (void)smallerBtnStart:(UIButton *)btn {
    [self startPTZZoomWithIsEnlarge:NO];
}

- (void)smallerBtnEnd:(UIButton *)btn {
    [self stopPTZZoom];
}

- (void)presetBtn1Click:(UIButton *)btn {
    BOOL isSupportPresetPoint = [self.ptzManager isSupportPresetPoint];
    if (!isSupportPresetPoint) {
        NSLog(@"Not support");
        return;
    }
    
    NSArray *presetPoints = [self.ptzManager requestSupportedPresetPoints];
    if (presetPoints.count>=1) {
        NSInteger index = [presetPoints[0] integerValue];
        __weak typeof(self) weakSelf = self;
        [self.ptzManager setPresetPointWithIndex:index success:^(id result) {
            NSLog(@"success");
            [weakSelf showAlertWithMessage:NSLocalizedStringFromTable(@"Success", @"IPCLocalizable", @"") complete:nil];
        } failure:^(NSError *error) {
            NSLog(@"error");
        }];
    }
}

- (void)presetBtn2Click:(UIButton *)btn {
    BOOL isSupportPresetPoint = [self.ptzManager isSupportPresetPoint];
    if (!isSupportPresetPoint) {
        NSLog(@"Not support");
        return;
    }
    
    NSArray *presetPoints = [self.ptzManager requestSupportedPresetPoints];
    if (presetPoints.count>=2) {
        NSInteger index = [presetPoints[1] integerValue];
        __weak typeof(self) weakSelf = self;
        [self.ptzManager setPresetPointWithIndex:index success:^(id result) {
            NSLog(@"success");
            [weakSelf showAlertWithMessage:NSLocalizedStringFromTable(@"Success", @"IPCLocalizable", @"") complete:nil];
        } failure:^(NSError *error) {
            NSLog(@"error");
        }];
    }
}

- (void)confirmBtnClick:(UIButton *)btn {
    [self.textField resignFirstResponder];
    self.coverView.hidden = YES;
    NSString *name = self.textField.text;
    if (name==nil || name.length==0) {
        name = @"Default";
    }

    __weak typeof(self) weakSelf = self;
    [self.ptzManager addCollectionPointWithName:name success:^{
        [weakSelf showAlertWithMessage:NSLocalizedStringFromTable(@"Success", @"IPCLocalizable", @"") complete:nil];
    } failure:^(NSError *error) {

    }];
}

- (void)cancelBtnClick:(UIButton *)btn {
    [self.textField resignFirstResponder];
    self.coverView.hidden = YES;
}

- (UIButton *)creatButtonWithTitle:(NSString *)title tag:(int)tag {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    btn.tag = tag;
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    
    [btn addTarget:self action:@selector(directionBtnStart:) forControlEvents:(UIControlEventTouchDown)];
    [btn addTarget:self action:@selector(directionBtnEnd:) forControlEvents:(UIControlEventTouchUpInside | UIControlEventTouchUpOutside)];
    
    return btn;
}

- (UIButton *)getDefaultButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    btn.backgroundColor = [UIColor lightGrayColor];
    btn.layer.cornerRadius = 4;
    btn.layer.masksToBounds = YES;
    return btn;
}

#pragma mark - Private

- (void)showAlertWithMessage:(NSString *)msg complete:(void(^)(void))complete {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:NSLocalizedStringFromTable(@"ipc_settings_ok", @"IPCLocalizable", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        !complete?:complete();
    }];
    [alert addAction:action];
    [self.fatherVc presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Getters
- (TuyaSmartPTZManager *)ptzManager {
    if (!_ptzManager) {
        _ptzManager = [[TuyaSmartPTZManager alloc] initWithDeviceId:_deviceId];
        _ptzManager.delegate = self;
    }
    return _ptzManager;
}

@end
