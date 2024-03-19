//
//  ViewController.swift
//  EversenseUpgrade
//
//  Created by S on 9/13/19.
//  Copyright © 2019 senseonics. All rights reserved.
//

import Cocoa
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import ORSSerial
import CryptoKit
import AVFoundation
import AVKit
//import Reachability
import WebKit
import IOKit.ps
import Network

//import AppKit

var g_userID:String?
var g_loggedInUser:String?
var g_deviceType:String? = "SMSIMeter"
var g_deviceName:String?
var g_deviceID:String? = ""
var g_offsetBytes:String? = "wMf//w=="
var g_sgBytes:String?
var g_mgBytes:String?
var g_patientBytes:String?
var g_clickedButton:String?
var g_alertBytes:String?
var g_algorithmVersion:Int?
var g_algorithmParameterFormatVersion:String?
var g_logTextView: NSTextView?
var g_progressBar: NSProgressIndicator?
var g_incrementValue:Double?
var lastPrint:String?
var g_otwFullVersion:String?
var g_alertCommandNumber:Int?
var g_cmdIndex:Int = -1
var g_cmd_sub_Index:Int = 0
var userFriendlyLogText=true
var originalGCommandsCount:Int!
var g_commands_sub:[String]=[]
var g_commandsAndResponseDict = [String:Any]()
var g_commandsAndAddress_NumberOfBytes = [String:Any]()
var downloadCommandsArray = [String?]()
var sensorGlucoseNoOfRecords:String?
var sensorGlucoseCommandsArray = [String?]()
var sensorGlucoseResponseBytesArray:[UInt8]=[]
var bloodGlucoseNoOfRecords:String?
var bloodGlucoseCommandsArray = [String?]()
var bloodGlucoseResponseBytesArray:[UInt8]=[]
var patientEventsNoOfRecords:String?
var patientEventsCommandsArray = [String?]()
var patientEventsResponseBytesArray:[UInt8]=[]
var alertEventsNoOfRecords:String?
var alertEventsCommandsArray = [String?]()
var alertEventsResponseBytesArray:[UInt8]=[]
var g_mainVersion:String?
var g_fullVersion:String?
var g_commands:[String]  = []
var g_cmdName:String = ""
var g_sensorId:String = ""
var g_hexPath:String = ""
var g_exePath:String = ""
var g_stm32CubeSoftwarePath:String = ""

class EversenseLoginViewController: NSViewController, NSWindowDelegate {
    @IBOutlet weak var tempScrollViewAuditLOg: NSScrollView!
    @IBOutlet weak var webViewForgotPassword: WKWebView!
    @IBOutlet weak var lblStmDownloadTransferRate: NSTextField!
    @IBOutlet weak var lblStmDownloadEta: NSTextField!
    @IBOutlet weak var lblJavaDownloadTransferRate: NSTextField!
    @IBOutlet weak var lblJavaDownloadEta: NSTextField!
    @IBOutlet weak var lblNewVersionDownloadEta: NSTextField!
    @IBOutlet weak var lblNewVersionDownloadTransferRate: NSTextField!
    @IBOutlet weak var logo: NSImageView!
    @IBOutlet weak var btStartTransmitterUpdate_ViewReviewChanges: NSButton!
    @IBOutlet weak var startTransmitterUpdateBtn: NSButton!
    @IBOutlet weak var viewTxNotActive: NSView!
    @IBOutlet weak var lblLoggedInUser: NSTextField!
    @IBOutlet weak var lblLoggedInUserValue: NSTextField!
    @IBOutlet weak var btStartQuiz_ViewStartQuiz: NSButton!
    @IBOutlet weak var btCloseCross: NSButton!
    @IBOutlet var pdfTextView: NSTextView!
    @IBOutlet weak var viewNoUpdateAvailable: NSView!
    @IBOutlet weak var btNeedHelp: NSButton!
    @IBOutlet weak var stmProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var javaProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var newVersionProgressIndicator: NSProgressIndicator!
    @IBOutlet weak var lbInstructionRestartQuiz: NSTextField!
    @IBOutlet weak var tfSendPasswordResetEmail: NSTextField!
    @IBOutlet weak var btSendPasswordResetEmail: NSButton!
    @IBOutlet weak var btBack_ViewForgotUserName: NSButton!
    @IBOutlet weak var textFieldAppVersion: NSTextField!
    @IBOutlet weak var viewResumeQuizWelcome: NSView!
    @IBOutlet weak var viewRestartQuiz: NSView!
    @IBOutlet weak var btNextFromViewConnectUsb: NSButton!
    @IBOutlet weak var noUpdateAvailableTextField: NSTextField!
    @IBOutlet var textViewAuditLog: NSTextView!
    @IBOutlet weak var lbQuestionIndex: NSTextField!
    @IBOutlet weak var videoWebView: WKWebView!
    @IBOutlet weak var btSignOut: NSButton!
    @IBOutlet weak var btSignIn: NSButton!
    @IBOutlet weak var viewProgressBar: NSView!
    @IBOutlet weak var viewNavigation: NSView!
    @IBOutlet weak var viewFirmwareUpgradeProgressing: NSView!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var lbUpgradeStatus: NSTextField!
    @IBOutlet weak var viewAfterUpgrade: NSView!
    @IBOutlet weak var loginErrorColorWell: NSColorWell!
    @IBOutlet weak var btBack_ViewForgotPassword: NSButton!
    @IBOutlet weak var viewReviewChangesTitle: NSTextField!
    @IBOutlet weak var btSaveAndContinueLater_ViewQuizFailed: NSButton!
    @IBOutlet weak var startQuizTextField: NSTextField!
    @IBOutlet weak var quizFilterBtn: NSButton!
    @IBOutlet weak var viewWaitWhileWeValidateSignOn: NSView!
    @IBOutlet weak var viewStmDownload: NSView!
    @IBOutlet weak var viewJavaDownload: NSView!
    @IBOutlet weak var viewNewVersionDownload: NSView!
    @IBOutlet weak var updateErrorDescriptionTextField: NSTextField!
    @IBOutlet weak var eulaWebView: WKWebView!
    @IBOutlet weak var viewEula: NSView!
    @IBOutlet weak var viewQuizTooManyAttempts: NSView!
    @IBOutlet weak var btExit_ViewEula: NSButton!
    @IBOutlet weak var btAccept_ViewEula: NSButton!
    @IBOutlet weak var viewUpdateError: NSView!
    @IBOutlet weak var checkReviewChanges: NSButtonCell!
    @IBOutlet weak var viewQuizFailed: NSView!
    @IBOutlet weak var btSignOutAfterUpGrade: NSButton!
    @IBOutlet weak var btOk_ViewQuizSuccessful: NSButton!
    @IBOutlet weak var btResumeQuiz_ViewResumeQuizWelcome: NSButton!
    @IBOutlet weak var btResumeQuiz_ViewQuizFailed: NSButton!
    @IBOutlet weak var quizAvPlayerView: AVPlayerView!
    @IBOutlet weak var viewQuizQuestion: NSView!
    @IBOutlet weak var viewWelcomeAfterSignIn: NSView!
    @IBOutlet weak var viewFirmwareUpToDate: NSView!
    @IBOutlet weak var reviewChanges1WebView: WKWebView!
    @IBOutlet weak var viewQuizSuccessful: NSView!
    @IBOutlet weak var imageViewDoctorClientBackground: NSImageView!
    @IBOutlet weak var viewSignIn: NSView!
    @IBOutlet weak var oneHundredPercent: NSTextField!
    @IBOutlet weak var zeroPercent: NSTextField!
    @IBOutlet weak var viewWaitWhileWeCheck: NSView!
    @IBOutlet weak var viewConnectUsb: NSView!
    @IBOutlet weak var quizImageView: NSImageView!
    @IBOutlet weak var viewForgotUsername: NSView!
    @IBOutlet weak var viewStartQuiz: NSView!
    @IBOutlet weak var btRestartQuiz_ViewRestartQuiz: NSButton!
    @IBOutlet weak var radio1: NSButton!
    @IBOutlet weak var radio2: NSButton!
    @IBOutlet weak var radio3: NSButton!
    @IBOutlet weak var radio4: NSButton!
    @IBOutlet weak var radio5: NSButton!
    @IBOutlet weak var btRetry_ViewUpdateError: NSButton!
    @IBOutlet weak var btForgotUserName_ViewSignIn: NSButton!
    @IBOutlet weak var btOkFromViewNoUpdaetAvailable: NSButton!
    @IBOutlet weak var btForgotPassword_ViewSignIn: NSButton!
    @IBOutlet weak var viewForgotPassword: NSView!
    @IBOutlet weak var statusTextField: NSTextField!
    @IBOutlet weak var logInErrorTextField: NSTextField!
    @IBOutlet weak var lbCurrentTransmitterVer: NSTextField!
    @IBOutlet weak var lbEversenseMobileAppSoftwareVer: NSTextField!
    @IBOutlet weak var lbNoInstruction: NSTextField!
    @IBOutlet weak var btPrevQuizQuestion: NSButton!
    @IBOutlet weak var textFieldExceedQuizAttempts: NSTextField!
    @IBOutlet weak var textFieldTxUpToDate: NSTextField!
    @IBOutlet weak var incorrectAnswerTextField: NSTextField!
    @IBOutlet weak var viewFimwareUpToDate: NSView!
    @IBOutlet weak var btSubmitQuiz: NSButton!
    @IBOutlet weak var btNextQuizQuestion: NSButton!
    @IBOutlet weak var btContinue: NSButton!
    @IBOutlet weak var lbYourEversenseCGMSystem: NSTextField!
    @IBOutlet weak var lbEversenseMobileAppSoftwareVerValue: NSTextField!
    @IBOutlet weak var lbCurrentTransmitterVerValue: NSTextField!
    @IBOutlet weak var lbActiveTransmitterSnValue: NSTextField!
    @IBOutlet weak var lbActiveTransmitterSn: NSTextField!
    @IBOutlet weak var lbPassword: NSTextField!
    @IBOutlet weak var lbEmail: NSTextField!
    @IBOutlet weak var tfPassword: NSTextField!
    @IBOutlet weak var tfPasswordSecure: NSSecureTextField!
    @IBOutlet weak var tfEmailNew: NSTextField!
    @IBOutlet weak var auditScrollView: NSScrollView!
    @IBOutlet weak var btSaveAndContinueLater: NSButton!
    @IBOutlet weak var txNotActiveTextField: NSTextField!
    @IBOutlet weak var quizAnswer5: NSButton!
    @IBOutlet weak var quizAnswer4: NSButton!
    @IBOutlet weak var quizAnswer3: NSButton!
    @IBOutlet weak var quizAnswer2: NSButton!
    @IBOutlet weak var quizAnswer1: NSButton!
    @IBOutlet weak var quizQuestion: NSTextField!
    @IBOutlet weak var btViewHistory: NSButton!
    @IBOutlet weak var lbForgotPassword: NSTextField!
    @IBOutlet weak var lbInstruction: NSTextField!
    @IBOutlet weak var lbSignIn: NSTextField!
    @IBOutlet weak var btCheckForUpdateFromWelcomeView: NSButton!
    @IBOutlet weak var viewErrorMessage: NSView!
    @IBOutlet weak var textErrorMessage: NSTextField!
    @IBOutlet var viewMain: NSView!
    @IBOutlet weak var viewHeader: NSView!
    @IBOutlet weak var viewFooter: NSView!
    @IBOutlet weak var textReviewChanges: NSTextField!
    @IBOutlet weak var viewReviewChanges: NSView!
    @IBOutlet weak var btReviewChanges: NSButton!
    @IBOutlet weak var ShowTransmitterView: NSButton!
    @IBOutlet weak var buttonPasswordVisibility: NSButton!
    var timer:Timer?
    var lastdatareceivedon:CFTimeInterval=0
    var byteArray:[Int]=[]
    var passwordResetEmailSuccess: StructPasswordResetEmailSuccess?
    var isLoggedOut: Bool?


