# TuyaSmartCamera

[English](./README.md) | [中文版](./README-zh.md)

---

## Overview

Tuya Smart Camera SDK provides the interface package for communication with remote cameras to accelerate the application development process. The following features are supported:

* Preview images that are taken by remote cameras
* Play back video records from remote cameras
* Record video
* Speak to the remote camera
* Doorbell call service

## Fast integration

#### Use CocoaPods for integration (system version 9.0 or later)

Add the following code block to your Podfile:

```ruby
platform :ios, '9.0'

target 'your_target_name' do

  pod 'TuyaSmartHomeKit'
  pod 'TuyaSmartCameraKit'
  pod "TuyaCameraUIKit"
  pod 'TuyaSmartCloudServiceBizBundle'

end
```

TuyaSmartCameraKit does not support peer-to-peer (P2P) 1.0 by default. To integrate smart cameras that support P2P 1.0, add this code:  `pod 'TuyaSmartCameraT'` .

Run the command ```pod update``` in the root directory of the project to implement the integration.

For more information about CocoaPods, see [CocoaPods Guides](https://guides.cocoapods.org/).

## Reference

For more information, see [IPC SDK](https://developer.tuya.com/en/docs/app-development/ipccamera?id=Ka5vexydbwua5).

## Demo

1. Clone this repo to your local computer.

2. Open the terminal and run the following sample code:

   ```ruby
   cd tuyasmart_ipc_sdk_demo/Example/
   pod install
   ```

3. Open `TuyaSmartIPCDemo.xcworkspace`.

4. Add the security image named `t_s.bmp` to your project. For more information, see [Preparation](https://developer.tuya.com/en/docs/app-development/preparation?id=Ka69nt983bhh5).

5. Set `bundleId` to your bundle ID. 

6. Open `AppDelegate.m` and set `appKey` and `appSecret`.

7. To integrate modules that are purchased from the cloud storage service, configure the `ty_custom_config.json` file. In the file, the value of `appId` is obtained from the URL of the SDK configuration page. For example, if the URL is `https://iot.tuya.com/oem/sdk?id=xxx`, `xxx` indicates the value of `appId`. `tyAppKey` is your AppKey and `appScheme` is your channel identifier.

8. Run the project. Video decoding is supported by smart cameras. You can debug the code with your iPhone.

## Running result

The following figures show the image preview and record playback features.

![Preview](https://images.tuyacn.com/fe-static/docs/img/b0d0c34c-5ec4-4dc3-bdc7-25d030be9454.png) ![Playback](https://images.tuyacn.com/fe-static/docs/img/1fd97e98-25a9-4a4f-a10f-72bea17ca9ee.png)

## Change Log

For more information, see [Change Log](https://developer.tuya.com/en/docs/app-development/versionrecord?id=Ka5vox6pd09cn).

