//
//  EversenseLoginViewUI.swift
//  EversenseUpgrade
//
//  Created by Shiney Chaudhary on 20/07/23.
//  Copyright © 2023 senseonics. All rights reserved.
//

import Foundation
import Cocoa
import AVKit

@available(macOS 11.0, *)
extension EversenseLoginViewController {
    
    func disableAllButtons(myView:NSView) {
        //g_functionJCode = 349
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if myView == viewUpdateError {
            return
        }
        for subView in myView.allSubviews {
            print(subView.debugDescription)
            if subView.description.contains("NSButton:") {
                if (subView as! NSButton) == btCheckForUpdateFromWelcomeView {
                    //don't disable the button
                }
                if (subView as! NSButton) == btRetry_ViewUpdateError {
                    //don't disable the button
                }
                if (subView as! NSButton) == btCheckForUpdateFromWelcomeView {
                    //don't disable the button
                } else {
                    (subView as! NSButton).isEnabled = false
                }
            }
            if subView.description.contains("NSTextView:") {
                (subView as! NSTextView).isEditable = false
            }
            if subView.description.contains("NSSecureTextField:") {
                (subView as! NSSecureTextField).isEnabled = false
            }
            if subView.description.contains("NSTextField:") {
                (subView as! NSTextField).isEnabled = false
            }
        }
        if 1 == 1 // the followings are enabled no matter what
        {
            startTransmitterUpdateBtn.isEnabled=true
        }
    }
    
    func enableAllButtons(myView:NSView)
    {
        //g_functionJCode = 350
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        DispatchQueue.main.async {
            for subView in myView.allSubviews {
                if subView.description.contains("NSButton:")
                {
                    (subView as! NSButton).isEnabled = true
                }
                if subView.description.contains("NSTextView:") {
                    (subView as! NSTextView).isEditable = true
                }
                if subView.description.contains("NSSecureTextField:") {
                    (subView as! NSSecureTextField).isEnabled = true
                }
                if subView.description.contains("NSTextField:") {
                    (subView as! NSTextField).isEnabled = true
                }
                if let foo = subView as? NSButton {
                    if foo.title == "Review Previous Changes" {
                        if g_upgradeAvailable {
                            foo.isEnabled = true
                        } else {
                            foo.isEnabled = false
                        }
                    }
                }
            }
        }
    }
    
    func showUiBasedOnTxConnectionToUsbStatus() {
        //g_functionJCode = 401
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        DispatchQueue.main.async { [self] in
            if g_TxConnectedToUsbAndSuccessfullyCalledTxInfoApis {
                if g_authenticated {
                    self.CallApiGetAuditHistory()
                }
//                btNextFromViewConnectUsb.isEnabled = true
                g_TxIsPhysicallyConnectedToUsb = true
                enableAllButtons(myView: viewSignIn)
                enableAllButtons(myView: viewWelcomeAfterSignIn)
                enableAllButtons(myView: viewStartQuiz)
                enableAllButtons(myView: viewResumeQuizWelcome)
                enableAllButtons(myView: viewQuizTooManyAttempts)
                enableAllButtons(myView: viewRestartQuiz)
                enableAllButtons(myView: viewQuizFailed)
                enableAllButtons(myView: viewConnectUsb)
                enableAllButtons(myView: viewQuizQuestion)
                enableAllButtons(myView: viewProgressBar)
                enableAllButtons(myView: viewAfterUpgrade)
                enableAllButtons(myView: viewReviewChanges)
                enableAllButtons(myView: viewQuizSuccessful)
                enableAllButtons(myView: viewTxNotActive)
                enableAllButtons(myView: viewNoUpdateAvailable)
                enableAllButtons(myView: viewFirmwareUpgradeProgressing)
                enableAllButtons(myView: viewNoUpdateAvailable)
                enableAllButtons(myView: viewNavigation)
            } else {
                btReviewChanges.isEnabled = false
                btReviewChanges.isHidden = true
                btNextFromViewConnectUsb.isEnabled = false
                disableAllButtons(myView: viewWelcomeAfterSignIn)
                disableAllButtons(myView: viewStartQuiz)
                disableAllButtons(myView: viewResumeQuizWelcome)
                disableAllButtons(myView: viewQuizTooManyAttempts)
                disableAllButtons(myView: viewRestartQuiz)
                disableAllButtons(myView: viewQuizFailed)
                disableAllButtons(myView: viewConnectUsb)
                disableAllButtons(myView: viewQuizQuestion)
                disableAllButtons(myView: viewProgressBar)
                disableAllButtons(myView: viewAfterUpgrade)
                disableAllButtons(myView: viewReviewChanges)
                disableAllButtons(myView: viewQuizSuccessful)
                disableAllButtons(myView: viewNoUpdateAvailable)
                disableAllButtons(myView: viewNoUpdateAvailable)
            }
        }
    }
    
