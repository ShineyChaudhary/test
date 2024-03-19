//
//  EversenseLoginViewIBActions.swift
//  EversenseUpgrade
//
//  Created by Shiney Chaudhary on 20/07/23.
//  Copyright © 2023 senseonics. All rights reserved.
//

import Foundation
import WebKit

extension EversenseLoginViewController: WKNavigationDelegate {
    @IBAction func showIncorrectQuestionsOnlyBtnAdded(_ sender: Any) {
        //g_functionJCode = 103
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if (QuizzesOriginal.count == 0) {
            QuizzesOriginal = Quizzes
        }
        if quizFilterBtn.title.lowercased()=="show incorrect questions only" {
            quizFilterBtn.title = "Show All Questions"
            showIncorrectQuestions()
        } else {
            quizFilterBtn.title = "Show Incorrect Questions Only"
            showAllQuestions()
        }
    }
    
    @IBAction func okBtnFromQuizTooManyAttemptsClicked(_ sender: Any) {
        //g_functionJCode = 104
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        displayMainView(myView: viewWelcomeAfterSignIn)
    }
    
    @IBAction func okBtnFromNoUpdateAvailableViewClicked(_ sender: Any) {
        //g_functionJCode = 106
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        displayMainView(myView: viewWelcomeAfterSignIn)
    }
    
    @IBAction func okBtnFromTxNotActiveClicked(_ sender: Any) {
        //g_functionJCode = 107
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        displayMainView(myView: viewWelcomeAfterSignIn)
    }
    
    @IBAction func reviewChangesCheckClicked(_ sender: Any) {
        //g_functionJCode = 108
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        // Updated code from if else to guard
        guard checkReviewChanges.state == .on else {
            startTransmitterUpdateBtn.isEnabled = false
            return
        }
        startTransmitterUpdateBtn.isEnabled = true
    }
    
//    @IBAction func btnOkFromUpdateErrorClicked(_ sender: Any) {
//        //g_functionJCode = 109
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
//            if updateErrorDescriptionTextField.stringValue.contains("5000014") {
//                return
//            } else {
////                showAlert(auditCode: "5025")
//                let index = EuaMessage.firstIndex { $0.messageCode == "5000025" }
//                addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly, isHeaderSecondaryHidden: true)
//                Logger.log(EuaMessage[index!].messageDescription)
//                return
//            }
//        }
//        else{ if g_statusTextReason == "5000025" {
//            DispatchQueue.main.async { [self] in
//                statusTextField.isHidden = true
//            }
//        }
//        }
//        var code:String = "5000028"
//        if g_upgradeInProgress {
//            code = "5000010"
//        }
//        if ((g_deviceIDFromTx == nil) || (g_deviceIDFromCloud==nil)) {
//            showAlert(auditCode: code)
//            let index = EuaMessage.firstIndex { $0.messageCode == code }
//            Logger.log(EuaMessage[index!].messageDescription)
//            return
//        } else {
//            if g_statusTextReason == code {
//                DispatchQueue.main.async { [self] in
//                    statusTextField.isHidden = true
//                }
//            }
//        }
//        // FIXME: Commented code, can be removed
//        //        if checkInternetConnectionAndDisableOrEnableControls() == false
//        //        {
//        //            return
//        //        }
//        //        enableAllButtons(myView: viewNavigation)
//        //        displayMainView(myView: viewSignIn)
//        //        if g_TxIsPhysicallyConnectedToUsb
//        //        if (statusTextField.stringValue == NSLocalizedString("transmitter_connected", comment: ""))
//        if g_TxIsPhysicallyConnectedToUsb {
//            if g_deviceIDFromTx != g_deviceIDFromCloud {
//                displayMainView(myView: viewTxNotActive)
//                return
//            } else {
//                displayMainView(myView: viewReviewChanges)
//            }
//        } else {
//            getTransmitterInfo()
//        }
//    }
    
    @IBAction func btnOkFromTxIsUpToDateViewClicked(_ sender: Any) {
        //g_functionJCode = 110
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        displayMainView(myView: viewWelcomeAfterSignIn)
    }
    
    @IBAction func viewForgotPasswordBackBtnClicked(_ sender: Any) {
        //g_functionJCode = 111
        tfSendPasswordResetEmail.stringValue = ""
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
//            return
//        }
        addtransition(transitionView: viewForgotPassword, direction: .fromTop)
        viewForgotPassword.isHidden = true
        addtransition(transitionView: viewSignIn, direction: .fromTop)
        viewSignIn.isHidden = false
        
    }
    
