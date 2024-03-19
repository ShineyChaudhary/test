//
//  EversenseLoginViewJava.swift
//  EversenseUpgrade
//
//  Created by Shiney Chaudhary on 20/07/23.
//  Copyright © 2023 senseonics. All rights reserved.
//

import Foundation

@available(macOS 11.0, *)
extension EversenseLoginViewController {
    
    func javaSoftwareInstallation(result :Bool) {
        //g_functionJCode = 149
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("hey \(result)")
        if result{
            if 1 == 1 //download and install java
            {
                if g_cpuType == "apple" {
                    callPublicApiViaAppCong(keyName: "ArmJavaVolumePath", notificationName: "viaAppConfigPublicApiJavaVolumePathDone")
                }
                else{
                    callPublicApiViaAppCong(keyName: "IntelJavaVolumePath", notificationName: "viaAppConfigPublicApiJavaVolumePathDone")
                }
                    
                
            }
        }
    }
    
    @objc func viaAppConfigPublicApiGetJavaDownloadUrlDoneNotified(notification: NSNotification) {
        //g_functionJCode = 247
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("viaAppConfigPublicApiGetJavaDownloadUrlDoneNotified!")
        var url = URL(string: g_javaDownloadUrl!)
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | JavaDownloadUrl: \(g_javaDownloadUrl!)")
        SoftwareDownload(url! as NSObject).download(url: url!)
    }
    @objc func viaAppConfigPublicApiGetNewVersionDownloadUrlDoneNotified(notification: NSNotification) {
        //g_functionJCode = 247
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("viaAppConfigPublicApiGetNewVersionDownloadUrlDoneNotified!")
        var url = URL(string: g_newVersionDownloadUrl!)
        SoftwareDownload(url! as NSObject).download(url: url!)
    }
    @objc func viaAppConfigPublicApiJavaVolumePathDoneNotified(notification: NSNotification) {
        //g_functionJCode = 328
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("viaAppConfigPublicApiJavaVolumePathDoneNotified!")
        if g_cpuType == "apple" {
            callPublicApiViaAppCong(keyName:"ArmJavaDownloadMd5",notificationName:"viaAppConfigPublicApiJavaMd5Done")
        }
        else{
            callPublicApiViaAppCong(keyName:"IntelJavaDownloadMd5",notificationName:"viaAppConfigPublicApiJavaMd5Done")
        }
        
    }
    
    @objc func viaAppConfigPublicApiJavaMd5DoneNotified(notification: NSNotification) {
        //g_functionJCode = 249
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("viaAppConfigPublicApiJavaMd5DoneNotified!")
        if g_cpuType == "apple" {
            callPublicApiViaAppCong(keyName: "ArmJavaDownloadUrl", notificationName: "viaAppConfigPublicApiGetJavaDownloadUrlDone")
        }
        else{
            callPublicApiViaAppCong(keyName: "IntelJavaDownloadUrl", notificationName: "viaAppConfigPublicApiGetJavaDownloadUrlDone")
        }
    }
    
    @objc func viaAppConfigPublicApiNewVersionMd5DoneNotified(notification: NSNotification) {
        //g_functionJCode = 249
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("viaAppConfigPublicApiNewVersionMd5DoneNotified!")
        callPublicApiViaAppCong(keyName: "MacNewVersionDownloadUrl", notificationName: "viaAppConfigPublicApiGetNewVersionDownloadUrlDone")
    }
    
    @objc func javaDownloadProgress(notification: NSNotification) {
        //g_functionJCode = 301
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("java progress post received!")
        if let dict = notification.object! as! NSDictionary? {
            for (key, value) in dict {
                DispatchQueue.main.async { [self] in
                    if key as! String == "transferRate" {
                        lblJavaDownloadTransferRate.stringValue = value as! String
                    }
                    if key as! String == "eta" {
                        lblJavaDownloadEta.stringValue = value as! String
                    }
                    if key as! String == "percentDone" {
                        javaProgressIndicator.doubleValue = Double(value as! String)!
                    }
                }
            }
        }
    }

