//
//  EversenseLoginViewORSSerialPort.swift
//  EversenseUpgrade
//
//  Created by Shiney Chaudhary on 20/07/23.
//  Copyright © 2023 senseonics. All rights reserved.
//

import Foundation
import ORSSerial
import Cocoa

extension EversenseLoginViewController: ORSSerialPortDelegate {
    
    // FIXME: Function not in use can be removed
    func serialPortWasRemovedFromSystem(_ serialPort: ORSSerialPort) {
    }
    
    // FIXME: Can be removed as not in use
    func serialPortWasOpened(_ serialPort: ORSSerialPort) {
    }
    
    func GetCmdByteByAddressSubAndSendToTx(strAddress: String, numberOfBytes: [Int]) {
        //g_functionJCode = 131
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var host:String! = (hostCgmUploadApiUrl?.replacingOccurrences(of: "https://", with: ""))!
        let headers = [
            "Content-Type": "application/json",
            "User-Agent": "PostmanRuntime/7.20.1",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Postman-Token": "bca6916f-4815-4d12-b8a5-42df55502338,c1a29cef-c2d0-45d2-b1c4-0d3d90436dd5",
            "Host": host!,
            "Accept-Encoding": "gzip, deflate",
            "Content-Length": "25",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        let parameters = numberOfBytes
        let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        let request = NSMutableURLRequest(url: NSURL(string: hostCgmUploadApiUrl! + "/api/GetCmdBytesByAddress?straddress=\(strAddress)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        // FIXME: Remove forcecasting
        request.httpBody = postData as! Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            // FIXME: Use guard statement avoid if else cases
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
                var addr = String(resultArr![0])
                var bytes = String(resultArr![1])
                if !(g_commands.contains(strAddress)) {
                    g_commands.append(strAddress)
                }
                g_commandsAndAddress_NumberOfBytes[strAddress]=addr+"_"+bytes
                result = String(resultArr![2])
                let resultcount = result?.count
                var byteArray:[UInt8]=[]
                for n in 1...(resultcount!)/2 {
                    var foo = result!.dropFirst((n-1)*2).dropLast(resultcount!-(2*n))
                    if let value = UInt8(foo, radix: 16) {
                        byteArray.append(value)
                    }
                }
                var byteArrayData = NSData(bytes: byteArray, length: byteArray.count) as Data
                // FIXME: Commented code can be removed if not in use
                //                var byteArrayData1 = NSData(bytes: [0x55,0x07,0x00,0x60,0x07,0x00,0x12,0x00,0x34,0x06,0xDA,0x8D ] as [UInt8], length: 12) as Data
                g_cmdName = strAddress
                self.serialPort?.send(byteArrayData)
            }
        })
        dataTask.resume()
    }
    
    func GetCmdByteByAddressAndSendToTx(strAddress: String, numberOfBytes: Int, commandName: String) {
        //g_functionJCode = 132
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var host:String! = (hostCgmUploadApiUrl?.replacingOccurrences(of: "https://", with: ""))!
        host = host.replacingOccurrences(of: "http://", with: "")
        host = host.replacingOccurrences(of: "https://", with: "")
        host = host.replacingOccurrences(of: "/CGMUploaderApi", with: "")
        let headers = [
            "User-Agent": "PostmanRuntime/7.19.0",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Postman-Token": "5a2f03c8-ef0c-4e4f-b1b2-073c78b933ca,8969688e-6b70-4387-a277-0eb0e1b6bafe",
            "Host": host!,
            "Accept-Encoding": "gzip, deflate",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        let request = NSMutableURLRequest(url: NSURL(string: hostCgmUploadApiUrl!+"/api/GetCmdBytesByAddress?straddress=\(strAddress)&numberofbytes=\(numberOfBytes)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 3000.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print(request.url)
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            // FIXME: Use guard statement avoid if else cases
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? HTTPURLResponse
                // FIXME: Remove Forcecasting
                var result = String(data: data as! Data, encoding: String.Encoding.utf8)
                //            print(result)
                result = result!.replacingOccurrences(of: "\"", with: "")
                var resultArr = result?.split(separator: ",")
                var addr = String(resultArr![0])
                var bytes = String(resultArr![1])
                if !(g_commands.contains(strAddress)) {
                    g_commands.append(strAddress)
                }
                g_commandsAndAddress_NumberOfBytes[strAddress]=addr+"_"+bytes
                result = String(resultArr![2])
                let resultcount = result?.count
                var byteArray:[UInt8]=[]
                for n in 1...(resultcount!)/2 {
                    var foo = result!.dropFirst((n-1)*2).dropLast(resultcount!-(2*n))
                    if let value = UInt8(foo, radix: 16) {
                        byteArray.append(value)
                    }
                }
                var byteArrayData = NSData(bytes: byteArray, length: byteArray.count) as Data
                g_cmdName = commandName
                sleep(1)
                self.serialPort?.send(byteArrayData)
            }
        })
        dataTask.resume()
    }
        
