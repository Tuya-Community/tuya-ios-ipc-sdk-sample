//
//  DoorbellManager.swift
//  TuyaSmartIPCDemo_Example
//
//  Created by Wen Jun on 2021/5/11.
//  Copyright © 2021 Tuya. All rights reserved.
//

import Foundation

class DoorbellManager: NSObject {
    
    var messageId:String = ""
    
    func addDoorbellObserver() {
        let manager = TuyaSmartDoorBellManager.sharedInstance()
        manager?.add(self)
    }
    
    func removeDoorbellObserver() {
        TuyaSmartDoorBellManager.sharedInstance()?.remove(self)
    }
}

extension DoorbellManager:TuyaSmartDoorBellObserver {
    func doorBellCall(_ callModel: TuyaSmartDoorBellCallModel!, didReceivedFromDevice deviceModel: TuyaSmartDeviceModel!) {
        messageId = callModel.messageId
        TuyaSmartDoorBellManager.sharedInstance()?.hangupDoorBellCall(messageId)
    }
    
    func doorBellCallDidRefuse(_ callModel: TuyaSmartDoorBellCallModel!) {
        
    }
    
    func doorBellCallDidHangUp(_ callModel: TuyaSmartDoorBellCallModel!) {
        
    }
    
    func doorBellCallDidAnswered(byOther callModel: TuyaSmartDoorBellCallModel!) {
        
    }
    
    func doorBellCallDidCanceled(_ callModel: TuyaSmartDoorBellCallModel!, timeOut isTimeOut: Bool) {
        
    }
}