    @objc func javaDownloadCompletion(notification: NSNotification) {
        //g_functionJCode = 303
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        Logger.log("java download completed")
        DispatchQueue.main.async {
            self.javaProgressIndicator.doubleValue = 100
            self.lblJavaDownloadEta.stringValue = "0 Second"
        }
        if let dict = notification.object! as! NSDictionary? {
            for (key, value) in dict {
                if key as! String == "path" {
                    print("value is \(value as! String)")
                    let path:String = value as! String
                    print("java software downloaded to : \(path)")
                    Logger.log("java software downloaded to : \(path)")
                    var data = loadFileFromLocalPath(path)
                    var md5string = md5(data: data!)
                    if (md5string == g_javaDownloadMd5) {
                        self.addToLogUserFriendly(logText: shell("hdiutil mount '\(path)'"))
                        //                        self.addToLogUserFriendly(logText: shell(#"/Volumes/Java\ 8\ Update\ 361/Java\ 8\ update\ 361.app/Contents/MacOS/MacJREInstaller"#))
                        self.addToLogUserFriendly(logText: shell("'\(g_javaVolumePath!)'"))
                        self.addToLogUserFriendly(logText: shell("hdiutil detach '\(path)'"))
                        installCubeIfNotInstalled()
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(header: "Eversense Upgrade", body: "MD5 Checksum doesn't match for Java Download.",quit: true)
                        }
                    }
                }
            }
        }
    }

@objc func newVersionDownloadCompletion(notification: NSNotification) {
        //g_functionJCode = 303
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        Logger.log("new version download completed")

        if let dict = notification.object! as! NSDictionary? {
            for (key, value) in dict {
                if key as! String == "path" {
                    print("value is \(value as! String)")
                    let path:String = value as! String
                    print("new version software downloaded to : \(path)")
                    Logger.log("new version software downloaded to : \(path)")


                    var data = loadFileFromLocalPath(path)
                    var md5string = md5(data: data!)
                    if (md5string == g_newVersionDownloadMd5) {

//                    logText:
//                        var foo = shell("open \(path.replacingOccurrences(of: " ", with: "\ "))")
                        self.addToLogUserFriendly(logText: shell("open '\(path)'"))
                        exit(0)
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(header: "Eversense Upgrade", body: "MD5 Checksum doesn't match for New Version Download.",quit: true)
                        }
                    }
                }
            }
        }

//        var foo = shell(#"open /Users/tinlatt/Library/Application\ Support/com.senseonics.EversenseUpgrade/eua_package_signed.pkg"#)
//        exit(0)

//        showAlert(header: "EUA", body: "Update successful!", quit: true)
    }

    @objc func newVersionDownloadProgress(notification: NSNotification) {
            //g_functionJCode = 301
            Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
            print("new version progress post received!")
            if let dict = notification.object! as! NSDictionary? {
                for (key, value) in dict {
                    DispatchQueue.main.async { [self] in
                        if key as! String == "transferRate" {
                            lblNewVersionDownloadTransferRate.stringValue = value as! String
                        }
                        if key as! String == "eta" {
                            lblNewVersionDownloadEta.stringValue = value as! String
                        }
                        if key as! String == "percentDone" {
                            newVersionProgressIndicator.doubleValue = Double(value as! String)!
                        }
                    }
                }
            }
        }
    func newVersionSoftwareInstallation(result :Bool) {
            //g_functionJCode = 149
            Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
            print("hey \(result)")
            if result{
                if 1 == 1 //download and install java
                {
                    DispatchQueue.main.async { [self] in
                        displayMainView(myView: viewNewVersionDownload)
                        callPublicApiViaAppCong(keyName:"MacNewVersionDownloadMd5",notificationName:"viaAppConfigPublicApiNewVersionMd5Done")
                    }

                }
            }
        }


