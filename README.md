# TuyaSmartCamera

[中文版](./README-zh.md) | [English](./README.md)

---

## Features Overview

Tuya Smart Camera SDK provides the interface package for the communication with remote camera device to accelerate the application development process, including the following features:

* Preview the picture taken by the camera
* Play back recorded video of the remote camera
* Record video
* Talk to the remote camera
* Doorbell call service

## Rapid Integration

#### Using CocoaPods integration（System version 9.0 or above is supported）

Add the following line to your Podfile:

```ruby
platform :ios, '9.0'

target 'your_target_name' do

  pod 'TuyaSmartHomeKit'
  pod 'TuyaSmartCameraKit'
  pod "TuyaCameraUIKit"
  pod 'TuyaSmartCloudServiceBizBundle'

end
```

TuyaSmartCameraKit is not support p2p 1.0 by default,  if you want integrate p2p 1.0 camera, you could add this code:  `pod 'TuyaSmartCameraT'` .

Execute command ```pod update``` in the project's root directory to begin integration.

For the instructions of CocoaPods, please refer to : [CocoaPods Guides](https://guides.cocoapods.org/)

## Doc

Refer to Details: [Tuya Smart Camera iOS SDK Doc](https://developer.tuya.com/cn/docs/app-development/ipccamera?id=Ka5vexydbwua5)

## Demo

1. Clone this repo to local.

2. Open terminal, run these command:

   ```ruby
   cd tuyasmart_ipc_sdk_demo/Example/
   pod install
   ```

3. Open `TuyaSmartIPCDemo.xcworkspace`.

4. Refer to [Preparation work](https://developer.tuya.com/cn/docs/app-development/preparation?id=Ka69nt983bhh5), add the security image named `t_s.bmp` to your project

5. Modify the `bundleId` as your bundleId. 

6. Open `AppDelegate.m`, complement the `appKey`, `appSecret`.

7. If you need to integrate modules purchased from cloud storage services, you need to configure the `ty_custom_config.json` file. In the file, the `appId` is obtained from the browser URL on the SDK configuration page, for example, the URL is `https://iot.tuya.com/oem/sdk?id=xxx`, where xxx is your `appId`. `tyAppKey` is your AppKey and ``appScheme`` is your channel identifier.

8. Run project. Since video decode with hardware decoding, so please debug with iPhone.

## Running Result

The following is the preview and playback effect pictures:

![Preview](https://images.tuyacn.com/fe-static/docs/img/01402207-902a-4627-aa98-8cc5d90abeb1.jpeg)
![Playback](https://images.tuyacn.com/fe-static/docs/img/e9f9b009-6202-4312-8c7c-e07f62105b4b.png)

## ChangeLog

[ChangeLog](https://developer.tuya.com/cn/docs/app-development/versionrecord?id=Ka5vox6pd09cn)

