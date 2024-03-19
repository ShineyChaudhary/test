//
//  EversenseLoginViewAPICall.swift
//  EversenseUpgrade
//
//  Created by Shiney Chaudhary on 20/07/23.
//  Copyright © 2023 senseonics. All rights reserved.
//

import Foundation

// FIXME: Common method can be created for header.
extension EversenseLoginViewController {

    // FIXME: Parameter name can be updated, a meaningful one
    func callApiGetTransmitterInfo(foo: [Int]) {
        //g_functionJCode = 129
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var host:String! = (hostCgmUploadApiUrl?.replacingOccurrences(of: "https://", with: ""))!
        host = host.replacingOccurrences(of: "http://", with: "")
        host = host.replacingOccurrences(of: "https://", with: "")
        host = host.replacingOccurrences(of: "/CGMUploaderApi", with: "")
        let headers = [
            "Content-Type": "application/json",
            "User-Agent": "PostmanRuntime/7.15.2",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Postman-Token": "50be88ba-a99e-4676-8f91-fe0244869a8e,05fcd731-bd72-4605-9edc-65150976baa4",
            "Host": host!,
            "Accept-Encoding": "gzip, deflate",
            "Content-Length": "51",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        //        let parameters = [129, 50, 88, 0, 0, 68, 69, 77, 79, 50, 53, 55, 56] as [Int]
        let parameters = foo
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        sleep(1)
        let request = NSMutableURLRequest(url: NSURL(string: hostCgmUploadApiUrl!+"/api/values")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 3000.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        // FIXME: Remove forcecasting
        request.httpBody = postData as! Data

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { [self] (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                // FIXME: Remove forcecasting
                var result = String(data: data as! Data, encoding: String.Encoding.utf8)
                print(result)
                result = result!.replacingOccurrences(of: "\"", with: "")
                var resultArr = result?.split(separator: ",")
                if resultArr!.count > 1  {
                    if g_deviceID != "" {
                        if g_deviceID != String(resultArr![0]) {
                            //meaning you have inserted a different tx
                            g_deviceID = String(resultArr![0])
                            if g_authenticated {
                                displayMainView(myView: viewWelcomeAfterSignIn)
                            }
                            //                            return
                        }
                    } else {
                        g_deviceID = String(resultArr![0])
                    }
                    //red-rabbit force deviceid because tx is not active (not the same as usb tx)
                    //g_deviceID = "61016"
                    g_deviceName = String(resultArr![1])
                    self.getMyFirmwareVersion()
                } else {
                    self.getTransmitterInfo()
                }
                //                self.GetCmdByteByAddressAndSendToTx(strAddress: "AlgorithmParameterFormatVersion", numberOfBytes: 4, commandName: "algorithmparameterformatversion")
                //                self.callApiGetOffsetCmdBytes()
                //                self.callApiGetGetVersionCmdBytesCmd()
                //                self.callApiGetSensorGlucoseCmd()
                //                self.sendAlertEventsRequestToTx()
            }
        })
        dataTask.resume()
    }

    func ReadFourByteSerialFlashRegisterResponse(strAddress: String, responseBytes: [UInt8]) {
        //g_functionJCode = 135
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        var semaphore = DispatchSemaphore (value: 1152)
        let parameters = responseBytes
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        var request = URLRequest(url: URL(string: hostCgmUploadApiUrl! + "/api/ReadFourByteSerialFlashRegisterResponse")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            var result = String(data: data, encoding: .utf8)!
            result = result.replacingOccurrences(of: "\"", with: "")
            print(result)
            if strAddress == "getmodelnumber" {
                g_modelNumber = result
                GetCmdBytesByAddresAndSendToTx(strAddress: "getfirmwareversion")

            }
            if strAddress == "getfirmwareversion" {
                g_firmwareVersion = result
                var key = getKey()
                print("txid \(g_deviceIDFromTx ?? "")")
                print("modelnumber \(g_modelNumber ?? "")")
                print("firmwareversion \(g_firmwareVersion ?? "")")
                print("unlock key \(key)")
                self.getCmdByteToUnlockTxAndSendToTx(key: String(key))
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    func callApiGetGetVersionNumber(versionBytes: [Int]) {
        //g_functionJCode = 201
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        sleep(1)
        print("versionBytes")
        print(versionBytes)
        // FIXME: Forcecasting
        var host:String! = (hostCgmUploadApiUrl?.replacingOccurrences(of: "https://", with: ""))!
        host = host.replacingOccurrences(of: "http://", with: "")
        host = host.replacingOccurrences(of: "https://", with: "")
        host = host.replacingOccurrences(of: "/CGMUploaderApi", with: "")
        let headers = [
            "Content-Type": "application/json",
            "User-Agent": "PostmanRuntime/7.15.2",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Postman-Token": "f2c1277f-c04e-4f1d-9917-1f602a1c8c5e,2cc83704-37dd-4f1b-a3c3-5adbf36323bf",
            "Host": host!,
            "Accept-Encoding": "gzip, deflate",
            "Content-Length": "53",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        let urlString:String! = hostCgmUploadApiUrl!+"/api/GetVersionNumber"
        let parameters = versionBytes
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        sleep(1)
        // FIXME: Forcecasting
        let request = NSMutableURLRequest(url: NSURL(string:  urlString!) as! URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 3000.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        // FIXME: Forcecasting
        request.httpBody = postData as! Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                var result = String(data: data as! Data, encoding: String.Encoding.utf8)
                print(result)
                result = result!.replacingOccurrences(of: "\"", with: "")
                g_mainVersion = result!
                //                if ((g_commandsAndResponseDict["00A2"] == nil) || ((g_commandsAndResponseDict["00A2"] as! [String]).count == 0))
                //                {
                self.GetCmdByteByAddressAndSendToTx(strAddress: "00A2", numberOfBytes: 4, commandName: "00A2")
                //                }
            }
        })
        dataTask.resume()
    }

    func callApiGetGetVersionExtNumber(versionExtBytes: [Int]) {
        //g_functionJCode = 202
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var host:String! = (hostCgmUploadApiUrl?.replacingOccurrences(of: "https://", with: ""))!
        host = host.replacingOccurrences(of: "http://", with: "")
        host = host.replacingOccurrences(of: "https://", with: "")
        host = host.replacingOccurrences(of: "/CGMUploaderApi", with: "")
        let headers = [
            "Content-Type": "application/json",
            "User-Agent": "PostmanRuntime/7.15.2",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Postman-Token": "f2c1277f-c04e-4f1d-9917-1f602a1c8c5e,2cc83704-37dd-4f1b-a3c3-5adbf36323bf",
            "Host": host!,
            "Accept-Encoding": "gzip, deflate",
            "Content-Length": "53",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        print("g_mainVersion")
        print(g_mainVersion ?? "")
        // FIXME: String!---> why is it used like this?.
        let urlString: String! = hostCgmUploadApiUrl!+"/api/GetVersionExtNumber?mainversion="+g_mainVersion!+"&withDots=true";
        print("urlstring")
        print(urlString)
        let parameters = versionExtBytes
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        sleep(1)
        //make sure urlString can be constructed as a url
        guard let myUrl = NSURL(string:  urlString!) else{
            return
        }
        let request = NSMutableURLRequest(url: NSURL(string:  urlString!) as! URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 3000.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        // FIXME: Forcecasting
        request.httpBody = postData as! Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                // FIXME: Forcecasting
                var result = String(data: data as! Data, encoding: String.Encoding.utf8)
                print(result)
                result = result!.replacingOccurrences(of: "\"", with: "")
                g_fullVersion=result!
                g_deviceIDFromTx = g_deviceID
                g_previousFullVersionFromTx = g_fullVersionFromTx
                g_fullVersionFromTx = g_fullVersion
                g_fullVersionFromTxForAudit = g_fullVersion
                g_TxConnectedToUsbAndSuccessfullyCalledTxInfoApis = true
                self.showUiBasedOnTxConnectionToUsbStatus()
                if ((g_upgradeInProgress) && (g_previousFullVersionFromTx != nil) && (g_previousFullVersionFromTx != "")) {
                    g_upgradeFirmwareDone = false
                    self.GetCmdByteByAddressAndSendToTx(strAddress: "0488", numberOfBytes: 1, commandName: "0488")
                }
                DispatchQueue.main.async { [weak self] in
                    self?.lbActiveTransmitterSnValue.stringValue = g_deviceIDFromTx!
                    self?.lbCurrentTransmitterVerValue.stringValue = g_fullVersionFromTx!
                    if g_internet {
                        self?.btRetry_ViewUpdateError.isEnabled=true
                        self?.checkReviewChanges.isEnabled = true
                    }
                    if 1 == 2 {
                        self?.callApiGetViaQuizFailAttempts()
                    }
                    if 1 == 1 //hide status field
                    {
                        if ((g_statusTextReason == "5000010") || (g_statusTextReason == "5000028") || (g_statusTextReason == "500006001")) {
                            g_showTxReconnectCountDown = false
                            DispatchQueue.main.async { [weak self] in
                                self?.statusTextField.isHidden = true
                            }
                        }
                    }
                }
            }
        })
        dataTask.resume()
    }

    func callApiFirmwareUpgradeResult(foo: [UInt8]) {
        //g_functionJCode = 126
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var semaphore = DispatchSemaphore (value: 433)
        let parameters = foo
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        //red-rabbit why are u hardcoding below
        if (1 == 2) {
            hostCgmUploadApiUrl = "http://10.211.55.3/CGMUploaderApi"
        }
        // FIXME: Forcecasting
        var request = URLRequest(url: URL(string: hostCgmUploadApiUrl! + "/api/ReadSingleByteSerialFlashRegisterResponse")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

//    func putTransmitterValues(txNo: String, txVersionNo: String) {
//        //g_functionJCode = 127
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
//            return
//        }
//        var semaphore = DispatchSemaphore (value: 712)
//        let parameters = "{\r\n\"TransmitterSNo\":\"\(txNo)\",\r\n\"TransmitterVersionNo\":\"\(txVersionNo)\"\r\n}"
//        let postData = parameters.data(using: .utf8)
//        var request = URLRequest(url: URL(string: hostApiUrl! + "/api/care/PutTransmitterValues")!,timeoutInterval: Double.infinity)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(g_accessToken!)", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "POST"
//        request.httpBody = postData
//        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            guard let data = data else {
//                print(String(describing: error))
//                if (String(describing: error).contains("The Internet connection appears to be offline")) {
//                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
//                }
//                semaphore.signal()
//                return
//            }
//            print(String(data: data, encoding: .utf8)!)
//            GlobalManager.shared.sendAudit(code: "5000056")
//            let index = EuaMessage.firstIndex { $0.messageCode == "5000056" }
//            Logger.log(EuaMessage[index!].messageDescription)
//            g_upgradeFirmwareTryCount=0
//            //update otwfirmwareinfo to make sure it doesn't keep upgrading
//            self?.CallApiGetOtwFirmwareInformation(changeUi: false)
//            semaphore.signal()
//        }
//        task.resume()
//        semaphore.wait()
//    }

    func CallApiGetUserFirmwareInformation(changeUi:Bool = true) {
        //g_functionJCode = 338
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var semaphore = DispatchSemaphore (value: 344)
        var url = hostApiUrl!+"/api/OTW/GetUserFirmwareInformation"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+g_accessToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if (responseString == "null")
            {
                let index = EuaMessage.firstIndex { $0.messageCode == "5000039" }
                DispatchQueue.main.async {
                    self!.addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly, isHeaderSecondaryHidden: true)
                    Logger.log(EuaMessage[index!].messageDescription)
                }
                semaphore.signal()
                return
            }
        
            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            do {
                UserFirmwareInfo = try decoder.decode(StructUserFirmwareInfo?.self, from: jsonData)
                print(UserFirmwareInfo!.transmitterID)
                DispatchQueue.main.async {
                    g_deviceIDFromCloud = String(UserFirmwareInfo!.transmitterID)
                    g_fullVersionFromCloudCurrent = String(UserFirmwareInfo!.transmitterVersionNo)
                    if g_deviceIDFromTx == nil {
                        if 1 == 2 //do not update the ui for now. we will use the real info directly from device, not from cloud
                        {
                            self?.lbActiveTransmitterSnValue.stringValue = g_deviceIDFromCloud!
                            self?.lbCurrentTransmitterVerValue.stringValue = g_fullVersionFromCloudCurrent!
                        }
                    }
                    g_fullVersionApp = String(UserFirmwareInfo!.appVersion)
                    if (self?.lbEversenseMobileAppSoftwareVerValue != nil)
                    {
                        self?.lbEversenseMobileAppSoftwareVerValue.stringValue = g_fullVersionApp ?? ""
                    }
                    
                    self?.CallApiGetOtwFirmwareInformation(changeUi: changeUi)
                    self?.CallApiGetAuditHistory()
                }
            } catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    func CallApiGetAuditHistory() {
        //g_functionJCode = 339
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        if UserFirmwareInfo!.count == 0 {
//            return
//        }
        var semaphore = DispatchSemaphore (value: 412)
        let parameters = "{\r\n    \"userid\":\""+UserFirmwareInfo!.id+"\"}"
        let postData = parameters.data(using: .utf8)
        var url = hostApiUrl!+"/api/via/GetViaAuditHistory"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+g_accessToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline"))
                {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            print("Audit History refreshed!!")
//            print(String(data: data, encoding: .utf8)!)
            let responseString = String(data: data, encoding: .utf8)
            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            do {
                AuditHistory = try decoder.decode([StructAuditHistory].self, from: jsonData)
            } catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    func CallApiGetEuaMessageFromCloud() {
        //g_functionJCode = 339
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        
        var semaphore = DispatchSemaphore (value: 2048)
        let parameters = "{\r\n\"AppPlatform\":1,\r\n\"Language\":\"en-us\"\r\n}"
        let postData = parameters.data(using: .utf8)
        var url = hostApiUrl!+"/api/OTW/GetEUAMessage"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline"))
                {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
//            print(String(data: data, encoding: .utf8)!)
            let responseString = String(data: data, encoding: .utf8)
            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            do {
                EuaMessageOriginal = try decoder.decode([StructEuaMessage].self, from: jsonData)
                
                if 1 == 1 //reformat Message with error code
                {
                    for foo in EuaMessageOriginal
                    {
                        var newuserFriendlyMessage = ""
                        newuserFriendlyMessage = foo.messagerDescriptionUserFriendly
                        if (foo.showCodeInUI)
                        {
                            newuserFriendlyMessage = foo.messagerDescriptionUserFriendly + " (M-" + foo.messageCode + ")"
                        }
                        EuaMessage.append(StructEuaMessage(messageCode: foo.messageCode, language: foo.language, messageDescription: foo.messageDescription, messagerDescriptionUserFriendly: newuserFriendlyMessage, appPlatform: foo.appPlatform, showCodeInUI: foo.showCodeInUI))
                        
                    }
                }
                
                
                
                
                //temporary-temporary
                //EuaMessage.append(StructEuaMessage(messageCode: "6000005", language: "en-US", messageDescription: "No firmware version available for upgrade", messagerDescriptionUserFriendly: "No firmware version available for upgrade", appPlatform: 1))
            } catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func CallApiGetOtwFirmwareInformation(changeUi: Bool) {
        //g_functionJCode = 340
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        OtwFirmwareInfo?.result.removeAll()
        var semaphore = DispatchSemaphore (value: 479)
        var url = hostApiUrl!+"/api/OTW/GetOTWFirmwareInfoV2?TransmitterSNo=\(UserFirmwareInfo!.transmitterID)&TransmitterFirmwareVersion=\(UserFirmwareInfo!.transmitterVersionNo)"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+g_accessToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            var responseString = String(data: data, encoding: .utf8)
            print("responseString = \(String(describing: responseString))")
            if ((responseString?.contains("\"result\":null")) != nil)
            {
                responseString = responseString?.replacingOccurrences(of: "\"result\":null", with: "\"result\":[]")
            }
            print("responseString = \(String(describing: responseString))")

            //red-rabit
//            responseString = "6"
            
//            if (  responseString! == "1") {
//                g_upgradeUnavailableReason = "[M6000001]"
//            }
//            else if ( responseString! == "2") {
//                g_upgradeUnavailableReason = "[M6000002]"
//            }
//            else if ( responseString! == "3") {
//                g_upgradeUnavailableReason = "[M6000003]"
//            }
//            else if ( responseString! == "4") {
//                g_upgradeUnavailableReason = "[M6000004]"
//            }
//            else if ( responseString! == "5") {
//                g_upgradeUnavailableReason = "[M6000005]"
//            }
//            else if ( responseString! == "6") {
//                g_upgradeUnavailableReason = "[M6000006]"
//            }
//            else {
            g_upgradeUnavailableReason = ""
            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            do {
                OtwFirmwareInfo = try decoder.decode(StructOtwFirmwareInfoResult.self, from: jsonData)
                if (g_TmTxSyncStarted)
                {
                    //need to refresh welcome screen only for the event of TM's tx being synced when tx is plugged in to the usb port
                    NotificationCenter.default.post(name: Notification.Name("ShowWelcomeScreen"), object: nil)
                }
                print("")
            } catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            if changeUi {
                UiAfterLogIn()
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    func callApiGetViaQuizFailAttempts(comingfrom: String = "") {
        //g_functionJCode = 341
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if g_accessToken == nil {
            return
        }
        var semaphore = DispatchSemaphore (value: 5096)
        let parameters = "FirmwareID=\(g_fullVersionFromTx!)&TransmitterID=\(g_deviceIDFromTx!)"
        let postData =  parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: hostApiUrl! + "/api/Via/GetViaQuizFailAttempts")!,timeoutInterval: Double.infinity)
        request.addValue("Bearer \(g_accessToken!)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline"))
                {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let responseString = String(data: data, encoding: .utf8)
            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            do {
                QuizFailAttempts = try decoder.decode([StructQuizFailAttempts].self, from: jsonData)
                g_quizFailAttempts = 0
                g_quizFailAttempts = QuizFailAttempts.count
                //red-rabbit
                //                g_quizFailAttempts = 1
                //
                if g_quizFailAttempts > 3 {
                    g_upgradeAvailable = false
                    DispatchQueue.main.async {
                        self.btReviewChanges.isEnabled = false
                        self.btReviewChanges.isHidden = true
                    }
                    GlobalManager.shared.sendAudit(code: "5000021")
                    print("already attempted the quizmore 3 or more times, no more trying!!")
                    let index = EuaMessage.firstIndex { $0.messageCode == "5000021" }
                    addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly, isHeaderSecondaryHidden: true)
                    Logger.log(EuaMessage[index!].messageDescription)
                    displayMainView(myView: viewQuizTooManyAttempts )
                } else {
                    if comingfrom == "restartQuizButton" {
                        startDisplayingResumeQuizQuestions()
                    } else if comingfrom == "resumeQuizButton" {
                        //                        startDisplayingResumeQuizQuestions()
                        displayMainView(myView: viewResumeQuizWelcome)
                    } else {
                        return CallApiGetFirmwareQuiz() {
                            [self] (result: [Quiz]) in
                            if result.count == 0 {
                                displayMainView(myView: viewReviewChanges)
                                semaphore.signal()
                            } else {
                                displayMainView(myView: viewRestartQuiz!)
                                semaphore.signal()
                            }
                        }
                    }
                }
                print("")
            }
            catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    func CallApiGetTxHash() {
        //g_functionJCode = 204
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        //        g_fullVersion = "6.04.02w"
        var semaphore = DispatchSemaphore (value: 935)
        let parameters = "{\r\n    \"FirmwareVersionNo\":\"\(g_fullVersion!)\",\r\n    \"transmitterid\":\(g_deviceID!)\r\n    }"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: hostApiUrl!+"/api/OTW/GenerateHash")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(g_accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            DispatchQueue.main.async {
                self?.progressBar.doubleValue = 20
            }
            // FIXME: Forcecasting
            var result = String(data: data as! Data, encoding: String.Encoding.utf8)
            result = result?.replacingOccurrences(of: "\"", with: "")
            self?.callApiGetHashCommandByte(result: result!)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    func callApiGetViaAppVersion() {
        //g_functionJCode = 210
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var semaphore = DispatchSemaphore (value: 2601)
        let parameters = "{\r\n    \"Name\": \"ViaAppVersion\"\r\n}"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: hostApiUrl! + "/api/Via/GetFromViaAppConfig")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(g_accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let responseString = String(data: data, encoding: .utf8)
            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            do {
                ViaAppVersion = try decoder.decode([StructViaAppVersion].self, from: jsonData)
                for foo in ViaAppVersion {
                    if ((foo.Name?.contains("ViaAppVersion")) == true ) {
                        currentAppVersionFromCloud = foo.Value!
                    }
                }
                self?.checkAppVersion()
            } catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    
    
    func callPublicApiViaAppCong(keyName: String, notificationName: String) {
        //g_functionJCode = 211
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var semaphore = DispatchSemaphore (value: 3026)
        //        var request = URLRequest(url: URL(string: "https://u1-apiservicesdev.eversensedms.com/api/public/GetEUAAppConfig?Name=\(keyName)")!,timeoutInterval: Double.infinity)
        var request = URLRequest(url: URL(string: hostApiUrl!+"/api/public/GetEUAAppConfig?Name=\(keyName)")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            if ((keyName=="ArmJavaDownloadUrl") || (keyName=="IntelJavaDownloadUrl")) {
                g_javaDownloadUrl = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
            }
//            if keyName=="STMCubeExeUrl" {
//                g_stmDownloadUrl = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
//            }
            if keyName=="STMCubeInstallAnywhereUrl" {
                g_stmDownloadUrl = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
            }

            if ((keyName=="ArmJavaDownloadMd5") || (keyName=="IntelJavaDownloadMd5")) {
                g_javaDownloadMd5 = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
            }
//            if keyName=="StmCubeExeMd5" {
//                g_stmDownloadMd5 = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
//            }
            if keyName=="StmCubeInstallAnywhereMd5" {
                g_stmDownloadMd5 = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
            }
            if ((keyName=="ArmJavaVolumePath") || (keyName=="IntelJavaVolumePath"))  {
                g_javaVolumePath = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "[space]", with: " ")
            }
            if keyName=="MacNewVersionDownloadUrl" {
                g_newVersionDownloadUrl = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
            }
            if keyName=="MacNewVersionDownloadMd5" {
                g_newVersionDownloadMd5 = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
            }
            if keyName=="MacStmVersion" {
                g_MacStmVersionFromCloud = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
            }
            if keyName=="MacValidStmVersions" {
                g_MacValidStmVersionsFromCloud = String(data: data, encoding: .utf8)!.replacingOccurrences(of: "\"", with: "")
            }
            if (notificationName != "")
            {
                NotificationCenter.default.post(name: Notification.Name(notificationName), object: nil)
            }
            print(String(data: data, encoding: .utf8)!)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    func callApiGetAlgorithmParameterFormatVersionNumber(versionBytes: [Int]) {
        //g_functionJCode = 215
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var host:String! = (hostCgmUploadApiUrl?.replacingOccurrences(of: "https://", with: ""))!
        host = host.replacingOccurrences(of: "http://", with: "")
        host = host.replacingOccurrences(of: "https://", with: "")
        host = host.replacingOccurrences(of: "/CGMUploaderApi", with: "")
        let headers = [
            "Content-Type": "application/json",
            "User-Agent": "PostmanRuntime/7.15.2",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Postman-Token": "f2c1277f-c04e-4f1d-9917-1f602a1c8c5e,2cc83704-37dd-4f1b-a3c3-5adbf36323bf",
            "Host": host!,
            "Accept-Encoding": "gzip, deflate",
            "Content-Length": "53",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        let urlString:String! = hostCgmUploadApiUrl!+"/api/GetAlgorithmParameterFormatVersionNumber?defaultversion=0"
        let parameters = versionBytes
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        sleep(1)
        //FIXME: Forcecasting
        let request = NSMutableURLRequest(url: NSURL(string:  urlString!) as! URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 3000.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as! Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                //FIXME: Forcecasting
                var result = String(data: data as! Data, encoding: String.Encoding.utf8)
                print(result ?? "")
                result = result!.replacingOccurrences(of: "\"", with: "")
                g_algorithmParameterFormatVersion = result!
                self.GetCmdByteByAddressAndSendToTx(strAddress: "sensorid", numberOfBytes: -1, commandName: "sensorid")
                //                }
            }
        })
        dataTask.resume()
    }
    
    func callApiGetReviewChangesPath1() {
        //g_functionJCode = 342
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var semaphore = DispatchSemaphore (value: 23)
        var firmwareName = Helper.modifyFirmwareVersionName(firmware: (OtwFirmwareInfo?.result[0].firmwareVersionNo)!)
        let parameters = "{\r\n    \"Name\": \"\(firmwareName)_Release_Notes\"\r\n}"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: hostApiUrl! + "/api/Via/GetFromViaAppConfig")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(g_accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let responseString = String(data: data, encoding: .utf8)
            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            do {
                ReviewChanges = try decoder.decode([StructFirmwareReviewChange].self, from: jsonData)
//                let reviewChangesUrl = URL(string: ReviewChanges[0].Value!.replacingOccurrences(of: " ", with: "%20"))
                DispatchQueue.main.async { [weak self] in
//                    self?.reviewChanges1WebView.load(URLRequest(url: reviewChangesUrl!))
                    self?.reviewChanges1WebView.allowsBackForwardNavigationGestures = true
                    self?.reviewChanges1WebView.allowsMagnification = true
                }
            }
            catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    // FIXME: Parameter name can be updated
    func callApiGetForgotPasswordLink(env: String) {
        //g_functionJCode = 343
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        var semaphore = DispatchSemaphore (value: 893)
        //        let parameters = "{\r\n    \"Name\": \"USForgotPassword\"\r\n}"
        //        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: hostApiUrl! + "/api/Public/GetForgotPasswordLink?env=\(env)")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        //        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) {[weak self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let responseString = String(data: data, encoding: .utf8)
            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            do {
                AppConfig = try decoder.decode([StructAppConfig].self, from: jsonData)
                for foo in AppConfig {
                    // removed force casting
                    g_forgotPasswordLink = foo.Value ?? ""
                }
            } catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func callApiGetEulaPathAndVersion(env:String) {
        //g_functionJCode = 212
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var semaphore = DispatchSemaphore (value: 1538)
        //        let parameters = "{\r\n    \"Name\": \"\(g_fullVersion!)\"\r\n}"
        //        let postData = parameters.data(using: .utf8)
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | bookmark1: \(hostApiUrl! + "/api/Via/GetEULAFromViaAppConfig?env=\(env)")")
        var request = URLRequest(url: URL(string: hostApiUrl! + "/api/Via/GetEULAFromViaAppConfig?env=\(env)")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //        request.addValue("Bearer \(g_accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        //        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | bookmark3: \(String(describing: error))")
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let responseString = String(data: data, encoding: .utf8)
            Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | bookmark2: \(responseString)")

            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            do {
                AppConfig = try decoder.decode([StructAppConfig].self, from: jsonData)
                for foo in AppConfig {
                    if ((foo.Name?.contains("EulaPath")) == true ) {
                        eulaPathFromCloud = foo.Value!
                    }
                    if ((foo.Name?.contains("EulaVer")) == true) {
                        eulaVersionFromcloud = foo.Value!
                    }
                }
                self?.checkEula()
            } catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func callApiSendResetPasswordEmail(email: String) {
        //g_functionJCode = 343
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        var semaphore = DispatchSemaphore (value: 982)
        
        var parameters = "{\n    \"Email\": \"\(email)\",\n    \"ClientId\": \"dms_2fa\",\n    \"webBaseURL\": \"\(hostWebUrl!)\"\n}"
        
        var request = URLRequest(url: URL(string: hostApiUrl! + "/api/Account/ForgotPassword")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = parameters.data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                // Handle invalid response
                print("Invalid response")
                return
            }
            
            print(String(data: data, encoding: .utf8)!)
            let responseString = String(data: data, encoding: .utf8)
            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            
            if (200..<300).contains(httpResponse.statusCode) {
                // Successful response (status code 2xx)
                do {
                    strongSelf.passwordResetEmailSuccess = try decoder.decode(StructPasswordResetEmailSuccess.self, from: jsonData)
                    DispatchQueue.main.async { [weak self] in
                        self?.tfSendPasswordResetEmail.stringValue = ""
                        self?.addAlertView(headerPrimaryText: "Notification", headerSecondaryText: "", message: AppConstants.Alerts.descriptions.resetPasswordEmail, isHeaderSecondaryHidden: true)
                        Logger.log(AppConstants.Alerts.descriptions.resetPasswordEmail)
                    }
                } catch {
                    Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
                }
            } else if httpResponse.statusCode == 400 {
                
                DispatchQueue.main.async { [weak self] in
//                    self?.tfSendPasswordResetEmail.stringValue = ""
                    let index = EuaMessage.firstIndex { $0.messageCode == "5000070" }
                    self?.addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly, isHeaderSecondaryHidden: true)
                    Logger.log(EuaMessage[index!].messageDescription)
                    
//                    self?.addAlertView(headerPrimaryText: AppConstants.Alerts.titles.notification, message: AppConstants.Alerts.descriptions.emailNotRegistered, isHeaderSecondaryHidden: true)
                }
            } else {
                // Handle other status codes (e.g., 404, 500, etc.)
                print("Status code \(httpResponse.statusCode): \(HTTPURLResponse.localizedString(forStatusCode: httpResponse.statusCode))")
            }
            
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