    // FIXME: Commented code can be removed if not required
    @IBAction func btSignInClicked(_ sender: Any) {
        print("sign in button clicked")
        if (!(g_internet))
        {
            showAlertNoInternet()
            return
        }

       // to handle the case where the user enters password while the eye is open
       if (buttonPasswordVisibility.state.rawValue == 1)
       {
           tfPasswordSecure.stringValue = tfPassword.stringValue
       }
        
        //g_functionJCode = 113
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")

        // Email and password
        var email = tfEmailNew.stringValue
        var password = (buttonPasswordVisibility.state == .on) ? tfPassword.stringValue : tfPasswordSecure.stringValue
        
 
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            showErrorMessageLoginScreen(auditCode: "5000025")
            let index = EuaMessage.firstIndex { $0.messageCode == "5000025" }
            Logger.log(EuaMessage[index!].messageDescription)
            return
        }
        //red-rabbit ez login, change it back to 1 == 2 when going live
        if 1 == 2 // autofill
        {
            if tfEmailNew.stringValue == "" {
                DispatchQueue.main.async { [self] in
                    tfEmailNew.stringValue = "tin.latt@senseonics.com"
                    tfPasswordSecure.stringValue = "evdonalD@12444"
//                    tfPasswordSecure.stringValue = "evdonalD@123"
                }
                
            }
        }
        if (email == "")
        {
            showErrorMessageLoginScreen(auditCode: "5000038")
            var index = EuaMessage.firstIndex { $0.messageCode == "5000038" }
            if index == nil
            {
                index = EuaMessage.firstIndex { $0.messageCode == "100" }
            }
            Logger.log(EuaMessage[index!].messageDescription.replacingOccurrences(of: "CCCC", with: "5000038"))
            return
        }
        if !(isValidEmail(email)) {
            showErrorMessageLoginScreen(auditCode: "5000026")
            let index = EuaMessage.firstIndex { $0.messageCode == "5000026" }
            Logger.log(EuaMessage[index!].messageDescription)
            return
        }
        if (tfPasswordSecure.stringValue.count == 0)
        {
            showErrorMessageLoginScreen(auditCode: "5000020")
            let index = EuaMessage.firstIndex { $0.messageCode == "5000020" }
            Logger.log(EuaMessage[index!].messageDescription)
            return
        }
        