    func getCmdByteToUnlockTxAndSendToTx(key: String) {
        //g_functionJCode = 136
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        var semaphore = DispatchSemaphore (value: 1208)
        let parameters = key
        let postData = parameters.data(using: .utf8)
        
        var request = URLRequest(url: URL(string: hostCgmUploadApiUrl! + "/api/GetCmdBytesToUnlockTx")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        request.httpBody = postData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline"))
                {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            // FIXME: Remove forcecasting
            var result = String(data: data as! Data, encoding: String.Encoding.utf8)
            print(result)
            var cmdBytes = result!.replacingOccurrences(of: "\"", with: "")
            let cmdBytesCount = cmdBytes.count
            var byteArray:[UInt8]=[]
            for n in 1...(cmdBytesCount)/2 {
                var foo = cmdBytes.dropFirst((n-1)*2).dropLast(cmdBytesCount-(2*n))
                if let value = UInt8(foo, radix: 16) {
                    byteArray.append(value)
                }
            }
            var unlockBytes = NSData(bytes: byteArray, length: byteArray.count) as Data
            g_cmdName = "unlockTx"
            self.serialPort?.send(unlockBytes)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func GoToDfuMode() {
        //g_functionJCode = 137
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        g_dfuInProgress = true
        var dfuCmdBytes = NSData(bytes: dfuCommands[dfuCommandsIndex], length: dfuCommands[dfuCommandsIndex].count) as Data
        dfuCommandsIndex = dfuCommandsIndex + 1
        print(dfuCmdBytes)
        g_cmdName = "GoToDfuMode"
        self.serialPort?.send(dfuCmdBytes)
    }
    
    func callApiGetHashCommandByte(result:String) {
        //g_functionJCode = 205
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        if 1 == 1 {
            let resultcount = result.count
            var byteArray:[UInt8]=[]
            for n in 1...(resultcount)/2 {
                var foo = result.dropFirst((n-1)*2).dropLast(resultcount-(2*n))
                if let value = UInt8(foo, radix: 16) {
                    byteArray.append(value)
                }
            }
            var semaphore = DispatchSemaphore (value: 763)
            let parameters = byteArray
            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: hostCgmUploadApiUrl!+"/api/GetHashCmdByte")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 3000.0)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
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
                    self.progressBar.doubleValue = 30
                }
                // FIXME: Remove Forcecasting
                var result = String(data: data as! Data, encoding: String.Encoding.utf8)
                //            print(result)
                result = result!.replacingOccurrences(of: "\"", with: "")
                let resultcount = result?.count
                var byteArray:[UInt8]=[]
                for n in 1...(resultcount!)/2 {
                    var foo = result!.dropFirst((n-1)*2).dropLast(resultcount!-(2*n))
                    if let value = UInt8(foo, radix: 16) {
                        byteArray.append(value)
                    }
                }
                var byteArrayData = NSData(bytes: byteArray, length: byteArray.count) as Data
                g_cmdName = "HashVerification"
                self.serialPort?.send(byteArrayData)
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
        }
    }
    
