//
//  MainTableViewController.m
//  TuyaSmartIPCDemo
//
//  Copyright (c) 2014-2021 Tuya Inc. (https://developer.tuya.com/)

#import "MainTableViewController.h"
#import "Alert.h"
#import "Home.h"
#import <TuyaCloudStorageDebugger/TuyaCloudStorageDebugger.h>
#import <TuyaCameraAutomation/TuyaCameraAutomation.h>

#import <TuyaSmartCameraBase/TuyaSmartCameraBase.h>

@interface MainTableViewController ()

@property (weak, nonatomic) IBOutlet UIButton *logoutButton;
@property (weak, nonatomic) IBOutlet UILabel *currentHomeLabel;

@property (strong, nonatomic) TuyaSmartHomeManager *homeManager;
@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initiateCurrentHome];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([Home getCurrentHome]) {
        self.currentHomeLabel.text = [Home getCurrentHome].name;
    }
    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    }
}

- (void)initiateCurrentHome {
    [self.homeManager getHomeListWithSuccess:^(NSArray<TuyaSmartHomeModel *> *homes) {
        if (homes && homes.count > 0) {
            [Home setCurrentHome:homes.firstObject];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - IBAction

- (IBAction)logoutTapped:(UIButton *)sender {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"You're going to log out this account.", @"User tapped the logout button.") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *logoutAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Logout", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[TuyaSmartUser sharedInstance] loginOut:^{
            
            [TuyaSmartCameraFactory userDidLogOut];

            UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *nav = [mainStoryboard instantiateInitialViewController];
            [UIApplication sharedApplication].keyWindow.rootViewController = nav;
        } failure:^(NSError *error) {
            [Alert showBasicAlertOnVC:self withTitle:@"Failed to Logout." message:error.localizedDescription];
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel") style:UIAlertActionStyleCancel handler:nil];
    
    alertViewController.popoverPresentationController.sourceView = sender;
    [alertViewController addAction:logoutAction];
    [alertViewController addAction:cancelAction];
    [self.navigationController presentViewController:alertViewController animated:YES completion:nil];
}


#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0 && indexPath.row == 1) {
        [self logoutTapped:self.logoutButton];
    } else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            [[TuyaCloudStorageDebugger sharedInstance] startWithDeviceSpaceId:[Home getCurrentHome].homeId navigationController:self.navigationController];
        }else if (indexPath.row == 1) {
            UIViewController *vc = [[TYCameraAutomationPublicViewController alloc] initWithHomeId:[Home getCurrentHome].homeId];
            [self.navigationController pushViewController:vc animated:YES];
            
        }
        if (@available(iOS 11.0, *)) {
            self.navigationController.navigationBar.prefersLargeTitles = NO;
        }
    }
}

- (TuyaSmartHomeManager *)homeManager {
    if (!_homeManager) {
        _homeManager = [[TuyaSmartHomeManager alloc] init];
    }
    return _homeManager;
}

@end