        return authenticate(email: email, password: password) {
            [self] (result: String) in
            print("got back: \(result)")
            if result == "notoken"
            {
                // self.showAlert(header: "Error", body: "Incorrect email and/or password. Please click OK to try again.")
                LoginFailed()
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.lblLoggedInUserValue.stringValue = self?.tfEmailNew.stringValue ?? ""
                    g_loggedInUser = self?.tfEmailNew.stringValue ?? ""
                }
                g_accessToken = result
                self.callApiGetViaAppVersion()

            }
        }
    }
    
    @IBAction func okBtnQuizSuccessfulClicked(_ sender: Any) {
        //g_functionJCode = 115
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        if 1 == 1 {
            if Quizzes.count == 0 {
                startTransmitterUpdateBtn.title = "Start Transmitter Upgrade"
            } else {
                startTransmitterUpdateBtn.title = "Next"
            }
            callApiGetReviewChangesPath1()
            displayMainView(myView: viewReviewChanges)
        }
        //        startUpgradeProcess()
    }
    
    @IBAction func btSignOutAfterUpgradeClicked(_ sender: Any) {
        //g_functionJCode = 116
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        viewAfterUpgrade.isHidden = true
        viewProgressBar.isHidden = true
        //        signout()
        UiAfterLogIn()
    }
    
    @IBAction func togglePasswordVisibility(_ sender: NSButton) {
        let isPasswordVisible = (sender.state == .on)
        sender.image = isPasswordVisible ? NSImage(named: "eye-show") : NSImage(named: "eye-hide")
        if isPasswordVisible {
            tfPassword.stringValue = tfPasswordSecure.stringValue
            tfPasswordSecure.isHidden = true
            tfPassword.isHidden = false
        } else {
            tfPasswordSecure.stringValue = tfPassword.stringValue
            tfPassword.isHidden = true
            tfPasswordSecure.isHidden = false
        }
    }
    
    func wantToCloseApp()
    {
        addLogoutAlertView(headerPrimaryText: "Notification", headerSecondaryText: "", message: "Are you sure you want to close the application?", isHeaderSecondaryHidden: true, isSecondaryButtonHidden: false, textAlignment: .center, firstButtonText: "Yes",secondButtonText: "No", buttonColor: NSColor(named: "appColor"))
    }
    @IBAction func eulaRejectBtnTapped(_ sender: Any) {
        //g_functionJCode = 124
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("eula rejected")
        wantToCloseApp()
    }
    
    @IBAction func eulaAcceptBtnTapped(_ sender: Any) {
        //g_functionJCode = 125
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("eula accepted")
        
        Logger.log("EULA Accepted.")
            
        //        defaults!.set(eulaVersionFromcloud, forKey: "EulaAcceptedVersion")
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as? String ?? ""
        let currentBuildDate = getBuildDate()

        
        
        setAppUserDefault(key: "builddate", value: currentBuildDate ?? "nil")
        setAppUserDefault(key: "EulaAcceptedVersion", value: eulaVersionFromcloud ?? "nil")
        addtransition(transitionView: viewEula, direction: .fromRight)
        viewEula.isHidden = true
        addtransition(transitionView: viewSignIn, direction: .fromRight)
        viewSignIn.isHidden = false
        
    }
    
    @IBAction func SubmitQuizBtnClicked(_ sender: Any) {
        //g_functionJCode = 222
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        if isOneAnswerSelected() == false {
            DispatchQueue.main.async { [weak self] in
                let index = EuaMessage.firstIndex { $0.messageCode == "5000027" }
                self?.addAlertView(headerPrimaryText: "EversenseUpgrade", message: EuaMessage[index!].messagerDescriptionUserFriendly)
                Logger.log(EuaMessage[index!].messageDescription)
                self?.makeSureChoicesAreEnabled()
            }
            return
        }
        getChoiceJsonAndCallApiSetUserQuizTracker(continueGetApi: false)
        print("quiz submitted")
        var insertedQuestions:[Int]=[]
        var newQuizChoices:[StructQuizChoicesSubmit] = []
        //        for (idx,foo) in QuizChoices.reversed().enumerated()
        for (idx, foo) in QuizChoices.enumerated() {
            let questionId = foo.questionid
            let choiceId = foo.choiceid
            let questionTypeId = foo.questiontypeid
            if insertedQuestions.contains(questionId) {
                //                QuizChoices[idx].include = false
                //                QuizChoices.remove(at: idx)
            } else {
                //                QuizChoices[idx].include = true
                let structQuizChoicesSubmit = StructQuizChoicesSubmit(questionid: questionId, choiceid: choiceId,questiontypeid: questionTypeId)
                newQuizChoices.append(structQuizChoicesSubmit)
                insertedQuestions.append(questionId)
            }
        }
        if 1 == 1 // add all questions to g_correct, remove incorect ones when you get api response
        {
            for foo in newQuizChoices {
                g_correctQuestionIds.append(foo.questionid)
            }
        }
        return callApiSubmitQuiz(newQuizChoices: newQuizChoices) {
            [self] (result: String) in
            let responseString:String = result
            let jsonData = Data(responseString.utf8)
            var incorrectQuestions=""
            let decoder = JSONDecoder()
            do  {
                QuizResult = try decoder.decode([StructQuizResult].self, from: jsonData)
                g_incorrectQuestionIds.removeAll()
                for foo in QuizResult[0].wrongQuizChoices! {
                    g_incorrectQuestionIds.append(foo.questionID)
                    if let index = g_correctQuestionIds.firstIndex(of: foo.questionID) {
                        g_correctQuestionIds.remove(at: index) // array is now ["world", "hello"]
                    }
                }
                for foo in QuizResult[0].missingMulticheckboxQuizChoices! {
                    g_incorrectQuestionIds.append(foo.questionID)
                    if let index = g_correctQuestionIds.firstIndex(of: foo.questionID) {
                        g_correctQuestionIds.remove(at: index) // array is now ["world", "hello"]
                    }
                }
                for foo in QuizResult[0].wrongQuizChoices! {
                    var questionNumber = 1
                    for foobar in Quizzes[0].QuizQuestions {
                        if foobar.QuestionID == foo.questionID {
                            incorrectQuestions = incorrectQuestions + "\n" + foobar.quiz1OfN! + ". " + foobar.QuestionDescription!
                        }
                        questionNumber = questionNumber + 1
                    }
                }
                for foo in QuizResult[0].missingMulticheckboxQuizChoices! {
                    var questionNumber = 1
                    for foobar in Quizzes[0].QuizQuestions {
                        if foobar.QuestionID == foo.questionID {
                            incorrectQuestions = incorrectQuestions + "\n" + foobar.quiz1OfN! + ". " + foobar.QuestionDescription!
                        }
                        questionNumber = questionNumber + 1
                    }
                }
            }
            catch{
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
                Quizzes.removeAll()
            }
            var quizResult = ""
            var auditCode=""
            if result.replacingOccurrences(of: "\"", with: "").contains("QuizResult:true") {
                quizResult = "Quiz Result - PASS"
                DispatchQueue.main.async {
                    self.viewQuizQuestion.isHidden = true
                    self.viewQuizFailed.isHidden = true
                    self.viewQuizSuccessful.isHidden = false
                }
                auditCode = "5000051"
            } else {
                g_quizFailAttempts = g_quizFailAttempts + 1
                quizResult = "Quiz Result - FAIL"
                print("questions answered wrong")
                DispatchQueue.main.async { [weak self] in
                    self?.viewQuizQuestion.isHidden = true
                    self?.viewQuizSuccessful.isHidden = true
                    self?.viewQuizFailed.isHidden = false
                    self?.incorrectAnswerTextField.stringValue = incorrectQuestions
                }
                auditCode = "J5000058"
            }
            if 1 == 1 //quiz result add to audit
            {
                GlobalManager.shared.sendAudit(code: auditCode, viaStateId: 2)
                let index = EuaMessage.firstIndex { $0.messageCode == auditCode }
                Logger.log(EuaMessage[index!].messageDescription)
            }
        }
    }
    
    //LEGACY