    func quizAnswerClicked(tag: Int) {
        //g_functionJCode = 406
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        var mytag:Int = tag
        DispatchQueue.main.async { [self] in
            quizAnswer1.state = .off
            quizAnswer2.state = .off
            quizAnswer3.state = .off
            quizAnswer4.state = .off
            quizAnswer5.state = .off
            // FIXME: Use switch case rather than using static values
            if mytag == 1 {
                quizAnswer1.state = .on
            }
            if mytag == 2 {
                quizAnswer2.state = .on
            }
            if mytag == 3 {
                quizAnswer3.state = .on
            }
            if mytag == 4 {
                quizAnswer4.state = .on
            }
            if mytag == 5 {
                quizAnswer5.state = .on
            }
        }
        let newtag = mytag - 1
        let questionId = Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuestionID
        let choiceId = Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuizChoices[newtag].ChoiceID
        let questionTypeId = Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuestionTypeId
        updateQuizChoicesUsingQuestionIdAndChoiceId(questionId: questionId,choiceId: choiceId, questionTypeId: questionTypeId)
        defaults!.set(try? PropertyListEncoder().encode(QuizChoices), forKey:"QuizChoices")
        setImage(imageUrl: Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuizChoices[newtag].ImageURL!)
        let urlReq = URLRequest(url: URL(string: Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuizChoices[newtag].VideoURL!.replacingOccurrences(of: "watch", with: "watch_popup"))!)
        self.videoWebView.load(urlReq)
        //make sure to show save and continue later button as soon as something is selected
        btSaveAndContinueLater.isHidden = false
    }
    
