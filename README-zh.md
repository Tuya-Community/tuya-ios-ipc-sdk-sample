# 涂鸦智能摄像头 iOS SDK

[中文版](./README-zh.md) | [English](./README.md)

---

## 功能概述

涂鸦智能摄像头 SDK 提供了与远端摄像头设备通讯的接口封装，加速应用开发过程，主要包括了以下功能：

- 预览摄像头实时采集的图像。
- 播放摄像头 SD 卡中录制的视频。
- 手机端录制摄像头采集的图像。
- 与摄像头设备通话。
- 门铃呼叫业务。

## 快速集成

### 使用Cocoapods集成

SDK 最低支持 9.0 系统， 在 `Podfile` 文件中添加以下内容：

```ruby
platform :ios, '9.0'

target 'your_target_name' do
  
  pod 'TuyaSmartHomeKit'
  pod 'TuyaSmartCameraKit'
  pod "TuyaCameraUIKit"
  pod 'TuyaSmartCloudServiceBizBundle'

end

```

TuyaSmartCameraKit 默认不支持 p2p 1.0 的设备, 如果你需要集成 p2p 1.0 的 SDK，可以添加`pod 'TuyaSmartCameraT'`。

然后在项目根目录下执行 `pod update` 命令，集成第三方库。

CocoaPods的使用请参考：[CocoaPods Guides](https://guides.cocoapods.org/)

## 开发文档

更多请参考：[涂鸦智能摄像头 iOS SDK使用说明](https://developer.tuya.com/cn/docs/app-development/ipccamera?id=Ka5vexydbwua5)

## Demo

1. 克隆本仓库到本地。

2. 打开终端，执行下面的命令。

   ```ruby
   cd tuyasmart_ipc_sdk_demo/Example/
   pod install
   ```

3. 打开 `TuyaSmartIPCDemo.xcworkspace` 。

4. 参考[准备工作](https://developer.tuya.com/cn/docs/app-development/preparation?id=Ka69nt983bhh5)，下载安全图片并重命名为 `t_s.bmp` ，添加到项目中。

5. 修改 `bundleId` 为你的 bundleId 。

6. 在 `AppDelegate.m` 文件中，添充涂鸦平台上获取到的 `appKey`， `appSecret`。

7. 如果需要集成云存储服务购买的模块，需要配置 `ty_custom_config.json` 文件。其中，`appId` 在 SDK 配置页的浏览器网址中获取，如网址为`https://iot.tuya.com/oem/sdk?id=xxx`，其中的 `xxx` 就是你的 `appId` 。 `tyAppKey`为你的 AppKey ，``appScheme`` 为你的渠道标识符。

8. 运行程序。因为 SDK 采用硬件解码，所以要使用真机测试。

## 运行效果

以下为预览、回放的效果图：

![预览](https://images.tuyacn.com/fe-static/docs/img/7c4dd3c2-db59-46ac-b296-f1032940f480.jpeg)
![回放](https://images.tuyacn.com/fe-static/docs/img/b9f74a57-cf8b-491e-96f1-ad56fbfdfbbe.jpeg)

## 版本更新记录

[版本更新记录](https://developer.tuya.com/cn/docs/app-development/versionrecord?id=Ka5vox6pd09cn)