//    @IBAction func ContinueViewHistoryClicked(_ sender: Any) {
//        //g_functionJCode = 224
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
//            return
//        }
//        UiAfterLogIn()
//    }
    
    @IBAction func clickedForgotUserId(_ sender: Any) {
        //g_functionJCode = 226
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("forgot userid")
        statusTextField.isHidden = true
        if g_internet == false {
            return
        }
        displayMainView(myView: viewForgotUsername)
    }
    
    @IBAction func closeCrossBtnClicked(_ sender: Any) {
        //g_functionJCode = 310
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        showAlertOkCancel(key: "mykey", header: "Eversense Upgrade", body: "Are you sure you want to close the application?", completion: showAlertOkCancelAction(result:))
    }
    
    @IBAction func minimizeButtonClicked(_ sender: Any) {
        //g_functionJCode = 315
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        self.view.window!.miniaturize(self)
    }
    
    @IBAction func btnRestartQuizFromViewRestartQuizClicked(_ sender: Any) {
        //g_functionJCode = 317
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        displayMainView(myView: viewResumeQuizWelcome)
    }
    
    @IBAction func btnOkFromForgotUsernameClicked(_ sender: Any) {
        //g_functionJCode = 318
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        // Updated code with guard statement
        guard GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() != false else {
            return
        }
        displayMainView(myView: viewSignIn)
    }
    
   //LEGACY
//    @IBAction func ReviewChangesSaveAsPdfBtnClicked(_ sender: Any) {
//        //g_functionJCode = 320
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
//            return
//        }
//        makePdfReviewChanges()
//    }

    //LEGACY