    func setImage(imageUrl: String) {
        //g_functionJCode = 404
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        let url = URL(string: imageUrl)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: url!)
            DispatchQueue.main.async {
                if data != nil {
                    self.quizImageView.image = NSImage(data: data!)
                }
            }
        }
    }
    
    func displayCurrentQuizQuestionAndAnswers() {
        //g_functionJCode = 403
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if currentQuizQuestionIndex! < 0 {
            //sometimes if you click too fast to the left, it could get here
            return
        }
        if QuizResult.count == 0 {
            //if you haven't submitted the quiz, do not show filter button
            quizFilterBtn.isHidden = true
        } else {
            quizFilterBtn.isHidden = false
        }
        if 1 == 1 //show quiz question image and video
        {
            if currentQuizQuestionIndex! >= Quizzes[0].QuizQuestions.count {
                return
            }
            setImage(imageUrl: Quizzes[0].QuizQuestions[0].ImageURL!)
            let urlReq = URLRequest(url: URL(string: Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuizChoices[0].VideoURL!.replacingOccurrences(of: "watch", with: "watch_popup"))!)
            DispatchQueue.main.async {
                self.videoWebView.load(urlReq)
            }
            guard let videoURL = NSURL(string: "https://v.ftcdn.net/01/90/62/84/700_F_190628462_AHUzP2SYc1qXPUcxlZRflmj0hnXHdU2d_ST.mp4") else {
                return
            }
            let player = AVPlayer(url: videoURL as URL)
            quizAvPlayerView.player = player
        }
        DispatchQueue.main.async { [self] in
            if 1 == 1 //set question and 5 answer display values to "", state of off and hide the choices
            {
                viewQuizQuestion.isHidden = false
                // FIXME: Remove forcecasting and if commented code not required then remove it
                quizQuestion.stringValue = Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuestionDescription!
                //red-rabbit temporarily show question id
                //                quizQuestion.stringValue = String(Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuestionID) + " " + Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuestionDescription!
                
                // FIXME: Remove forcecasting
                lbQuestionIndex.stringValue = "Question \(Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].quiz1OfN!) of \(g_quizQuestionCount!)"
                quizAnswer1.title = ""
                quizAnswer1.state = .off
                quizAnswer2.title = ""
                quizAnswer2.state = .off
                quizAnswer3.title = ""
                quizAnswer3.state = .off
                quizAnswer4.title = ""
                quizAnswer4.state = .off
                quizAnswer5.title = ""
                quizAnswer5.state = .off
                quizQuestion.isHidden = false
                //hide all 5 answer
                quizAnswer1.isHidden = true
                quizAnswer2.isHidden = true
                quizAnswer3.isHidden = true
                quizAnswer4.isHidden = true
                quizAnswer5.isHidden = true
                btSubmitQuiz.isHidden = true
            }
            var quizAnswer1Selected = false
            var quizAnswer2Selected = false
            var quizAnswer3Selected = false
            var quizAnswer4Selected = false
            var quizAnswer5Selected = false
            // FIXME: Remove forcecasting
            for (idx, choice) in Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuizChoices.enumerated() {
                // FIXME: Switch case can be used and static value can be avoided
                if idx == 0 {
                    quizAnswer1Selected = modifyRadioAndIsSelected(idx: idx+1, quizButton: quizAnswer1, choice: choice)
                }
                else if idx == 1 {
                    quizAnswer2Selected = modifyRadioAndIsSelected(idx: idx+1, quizButton: quizAnswer2, choice: choice)
                }
                else if idx == 2 {
                    quizAnswer3Selected = modifyRadioAndIsSelected(idx: idx+1, quizButton: quizAnswer3, choice: choice)
                }
                else if idx == 3 {
                    quizAnswer4Selected = modifyRadioAndIsSelected(idx: idx+1, quizButton: quizAnswer4, choice: choice)
                }
                else if idx == 4 {
                    quizAnswer5Selected = modifyRadioAndIsSelected(idx: idx+1, quizButton: quizAnswer5, choice: choice)
                }
            }
            var enableChoice = true
            // FIXME: Remove forcecasting
            if g_incorrectQuestionIds.contains(Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuestionID) {
                enableChoice = true
            }
            // FIXME: Remove forcecasting
            else if g_correctQuestionIds.contains(Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuestionID) {
                enableChoice = false
            }
            //disabling it for now because if the user logs back in without submitting, the answered questions are now disabled eventhough they haven't submitted
            if 1 == 2 //if enablechoice is still false (they are either correct or never filled out)//if none of the choises are selected, it means the user never answered the question. in that case enable it
            { if enableChoice == false {
                //we assume the question was never answered and allow the user answer the question. however, if the search string is found in g_GetUserQuizTrackerString, we will have to disable it
                enableChoice = true
                for foo in Quizzes[0].QuizQuestions[currentQuizQuestionIndex!].QuizChoices {
                    let searchString="{ChoiceID:\(foo.ChoiceID)}"
                    if ((g_GetUserQuizTrackerString?.contains(searchString))! == true) {
                        //meaning it was answered already, must be a correct answer
                        enableChoice = false
                    }
                }
            }
            }
            quizAnswer1.isEnabled = enableChoice
            quizAnswer2.isEnabled = enableChoice
            quizAnswer3.isEnabled = enableChoice
            quizAnswer4.isEnabled = enableChoice
            quizAnswer5.isEnabled = enableChoice
            self.btNextQuizQuestion.isHidden = false
            self.btPrevQuizQuestion.isHidden = false
            if currentQuizQuestionIndex!+1 == Quizzes[0].QuizQuestions.count {
                //meaning you are at the last question
                self.btNextQuizQuestion.isHidden = true
                btSubmitQuiz.isHidden = false
            }
            if currentQuizQuestionIndex! == 0 {
                //meaning you are at the first question
                self.btPrevQuizQuestion.isHidden = true
            }
            quizAnswer1.set(textColor: .white)
            quizAnswer2.set(textColor: .white)
            quizAnswer3.set(textColor: .white)
            quizAnswer4.set(textColor: .white)
            quizAnswer5.set(textColor: .white)
            if 1 == 1 //"When quiz is started, save and continue button should not be available in first question until answer is selected
            {
                if (currentQuizQuestionIndex == 0) {
                    if ((quizAnswer1Selected == false) && (quizAnswer2Selected == false) && (quizAnswer3Selected == false) && (quizAnswer4Selected == false) && (quizAnswer5Selected == false))
                    {
                        DispatchQueue.main.async { [weak self] in
                            self?.btSaveAndContinueLater.isHidden = true
                        }
                    }
                } else {
                    btSaveAndContinueLater.isHidden = false
                }
            }
        }
    }
    
    func UiAfterLogIn() {
        //g_functionJCode = 334
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        DispatchQueue.main.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.lbYourEversenseCGMSystem.isHidden = false
            strongSelf.lbActiveTransmitterSn.isHidden = false
            strongSelf.lbActiveTransmitterSnValue.isHidden = false
            strongSelf.lbCurrentTransmitterVer.isHidden = false
            strongSelf.lbCurrentTransmitterVerValue.isHidden = false
            strongSelf.lbEversenseMobileAppSoftwareVer.isHidden = false
            strongSelf.lbEversenseMobileAppSoftwareVerValue.isHidden = false
            strongSelf.lblLoggedInUser.isHidden = false
            strongSelf.lblLoggedInUserValue.isHidden = false
            strongSelf.btSignOut.isHidden = false
            strongSelf.btViewHistory.isHidden = false
            strongSelf.btReviewChanges.isHidden = true
            strongSelf.btReviewChanges.isEnabled = false
            
            // Get a reference to the main storyboard
            let storyboard = NSStoryboard(name: "Main", bundle: nil)

            // Instantiate the view controller with the specified storyboard identifier
            if let viewController = storyboard.instantiateController(withIdentifier: "EversenseHomeScreenViewController") as? EversenseHomeScreenViewController {
                // Do something with the instantiated view controller
                // For example, present it or add it to the window's content view
                strongSelf.view.window?.contentViewController = viewController

            }
        }
    }
    
    func animateTransition(to newViewController: NSViewController?) {
        guard let mainWindow = NSApp.mainWindow, let _ = mainWindow.contentViewController else {
            return
        }
        
        // Ensure there is a new view controller to transition to
        guard let newViewController = newViewController else {
            return
        }
        
        // Configure animation
        let transition = CATransition()
        transition.type = .push
        transition.subtype = .fromRight
        transition.duration = 1.0
      
        // Set the new view controller as the content view controller
        mainWindow.contentViewController = newViewController
        newViewController.view.layer?.add(transition, forKey: kCATransition)
    }
    
    func moveUI() {
        //g_functionJCode = 332
        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls() == false {
            DispatchQueue.main.async { [self] in
                g_internet = false
                lbYourEversenseCGMSystem.isHidden = true
                lbActiveTransmitterSn.isHidden = true
                lbActiveTransmitterSnValue.isHidden = true
                lbCurrentTransmitterVer.isHidden = true
                lbCurrentTransmitterVerValue.isHidden = true
                lbEversenseMobileAppSoftwareVer.isHidden = true
                lbEversenseMobileAppSoftwareVerValue.isHidden = true
                lblLoggedInUser.isHidden = true
                lblLoggedInUserValue.isHidden = true
            }
        }
        // FIXME: Multiple dispatch queues are not required all can be moved in one with weak reference to avoid memory leak
        DispatchQueue.main.async { [self] in
            viewNavigation.isHidden = true
            viewWelcomeAfterSignIn.isHidden = true
            viewQuizQuestion.isHidden = true
            viewAfterUpgrade.isHidden = true
            viewFirmwareUpgradeProgressing.isHidden = true
            viewTxNotActive.isHidden = true
            viewNoUpdateAvailable.isHidden = true
            viewConnectUsb.isHidden = true
            viewWaitWhileWeCheck.isHidden = true
            viewStmDownload.isHidden = true
            viewJavaDownload.isHidden = true
            viewNewVersionDownload.isHidden = true
            viewFirmwareUpToDate.isHidden = true
            viewWaitWhileWeValidateSignOn.isHidden = true
            viewProgressBar.isHidden = true
            viewStartQuiz.isHidden = true
            viewResumeQuizWelcome.isHidden = true
            viewQuizTooManyAttempts.isHidden=true
            viewQuizFailed.isHidden = true
            viewQuizSuccessful.isHidden = true
            viewReviewChanges.isHidden = true
            viewEula.isHidden = true
            btReviewChanges.isHidden = true
            viewForgotUsername.isHidden = true
            viewForgotPassword.isHidden = true
            loginErrorColorWell.isHidden = true
            btViewHistory.isHidden = true
            btSignOut.isHidden = true
            lbYourEversenseCGMSystem.isHidden = true
            lbActiveTransmitterSn.isHidden = true
            lbActiveTransmitterSnValue.isHidden = true
            lbCurrentTransmitterVer.isHidden = true
            lbCurrentTransmitterVerValue.isHidden = true
            lbEversenseMobileAppSoftwareVer.isHidden = true
            lbEversenseMobileAppSoftwareVerValue.isHidden = true
            lblLoggedInUser.isHidden = true
            lblLoggedInUserValue.isHidden = true
            viewUpdateError.isHidden = true
            viewRestartQuiz.isHidden = true
        }
        DispatchQueue.main.async { [self] in
            viewNavigation.layer?.backgroundColor = .white
            viewStartQuiz.frame.origin.y=128
            viewResumeQuizWelcome.frame.origin.y=128
            viewQuizTooManyAttempts.frame.origin.y=128
            viewQuizFailed.frame.origin.y=35
            viewReviewChanges.frame.origin.y=25
            viewQuizSuccessful.frame.origin.y=128
            viewSignIn.frame.origin.y = 10
            viewEula.frame.origin.y = -4
            viewForgotUsername.frame.origin.y = -22
            viewForgotPassword.frame.origin.y = 20
            viewWelcomeAfterSignIn.frame.origin.y = 100
            viewQuizQuestion.frame.origin.y = 45
            loginErrorColorWell.frame.origin.y = 350
            viewAfterUpgrade.frame.origin.y = 45
            viewFirmwareUpgradeProgressing.frame.origin.y = 45
            viewProgressBar.frame.origin.y = 170
            viewTxNotActive.frame.origin.y = 140
            viewNoUpdateAvailable.frame.origin.y = 140
            viewConnectUsb.frame.origin.y = 140
            viewWaitWhileWeCheck.frame.origin.y = 140
            viewFirmwareUpToDate.frame.origin.y = 140
            viewWaitWhileWeValidateSignOn.frame.origin.y = 144
            viewStmDownload.frame.origin.y = 150
            viewUpdateError.frame.origin.y = 140
            viewRestartQuiz.frame.origin.y = 128
        }
        
        DispatchQueue.main.async { [self] in
            viewJavaDownload.wantsLayer = true
            viewJavaDownload.layer?.backgroundColor = NSColor(named: "appColor")?.cgColor
            viewNewVersionDownload.wantsLayer = true
            viewNewVersionDownload.layer?.backgroundColor = NSColor(named: "appColor")?.cgColor
            viewFooter.wantsLayer = true
            viewFooter.layer?.backgroundColor = NSColor(named: "appColor")?.cgColor
            viewHeader.wantsLayer = true
            viewHeader.layer?.backgroundColor = NSColor(named: "appColor")?.cgColor
            viewStmDownload.wantsLayer = true
            viewStmDownload.layer?.backgroundColor = NSColor(named: "appColor")?.cgColor
            viewSignIn.wantsLayer = true
            viewSignIn.layer?.backgroundColor = NSColor(named: "appColor")?.cgColor
            viewMain.wantsLayer = true
            viewMain.layer?.backgroundColor = NSColor(named: "appColor")?.cgColor
            viewEula.wantsLayer = true
            viewEula.layer?.backgroundColor = NSColor(named: "appColor")?.cgColor
            viewErrorMessage.wantsLayer = true
            viewErrorMessage.layer?.cornerRadius = 5
            viewErrorMessage.layer?.borderColor = NSColor(named: "blue")?.cgColor
            viewErrorMessage.layer?.borderWidth = 1
        }
        self.showUiBasedOnTxConnectionToUsbStatus()
    }
    
    func displayMainView(myView: NSView) {
        //        //g_functionJCode = 319
        //        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line)")
        if myView == viewQuizTooManyAttempts {
            let index = EuaMessage.firstIndex { $0.messageCode == "5000021" }
            let resultAuditDescriptionUserFriendly = EuaMessage[index!].messagerDescriptionUserFriendly
            DispatchQueue.main.async {
                self.textFieldExceedQuizAttempts.stringValue = resultAuditDescriptionUserFriendly
                self.btReviewChanges.isEnabled = false
                self.btReviewChanges.isHidden = true
            }
        }
        if myView == viewFirmwareUpToDate {
            DispatchQueue.main.async { [self] in
                textFieldTxUpToDate.stringValue = "There are no upgrades available for transmitter SN \(g_deviceIDFromTx!) \n \(g_upgradeUnavailableReason)"
            }
            print("")
        }
        if myView == viewReviewChanges {
            DispatchQueue.main.async {
                self.checkReviewChanges.state = .off
                //if tx is disconnected during the update, we hide the review changes button
                //becuase the user could reconnects using a different tx
                //if the user clicks on Retry button, user gets to review changes page
                //in this scenario, we want to make sure the review changes button is displayedxxx`
                self.btReviewChanges.isEnabled = true
                self.btReviewChanges.isHidden = false
                self.viewReviewChangesTitle.stringValue = self.viewReviewChangesTitle.stringValue.replacingOccurrences(of: "transmitter SN", with: "transmitter \(g_deviceIDFromTx!)")
                self.startTransmitterUpdateBtn.isEnabled = false
            }
        }
        if myView == viewStartQuiz {
            DispatchQueue.main.async {
                self.startQuizTextField.stringValue = "There are \(Quizzes[0].QuizQuestions.count) questions in this quiz. The estimated time to complete this quiz is 10 minutes."
            }
        }
        if myView != viewSignIn {
            DispatchQueue.main.async { [self] in
                tfPasswordSecure.stringValue = ""
            }
        }
        if myView == viewUpdateError {
            g_upgradeStartTime = 0
            showWindowCloseRedCircleBasedOnUpgradeProgressStatus()
            DispatchQueue.main.async { [self] in
                btViewHistory.isEnabled = true
                btNeedHelp.isEnabled = true
                btSignOut.isEnabled = true
            }
        }
        if myView == viewRestartQuiz {
            if g_deviceIDFromCloud != nil {
                DispatchQueue.main.async { [self] in
                    if !(lbInstructionRestartQuiz.stringValue.contains(g_deviceIDFromCloud!))
                    {
                        lbInstructionRestartQuiz.stringValue = lbInstructionRestartQuiz.stringValue.replacingOccurrences(of: "transmitter SN", with: "transmitter SN \(g_deviceIDFromCloud!)")
                    }
                }
            }
            if 1 == 1 // enable below no matter what
            {
                DispatchQueue.main.async { [weak self] in
                    self?.btCheckForUpdateFromWelcomeView.isEnabled = true
                }
            }
        }
        if myView == viewWelcomeAfterSignIn {
            g_upgradeStartTime = 0
            showWindowCloseRedCircleBasedOnUpgradeProgressStatus()
            if g_deviceIDFromCloud != nil {
                DispatchQueue.main.async { [self] in
                    if !(lbInstruction.stringValue.contains(g_deviceIDFromCloud!)) {
                        lbInstruction.stringValue = lbInstruction.stringValue.replacingOccurrences(of: "transmitter SN", with: "transmitter SN \(g_deviceIDFromCloud!)")
                    }
                }
            }
            if 1 == 1 // enable below no matter what
            {
                DispatchQueue.main.async { [self] in
                    btCheckForUpdateFromWelcomeView.isEnabled = true
                    viewNavigation.isHidden = false
                }
            }
        }
        if g_deviceIDFromTx != nil {
            if myView == viewTxNotActive {
                GlobalManager.shared.sendAudit(code: "5000023")
                let index = EuaMessage.firstIndex { $0.messageCode == "5000023" }
                let resultAuditDescriptionUserFriendly = EuaMessage[index!].messagerDescriptionUserFriendly
                Logger.log(EuaMessage[index!].messageDescription)

                DispatchQueue.main.async { [self] in
                    txNotActiveTextField.stringValue = resultAuditDescriptionUserFriendly.replacingOccurrences(of: "XXXX", with: String(g_deviceIDFromTx!))
                    txNotActiveTextField.stringValue = txNotActiveTextField.stringValue.replacingOccurrences(of: "YYYY", with: String(g_deviceIDFromCloud!))
                }
            }
        }
        g_currentView = myView
        DispatchQueue.main.async { [self] in
            print(myView.tag)
            viewProgressBar.isHidden = true
            viewFirmwareUpgradeProgressing.isHidden = true
            viewAfterUpgrade.isHidden=true
            viewStartQuiz.isHidden=true
            viewResumeQuizWelcome.isHidden=true
            viewQuizTooManyAttempts.isHidden=true
            viewQuizQuestion.isHidden=true
            viewAfterUpgrade.isHidden=true
            viewQuizFailed.isHidden=true
            viewWelcomeAfterSignIn.isHidden=true
            viewQuizSuccessful.isHidden=true
            viewSignIn.isHidden=true
            viewReviewChanges.isHidden=true
            viewEula.isHidden = true
            viewForgotUsername.isHidden = true
            viewForgotPassword.isHidden = true
            viewTxNotActive.isHidden = true
            viewNoUpdateAvailable.isHidden = true
            viewConnectUsb.isHidden = true
            viewWaitWhileWeCheck.isHidden = true
            viewFirmwareUpToDate.isHidden = true
            viewWaitWhileWeValidateSignOn.isHidden = true
            viewUpdateError.isHidden = true
            viewRestartQuiz.isHidden = true
            viewStmDownload.isHidden = true
            viewJavaDownload.isHidden = true
            viewNewVersionDownload.isHidden = true
            viewNewVersionDownload.isHidden = true
            myView.isHidden=false
        }
    }
}
