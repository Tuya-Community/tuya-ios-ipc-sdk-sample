//
//  EZModeTableViewController.m
//  TuyaSmartIPCDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "QRCodeModeTableViewController.h"
#import "Home.h"
#import "SVProgressHUD.h"
#import <TuyaSmartActivatorKit/TuyaSmartActivatorKit.h>
#import "UIImage+TYQRCode.h"

@interface QRCodeModeTableViewController () <TuyaSmartActivatorDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ssidTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) UILabel *tipLabel;
@property (strong, nonatomic) UIImageView *QRCodeView;

@property (strong, nonatomic) NSString *token;
@property (assign, nonatomic) bool isSuccess;

@property (nonatomic, assign) CGFloat originBrightness;
@end

@implementation QRCodeModeTableViewController

- (void)dealloc {
    [self resetScreenBrightness];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.originBrightness = [UIScreen mainScreen].brightness;
    [self registNotification];
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.tipLabel];
    self.tipLabel.frame = CGRectMake(20, 120, UIScreen.mainScreen.bounds.size.width-20*2, 70);
    
    [self.view addSubview:self.QRCodeView];
    CGFloat QRCodeViewWidth = 300;
    CGFloat QRCodeViewHeight = 300;
    self.QRCodeView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-QRCodeViewWidth)*0.5,  self.tipLabel.bottom+20, QRCodeViewWidth, QRCodeViewHeight);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self stopConfigWifi];
}

- (IBAction)searchTapped:(id)sender {
    [self.view endEditing:YES];
    // 屏幕亮度最大
    [self setScreenMaxBrightness];
    [self startConfiguration];
}

- (void)stopConfigWifi {
    [TuyaSmartActivator sharedInstance].delegate = nil;
    [[TuyaSmartActivator sharedInstance] stopConfigWiFi];
}

- (void)startConfiguration {
    long long homeId = [Home getCurrentHome].homeId;
    [[TuyaSmartActivator sharedInstance] getTokenWithHomeId:homeId success:^(NSString *result) {
        if (result && result.length > 0) {
            self.token = result;
        }
        [self startConfiguration:self.token];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }];
}

- (void)startConfiguration:(NSString *)token {
    NSString *ssid = self.ssidTextField.text;
    NSString *password = self.passwordTextField.text;
    [TuyaSmartActivator sharedInstance].delegate = self;
    
    [self generateQRCode];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[TuyaSmartActivator sharedInstance] startConfigWiFi:TYActivatorModeQRCode ssid:ssid password:password token:token timeout:100];
    });
}

- (void)generateQRCode {
    NSString *ssid = self.ssidTextField.text;
    NSString *password = self.passwordTextField.text;
    if (ssid == nil || password == nil || ssid.length == 0 || password.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"ssid or password can't be nil"];
        return;
    }
    NSDictionary *dictionary = @{
        @"s": ssid,
        @"p": password,
        @"t": self.token
    };
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:nil];
    NSString *wifiJsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    CGFloat width = self.view.frame.size.width - 44;
    if ([UIScreen mainScreen].bounds.size.width == 320 && [UIScreen mainScreen].bounds.size.height == 480) {
        width = 250;
    }
    UIImage *image = [UIImage ty_qrCodeWithString:wifiJsonStr width:width];
    self.QRCodeView.image = image;
}

-(void)activator:(TuyaSmartActivator *)activator didReceiveDevice:(TuyaSmartDeviceModel *)deviceModel error:(NSError *)error {
    if (deviceModel && error == nil) {
        NSString *name = deviceModel.name?deviceModel.name:NSLocalizedString(@"Unknown Name", @"Unknown name device.");
        [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@ %@" ,NSLocalizedString(@"Successfully Added", @"") ,name]];
        self.isSuccess = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (error) {
        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
    }
}

#pragma mark - note
- (void)registNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillBecomeActive)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)applicationWillResignActive {
    [self resetScreenBrightness];
}

- (void)applicationWillBecomeActive {
    [self setScreenMaxBrightness];
}

- (void)setScreenMaxBrightness {
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [UIScreen mainScreen].brightness = 0.8;
}

- (void)resetScreenBrightness {
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [UIScreen mainScreen].brightness = self.originBrightness;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        NSString *text = NSLocalizedStringFromTable(@"QRCodeActivatorTip", @"IPCLocalizable", @"");
        _tipLabel.text = text;
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
        _tipLabel.numberOfLines = 0;
    }
    return _tipLabel;
}

- (UIImageView *)QRCodeView {
    if (!_QRCodeView) {
        _QRCodeView = [[UIImageView alloc] init];
    }
    return _QRCodeView;
}

@end