    @objc let serialPortManager = ORSSerialPortManager.shared()
    @objc dynamic var serialPort: ORSSerialPort? {
        didSet {
            oldValue?.close()
            oldValue?.delegate = nil
            serialPort?.delegate = self
        }
    }
    
    @objc func CallApiGetOtwFirmwareInformationNotificationReceived(notification: NSNotification) {
        if let changeUi = notification.object as? Bool {
            CallApiGetOtwFirmwareInformation(changeUi: changeUi)
        }
    }
    
    @objc func CallApiGetAuditHistoryNotificationReceived(notification: NSNotification) {
            CallApiGetAuditHistory()
    }

    // MARK: Life Cycle
    override func viewDidLoad() {
        
        
        getDirectoryUrl()
        getCpuType()
        //g_functionJCode = 307
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        super.viewDidLoad()
        getDirectoryUrl() //find out where to save the log
        hostWebUrl = getValue(forKey: "HOSTWEBURL")?.replacingOccurrences(of: "#()", with: "//")
        hostApiUrl = getValue(forKey: "HOSTAPIURL")?.replacingOccurrences(of: "#()", with: "//")
        hostAuthenticationUrl = getValue(forKey: "HOSTAUTHENTICATIONURL")?.replacingOccurrences(of: "#()", with: "//")
        hostCgmUploadApiUrl = getValue(forKey: "HOSTCGMUPLOADAPIURL")?.replacingOccurrences(of: "#()", with: "//")
        ENV = getValue(forKey: "ENV")?.replacingOccurrences(of: "#()", with: "//")
        //this email will be replaced with the email from Api viaappconfig
        g_HELPEMAILADDR = getValue(forKey: "HELPEMAILADDR")?.replacingOccurrences(of: "#()", with: "//")
        g_firmwareOutputInLogFile = (getValue(forKey: "FIRMWARE_OUTPUT_IN_LOG_FILE")?.replacingOccurrences(of: "#()", with: "//"))?.lowercased()
        g_txLogoutputMsgLineCount = Int(((getValue(forKey: "TX_LOG_OUTPUT_MSG_LINE_COUNT")?.replacingOccurrences(of: "#()", with: "//"))?.lowercased())!)
        
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(CallApiGetOtwFirmwareInformationNotificationReceived(notification: )), name: Notification.Name("CallApiGetOtwFirmwareInformation"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CallApiGetAuditHistoryNotificationReceived(notification: )), name: Notification.Name("CallApiGetAuditHistory"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(CloseTheApp(notification: )), name: Notification.Name("CloseTheApp"), object: nil)
        
        self.CallApiGetEuaMessageFromCloud()

        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { [self] path in
            if path.status == .satisfied {
                print("Connected")
                g_internet = true
                if (defaults!.string(forKey: "pendingAudits") != nil)
                {
                    GlobalManager.shared.sendAudit(code: "",processPending: true)
                    defaults!.removeObject(forKey: "pendingAudits")
                }
            } else {
                g_internet = false
                print("Disconnected")
                
                if (g_installingDrivers)
                {
                    showAlert(header: "Eversense Upgrade", body: "Internet Connection Error.",quit: true)
//                    let dispatchGroup = DispatchGroup()
//                    dispatchGroup.enter()
//                    DispatchQueue.main.async { [self] in
//                        //            showStatusTextField(auditCode: "5020", lines: 5, x: 372, y: 380, width: 300, height: 60)
//                        showErrorMessageLoginScreen(auditCode: "5025")
//                        dispatchGroup.leave()
//                    }
//                    
//                    dispatchGroup.enter()
//                    DispatchQueue.main.async { [self] in
//                        displayMainView(myView: viewUpdateError)
//                        dispatchGroup.leave()
//                    }
                }
            }
            print(path.isExpensive)
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
        NotificationCenter.default.addObserver(self,selector:#selector(stmDownloadCompletion(notification:)),name: Notification.Name("stmDownloadCompleted"),object:nil);
        NotificationCenter.default.addObserver(self,selector:#selector(stmDownloadProgress(notification:)),name: Notification.Name("updateStmDownloadProgress"),object:nil);
        NotificationCenter.default.addObserver(self,selector:#selector(javaDownloadCompletion(notification:)),name: Notification.Name("javaDownloadCompleted"),object:nil);
        NotificationCenter.default.addObserver(self,selector:#selector(javaDownloadProgress(notification:)),name: Notification.Name("updateJavaDownloadProgress"),object:nil);
        NotificationCenter.default.addObserver(self,selector:#selector(newVersionDownloadCompletion(notification:)),name: Notification.Name("newVersionDownloadCompleted"),object:nil);
        NotificationCenter.default.addObserver(self,selector:#selector(newVersionDownloadProgress(notification:)),name: Notification.Name("updateNewVersionDownloadProgress"),object:nil);
        NotificationCenter.default.addObserver(self,selector:#selector(viaAppConfigPublicApiGetJavaDownloadUrlDoneNotified(notification:)),name: Notification.Name("viaAppConfigPublicApiGetJavaDownloadUrlDone"),object:nil);
        NotificationCenter.default.addObserver(self,selector:#selector(viaAppConfigPublicApiGetStmDownloadUrlDoneNotified(notification:)),name: Notification.Name("viaAppConfigPublicApiGetStmDownloadUrlDone"),object:nil);
        NotificationCenter.default.addObserver(self,selector:#selector(viaAppConfigPublicApiStmMd5DoneNotified(notification:)),name: Notification.Name("viaAppConfigPublicApiStmMd5Done"),object:nil);
        
        NotificationCenter.default.addObserver(self,selector:#selector(viaAppConfigPublicApiGetNewVersionDownloadUrlDoneNotified(notification:)),name: Notification.Name("viaAppConfigPublicApiGetNewVersionDownloadUrlDone"),object:nil);
        NotificationCenter.default.addObserver(self,selector:#selector(viaAppConfigPublicApiNewVersionMd5DoneNotified(notification:)),name: Notification.Name("viaAppConfigPublicApiNewVersionMd5Done"),object:nil);
        
        NotificationCenter.default.addObserver(self,selector:#selector(viaAppConfigPublicApiJavaMd5DoneNotified(notification:)),name: Notification.Name("viaAppConfigPublicApiJavaMd5Done"),object:nil);
        NotificationCenter.default.addObserver(self,selector:#selector(viaAppConfigPublicApiJavaVolumePathDoneNotified(notification:)),name: Notification.Name("viaAppConfigPublicApiJavaVolumePathDone"),object:nil);
        btSignIn.setButton(backgroundColor: NSColor(named: "blue")!)
        beautify(foo: btNeedHelp)
        beautify(foo: btReviewChanges)
        beautify(foo: btSignOut)
        beautify(foo: btSubmitQuiz)
        beautify(foo: btViewHistory)
        beautify(foo: btNextQuizQuestion)
        beautify(foo: btPrevQuizQuestion)
        beautify(foo: btSaveAndContinueLater)
        beautify(foo: btNextFromViewConnectUsb)
        beautify(foo: btCheckForUpdateFromWelcomeView)
        beautify(foo: btSignOutAfterUpGrade)
        beautify(foo: btStartTransmitterUpdate_ViewReviewChanges)
        beautify(foo: btRetry_ViewUpdateError)
        beautify(foo: btStartQuiz_ViewStartQuiz)
        beautify(foo: btSaveAndContinueLater_ViewQuizFailed)
        beautify(foo: btRestartQuiz_ViewRestartQuiz)
        beautify(foo: btResumeQuiz_ViewQuizFailed)
        beautify(foo: btResumeQuiz_ViewResumeQuizWelcome)
        beautify(foo: btOk_ViewQuizSuccessful)
        beautify(foo: btBack_ViewForgotUserName)
        beautify(foo:btOkFromViewNoUpdaetAvailable)
        moveUI()
        self.createFolderInsideApplicationSupportIfNotExist()
        if getAppUserDefault(key: "builddate") == "" {
            setAppUserDefault(key: "builddate", value: getBuildDate())
        }
        self.updateAppVersionFromBundle()
        g_upgradeStartTime = 0
        if 1 == 1 //this is to show the sign in page incase internet is disconnected from the getgo
        {
            viewSignIn.frame.origin.y = 0
            if !(g_internet)
            {
//                addAlertView(headerPrimaryText: "Notification", message: "Internet Connection Error", isHeaderSecondaryHidden: true)
                showAlert(header: "Eversense Upgrade", body: "Internet Connection Error.",quit: true)

                return
            }
        }
        Bundle.setLanguage("en")
//        getCpuTypeAndInstallRosettaIfNeeded()

            
            GlobalManager.shared.uploadLogFile()
//            installJavaIfNotInstalled()
        callPublicApiViaAppCong(keyName: "MacStmVersion", notificationName: "")
        callPublicApiViaAppCong(keyName: "MacValidStmVersions", notificationName: "")
        
        while (true)
        {
            sleep(1)
            if (g_MacStmVersionFromCloud != "" && g_MacValidStmVersionsFromCloud != "")
            {
                installCubeIfNotInstalled()
                break
            }
        }
                
            
        DispatchQueue.main.async {
            self.view.window?.standardWindowButton(.closeButton)?.isEnabled = true
        }

    }
    
    @objc func CloseTheApp(notification: NSNotification) {
            wantToCloseApp()
    }

    override func viewWillAppear() {
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        super.viewWillAppear()
        self.view.window?.delegate = self
        // FIXME: commented code can be removed if not required
        //        if 1 == 1 //control the window title buttons
        //        {
        //            if #available(macOS 11.0, *) {
        //                view.window?.standardWindowButton(.closeButton)?.isHidden = true
        //                view.window?.standardWindowButton(.zoomButton)?.isHidden = true
        //                view.window?.standardWindowButton(.miniaturizeButton)?.isHidden = true
        //            } else {
        //                // Fallback on earlier versions
        //            }
        //        }
//        var langCode = Locale.current.languageCode
    }
    
    override func viewDidAppear() {
        //KEEP
        super.viewDidAppear()
        if let window: NSWindow = self.view.window {
            window.contentMinSize = NSSize(width: 700, height: 700)
        }
        if isLoggedOut ?? false {
            viewEula.isHidden = true
            viewSignIn.isHidden = false
        }
    }
    
    func showIncorrectQuestions() {
        //KEEP
        //g_functionJCode = 101
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if QuizResult.count > 0 {
            Quizzes[0].QuizQuestions.removeAll()
            var incorrectQuestionsCount = QuizResult[0].wrongQuizChoices!.count + QuizResult[0].missingMulticheckboxQuizChoices!.count
            if incorrectQuestionsCount > 0 {
                for foo in QuizResult[0].wrongQuizChoices! {
                    var incorrectQuestionId = foo.questionID
                    for (idx,bar) in QuizzesOriginal[0].QuizQuestions.enumerated() {
                        if incorrectQuestionId == bar.QuestionID {
                            Quizzes[0].QuizQuestions.append(bar)
                        }
                    }
                }
                for foo in QuizResult[0].missingMulticheckboxQuizChoices! {
                    var incorrectQuestionId = foo.questionID
                    for (idx,bar) in QuizzesOriginal[0].QuizQuestions.enumerated() {
                        if incorrectQuestionId == bar.QuestionID {
                            Quizzes[0].QuizQuestions.append(bar)
                        }
                    }
                }
            }
            currentQuizQuestionIndex=0
            displayCurrentQuizQuestionAndAnswers()
        }
    }

    func showAllQuestions()
    {
        //KEEP
        //g_functionJCode = 102
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        Quizzes = QuizzesOriginal
        currentQuizQuestionIndex=0
        displayCurrentQuizQuestionAndAnswers()
    }

    func showAlert(auditCode: String)
    {
        //KEEP
        let index = EuaMessage.firstIndex { $0.messageCode == auditCode }
        addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly, isHeaderSecondaryHidden: true)
        //g_functionJCode = 112
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if auditCode=="5000010" {
            GlobalManager.shared.sendAudit(code: auditCode)
            let index = EuaMessage.firstIndex { $0.messageCode == "5000010" }
            Logger.log(EuaMessage[index!].messageDescription)
        }
        
        g_statusTextReason=auditCode
    }
//    func quitApp()
//    {
//        exi
//    }
    
    func closeApp(result:Bool)
    {
        exit(0)
    }
    func showAlertNoInternet(quit:Bool = false)
    {
        //KEEP
        let index = EuaMessage.firstIndex { $0.messageCode == "5000025" }
        if (index != nil)
        {
            self.addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly)
            Logger.log(EuaMessage[index!].messageDescription)
//            showAlert(header: "Notification", body: EuaMessage[index!].messagerDescriptionUserFriendly)

        }
        else
        {
            self.addAlertView(headerPrimaryText: "Notification", message: "Please check your internet connection and try again.")
//            Logger.log(EuaMessage[index!].messageDescription)
//            showAlert(header: "Notification", body: "Please check your internet connection and try again.")

        }
//        if (quit)
//        {
//            showAlert(header: "Notification", body: "Please check your internet connection and try again.", quit: true)
//        }
//        else{
//            addAlertView(headerPrimaryText: "Notification", message: "Please check your internet connection and try again.", isHeaderSecondaryHidden: true)
//        }
//        
        
        
        
//        exit(0)
        //g_functionJCode = 112
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        if auditCode=="5000010" {
//            GlobalManager.shared.sendAudit(code: auditCode)
//            let index = EuaMessage.firstIndex { $0.messageCode == "5000010" }
//            Logger.log(EuaMessage[index!].messageDescription)
//        }
//        
//        g_statusTextReason=auditCode
    }
    
    

    func showErrorMessageLoginScreen(auditCode: String, auditText:String="") {
        //KEEP
        DispatchQueue.main.async { [weak self] in
            var index = EuaMessage.firstIndex { $0.messageCode == auditCode }
            if index == nil
            {
                index = EuaMessage.firstIndex { $0.messageCode == "100" }
            }
            if (auditText == "")
            {
                self?.addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly.replacingOccurrences(of: "CCCC", with: auditCode), isHeaderSecondaryHidden: true)
            }
            else
            {
                self?.addAlertView(headerPrimaryText: "Notification", message: auditText, isHeaderSecondaryHidden: true)
            }
            
        }
    }
    

    
    //LEGACY-METHOD-TO-BE-REMOVED
//    func showModalPopUp(auditCode: String) {
//        DispatchQueue.main.async { [weak self] in
//            self?.addAlertView(headerPrimaryText: AppConstants.auditCodeTitle[auditCode] ?? "", message: AppConstants.auditCodeDescription[auditCode] ?? "", isHeaderSecondaryHidden: true)
//        }
//    }
    
    
    
  
    //LEGACY-METHOD-TO-BE-REMOVED
//    func writeToFile(text: String, fileName: String) {
//        //g_functionJCode = 119
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        let file = fileName//this is the file. we will write to and read from it
//        //        let text = "some text" //just a text
//        let fileURL = g_directoryURL.appendingPathComponent(file)
//        //writing
//        do {
//            try text.write(to: fileURL, atomically: true, encoding: .utf8)
//        }
//        catch {/* error handling here */}
//        //reading
//        do {
//            let text2 = try String(contentsOf: fileURL, encoding: .utf8)
//        }
//        catch {
//            print("error writing")
//        }
//    }
    
    func writeToAppUserDefaultFile(text: String) {
        //KEEP
        //g_functionJCode = 120
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let fileURL = g_appUserDefaultUrl
        //writing
        do {
            try text.write(to: fileURL!, atomically: true, encoding: .utf8)
        }
        catch {/* error handling here */}
        //reading
        do {
            let text2 = try String(contentsOf: fileURL!, encoding: .utf8)
        }
        catch {
            print("error writing")
        }
    }
    
    //LEGACY-METHOD-TO-BE-REMOVED
//    func readFromFile(fileName: String) -> String {
//        //g_functionJCode = 121
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        let file = fileName//this is the file. we will write to and read from it
//        //        let text = "some text" //just a text
//        let fileURL = g_directoryURL.appendingPathComponent(file)
//        var text2:String?=""
//        //reading
//        do {
//            text2 = try String(contentsOf: fileURL, encoding: .utf8)
//        }
//        catch {
//            print("error reading")
//        }
//        return text2!
//    }
    
    func readFromAppUserDefault() -> String {
        //KEEP
        //g_functionJCode = 122
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        //        let file = fileName//this is the file. we will write to and read from it
        
        //        let text = "some text" //just a text
        let fileURL:URL = g_appUserDefaultUrl
        var text2:String?=""
        //reading
        do {
            text2 = try String(contentsOf: fileURL, encoding: .utf8)
        }
        catch {
            print("error reading")
        }
        return text2!
    }
    
   //LEGACY
//    func makePdfReviewChanges() {
//        //g_functionJCode = 123
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        do {
//            // define bounds of PDF as the note text view
//            let rect: NSRect = self.textReviewChanges.bounds
//            // create the file path for the PDF
//            
//            // add the note title to path
//            let path = g_directoryURL.appendingPathComponent("FirmwareChanges.pdf")
//            // Create a PDF of the noteTextView and write it to the created filepath
//            try self.textReviewChanges.dataWithPDF(inside: rect).write(to: path)
//            DispatchQueue.main.async { [self] in
//                showAlert(header: "Changes", body: "A PDF file that contains changes have been safed to your Documents Folder.  Please look for FirmwareChanges.pdf in your documents folder")
//            }
//        } catch _ {
//            print("something went wrong.") // never happens to me
//        }
//    }
    
    //LEGACY-METHOD-TO-BE-REMOVED
//    // FIXME: Static text, can be moved to constants file.
//    func getAuditCode(auditCode:String) -> (resultAuditCode:String,resultAuditDescription:String,resultAuditDescriptionUserFriendly:String)
//    {
//        //        //g_functionJCode = 128
//        //        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        var resultAuditCode = auditCode
//        var resultAuditDescription = ""
//        var resultAuditDescriptionUserFriendly = ""
//        if auditCode == "1"
//        {
//            resultAuditCode = "J5001"
//            resultAuditDescription = "There was an error during Loader startup."
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade. Ensure your transmitter is secure in the cradle and the cradle is connected to your computer. Please try again. Do not unplug the USB or remove the transmitter from the cradle. If the problem persists, please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5001."
//        }
//        if auditCode == "2"
//        {
//            resultAuditCode = "J5002"
//            resultAuditDescription = "FW update is pending. Current application backup to external flash failed after 2 retry attempts. Proceed to perform FW update anyway even though we failed to back up!"
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade. Ensure your transmitter is secure in the cradle and the cradle is connected to your computer. Please try again. Do not unplug the USB or remove the transmitter from the cradle. If the problem persists, please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5002."
//        }
//        if auditCode == "3"
//        {
//            resultAuditCode = "J5003"
//            resultAuditDescription = "FW update was successful. But the new image could not be copied to external flash. We are operating without a backup at this point."
//            resultAuditDescriptionUserFriendly = "The upgrade was successful and you can continue using your transmitter.  However, system checks indicate your transmitter needs to be replaced. Please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5003."
//        }
//        if auditCode == "4"
//        {
//            resultAuditCode = "J5004"
//            resultAuditDescription = "FW update failed. We reverted to the application back-up available in the external flash."
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade. Ensure your transmitter is secure in the cradle and the cradle is connected to your computer. Please try again. Do not unplug the USB or remove the transmitter from the cradle. If the problem persists, please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5004."
//        }
//        if auditCode == "5"
//        {
//            resultAuditCode = "J5005"
//            resultAuditDescription = "FW update failed. We tried copying the image in the external flash and failed. Await a new image."
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade. Ensure your transmitter is secure in the cradle and the cradle is connected to your computer. Please try again. Do not unplug the USB or remove the transmitter from the cradle. If the problem persists, please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5005."
//        }
//        if auditCode == "6"
//        {
//            resultAuditCode = "J5006"
//            resultAuditDescription = "FW update failed and we did not have a good back up image in the external flash either."
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade. Ensure your transmitter is secure in the cradle and the cradle is connected to your computer. Please try again. Do not unplug the USB or remove the transmitter from the cradle. If the problem persists, please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5006."
//        }
//        if auditCode == "7"
//        {
//            resultAuditCode = "J5007"
//            resultAuditDescription = "Normal boot, application was no good, we have a backup image in the external flash, but we couldn’t copy it even after 2 retries"
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade. Ensure your transmitter is secure in the cradle and the cradle is connected to your computer. Please try again. Do not unplug the USB or remove the transmitter from the cradle. If the problem persists, please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5007."
//        }
//        if auditCode == "8"
//        {
//            resultAuditCode = "J5008"
//            resultAuditDescription = "Normal boot, application was no good and we reverted to back up image in the external flash."
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade. Ensure your transmitter is secure in the cradle and the cradle is connected to your computer. Please try again. Do not unplug the USB or remove the transmitter from the cradle. If the problem persists, please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5008."
//        }
//        if auditCode == "9"
//        {
//            resultAuditCode = "J5009"
//            resultAuditDescription = "Normal boot, application was no good and we don’t have a backup image either. Await a new image."
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade. Ensure your transmitter is secure in the cradle and the cradle is connected to your computer. Please try again. Do not unplug the USB or remove the transmitter from the cradle. If the problem persists, please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5009."
//        }
//        if auditCode == "J5010"
//        {
//            resultAuditDescription = "Transmitter Disconnected During Upgrade."
//            resultAuditDescriptionUserFriendly = "Transmitter is disconnected. Ensure that the transmitter is secured in the cradle, and the cradle is plugged into your computer and try again.\nJ5010"
//        }
//        if auditCode == "J5011"
//        {
//            //resultAuditCode = "J5012
//            resultAuditDescription = "Mismatched Hash Keys"
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade.  Your transmitter cannot be upgraded at this time. Please contact Customer Care.\nJ5011."
//        }
//        if auditCode == "J5012"
//        {
//            resultAuditDescription = "Cloud Not Responding"
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade. Ensure your transmitter is secure in the cradle and the cradle is connected to your computer. Please try again. Do not unplug the USB or remove the transmitter from the cradle. If the problem persists, please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5012."
//        }
//        if auditCode == "J5013"
//        {
//            resultAuditDescription = "Corrupted Firmware"
//            resultAuditDescriptionUserFriendly = " Your transmitter cannot be upgraded at this time. Please contact Customer Care. support@eversensediabetes.com, 844-SENSE4U.\nJ5013."
//        }
//        if auditCode == "J5014"
//        {
//            resultAuditDescription = "Time Elapsed – Not connected to internet"
//            resultAuditDescriptionUserFriendly = "A problem occured during the upgrade. Be sure your computer is connected to the internet and try again.\nJ5014."
//        }
//        if auditCode == "J5020"
//        {
//            resultAuditDescription = "Incorrect username and password during sign in"
//            resultAuditDescriptionUserFriendly = "Incorrect Email or Password. Please try again.\nJ5020"
//        }
//        if auditCode == "J5021"
//        {
//            resultAuditDescription = "Exceeded quiz retries."
//            resultAuditDescriptionUserFriendly = "You have exceeded the number of quiz attempts. Please contact Customer Care. support@eversensediabetes.com,844-SENSE4U\nJ5021"
//        }
//        if auditCode == "J5022"
//        {
//            resultAuditDescription = "Please charge your laptop and try upgrading again"
//            resultAuditDescriptionUserFriendly = "Not enough battery power in your computer to continue. Please charge your laptop and try again.\nJ5022"
//        }
//        
//        if auditCode == "J5023"
//        {
//            resultAuditDescription = "Inactive Transmitter Connected."
//            resultAuditDescriptionUserFriendly = "Transmitter SN: XXXX is not active in your account. Please Connect Transmitter SN: YYYY\nJ5023"
//        }
//        if auditCode == "J5024"
//        {
//            resultAuditDescription = "Upgrade Third Attempt Error."
//            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade. Please contact Customer Care immediately. support@eversensediabetes.com.\n844-SENSE4U.\nJ5024"
//        }
//        if auditCode == "J5025"
//        {
//            resultAuditDescription = "No internet connection."
//            resultAuditDescriptionUserFriendly = "Please check your internet connection and try again.\nJ5025"
//        }
//        if auditCode == "J5026"
//        {
//            resultAuditDescription = "Email Address is not valid"
//            resultAuditDescriptionUserFriendly = "Email Address is not valid. Maximum 256 Characters.\nJ5026"
//        }
//        if auditCode == "J5027"
//        {
//            resultAuditDescription = "You need to answer all the questions before submitting"
//            resultAuditDescriptionUserFriendly = "You need to answer all the questions before submitting.\nJ5027"
//        }
//        if auditCode == "J5028"
//        {
//            resultAuditDescription = "Transmitter disconnected."
//            resultAuditDescriptionUserFriendly = "Transmitter is disconnected. Ensure that the transmitter is secured in the cradle, and the cradle is plugged into your computer and try again.\nJ5028"
//        }
//        
//        
//        if auditCode == "J5050"
//        {
//            resultAuditDescription = "Initiated Quiz"
//            resultAuditDescriptionUserFriendly = "Initiated Quiz.\nJ5050"
//        }
//        if auditCode == "J5051"
//        {
//            resultAuditDescription = "Completed Quiz - Pass"
//            resultAuditDescriptionUserFriendly = "Completed Quiz - Pass.\nJ5051"
//        }
//        if auditCode == "J5052"
//        {
//            resultAuditDescription = "Quiz: Save and Continue Later."
//            resultAuditDescriptionUserFriendly = "Quiz: Save and Continue Later.\nJ5052"
//        }
//        if auditCode == "J5053"
//        {
//            resultAuditDescription = "Initiated Firmware Upgrade"
//            resultAuditDescriptionUserFriendly = "Initiated Firmware Upgrade.\nJ5053"
//        }
//        if auditCode == "J5054"
//        {
//            resultAuditDescription = "Firmware Upgraded Successfully."
//            resultAuditDescriptionUserFriendly = "Smart Transmitter Upgrade Complete.\nJ5054"
//        }
//        if auditCode == "J5055"
//        {
//            resultAuditDescription = "Firmware Upgrade Failed."
//            resultAuditDescriptionUserFriendly = "Firmware Upgrade Failed.\nJ5055"
//        }
//        if auditCode == "J5056"
//        {
//            resultAuditDescription = "Data is synced to Eversense Cloud."
//            resultAuditDescriptionUserFriendly = "Data is synced to Eversense Cloud.\nJ5056"
//        }
//        if auditCode == "J5058"
//        {
//            resultAuditDescription = "Quiz Result - FAIL."
//            resultAuditDescriptionUserFriendly = "Quiz Result - FAIL.\nJ5058"
//        }
//        if auditCode == "J506001"
//        {
//            resultAuditDescription = "Connecting Transmitter. Please wait about XX seconds"
//            resultAuditDescriptionUserFriendly = "Connecting Transmitter. Please wait about XX seconds"
//        }
//        if auditCode == "J506002"
//        {
//            resultAuditDescription = "Please disconnect the Transmitter and reconnect"
//            resultAuditDescriptionUserFriendly = "Please disconnect the Transmitter and reconnect"
//        }
//        if auditCode == "J600001"
//        {
//            resultAuditDescription = "Warranty Expired"
//            resultAuditDescriptionUserFriendly = "Warranty Expired"
//        }
//        if auditCode == "J600002"
//        {
//            resultAuditDescription = "No Firmware Version Available to Upgrade"
//            resultAuditDescriptionUserFriendly = "No Firmware version Available to Upgrade"
//        }
//        if auditCode == "J600003"
//        {
//            resultAuditDescription = "Customer not paid"
//            resultAuditDescriptionUserFriendly = "Customer not paid"
//        }
//        if auditCode == "J600004"
//        {
//            resultAuditDescription = "Incompatible MMA"
//            resultAuditDescriptionUserFriendly = "Incompatible MMA"
//        }
//        
//        //        if auditCode == "J5059"
//        //        {
//        //            resultAuditDescription = "Upgrade Third Attempt Error"
//        //            resultAuditDescriptionUserFriendly = "A problem occurred during the upgrade.  Please contact Customer Care immediately. support@eversensediabetes.com, 844-SENSE4U. J5059"
//        //        }
//        
//        return(resultAuditCode,resultAuditDescription,resultAuditDescriptionUserFriendly)
//    }
    

    func getMyFirmwareVersion() {
        //KEEP
        //g_functionJCode = 130
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        sleep(1)
        self.GetCmdByteByAddressAndSendToTx(strAddress: "000A", numberOfBytes: 4, commandName: "000A")
        g_zeroZeroAStartTime = Int(Date().timeIntervalSince1970)

    }
    
    //LEGACY-METHOD-TO-BE-REMOVED
//    func checkInternetConnectionAndDisableOrEnableControls() -> Bool {
//        //g_functionJCode = 133
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        //        let networkMonitor = try! NetworkMonitor()
//        //        let reachability = try! Reachability()
//        var errorString = getAuditCode(auditCode: "5014").resultAuditDescriptionUserFriendly
//        if g_internet == false {
//            if g_internet == true {
//                g_internet = false
//                if g_upgradeInProgress {
//                    print("There was an error in upgrading Transmitter Firmware. Please try again.")
//                    //                    self.signout()
//                    let resultAuditCode = getAuditCode(auditCode: "5014").resultAuditCode
//                    let resultAuditDescription = getAuditCode(auditCode: "5014").resultAuditDescription
//                    let resultAuditDescriptionUserFriendly = getAuditCode(auditCode: "5014").resultAuditDescriptionUserFriendly
//                    DispatchQueue.main.async { [self] in
//                        updateErrorDescriptionTextField.stringValue = errorString
//                        updateErrorDescriptionTextField.stringValue.replacingOccurrences(of: "JXX", with: "J5014")
//                    }
//                    displayMainView(myView: viewUpdateError)
//                } else {
//                    //                    statusTextField.textColor = NSColor.red
//                    let resultAuditDescription = getAuditCode(auditCode: "5025").resultAuditDescription
//                    let resultAuditDescriptionUserFriendly = getAuditCode(auditCode: "5025").resultAuditDescriptionUserFriendly
//                    //                    errorString = NSLocalizedString("internet_is_disconnected", comment: "")
//                    errorString = resultAuditDescriptionUserFriendly
//                }
//                enableDisableNavigationButtonsDuringOrAfterUpgradeProcess()
//                print("Network connection Down")
//                //                DispatchQueue.main.async { [self] in
//                ////                    statusTextField.textColor = NSColor.red
//                //                    statusTextField.stringValue = errorString
//                ////                    statusTextField.isHidden = false
//                //                    disableAllButtons(myView: g_currentView!)
//                //                    disableAllButtons(myView: viewNavigation)
//                //                }
//                
//                //                logInErrorTextField.isHidden = true
//            }
//            return false
//        }
//        if ((g_statusTextReason == "J5014") || (g_statusTextReason == "J5025")) {
//            DispatchQueue.main.async { [self] in
//                statusTextField.isHidden = true
//                g_statusTextReason = ""
//            }
//        }
//        return true
//    }
    
    //LEGACY-METHOD-TO-BE-REMOVED
//    // FIXME: Commented code -- remove it
//    @objc func upgradeFirmware() {
//        //TOBEREMOVED
//        if 1 == 2 {
//            //g_functionJCode = 138
//            Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//            if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
//                return
//            }
//            if 1 == 1 {
//                sleep(1)
//                //if you want to force update make it 1 == 1
//                if 1 == 2 {
//                    //red-rabbitforceChange firmware url
//                    g_hexPath = Bundle.main.path(forResource: "Phoenix-Transmitter-STM-Release_XL-6.04.01.23", ofType: "hex")!
//                }
//                //            g_hexPath = Bundle.main.path(forResource: "6.04.02_XL_Phoenix-dev_release", ofType: "hex")!
//                
//                //            var logtext = shell("/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -c port=usb1 -w 60208.hex")
//                //            var logtext = shell("/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -c port=usb1 -w \(g_hexPath) -g")
//                //            var logtext = shell("/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -c port=usb1 -w \(g_hexPath) -g")
//                
//                var logtext = ""
//                logtext="100%"
//                if 1==2 //LATT temporarily disable
//                {
//                    logtext = shell("/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -c port=usb1 -w '\(g_hexPath)' -g & sleep 45; kill $! 2> /dev/null || :")
//                }
//                //            self.removeAllHexFiles()
//                Logger.log("Firmware Upgrade Details: \(logtext)")
//                if logtext.contains("100%") {
//                    g_upgradeFirmwareDone = true
//                    if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
//                        return
//                    }
//                    DispatchQueue.main.async { [self] in
//                        //                    viewFirmwareUpgradeProgressing.isHidden = true
//                        //                    btSignOutAfterUpGrade.isHidden = true
//                        //                    viewAfterUpgrade.isHidden = false
//                        self.progressBar.doubleValue = 95
//                    }
//                    //                self.timer?.invalidate()
//                    //                DispatchQueue.main.async {
//                    //                    self.progressBar.doubleValue = 100
//                    //                    self.lbUpgradeStatus.stringValue = "Transmitter Firmware upgraded successfully. Please wait a few seconds. Transmitter will reboot."
//                    //                }
//                    
//                    //                self.addToLogUserFriendly(logText: "\nTransmitter Firmware upgraded successfully")
//                    //                self.showAlert(header: "Firmware", body: "Transmitter Firmware upgraded successfully. Please wait a few seconds. Transmitter will reboot.")
//                } else {
//                    print("There was an error in upgrading Transmitter Firmware. Please try again.")
//                    if g_deviceIDFromTx == g_deviceIDFromCloud  //incase you intentionall remove the tx during upgrade and put in a different tx,we don't need to go there
//                    {
//                        GlobalManager.shared.sendAudit(code: "5055")
//                        self.checkTxConnectionAndUpdateStatus()
//                        showAlert(auditCode: "5055")
//                    }
//                }
//                for foo in self.serialPortManager.availablePorts {
//                    foo.close()
//                }
//            }
//        }
//    }
//    
    func removeAllHexFiles() {
        //g_functionJCode = 139
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let fileManager = FileManager.default
        guard let allFiles = try? fileManager.contentsOfDirectory(at: g_directoryURL, includingPropertiesForKeys: nil) else {
            return
        }
        let sqliteFiles = allFiles.filter { $0.pathExtension.elementsEqual("hex") }
        for sqliteFile in sqliteFiles {
            do {
                try fileManager.removeItem(at: sqliteFile)
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func checkTxConnectionAndUpdateStatus() {
        //        //g_functionJCode = 140
        //        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var portFound:Bool = false
        for foo in self.serialPortManager.availablePorts {
            if (foo.name.contains("usbmodem")) {
                portFound = true
            }
        }
        if portFound == false {
            g_TxIsPhysicallyConnectedToUsb = false
            //do nothing
            print("port not found")
            DispatchQueue.main.async {
                //                self.statusTextField.textColor = NSColor.red
                //                self.statusTextField.stringValue = NSLocalizedString("transmitter_disconnected", comment: "")
                g_TxIsPhysicallyConnectedToUsb = false
                self.lbActiveTransmitterSnValue.stringValue = "N/A"
                self.lbCurrentTransmitterVerValue.stringValue = "N/A"
            }
        } else {
            g_TxIsPhysicallyConnectedToUsb = true
            print("port found")
            DispatchQueue.main.async {
                //            self.statusTextField.textColor = NSColor.systemGreen
                //            self.statusTextField.stringValue = NSLocalizedString("transmitter_connected", comment: "")
                g_TxIsPhysicallyConnectedToUsb = true
            }
        }
    }
    func safeShell(_ command: String) throws -> String {
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh") //<--updated
        task.standardInput = nil

        try task.run() //<--updated
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return output
    }
    
    func shell(_ command: String) -> String {
        //g_functionJCode = 141
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | command: \(command)")
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/bin/bash"
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        return output
    }
    
    func shellNew(_ command: String) -> String {
        //g_functionJCode = 141
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | command: \(command)")
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.arguments = ["-c", command]
        task.launchPath = "/Users/tinlatt/Library/Application Support/com.senseonics.EversenseUpgrade/stm2140-and-jre/stm/en.stm32cubeprg-mac-v2-14-0/Senseonics"
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        return output
    }
    
    func showAlertPurple(header: String, body: String) {
        //g_functionJCode = 142
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        DispatchQueue.main.async { [self] in
            let alert = NSAlert()
            let index = EuaMessage.firstIndex { $0.messageCode == "5000027" }
            let resultAuditDescriptionUserFriendly = EuaMessage[index!].messagerDescriptionUserFriendly
            Logger.log(EuaMessage[index!].messageDescription)
            alert.messageText = resultAuditDescriptionUserFriendly
            alert.alertStyle = .warning
            alert.addButton(withTitle: "OK")
            alert.icon = NSImage (named: NSImage.cautionName)
            alert.window.contentView?.wantsLayer = true
            alert.window.contentView?.layer?.backgroundColor = CGColor.init(red: 128, green: 49, blue: 167, alpha: 1)
            alert.window.contentView?.updateLayer()
            alert.window.contentView?.needsDisplay = true
            alert.runModal()
        }
    }
    
    func showAlert(header: String, body: String, quit: Bool = false) {
        //g_functionJCode = 143
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        DispatchQueue.main.async {
            let alert = NSAlert()
            alert.messageText = header
            alert.informativeText = body
            alert.alertStyle = .warning
            if quit {
                alert.addButton(withTitle: NSLocalizedString("Exit", comment: ""))
            } else {
                alert.addButton(withTitle: NSLocalizedString("ok", comment: ""))
            }
            let modalResult = alert.runModal()
            if quit{
                switch modalResult {
                case .OK:
                    exit(0)
                default:
                    exit(0)
                }
            }
        }
    }
    
    // FIXME: a dynamic alert view can be created mutiple alertviews are not required
    func showAlertOkCancel(key: String, header: String, body: String, completion: (Bool) -> Void) {
        //KEEP
        //g_functionJCode = 144
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let alert = NSAlert()
        alert.messageText = header
        alert.informativeText = body
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Yes")
        alert.addButton(withTitle: "No")
        alert.icon = NSImage (named: NSImage.cautionName)
        completion(alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn)
    }
    
    func showStmInstallationOkCancel(key: String, header: String, body: String, completion: (Bool) -> Void) {
        //g_functionJCode = 145
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let alert = NSAlert()
        alert.messageText = header
        alert.informativeText = body
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Cancel")
        alert.addButton(withTitle: "Ok")
        alert.icon = NSImage (named: NSImage.cautionName)
        completion(alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn)
    }
    
    func showStmInstallationOk(key: String, header: String, body: String, completion: (Bool) -> Void) {
        //g_functionJCode = 145
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let alert = NSAlert()
        alert.messageText = header
        alert.informativeText = body
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Ok")
        alert.icon = NSImage (named: NSImage.cautionName)
        completion(alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn)
    }
    
    func showAlertWithCompletion(key: String, header: String, body: String, completion: (Bool) -> Void) {
        //g_functionJCode = 146
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let alert = NSAlert()
        alert.messageText = header
        alert.informativeText = body
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Continue Installation")
        alert.icon = NSImage (named: NSImage.cautionName)
        completion(alert.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn)
    }
    
    func signOutOrStaySgignIn(result: Bool) {
        //g_functionJCode = 147
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if result == false {
            return
        }
        print("sign out clicked")
        lblLoggedInUserValue.stringValue = "N/A"
        if g_quizFailAttempts > 3 {
            g_quizFailAttempts = 0
            
        }
        g_authenticated = false
        g_upgradeFirmwareTryCount = 0
        checkTxConnectionAndUpdateStatus()
        moveUI()
        g_upgradeInProgress = false
        showWindowCloseRedCircleBasedOnUpgradeProgressStatus()
        displayMainView(myView: viewSignIn)
        statusTextField.isHidden = true
        viewErrorMessage.isHidden = true
    }
    
    func stmSoftwareInstallation(result: Bool) {
        //g_functionJCode = 148
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("hey \(result)")
        g_installingDrivers = true;
        if result {
            //            view.window?.close()
            exit(0)
        } else {
            if 1 == 2 //run the installation software embedded in the App
            {
                g_exePath = Bundle.main.path(forResource: "SetupSTM32CubeProgrammer-2.4.0", ofType: "exe")!
                g_exePath = g_exePath.replacingOccurrences(of: " ", with: "\\ ")
                self.addToLogUserFriendly(logText: shell("java -jar \(g_exePath)"))
            }
            if 1 == 1 //download the software
            {
                DispatchQueue.main.async { [self] in
                    displayMainView(myView: viewStmDownload)
                }
//                callPublicApiViaAppCong(keyName: "StmCubeExeMd5", notificationName: "viaAppConfigPublicApiStmMd5Done")
                callPublicApiViaAppCong(keyName: "StmCubeInstallAnywhereMd5", notificationName: "viaAppConfigPublicApiStmMd5Done")
            }
        }
    }
    
    func showAlertOkCancelAction(result: Bool) {
        //KEEP
        //g_functionJCode = 150
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("hey \(result)")
        if result {
            view.window?.close()
        }
    }
    func showAlertEulaOkCancelAction(result: Bool) {
        //KEEP
        //g_functionJCode = 150
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("hey \(result)")
        if result {
            view.window?.close()
            Logger.log("Eula rejected.")
        }
    }
    func WindowWillClose() -> Void {
        //g_functionJCode = 203
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("heyhey 1")
    }
    
    func callApiVerifyHash(responseBytes: [Int]) {
        if 1 == 2  //to be removed. duplicate code
        {
            //g_functionJCode = 206
            Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
            if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
                return
            }
            callApiVerifyHash_Post(responseBytes: responseBytes) {
                [self] (result:String) in
                if result == "INTERNET_ERROR" {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                    return
                } else {
                    if result == "true" {
                        DispatchQueue.main.async {
                            self.progressBar.doubleValue = 45
                        }
                        self.checkMd5()
                    } else if result == "false" {
                        if g_currentView != viewUpdateError {
                            GlobalManager.shared.sendAudit(code: "5000011")
                            let index = EuaMessage.firstIndex { $0.messageCode == "5000011" }
                            addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly)
                            Logger.log(EuaMessage[index!].messageDescription)
                            displayMainView(myView: viewUpdateError)
                        }
                    }
                }
            }
        }
    }
    
    func checkMd5() {
        if (1 == 2) //to be removed
        {
            //g_functionJCode = 207
            Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
            if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
                return
            }
            var data = loadFileFromLocalPath(g_hexPath)
            var md5string = md5(data: data!)
            callApiVerifyMd5(md5string: md5string)
        }
    }
    
    func callApiVerifyMd5(md5string: String) {
        //TOBEREMOVED
        if 1 == 2
        {
            //g_functionJCode = 208
            Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
            if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
                return
            }
            CallApiVerifyMd5_Post(md5string: md5string) {
                [self] (result:String) in
                if result == "INTERNET_ERROR" {
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                    return
                } else {
                    var md5Matched = false
                    if result == md5string {
                        md5Matched = true
                    } else {
                        md5Matched = false
                    }
                    //red-rabbitforce md5 match error
                    //                md5Matched = false
                    if md5Matched {
                        print("md5 matched")
                        DispatchQueue.main.async {
                            self.progressBar.doubleValue = 50
                        }
                        self.GoToDfuMode()
                    } else {
                        GlobalManager.shared.sendAudit(code: "5000013")
                        let index = EuaMessage.firstIndex { $0.messageCode == "5000013" }
                        addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly)
                        Logger.log(EuaMessage[index!].messageDescription)
                        displayMainView(myView: viewUpdateError)
                    }
                }
            }
        }
    }
    
    func cloudNotResponding()
    {
        //g_functionJCode = 209
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        GlobalManager.shared.sendAudit(code: "5000012")
        let index = EuaMessage.firstIndex { $0.messageCode == "5000012" }
        addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messageDescription)
        Logger.log(EuaMessage[index!].messageDescription)
        displayMainView(myView: viewUpdateError)
    }
    
    func loadFileFromLocalPath(_ localFilePath: String) -> Data? {
        //g_functionJCode = 213
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        return try? Data(contentsOf: URL(fileURLWithPath: localFilePath))
    }
    
    func md5(data: Data) -> String {
        //g_functionJCode = 214
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let md5String = Insecure.MD5.hash(data: data).map { String(format: "%02hhx", $0) }.joined()
        return md5String
        //        var context = CC_MD5_CTX()
        //        var digest = Array<UInt8>(repeating:0, count:Int(CC_MD5_DIGEST_LENGTH))
        //        CC_MD5_Init(&context)
        //        CC_MD5_Update(&context, bytes, CC_LONG(bytes.count))
        //        CC_MD5_Final(&digest, &context)
        //        return digest.map { String(format: "%02hhx", $0) }.joined()
    }
    
    func callApiGetUserQuizTracker(quizid: Int, firmwareversion: String, transmitterid: String) {
        //g_functionJCode = 219
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        return callApiGetUserQuizTrackerNew(quizid: Quizzes[0].QuizID, firmwareversion: g_fullVersionFromTx!, transmitterid: g_deviceID!) {
            [self] (result: [StructGetUserQuizTracker]) in
            for foo in GetUserQuizTracker {
                let choiceArray = foo.ChoiceSelectionJSON?.replacingOccurrences(of: "ChoiceID:", with: "").replacingOccurrences(of: "}", with: "").replacingOccurrences(of: "{", with: "").replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").components(separatedBy: ",")
                for choiceId in choiceArray! {
                    if choiceId == ""{
                        return
                    }
                    let questionId = self.getQuestionIdFromChoiceId(choiceId:Int(choiceId)!)
                    let questionTypeId = self.getQuestionTypeIdFromChoiceId(choiceId:Int(choiceId)!)
                    self.updateQuizChoicesUsingQuestionIdAndChoiceId(questionId: questionId, choiceId: Int(choiceId)!, questionTypeId: questionTypeId)
                }
            }
            DispatchQueue.main.async {
                self.displayCurrentQuizQuestionAndAnswers()
            }
        }
    }
    
    func getQuestionIdFromChoiceId(choiceId: Int) -> Int {
        //g_functionJCode = 220
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var resultQuestionId = 0
        for foo in Quizzes[0].QuizQuestions {
            resultQuestionId = foo.QuestionID
            for bar in foo.QuizChoices {
                if bar.ChoiceID == choiceId {
                    return resultQuestionId
                }
            }
        }
        return resultQuestionId
    }
    
    func getQuestionTypeIdFromChoiceId(choiceId: Int) -> Int {
        
        var resultQuestionTypeId = 0
        for foo in Quizzes[0].QuizQuestions {
            resultQuestionTypeId = foo.QuestionTypeId
            for bar in foo.QuizChoices {
                if bar.ChoiceID == choiceId {
                    return resultQuestionTypeId
                }
            }
        }
        return resultQuestionTypeId
    }
    
    func makeSureChoicesAreEnabled() {
        //g_functionJCode = 221
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        DispatchQueue.main.async { [self] in
            quizAnswer1.isEnabled = true
            quizAnswer2.isEnabled = true
            quizAnswer3.isEnabled = true
            quizAnswer4.isEnabled = true
            quizAnswer5.isEnabled = true
        }
    }
    
    func enableDisableNavigationButtonsDuringOrAfterUpgradeProcess() {
        //g_functionJCode = 223
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if g_upgradeInProgress  {
            btReviewChanges.isEnabled = false
            btReviewChanges.isHidden = true
            
            btViewHistory.isEnabled = false
            btNeedHelp.isEnabled = false
            btSignOut.isEnabled = false
        } else {
            btReviewChanges.isEnabled = true
            btReviewChanges.isHidden = false
            
            btViewHistory.isEnabled = true
            btNeedHelp.isEnabled = true
            btSignOut.isEnabled = true
        }
    }
    
    func signout() {
        //g_functionJCode = 227
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        showAlertOkCancel(key: "mykey", header: "Eversense Upgrade", body: "Are you sure you want to sign out? \nNote: Any progress on a quiz will be saved.", completion: signOutOrStaySgignIn(result:))
    }
    
    func getHost() -> String {
        //KEEP
        //g_functionJCode = 229
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var host:String! = (hostAuthenticationUrl?.replacingOccurrences(of: "https://", with: ""))!
        host = host.replacingOccurrences(of: "http://", with: "")
        host = host.replacingOccurrences(of: "https://", with: "")
        host = host.replacingOccurrences(of: "/", with: "")
        host = host.replacingOccurrences(of: "/CGMUploaderApi", with: "")
        return host
    }
    
    @objc func serialPortsWereConnected(_ notification: Notification) {
        //g_functionJCode = 230
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if let userInfo = notification.userInfo {
            let connectedPorts = userInfo[ORSConnectedSerialPortsKey] as! [ORSSerialPort]
            print("Ports were connected: \(connectedPorts)")
            //            self.postUserNotificationForConnectedPorts(connectedPorts)
        }
    }
    
    @objc func serialPortsWereDisconnected(_ notification: Notification) {
        //g_functionJCode = 231
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if let userInfo = notification.userInfo {
            let disconnectedPorts: [ORSSerialPort] = userInfo[ORSDisconnectedSerialPortsKey] as! [ORSSerialPort]
            print("Ports were disconnected: \(disconnectedPorts)")
            //            self.postUserNotificationForDisconnectedPorts(disconnectedPorts)
        }
    }
        
    // FIXME: Sting?
    func addToLogUserFriendly(logText: String!) {
        //g_functionJCode = 234
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if userFriendlyLogText
        {
            if lastPrint != logText
            {
                DispatchQueue.main.async {
                    g_logTextView?.textStorage?.mutableString.append(logText)
                    g_logTextView?.scrollToEndOfDocument(self)
                }
                lastPrint = logText
            }
        }
    }
    
    func getKey() ->Int {
        //g_functionJCode = 236
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if g_deviceIDFromTx == nil {
            return 0
        } else {
            var txid = Int(g_deviceIDFromTx!)
            var modelno = Int(g_modelNumber!)
            var versionno = Int(g_firmwareVersion!)
            var result = txid! ^ modelno! ^ versionno!
            return result
        }
    }
    
    func preloadApiCalls() {
        //KEEP
        //g_functionJCode = 239
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        DispatchQueue.main.async {
            self.statusTextField.isHidden = true
        }
        if g_internet == false
        {
            statusTextField.isHidden = false
            DispatchQueue.main.async { [self] in
                let index = EuaMessage.firstIndex { $0.messageCode == "5000025" }
                if (index != nil)
                {
                    self.addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly)
                    Logger.log(EuaMessage[index!].messageDescription)
                }
                else
                {
//                    self.addAlertView(headerPrimaryText: "Notification", message: "Internet Connection Not Available")
                    Logger.log("Internet Connection Not Available")
                    showAlertNoInternet(quit:true)
//                    showAlert(header: "Eversense Upgrade App", body: "Internet Connection Not Available", quit: true)
//                    let index = EuaMessage.firstIndex { $0.messageCode == "5000025" }
//                    showAlert(auditCode: "Internet Connection Not Available")
//                    addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly, isHeaderSecondaryHidden: true)

                }
            }
            return
        }
        if g_preloadedApiCalls == false {
            DispatchQueue.main.async {
                self.statusTextField.isHidden = true
            }
            self.callApiGetForgotPasswordLink(env: ENV!)
            getTxIdAndFirmWareVersionFromUsbTx()
            callApiGetEulaPathAndVersion(env: ENV!)
            g_preloadedApiCalls = true
        }
    }
    
    func convertToDictionary(text: String) -> [String: String]? {
        //KEEP
        //g_functionJCode = 240
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
        }
        return nil
    }
    
    func setAppUserDefault(key: String, value: String) {
        //KEEP
        //g_functionJCode = 241
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        Logger.log("Set userdefault key: \(key) | value: \(value)")
        getAppUserDefaultFromFileToDictionary()
        AppUserDefault[key]=value
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(AppUserDefault) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                writeToAppUserDefaultFile(text: jsonString)
            }
        }
    }
    
    func getAppUserDefaultFromFileToDictionary() {
        //KEEP
        //g_functionJCode = 242
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var txt = readFromAppUserDefault()
        if ((txt != "") && (txt != "\n")) {
            AppUserDefault = convertToDictionary(text: txt)!
        }
    }
    
    func getAppUserDefault(key: String) -> String {
        //KEEP
        //g_functionJCode = 243
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        Logger.log("get userdefault key: \(key)")

        var txt = readFromAppUserDefault()
        Logger.log("appuserdefault is \(txt)")

        var foobar = convertToDictionary(text: txt)

        if foobar == nil {
            return ""
        }
        if foobar![key] == nil {
            return ""
        }
        Logger.log("get userdefault value: \(foobar![key]! as! String)")
        return foobar![key]! as! String
    }
    
    public func getBuildDate() ->String  {
        //KEEP
        //g_functionJCode = 244
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if let executablePath = Bundle.main.executablePath,
           let attributes = try? FileManager.default.attributesOfItem(atPath: executablePath),
           let date = attributes[.creationDate] as? Date {
            return String(date.timeIntervalSince1970)
        }
        return String(Date().timeIntervalSince1970)
    }
    
    func beautify(foo: NSButton)  {
        //KEEP
        //g_functionJCode = 245
        //do not log beautify
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let myAttribute = [ NSAttributedString.Key.foregroundColor: NSColor.white ]
        let myAttrString = NSAttributedString(string: foo.title, attributes: myAttribute)
        foo.attributedTitle = myAttrString
    }
    
    func viewDidLoadAfterSTMInstallation() {
        //KEEP
        //g_functionJCode = 246
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        //      Bundle.setLanguage("fr")
        print("hey \(NSLocalizedString("transmitter_connected", comment: ""))")
        if 1 == 2 //temporarily remove eula accepted version to test
        {
            defaults!.removeObject(forKey: "EulaAcceptedVersion")
        }
        
        currentQuizQuestionIndex = 0
        DispatchQueue.main.async {
            if self.progressBar != nil  {
                self.progressBar.minValue = 0
                self.progressBar.maxValue = 100
                self.progressBar.doubleValue = 0
                self.progressBar.alphaValue = 1
                self.progressBar.wantsLayer = true
            }
            self.viewJavaDownload.isHidden = true
            self.viewStmDownload.isHidden = true
            self.viewNewVersionDownload.isHidden = true
        }
        preloadApiCalls()
    }
    
    @objc func viaAppConfigPublicApiStmMd5DoneNotified(notification: NSNotification) {
        //g_functionJCode = 248
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("viaAppConfigPublicApiStmMd5DoneNotified!")
//        callPublicApiViaAppCong(keyName: "STMCubeExeUrl", notificationName: "viaAppConfigPublicApiGetStmDownloadUrlDone")
        callPublicApiViaAppCong(keyName: "STMCubeInstallAnywhereUrl", notificationName: "viaAppConfigPublicApiGetStmDownloadUrlDone")
    }
    
    @objc func viaAppConfigPublicApiGetStmDownloadUrlDoneNotified(notification: NSNotification) {
        //g_functionJCode = 250
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("viaAppConfigPublicApiGetStmDownloadUrlDoneNotified!")
        var url = URL(string: g_stmDownloadUrl!)
        
        //no need to check java anymore
        SoftwareDownload(url! as NSObject).download(url: url!)
        
//        if isJavaAlreadyInstalled() {
//            SoftwareDownload(url! as NSObject).download(url: url!)
//        } else {
//            showAlert(header: "Eversense Upgrade", body: "Java needs to be pre-installed first.",quit: true)
//        }
    }
    
    @objc func stmDownloadProgress(notification: NSNotification) {
        //g_functionJCode = 302
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("stm progress post received!")
        if let dict = notification.object! as! NSDictionary? {
            for (key,value) in dict {
                DispatchQueue.main.async { [self] in
                    if key as! String == "transferRate" {
                        lblStmDownloadTransferRate.stringValue = value as! String
                    }
                    if key as! String == "eta" {
                        lblStmDownloadEta.stringValue = value as! String
                    }
                    if key as! String == "percentDone" {
                        stmProgressIndicator.doubleValue = Double(value as! String)!
                    }
                }
            }
        }
    }

    @objc func stmDownloadCompletion(notification: NSNotification) {
        //g_functionJCode = 304
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        DispatchQueue.main.async {
            self.stmProgressIndicator.doubleValue = 100
            self.lblStmDownloadEta.stringValue = "0 Second"
        }
        if let dict = notification.object! as! NSDictionary? {
            for (key,value) in dict {
                if key as! String == "path" {
                    print("value is \(value as! String)")
                    g_stm32CubeSoftwarePath = value as! String
                    print("g_stm32CubeSoftwarePath is \(g_stm32CubeSoftwarePath)")
                    var data = loadFileFromLocalPath(g_stm32CubeSoftwarePath)
                    var md5string = md5(data: data!)
                    if (md5string == g_stmDownloadMd5) {
                        
                        //no need java anymore to install cubeprogram
//                        self.addToLogUserFriendly(logText: shell("open '\(g_stm32CubeSoftwarePath)'"))
                        
//                        self.addToLogUserFriendly(logText: shell("java -jar '\(g_stm32CubeSoftwarePath)'"))
//                        self.addToLogUserFriendly(logText: shell("open '\(g_stm32CubeSoftwarePath)'"))
//                        g_stm32CubeSoftwarePath = "/Users/tinlatt/Library/Application Support/com.senseonics.EversenseUpgrade/SetupSTM32CubeProgrammer-2.15.0"
                        
                        
//                        self.addToLogUserFriendly(logText: shell("unzip -o '\(g_stm32CubeSoftwarePath)' -d '\(g_directoryURL!)'"))
//                        try! self.safeShell("unzip -o '\(g_stm32CubeSoftwarePath)' -d '/Users/tinlatt/Library/Application Support/com.senseonics.EversenseUpgrade/'")
                        
                        try! self.safeShell("unzip -o '\(g_stm32CubeSoftwarePath)' -d '\(g_directoryURL.absoluteString.replacingOccurrences(of: "file://", with: "").replacingOccurrences(of: "%20", with: " "))'")
                        
//                        self.addToLogUserFriendly(logText: shellNew("open '/Users/tinlatt/Library/Application Support/com.senseonics.EversenseUpgrade/stm2140-and-jre/stm/en.stm32cubeprg-mac-v2-14-0/SetupSTM32CubeProgrammer-2.14.0'"))
//                        self.addToLogUserFriendly(logText: shell(g_directoryURL!+"")
                        sleep(5)

                        self.addToLogUserFriendly(logText: shell("open '\(g_stm32CubeSoftwarePath.replacingOccurrences(of: ".zip", with: "")+".app")'"))
                        
                        while (true)
                        {
                            if 1 == 1 // checking if cube installation was successful or not
                            {
                                Logger.log("TX_LOG_COMMAND: "+"/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -version")
                                var isCubeInstalled =  shell("/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -version")
                                Logger.log("TX_LOG_OUTPUT: "+isCubeInstalled)
                                if isCubeInstalled.lowercased().contains("stm32cubeprogrammer version") {
                                    //Cube was really installed
                                    if 1 == 2 //ask the user to restart
                                    {
                                        DispatchQueue.main.async { [self] in
                                            showAlert(header: "Eversense Upgrade", body: "Installation is all done. Please restart your computer.",quit: true)
                                        }
                                    }
                                    if 1 == 1 //proceed to showing the app because cube is already installed
                                    {
                                        if g_internet{
                                            DispatchQueue.main.async { [self] in
                                                viewSignIn.isHidden = false
                                                viewEula.isHidden = false
                                            }
                                        }
                                        let executableURL = URL(fileURLWithPath: "/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI")
                                        // FIXME: USE Try?
                                        try! Process.run(executableURL,
                                                         arguments: ["-c port=usb1"],
                                                         terminationHandler: nil)
                                        viewDidLoadAfterSTMInstallation()
                                        break
                                    }
                                } else {
                                    //Cube installation must have been interrupted in the middle
//                                    exit(0)
                                    //Cube installation on going
                                    sleep(1)

                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.showAlert(header: "Eversense Upgrade", body: "MD5 Checksum doesn't match for STM Cube Download.",quit: true)
                        }
                    }
                }
            }
        }
    }
    
    func getCpuType() {
        //KEEP
        //g_functionJCode = 305
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var systeminfo = utsname()
        uname(&systeminfo)
        let machine = withUnsafeBytes(of: &systeminfo.machine) {bufPtr->String in
            let data = Data(bufPtr)
            if let lastIndex = data.lastIndex(where: {$0 != 0}) {
                return String(data: data[0...lastIndex], encoding: .isoLatin1)!
            } else {
                return String(data: data, encoding: .isoLatin1)!
            }
        }
        print(machine)
        if machine == "x86_64" {
            g_cpuType = "intel"
        } else {
            g_cpuType = "apple"
        }
        print(g_cpuType)
    }
    
    func getValue(forKey key: String) -> String? {
        //KEEP
        return Bundle.main.infoDictionary?[key] as? String
    }
    
    func writeLocalLog(text: String)
    {
        //g_functionJCode = 308
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if 1 == 1 //write json string to a text file
        {
            let fileURL = g_directoryURL.appendingPathComponent("EversenseUpgradeLog.txt")
            //writing
            do {
                try text.write(to: fileURL, atomically: false, encoding: .utf8)
            }
            catch {/* error handling here */}
        }
    }
    
    func doesTheUserHasLowerStmVersionInstalled(currentlyInstalledStmCubeVersion:String, stmVersionFromCloud:String ) -> Bool
    {
        var currentArray = currentlyInstalledStmCubeVersion.components(separatedBy: ".")
        for (index,bar) in currentArray.enumerated()
        {
            if (bar.count == 1)
            {
                currentArray[index] = "0"+bar
            }
        }
//        var current = currentlyInstalledStmCubeVersion.replacingOccurrences(of: ".", with: "")
        var current = currentArray.joined(separator:"")

        var fills = 10 - current.count
        for i in 0..<fills
        {
            current = current + "0"
        }
        
        
        var cloudArray = stmVersionFromCloud.components(separatedBy: ".")
        for (index,bar) in cloudArray.enumerated()
        {
            if (bar.count == 1)
            {
                cloudArray[index] = "0"+bar
            }
        }
//        var cloud = stmVersionFromCloud.replacingOccurrences(of: ".", with: "")
        var cloud = cloudArray.joined(separator:"")

        fills = 10 - cloud.count
        for i in 0..<fills
        {
            cloud = cloud + "0"
        }
        
        if (Double(current)! < Double(cloud)!)
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("closed ??")
        
        
        //for screens on or after welcome screen
        NotificationCenter.default.post(name: Notification.Name("CloseTheApp"), object: nil)

        //screens b4 welcome screen
//        wantToCloseApp()

//        addLogoutAlertView(headerPrimaryText: "Notification", headerSecondaryText: "", message: "Are you sure you want to close the application?", isHeaderSecondaryHidden: true, isSecondaryButtonHidden: false, textAlignment: .center, firstButtonText: "Yes",secondButtonText: "No", buttonColor: NSColor(named: "appColor"))

        return false
    }
    
    @objc func installCubeIfNotInstalled() {
        
        if !(g_internet)
        {
            return
        }
        
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        DispatchQueue.main.async { [self] in
            viewSignIn.isHidden = true
            viewEula.isHidden = true
        }
        
        Logger.log("TX_LOG_COMMAND: "+"/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -version")
        var isCubeInstalled =  shell("/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -version")
        Logger.log("TX_LOG_OUTPUT: "+isCubeInstalled)
        
        if isCubeInstalled.lowercased().contains("stm32cubeprogrammer version") {
            print("cube already installed")
            
            var currentlyInstalledStmCubeVersion = Helper.getStmCubeVersion()
            
            //red-rabbit
//            currentlyInstalledStmCubeVersion = "2.17.0"
            
            if currentlyInstalledStmCubeVersion == g_MacStmVersionFromCloud
            {
                if g_internet {
                    DispatchQueue.main.async { [weak self] in
                        self?.viewSignIn.isHidden = false
                        self?.viewEula.isHidden = false
                    }
                }
                viewDidLoadAfterSTMInstallation()
            }
            else if (doesTheUserHasLowerStmVersionInstalled(currentlyInstalledStmCubeVersion: currentlyInstalledStmCubeVersion, stmVersionFromCloud: g_MacStmVersionFromCloud))
            {
                print("installing cube")
                DispatchQueue.main.async { [self] in
                    displayMainView(myView: viewStmDownload)
                    showStmInstallationOkCancel(key: "mykey", header: "Eversense Upgrade", body: "Eversense Upgrade App requires STM32 Cube Program pre-installed. It will be installed now. It will take a couple of minutes to download the software. Then, follow the prompts to install it.", completion: stmSoftwareInstallation(result:))
                }
            }
            else if g_MacValidStmVersionsFromCloud.contains(currentlyInstalledStmCubeVersion)
            {
                //your stm version is in the list, it is good.
                viewDidLoadAfterSTMInstallation()
            }
            else
            {
                // your stm version is not in the list, but it has higher version, so we try our luck and install it
                g_installedStmHasHigherVersion = true
                viewDidLoadAfterSTMInstallation()
                if 1 == 2 //let's not show this message, let the user try it, if it doesn't work, fail it.
                {
                    DispatchQueue.main.async {
                        let index = EuaMessage.firstIndex { $0.messageCode == "7000017" }
                        self.showStmInstallationOk(key: "mykey", header: "Eversense Upgrade", body: EuaMessage[index!].messagerDescriptionUserFriendly.replacingOccurrences(of: "XXXX", with: g_MacStmVersionFromCloud).replacingOccurrences(of: "YYYY", with: currentlyInstalledStmCubeVersion), completion: self.stmSoftwareInstallation(result:))
                        Logger.log(EuaMessage[index!].messageDescription)
                        return
                    }
                }
            }
            
        }
        else
        {
            print("installing cube")
            DispatchQueue.main.async { [self] in
                displayMainView(myView: viewStmDownload)
                showStmInstallationOkCancel(key: "mykey", header: "Eversense Upgrade", body: "Eversense Upgrade App requires STM32 Cube Program pre-installed. It will be installed now. It will take a couple of minutes to download the software. Then, follow the prompts to install it.", completion: stmSoftwareInstallation(result:))
            }
        }
        
    }
    
    func startDisplayingResumeQuizQuestions() {
        //g_functionJCode = 316
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        currentQuizQuestionIndex = 0
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        DispatchQueue.main.async { [self] in
            viewRestartQuiz.isHidden = true
        }
        self.callApiGetUserQuizTracker(quizid:Quizzes[0].QuizID,firmwareversion:g_fullVersionFromTx!,transmitterid:g_deviceID!)
    }

    func LoginFailed() {
        //KEEP
        //g_functionJCode = 321
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        DispatchQueue.main.async { [self] in
            //            showStatusTextField(auditCode: "5020", lines: 5, x: 372, y: 380, width: 300, height: 60)
            
            
            //            if LoginAttemptError == nil
            //            {
            //                showErrorMessageLoginScreen(auditCode: "5000020")
            //                let index = EuaMessage.firstIndex { $0.messageCode == "5000020" }
            //                Logger.log(EuaMessage[index!].messageDescription)
            //
            //            }
            //            else
            //            {
            var loginErrorCode=""
//            if (LoginAttemptError == nil)
//            {
//                loginErrorCode = "5000020"
//            }
//            else
            var remainingLoginAttempts=""
            var loginErrorMessage=""
            if (LoginAttemptError == nil)
            {
                return
            }
            if (LoginAttemptError!.errorDescription.lowercased().contains("remainingattempt"))
            {
                remainingLoginAttempts = String(LoginAttemptError!.errorDescription.suffix(1))
                let index = EuaMessage.firstIndex { $0.messageCode == "5000065" }
                loginErrorMessage = EuaMessage[index!].messagerDescriptionUserFriendly.replacingOccurrences(of: "XXXX", with: remainingLoginAttempts)
                showErrorMessageLoginScreen(auditCode: "5000065",auditText: loginErrorMessage)
                Logger.log("Login Failed: " + loginErrorMessage)
            }
            if (LoginAttemptError!.errorDescription.lowercased().contains("is locked out"))
            {
                loginErrorCode = "5000061"
                showErrorMessageLoginScreen(auditCode: loginErrorCode)
                let index = EuaMessage.firstIndex { $0.messageCode == loginErrorCode }
                Logger.log(EuaMessage[index!].messageDescription)
                Logger.log("Login Failed: " + LoginAttemptError!.errorDescription)
            }
            if (LoginAttemptError!.errorDescription.lowercased().contains("invalid username"))
            {
                loginErrorCode = "5000066"
                showErrorMessageLoginScreen(auditCode: loginErrorCode)
                let index = EuaMessage.firstIndex { $0.messageCode == loginErrorCode }
                Logger.log(EuaMessage[index!].messageDescription)
                Logger.log("Login Failed: " + LoginAttemptError!.errorDescription)
            }
            if (LoginAttemptError!.errorDescription.lowercased().contains("user is inactive"))
            {
                loginErrorCode = "5000067"
                showErrorMessageLoginScreen(auditCode: loginErrorCode)
                let index = EuaMessage.firstIndex { $0.messageCode == loginErrorCode }
                Logger.log(EuaMessage[index!].messageDescription)
                Logger.log("Login Failed: " + LoginAttemptError!.errorDescription)
            }
            
            
            
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        DispatchQueue.main.async { [self] in
            displayMainView(myView: viewSignIn)
            dispatchGroup.leave()
        }
    }
    
    func updateAppVersionFromBundle() {
        //KEEP
        //g_functionJCode = 322
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var appVersionMac:String? = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let title = "Upgrade App Version: "
        let build = dictionary["CFBundleVersion"] as? String ?? ""
        defaults!.set(version, forKey: "currentAppVersion")
        DispatchQueue.main.async {
            let font = NSFont(name: "HelveticaNeue-Medium", size: 12.0)
            let attributesForTitle: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: NSColor(named: "grey"),
            ]
            let attributesForVersion: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: NSColor(named: "blue"),
            ]
            let attributedTitle = NSMutableAttributedString(string: title)
            attributedTitle.addAttributes(attributesForTitle, range: NSRange(location: 0, length: title.count))
            let attributedVersion = NSMutableAttributedString(string: "v\(version)")
            attributedVersion.addAttributes(attributesForVersion, range: NSRange(location: 0, length: version.count+1))
            attributedTitle.append(attributedVersion)
            self.textFieldAppVersion.attributedStringValue = attributedTitle
        }
    }
    
    func checkAppVersion()
    {
        //KEEP
        //g_functionJCode = 323
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var showNewVersion:Bool = false
        let dictionary = Bundle.main.infoDictionary!
        let currentAppVersion = dictionary["CFBundleShortVersionString"] as! String

        
            if currentAppVersion != currentAppVersionFromCloud! {
                print("clould has different app version")
                showNewVersion = true
            } else {
                print("same app version")
                if 1 == 1 //continue login success
                {
                    LoginSuccess()
                    g_authenticated = true
                    g_upgradeFirmwareTryCount = 0
                    DispatchQueue.main.async { [weak self] in
                        if g_statusTextReason == "5000020" {
                            //                        statusTextField.isHidden=true
                            self?.viewErrorMessage.isHidden = true
                        }
                    }
                }
                
            }
        
        if showNewVersion {
            print("show new version")
            DispatchQueue.main.async { [self] in
                showAlertWithCompletion(key: "mykey", header: "Eversense Upgrade", body: "There is a new version of Eversense Upgrade (v\(currentAppVersionFromCloud!)) software available.", completion: newVersionSoftwareInstallation(result:))
            }
        }
    }
    
    func checkEula() {
        //KEEP
        //g_functionJCode = 324
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var showEula:Bool = false
        //check if the app is a new install
        let recordedBuildDate = getAppUserDefault(key: "builddate")
        let currentBuildDate = getBuildDate()
        Logger.log("recorded build date:\(recordedBuildDate) | current build date: \(currentBuildDate)")
        if currentBuildDate != recordedBuildDate {
            //            this is a new install
            showEula = true
            Logger.log("re install")
            setAppUserDefault(key: "EulaAcceptedVersion", value: "")
            setAppUserDefault(key: "builddate", value: currentBuildDate)
        } else {
            //            this is existing install
            Logger.log("existing install or very first time install")
            let currentlyAcceptedVersion = getAppUserDefault(key: "EulaAcceptedVersion")
            Logger.log("currently accepted version \(currentlyAcceptedVersion)")
            if currentlyAcceptedVersion == "" {
                print("eula never accepted")
                Logger.log("eula never accepted")
                showEula = true
            } else if currentlyAcceptedVersion != eulaVersionFromcloud {
                print("eula accepted before, but clould has newer version")
                Logger.log("eula accepted before, but clould has newer version")
                showEula = true
            } else {
                print("same eula version accepted before")
                Logger.log("same eula version accepted before")
            }
        }
        Logger.log("showEula is \(showEula)")
        if showEula {
            print("show eula")
            initEulaWebViewAndDisplay()
        } else {
            displayMainView(myView: viewSignIn)
            //            self.CallApiGetUserFirmwareInformation()
            //            self.CallApiGetOtwFirmwareInformation()
        }
    }
    
    func LoginSuccess(){
        GlobalManager.shared.uploadLogFile()
        //KEEP
        //g_functionJCode = 325
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        self.CallApiGetReviewChanges()
        self.CallApiGetUserFirmwareInformation()
    }
    
    func saveAndContinueLater() {
        //g_functionJCode = 328
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("save and continue clicked")
        GlobalManager.shared.sendAudit(code: "5000052",  viaStateId: 3)
        let index = EuaMessage.firstIndex { $0.messageCode == "5000052" }
        Logger.log(EuaMessage[index!].messageDescription)
            
        CallApiGetOtwFirmwareInformation(changeUi: false)
        currentQuizQuestionIndex = 0
        getChoiceJsonAndCallApiSetUserQuizTracker(continueGetApi: false)
        displayMainView(myView: viewRestartQuiz)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        //KEEP
        //g_functionJCode = 329
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func initEulaWebViewAndDisplay() {
        //KEEP
        //g_functionJCode = 335
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let url = URL(string: eulaPathFromCloud!)!
        DispatchQueue.main.async { [self] in
            eulaWebView.load(URLRequest(url: url))
            eulaWebView.allowsBackForwardNavigationGestures = true
            self.eulaWebView.layer?.backgroundColor = NSColor.clear.cgColor
            eulaWebView.layer?.borderColor = NSColor.init(displayP3Red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1).cgColor
            eulaWebView.layer?.borderWidth = 1
            eulaWebView.layer?.cornerRadius = 6
            if #available(macOS 11.0, *) {
                eulaWebView.pageZoom = 0.5
            } else {
                // Fallback on earlier versions
            }
            self.btAccept_ViewEula.setButton(backgroundColor: NSColor(named: "blue")!)
            self.btExit_ViewEula.setButton(backgroundColor: NSColor(named: "appColor") ?? .white, isBordered: true)
        }
        displayMainView(myView: viewEula)
        if 1 == 2 {
            DispatchQueue.main.async {
                if (OtwFirmwareInfo?.result.count)! > 0 {
                    self.viewWelcomeAfterSignIn.isHidden = false
                    self.lbNoInstruction.isHidden = true
                } else {
                    self.lbNoInstruction.isHidden=false
                }
                self.btViewHistory.isHidden = false
                self.lbYourEversenseCGMSystem.isHidden = false
                self.lbActiveTransmitterSn.isHidden = false
                self.lbActiveTransmitterSnValue.isHidden = false
                self.lbCurrentTransmitterVer.isHidden = false
                self.lbCurrentTransmitterVerValue.isHidden = false
                self.lbEversenseMobileAppSoftwareVer.isHidden = false
                self.lbEversenseMobileAppSoftwareVerValue.isHidden = false
                self.lblLoggedInUser.isHidden = false
                self.lblLoggedInUserValue.isHidden = false
                self.lbYourEversenseCGMSystem.isHidden = false
                self.btSignOut.isHidden = false
                self.viewSignIn.isHidden = true
                self.loginErrorColorWell.isHidden = true
                self.viewQuizQuestion.isHidden = true
            }
        }
    }
    
    func getIncorrectQuestionIdsFromAudit() {
        //g_functionJCode = 336
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        g_incorrectQuestionIds.removeAll()
        for foo in AuditHistory {
            if foo.FailureDescription == "Quiz Result - PASS" {
                return
            }
            if foo.FailureDescription == "Quiz Result - FAIL" {
                var incorrectChoiceSelectionJson = foo.IncorrectChoiceSelectionJSON
                let jsonData = Data(incorrectChoiceSelectionJson!.utf8)
                let decoder = JSONDecoder()
                do {
                    QuizResult = try decoder.decode([StructQuizResult].self, from: jsonData)
                    for foo in QuizResult[0].wrongQuizChoices! {
                        g_incorrectQuestionIds.append(foo.questionID)
                    }
                    for foo in QuizResult[0].missingMulticheckboxQuizChoices! {
                        g_incorrectQuestionIds.append(foo.questionID)
                    }
                } catch {
                    Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
                }
                return
            }
        }
    }
    
    func createPDF(markup: String) {
        //g_functionJCode = 337
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let printOpts: [NSPrintInfo.AttributeKey: Any] = [NSPrintInfo.AttributeKey.jobDisposition: NSPrintInfo.JobDisposition.save, NSPrintInfo.AttributeKey.jobSavingURL: g_directoryURL ?? ""]
        let printInfo = NSPrintInfo(dictionary: printOpts)
        printInfo.topMargin = 20.0
        printInfo.leftMargin = 20.0
        printInfo.rightMargin = 20.0
        printInfo.bottomMargin = 20.0
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 570, height: 740))
        if let htmlData = markup.data(using: String.Encoding.utf8) {
            if let attrStr = NSAttributedString(html: htmlData, documentAttributes: nil) {
                let frameRect = NSRect(x: 0, y: 0, width: 570, height: 740)
                let textField = NSTextField(frame: frameRect)
                textField.attributedStringValue = attrStr
                view.addSubview(textField)
                let printOperation = NSPrintOperation(view: view, printInfo: printInfo)
                printOperation.showsPrintPanel = false
                printOperation.showsProgressPanel = false
                printOperation.run()
            }
        }
    }
    
    func getDirectoryUrl() {
        //KEEP
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        //  Create subdirectory
        let directoryURL = appSupportURL.appendingPathComponent("com.senseonics.EversenseUpgrade")
        g_directoryURL = directoryURL
    }
    
    func createFolderInsideApplicationSupportIfNotExist() {
        //KEEP
        //g_functionJCode = 345
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        do
        {
            //  Find Application Support directory
            let fileManager = FileManager.default
            let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
            //  Create subdirectory
            let directoryURL = appSupportURL.appendingPathComponent("com.senseonics.EversenseUpgrade")
            g_directoryURL = directoryURL
//            g_appUserDefaultUrl = Bundle.main.url(forResource: "AppUserDefault", withExtension: "txt")
//            g_appUserDefaultUrl = directoryURL.appending(path: "AppUserDefault.txt")
            g_appUserDefaultUrl = directoryURL.appendingPathComponent("AppUserDefault.txt")
            Logger.log("g_appUserDefaultUrl is \(g_appUserDefaultUrl)")
            try fileManager.createDirectory (at: directoryURL, withIntermediateDirectories: true, attributes: nil)
            //          let documentURL = directoryURL.appendingPathComponent ("log.txt")
            //          try "log created.".write(to: documentURL, atomically: true, encoding: .utf8)
            Logger.log("Eversense Upgrade App Started")
        } catch {
            print("An error occured")
        }
    }
    
    func isItPreviouslySelected_FromApi(choiceID: Int) -> Bool {
        //g_functionJCode = 346
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if g_GetUserQuizTrackerString == nil {
            return false
        }
        print("is it previously selected \(choiceID)")
        if g_GetUserQuizTrackerString!.contains("{ChoiceID:\(choiceID)}") {
            return true
        } else {
            return false
        }
    }
    
    func modifyRadioAndIsSelected(idx: Int, quizButton: NSButton, choice: QuizChoice) -> Bool {
        //g_functionJCode = 402
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var prefix = ["a","b","c","d","e"]
        quizButton.title = prefix[idx-1]+". "+choice.ChoiceText!
        //red-rabbit temporarily show choiceid
        //        quizButton.title = String(choice.ChoiceID) + " " + prefix[idx-1]+". "+choice.ChoiceText!
        quizButton.isHidden = false
        if 1 == 1 // restore previously saved selection
        {
            let prevoiuslySelected:Bool = isItPreviouslySelected_FromApi(choiceID: choice.ChoiceID)
            if prevoiuslySelected {
                DispatchQueue.main.async { [self] in
                    quizAnswerClicked(tag: idx)
                }
                return true
            }
            return false
        }
    }
    
    func updateQuizChoicesUsingQuestionIdAndChoiceId(questionId: Int, choiceId: Int, questionTypeId: Int) {
        //g_functionJCode = 407
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let structQuizChoiceSubmit = StructQuizChoicesSubmit(questionid: questionId, choiceid: choiceId, questiontypeid: questionTypeId)
        for (idx,foo) in QuizChoices.enumerated() {
            if foo.questionid == questionId {
                QuizChoices.remove(at: idx)
            }
        }
        QuizChoices.append(structQuizChoiceSubmit)
    }
    
    func isOneAnswerSelected() -> Bool
    {
        //g_functionJCode = 414
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if ((quizAnswer1.state == .on)||(quizAnswer2.state == .on)||(quizAnswer3.state == .on)||(quizAnswer4.state == .on)||(quizAnswer5.state == .on)) {
            return true
        } else {
            return false
        }
    }
    
    func getChoiceJsonAndCallApiSetUserQuizTracker(continueGetApi: Bool = true) {
        //g_functionJCode = 415
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        
        var choices:[Choice] = []
        choices.append(Choice(choiceID: 3))
        choices.append(Choice(choiceID: 2))
        choices.append(Choice(choiceID: 3))
        
        let quizTracker:QuizTracker = QuizTracker(questionindex: 1, choices: choices)
        
        var choicejson = "["
        for foo in QuizChoices {
            choicejson = choicejson + "{ChoiceID:"+String(foo.choiceid)+"},"
        }
        choicejson = String(choicejson.dropLast())
        choicejson = choicejson + "]"
        return CallApiSetUserQuizTracker(quizid: Quizzes[0].QuizID, firmwareversion: g_fullVersionFromTx!, transmitterid: g_deviceID!, choiceselectionjson: choicejson, continueGetApi: continueGetApi) {
            [self] (result: Bool) in
            if result {
                if continueGetApi {
                    self.callApiGetUserQuizTracker(quizid: Quizzes[0].QuizID, firmwareversion: g_fullVersionFromTx!, transmitterid: g_deviceID!)
                }
            }
        }
        //            callApiSetUserQuizTracker(quizid:Quizzes[0].QuizID,firmwareversion:g_fullVersionFromTx!,transmitterid:g_deviceID!,choiceselectionjson:choicejson,continueGetApi:continueGetApi)
    }
    
    func addtransition(transitionView: NSView, direction: CATransitionSubtype) {
        //KEEP
        // Configure animation
        let transition = CATransition()
        transition.type = .push
        transition.subtype = direction
        transition.duration = 0.4
        transitionView.layer?.add(transition, forKey: kCATransition)
    }
   
}

extension EversenseLoginViewController: SerialPortDataRecievedDelegate {
    func didRecievedData(byteArray: [Int]?, lastDataRecievedOn: CFTimeInterval) {
        guard let byteArray = byteArray else { return }
        self.byteArray = byteArray
        self.lastdatareceivedon = lastDataRecievedOn
    }
    
}