//     @IBAction func checkForUpdatesBtnClicked(_ sender: Any) {
//        //g_functionJCode = 327
//        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//        print("check for upgrade button clicked")
//        if g_quizFailAttempts >= 3 {
//            g_upgradeAvailable = false
//            GlobalManager.shared.sendAudit(code: "5021")
//            print("already attempted the quizmore 3 or more times, no more trying!!")
//            displayMainView(myView: viewQuizTooManyAttempts)
//            return
//        }
//        var code:String = "J5028"
//        if g_upgradeInProgress {
//            code = "J5010"
//        }
//        if ((g_deviceIDFromTx == nil) || (g_deviceIDFromCloud==nil)) {
//            showAlert(auditCode: code)
//            return
//        } else { if g_statusTextReason == code {
//            DispatchQueue.main.async { [self] in
//                statusTextField.isHidden = true
//            }
//        }
//        }
//        if g_internet == false {
//            showAlert(auditCode: "5025")
//        } else {
//            if g_statusTextReason == "J5025" {
//                DispatchQueue.main.async { [self] in
//                    statusTextField.isHidden = true
//                }
//            }
//            var isCubeInstalled =  shell("/Applications/STMicroelectronics/STM32Cube/STM32CubeProgrammer/STM32CubeProgrammer.app/Contents/MacOs/bin/STM32_Programmer_CLI -version")
//            if isCubeInstalled.lowercased().contains("stm32cubeprogrammer version") {
//                checkForUpdates()
//            } else {
//                DispatchQueue.main.async { [self] in
//                    showAlert(header: "Eversense Upgrade", body: "Please close the app. Reopen the app and follow the prompts to install STM32Cube Client")
//                }
//            }
//        }
//     }
    
    @IBAction func saveAndContinueBtnClicked(_ sender: Any) {
        //g_functionJCode = 330
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        saveAndContinueLater()
    }
    
    @IBAction func resumeQuizBtnClicked(_ sender: Any) {
        //g_functionJCode = 331
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        currentQuizQuestionIndex = 0
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        getIncorrectQuestionIdsFromAudit()
        GlobalManager.shared.sendAudit(code: "5000050")
        let index = EuaMessage.firstIndex { $0.messageCode == "5000050" }
        Logger.log(EuaMessage[index!].messageDescription)
        callApiGetViaQuizFailAttempts(comingfrom: "resumeQuizButton")
    }
    
    @IBAction func startQuizBtnClicked(_ sender: Any) {
        //g_functionJCode = 333
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            return
        }
        viewStartQuiz.isHidden = true
        viewResumeQuizWelcome.isHidden = true
        GlobalManager.shared.sendAudit(code: "5000050")
        let index = EuaMessage.firstIndex { $0.messageCode == "5000050" }
        Logger.log(EuaMessage[index!].messageDescription)
        self.callApiGetUserQuizTracker(quizid:Quizzes[0].QuizID,firmwareversion:g_fullVersionFromTx!,transmitterid:g_deviceID!)
        getIncorrectQuestionIdsFromAudit()
        if 1 == 1 //show questions and answers based on filter status
        {
            if (QuizzesOriginal.count == 0){
                QuizzesOriginal = Quizzes
            }
            if quizFilterBtn.title.lowercased()=="show incorrect questions only" {
                showAllQuestions()
            } else {
                showIncorrectQuestions()
            }
        }
    }
    
    @IBAction func QuizAnswer1Clicked(_ sender: Any) {
        //g_functionJCode = 405
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        // Updated code with guard statement
        guard GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() != false else { return}
        var tag = (sender as! NSButton).tag
        quizAnswerClicked(tag: tag)
    }
    
    @IBAction func QuizAnswer2Clicked(_ sender: Any) {
        //g_functionJCode = 408
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        // Updated code with guard statement
        guard GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() != false else { return }
        var tag = (sender as! NSButton).tag
        quizAnswerClicked(tag: tag)
    }
    
    @IBAction func QuizAnswer3Clicked(_ sender: Any) {
        //g_functionJCode = 409
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        // Updated code with guard statement
        guard GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() != false else { return }
        var tag = (sender as! NSButton).tag
        quizAnswerClicked(tag: tag)
    }
    
    @IBAction func QuizAnswer4Clicked(_ sender: Any) {
        //g_functionJCode = 410
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        // Updated code with guard statement
        guard GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() != false else { return }
        var tag = (sender as! NSButton).tag
        quizAnswerClicked(tag: tag)
    }
    
    @IBAction func SaveAndContinueBtnClicked(_ sender: Any) {
        //g_functionJCode = 411
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        // Updated code with guard statement
        guard GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() != false else { return }
        saveAndContinueLater()
    }
    
    @IBAction func QuizAnswer5Clicked(_ sender: Any) {
        //g_functionJCode = 412
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        // Updated code with guard statement
        guard GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() != false else { return }
        var tag = (sender as! NSButton).tag
        quizAnswerClicked(tag: tag)
    }
    
    @IBAction func PrevQuizQuestionBtnClicked(_ sender: Any) {
        if 1 == 2 //TOBEREMOVED
        {
//            //g_functionJCode = 413
//            Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//            if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
//    //            showAlert(auditCode: "5025")
//                let index = EuaMessage.firstIndex { $0.messageCode == "5000025" }
//                addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly, isHeaderSecondaryHidden: true)
//                Logger.log(EuaMessage[index!].messageDescription)
//
//                return
//            } else {
//                if g_statusTextReason == "J5025" {
//                    DispatchQueue.main.async { [self] in
//                        statusTextField.isHidden = true
//                    }
//                }
//            }
//            if isOneAnswerSelected() == false {
//                DispatchQueue.main.async { [self] in
//                    let index = EuaMessage.firstIndex { $0.messageCode == "5000027" }
//                    addAlertView(headerPrimaryText: "EversenseUpgrade", message: EuaMessage[index!].messagerDescriptionUserFriendly)
//                    Logger.log(EuaMessage[index!].messageDescription)
//                }
//                makeSureChoicesAreEnabled()
//                return
//            }
//            currentQuizQuestionIndex = currentQuizQuestionIndex! - 1
//            getChoiceJsonAndCallApiSetUserQuizTracker(continueGetApi: true)
        }
    }
    
    @IBAction func NextQuizQuestionBtnClicked(_ sender: Any) {
        if 1 == 2 //TOBEREMOVED
        {
//            //g_functionJCode = 416
//            Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
//            if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
//    //            showAlert(auditCode: "5025")
//                let index = EuaMessage.firstIndex { $0.messageCode == "5000025" }
//                addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly, isHeaderSecondaryHidden: true)
//                Logger.log(EuaMessage[index!].messageDescription)
//
//                return
//            } else {
//                if g_statusTextReason == "J5025" {
//                    DispatchQueue.main.async { [self] in
//                        statusTextField.isHidden = true
//                    }
//                }
//            }
//            if isOneAnswerSelected() == false {
//                let index = EuaMessage.firstIndex { $0.messageCode == "5000027" }
//                let resultAuditDescriptionUserFriendly = EuaMessage[index!].messagerDescriptionUserFriendly
//                Logger.log(EuaMessage[index!].messageDescription)
//
//                DispatchQueue.main.async { [self] in
//                    showAlert(header: "EversenseUpgrade", body: resultAuditDescriptionUserFriendly)
//                }
//                makeSureChoicesAreEnabled()
//                return
//            }
//            currentQuizQuestionIndex = currentQuizQuestionIndex! + 1
//            getChoiceJsonAndCallApiSetUserQuizTracker(continueGetApi: true)
        }
    }
    
    //MARK: - Trouble Logging In Screen
    @IBAction func troubleLoggingInButttonTapped(_ sender: Any) {
        //g_functionJCode = 225
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        print("FORGOT PW")
        tfEmailNew.stringValue=""
        tfPassword.stringValue=""
        tfPasswordSecure.stringValue=""
        statusTextField.isHidden = true
        // Updated code with guard statement
//        guard g_internet != false else { return }
        btSendPasswordResetEmail.setButton(backgroundColor: NSColor(named: "blue") ?? .blue)
        btBack_ViewForgotPassword.setButton(backgroundColor: NSColor(named: "blue") ?? .blue)
//        btBack_ViewForgotPassword.setButton(backgroundColor: NSColor(named: "appColor") ?? .white, isBordered: true)
        addtransition(transitionView: viewSignIn, direction: .fromBottom)
        viewSignIn.isHidden = true
        addtransition(transitionView: viewForgotPassword, direction: .fromBottom)
        viewForgotPassword.isHidden = false
    }
    
    @IBAction func SignOutClicked(_ sender: Any) {
        //g_functionJCode = 228
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        signout()
    }

    @IBAction func printBtnFromReviewChangesClicked(_ sender: Any) {
        //g_functionJCode = 118
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        // FIXME: Update Try condition
        try self.textReviewChanges.printView("me")
    }
    
    
    @IBAction func sendResetPasswordEmailButtonTapped(_ sender: NSButton) {
        if !(g_internet)
        {
            let index = EuaMessage.firstIndex { $0.messageCode == "5000025" }
            addAlertView(headerPrimaryText: "Notification", message: EuaMessage[index!].messagerDescriptionUserFriendly, isHeaderSecondaryHidden: true)
            Logger.log(EuaMessage[index!].messageDescription)
            return
        }
        if (tfSendPasswordResetEmail.stringValue == "")
        {
            showErrorMessageLoginScreen(auditCode: "5000038")
            let index = EuaMessage.firstIndex { $0.messageCode == "5000038" }
            Logger.log(EuaMessage[index!].messageDescription)
            return
        }
        if !(isValidEmail(tfSendPasswordResetEmail.stringValue)) {
            showErrorMessageLoginScreen(auditCode: "5000026")
            return
        } else {
            callApiSendResetPasswordEmail(email: tfSendPasswordResetEmail.stringValue)
        }
    }
    
}