func isJavaAlreadyInstalled() -> Bool {
    //g_functionJCode = 312
    Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
    Logger.log(#function)
    let res = HelperShell.shell(launchPath: "/bin/ls", arguments: ["/Library/Internet Plug-Ins/"])
    var isJavaInstalled:Bool = false
    print("isJavaInstalledResponse: \(res)")
    Logger.log("isJavaInstalledResponse: \(res)")
    //checking if java 8 is installed
    if ((res == "") || (res.lowercased().contains("bad cpu"))) {
        //if you are here, java8 is not installed
        print("java is blank or bad cpu")
        Logger.log("java is blank or bad cpu")
        return false
    }
    //If you are here, java is most likely installed, unless it is damaged.
    //double check for lower specific java version also
    if res.contains("JavaAppletPlugin.plugin") {
        Logger.log("Checking Java")
        isJavaInstalled = false
        if 1 == 1 //check for older version as well
        {
            shell(#"java -version 2>~/Library/Application\ Support/com.senseonics.EversenseUpgrade/java.txt"#)
            var javaVersionOutput:String = shell(#"cat ~/Library/Application\ Support/com.senseonics.EversenseUpgrade/java.txt"#)
            print("java -version output: \(javaVersionOutput)")
            Logger.log("java -version output: \(javaVersionOutput)")
            let components = javaVersionOutput.components(separatedBy: "\n")
            var javaVersionTxt:String = components[0].replacingOccurrences(of: "\"", with: "").replacingOccurrences(of: "java version ", with: "")
            if ((javaVersionTxt.starts(with: "1.0")) || (javaVersionTxt.starts(with: "1.1")) || (javaVersionTxt.starts(with: "1.2")) || (javaVersionTxt.starts(with: "1.3")) || (javaVersionTxt.starts(with: "1.4")) || (javaVersionTxt.starts(with: "1.5")) || (javaVersionTxt.starts(with: "1.6")) || (javaVersionTxt.starts(with: "1.7")) ) {
                print("you have lower java version than needed")
                Logger.log("you have lower java version than needed")
                isJavaInstalled = false
            }
            else if (javaVersionTxt.starts(with: "1.8"))
            {
                print("you have java 8 installed.")
                Logger.log("you have java 8 installed.")
                isJavaInstalled = true
            }
            else if ((javaVersionOutput.lowercased().contains("unable to locate a java runtime")) || (javaVersionOutput.lowercased().contains("error")))
            {
                print("current java installation is damaged")
                Logger.log("current java installation is damaged")
                isJavaInstalled = false
            }
            //NOTE: Below code is for higher jdk version. For now, we will install Java 8 anyway even if the user has hight java version.
//          else if (javaVersionOutput.lowercased().contains("openjdk version"))
//          {
//              isJavaInstalled = true
//          }
            else
            {
                print("unknown java version")
                Logger.log("unknown java version")
                isJavaInstalled = false
            }
        }
    }
    Logger.log("Java already installed is \(isJavaInstalled)")
    return isJavaInstalled
}
    
    @objc func installJavaIfNotInstalled() {
        //g_functionJCode = 313
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if 1 == 2 // if you want to use a file from local directory
        {
            g_hexPath = Bundle.main.path(forResource: "Phoenix-Transmitter-STM-DeveloperReleaseCombined-USXL-6.04.02.14", ofType: "hex")!
        }
        if 1 == 2 {
            if 1 == 1 //download hex frile
            {
                //            let url = URL(string: "https://usstaging.eversensedms.com/firmware/Phoenix-Transmitter-STM-Release_XL-6.04.01.23.hex")
                let url = URL(string: "https://usstaging.eversensedms.com/firmware/Phoenix-Transmitter-STM-Release_XL-6.04.02.14.hex")
                FileDownloader.loadFileAsync(url: url!) { (path, error) in
                    print("Hex File downloaded to : \(path!)")
                    g_hexPath = path!
                }
            }
            g_hexPath = g_hexPath.replacingOccurrences(of: " ", with: "\\ ")
        }
        DispatchQueue.main.async { [self] in
            viewSignIn.isHidden = true
            viewEula.isHidden = true
        }
        var isJavaInstalled = isJavaAlreadyInstalled()
        if (isJavaInstalled) {
            Logger.log("JAVA INSTALLED")
            installCubeIfNotInstalled()
        } else {
            Logger.log("JAVA NOT INSTALLED")
            if 1 == 1 //if Cube is installed, you don't need Java.
            {
                Logger.log("TX_LOG_COMMAND: "+"/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -version")
                var isCubeInstalled =  shell("/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -version")
                Logger.log("TX_LOG_OUTPUT: "+isCubeInstalled)
                if isCubeInstalled.lowercased().contains("stm32cubeprogrammer version") {
                    //cube is already installed. No need to install java
                    let executableURL = URL(fileURLWithPath: "/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI")
                    try! Process.run(executableURL,
                                     arguments: ["-c port=usb1"],
                                     terminationHandler: nil)
                    viewDidLoadAfterSTMInstallation()
                } else {
                    DispatchQueue.main.async { [self] in
                        displayMainView(myView: viewJavaDownload)
                        if 1 == 1 //ask user to manually download java
                        {
                            DispatchQueue.main.async { [self] in
                                showAlertWithCompletion(key: "mykey", header: "Eversense Upgrade", body: "Eversense Upgrade App needs Java and STM32CubeProgram pre-installed. Please follow the prompts to install those 2 Softwares.", completion: javaSoftwareInstallation(result:))
                            }
                        }
                    }
                }
            }
        }
    }
}