    func unlockTx() {
        //g_functionJCode = 216
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        //        var unlockBytes = NSData(bytes: [0x06,0x00,0x39,0x00,0xA5,0x50,0x31,0x34,0x15,0x9E], length: 11) as Data
        //        var unlockBytes = NSData(bytes: [0x55,0x06,0x00,0x39,0x00,0xDD,0x50,0x31,0x34,0xA3,0x59] as [UInt8], length: 11) as Data
        //1. get cmdbytes for model number
        //2. send to tx
        //3. callapi to interpret
        //4. get cmdbytes for version
        //5. send to tx
        //6. callapi to interpret
        GetCmdBytesByAddresAndSendToTx(strAddress: "getmodelnumber")
        if 1 == 2
        {
            var unlockBytes = NSData(bytes: [0x55,0x06,0x00,0x39,0x00,0xED,0x50,0x31,0x34,0x4A,0x75] as [UInt8], length: 11) as Data
            print(unlockBytes)
            g_cmdName = "unlockTx"
            self.serialPort?.send(unlockBytes)
        }
    }
    
    func GetCmdBytesByAddresAndSendToTx(strAddress:String) {
        //g_functionJCode = 217
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var semaphore = DispatchSemaphore (value: 2002)
        var request = URLRequest(url: URL(string: hostCgmUploadApiUrl! + "/api/GetCmdBytesByAddress?straddress=\(strAddress)&numberofbytes=4")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            // FIXME: Remove Forcecasting
            var result = String(data: data as! Data, encoding: String.Encoding.utf8)
            print(result)
            result = result!.replacingOccurrences(of: "\"", with: "")
            var resultArr = result?.split(separator: ",")
            var addr = String(resultArr![0])
            var noOfBytes = String(resultArr![1])
            var cmdBytes = String(resultArr![2])
            let cmdBytesCount = cmdBytes.count
            var byteArray:[UInt8]=[]
            for n in 1...(cmdBytesCount)/2 {
                var foo = cmdBytes.dropFirst((n-1)*2).dropLast(cmdBytesCount-(2*n))
                if let value = UInt8(foo, radix: 16) {
                    byteArray.append(value)
                }
            }
            var byteArrayData = NSData(bytes: byteArray, length: byteArray.count) as Data
            g_cmdName = strAddress
            self.serialPort?.send(byteArrayData)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func getTransmitterInfo() {
        //g_functionJCode = 218
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        self.serialPort?.finalize()
        self.serialPort?.cleanupAfterSystemRemoval()
        // FIXME: Bool is locally declated and value is never read. can be removed.
        var portFound: Bool = false
        for foo in self.serialPortManager.availablePorts {
            print(foo)
            if (foo.name.contains("usbmodem")) {
                portFound = true
                self.serialPort = foo
                foo.open()
                var getTransmitterInfoCmdBytes = NSData(bytes: [0x55, 0x01, 0x00, 0x01, 0x8D, 0xEB] as [UInt8], length: 6) as Data
                g_cmdName = "GetTransmitterInfo"
                self.serialPort?.send(getTransmitterInfoCmdBytes)
            }
        }
    }
    
    func serialPort(_ serialPort: ORSSerialPort, didReceive data: Data) {
        print("data received")
        for n in 0...data.count-1 {
            print(data[n])
            byteArray.append(Int(data[n]))
        }
        lastdatareceivedon = CACurrentMediaTime();
    }
    
    // FIXME: Commented code inside please check if not required can be removed.
    func getTxIdAndFirmWareVersionFromUsbTx() {
        //g_functionJCode = 235
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        self.serialPort?.finalize()
        self.serialPort?.cleanupAfterSystemRemoval()
        var portFound:Bool = false
        for foo in self.serialPortManager.availablePorts {
            print(foo)
            if (foo.name.contains("usbmodem"))
            {
                portFound = true
                //                self.serialPort = foo
                //                foo.open()
            }
        }
        if portFound == false {
            //do nothing
            print("port not found")
            //            showAlert(header: "Transmitter", body: "Please connect transmitter to USB Port!")
            
        } else {
            print("port found")
            //            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.fireTimer), userInfo: nil, repeats: true)
            getTransmitterInfo()
            //            g_logTextView?.textStorage?.mutableString.setString("")
            //            self.addToLogUserFriendly(logText:"\nTransmitter connected. Select an option to continue.")
            //            if uploadTransmitterDataBtn != nil
            //            {
            //                uploadTransmitterDataBtn.isEnabled = true
            //                uploadCustomerSupportBtn.isEnabled = true
            //            }
        }
    }
}
