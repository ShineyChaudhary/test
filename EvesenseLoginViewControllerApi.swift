import Cocoa
import Foundation

extension EversenseLoginViewController: LoginViewControllerProtocol {
    // FIXME: Parameter name can be better than FOO, a meaningful one
    func callApiVerifyUpgradeResult_Post(foo: [Int], completion: @escaping (_ result: String) -> Void) {
        var semaphore = DispatchSemaphore (value: 2534)
        let parameters = foo
        var postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
        var request = URLRequest(url: URL(string: hostCgmUploadApiUrl! + "/api/ReadSingleByteSerialFlashRegisterResponse")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline"))
                {
                    completion("INTERNET_ERROR")
                }
                semaphore.signal()
                return
            }
            print(String(data: data, encoding: .utf8)!)
            // FIXME: Force casting, make it optional
            var result = String(data: data as! Data, encoding: String.Encoding.utf8)
            result = result!.replacingOccurrences(of: "\"", with: "")
            //red-rabbit
            //            completion("4")
            completion(result!)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func callApiVerifyHash_Post(responseBytes: [Int], completion: @escaping (_ result: String) -> Void) {
        if (1 == 2) // looks like duplicated code
        {
            var semaphore = DispatchSemaphore (value: 763)
            let parameters = responseBytes
            let postData = try? JSONSerialization.data(withJSONObject: parameters, options: [])
            let request = NSMutableURLRequest(url: NSURL(string: hostCgmUploadApiUrl!+"/api/VerifyHash")! as URL,
                                              cachePolicy: .useProtocolCachePolicy,
                                              timeoutInterval: 3000.0)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpMethod = "POST"
            request.httpBody = postData
            let task = URLSession.shared.dataTask(with: request as URLRequest) {  data, response, error in
                guard let data = data else {
                    print(String(describing: error))
                    if (String(describing: error).contains("The Internet connection appears to be offline"))
                    {
                        completion("INTERNET_ERROR")
                    }
                    semaphore.signal()
                    return
                }
                print(String(data: data, encoding: .utf8)!)
                
                // FIXME: Force casting, make it optional
                var result = String(data: data as! Data, encoding: String.Encoding.utf8)
                //red-rabbitforce hashkey verification error
//                result = "false"
                completion(result!)
                semaphore.signal()
            }
            task.resume()
            semaphore.wait()
        }
    }
    
    func CallApiVerifyMd5_Post(md5string: String, completion: @escaping (_ result: String) -> Void) {
        var semaphore = DispatchSemaphore (value: 892)
        let parameters = "{\r\n    \"Name\": \"\(g_fullVersion!)_MD5_HEX\"\r\n}"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: hostApiUrl! + "/api/Via/GetFromViaAppConfig")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(g_accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline"))
                {
                    completion("INTERNET_ERROR")
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
                if AppConfig.count>0
                {
                    completion(AppConfig[0].Value!)
                }
                else
                {
                    completion("MD5ERROR")
                }
            } catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func authenticate(email: String, password: String, completion: @escaping (_ result: String) -> Void) {
        let host: String! = getHost()
        let headers = [
            "Content-Type": "application/x-www-form-urlencoded",
            "User-Agent": "PostmanRuntime/7.17.1",
            "Accept": "*/*",
            "Cache-Control": "no-cache",
            "Host": host!,
            "Accept-Encoding": "gzip, deflate",
            "Content-Length": "139",
            "Connection": "keep-alive",
            "cache-control": "no-cache"
        ]
        // FIXME: Remove all force casting and give default values
        let postData = NSMutableData(data: "grant_type=password".data(using: String.Encoding.utf8)!)
        postData.append(("&username="+email).data(using: String.Encoding.utf8)!)
        postData.append(("&password="+password).data(using: String.Encoding.utf8)!)
        postData.append("&client_id=dms".data(using: String.Encoding.utf8)!)
        postData.append("&client_secret=secret".data(using: String.Encoding.utf8)!)
        sleep(1)
        let request = NSMutableURLRequest(url: NSURL(string: hostAuthenticationUrl!+"/connect/token")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 60)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData as Data
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                completion("notoken")
            } else {
                let httpResponse = response as? HTTPURLResponse
                print(httpResponse)
                
                var loginError:Bool = false
                if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
                    print("statusCode should be 200, but is \(httpStatus.statusCode)")
                    print("response = \(String(describing: response))")
                    
                    loginError = true
//                    completion("notoken")
                }
                
                let responseString = String(data: data!, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
//                if responseString!.contains("invalid_grant")
//                {
//                    completion("notoken")
//                }
                if (loginError)
                {
                    let jsonData = Data(responseString!.utf8)
                    let decoder = JSONDecoder()
                    do {
                        LoginAttemptError = try decoder.decode(StructLoginAttemptError.self, from: jsonData)
                        completion("notoken")
                    } catch {
                        Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
                    }
                }
                else
                {
                    if let JSONData:Data = data {
                        if let JSONDictionary = try? JSONSerialization.jsonObject(with: JSONData, options: []) as? NSDictionary {
                            if (JSONDictionary.description.contains("Task timed out after")) {
                                return
                            }
                            for (key, value) in JSONDictionary {
                                if ((key as! String)=="access_token") {
                                    print(key)
                                    print(value)
                                    completion(value as! String)
                                }
                            }
                        }
                    }
                }
                
                
            }
        })
        dataTask.resume()
    }
    
    func CallApiGetFirmwareQuiz(completion: @escaping (_ result: [Quiz]) -> Void) {
        var semaphore = DispatchSemaphore (value: 226)
        var parameters = ""
        if OtwFirmwareInfo?.result[0].language == nil {
            parameters = "{\r\n    \"firmwareid\":\(OtwFirmwareInfo?.result[0].firmwareID),\r\n    \"firmwareversionno\":\"\(OtwFirmwareInfo?.result[0].nextFWVersion)\",\r\n    \"language\":null\r\n\r\n}"
        } else {
            //  added default value
            parameters = "{\r\n    \"firmwareid\":\(OtwFirmwareInfo?.result[0].firmwareID),\r\n    \"firmwareversionno\":\"\(OtwFirmwareInfo?.result[0].nextFWVersion ?? "")\",\r\n    \"language\":\"\(OtwFirmwareInfo?.result[0].language)\"\r\n\r\n}"
        }
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: hostApiUrl! + "/api/quiz/GetFirmwareQuiz")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+g_accessToken!, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    // FIXME: a separate function can be created as in here the bool result is not in use
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                self.cloudNotResponding()
                semaphore.signal()
                return
            }
            let responseString = String(data: data, encoding: .utf8)
            if responseString == "0" {
                completion(Quizzes)
            } else {
                let jsonData = Data(responseString!.utf8)
                let decoder = JSONDecoder()
                do {
                    Quizzes = try decoder.decode([Quiz].self, from: jsonData)
                    g_quizQuestionCount = String(Quizzes[0].QuizQuestions.count)
                    for (idx, foo) in Quizzes[0].QuizQuestions.enumerated()  {
                        Quizzes[0].QuizQuestions[idx].quiz1OfN = "\(idx+1)"
                    }
                    if 1 == 2 // check to resume quiz or start new quiz
                    {
                        if  let foo = defaults!.bool(forKey:"g_resumeQuiz") as? Bool {
                            g_resumeQuiz = foo
                        } else {
                            g_resumeQuiz = false
                            defaults!.set(g_resumeQuiz, forKey: "g_resumeQuiz")
                        }
                    }
                    completion(Quizzes)
                } catch {
                    Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
                }
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }

    func CallApiSetUserQuizTracker(quizid: Int, firmwareversion: String, transmitterid: String, choiceselectionjson: String, continueGetApi: Bool, completion: @escaping (_ result: Bool) -> Void) {
        var semaphore = DispatchSemaphore (value: 314)
        var url = hostApiUrl!+"/api/QUIZ/SetUserQuizTracker"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+g_accessToken!, forHTTPHeaderField: "Authorization")
        let parameters = "QuizID=\(quizid)&FirmwareVersion=\(firmwareversion)&TransmitterID=\(transmitterid)&ChoiceSelectionJSON=\(choiceselectionjson)"
        let postData =  parameters.data(using: .utf8)
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    // FIXME: a separate function can be created as in here the bool result is not in use
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                completion(false)
                return
            }
            print(String(data: data, encoding: .utf8)!)
            completion(true)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func callApiGetUserQuizTrackerNew(quizid: Int, firmwareversion: String, transmitterid: String, completion: @escaping (_ result: [StructGetUserQuizTracker]) -> Void) {
        var semaphore = DispatchSemaphore (value: 2618)
        var url = hostApiUrl!+"/api/QUIZ/GetUserQuizTracker"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer "+g_accessToken!, forHTTPHeaderField: "Authorization")
        let parameters = "QuizID=\(quizid)&FirmwareVersion=\(firmwareversion)&TransmitterID=\(transmitterid)"
        let postData =  parameters.data(using: .utf8)
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    // FIXME: a separate function can be created as in here the bool result is not in use
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                completion(GetUserQuizTracker)
                return
            }
            print(String(data: data, encoding: .utf8)!)
            let responseString = String(data: data, encoding: .utf8)
            g_GetUserQuizTrackerString = String(data: data, encoding: .utf8)
            let jsonData = Data(responseString!.utf8)
            let decoder = JSONDecoder()
            do {
                GetUserQuizTracker = try decoder.decode([StructGetUserQuizTracker].self, from: jsonData)
                completion(GetUserQuizTracker)
            } catch {
                Logger.log("file_name:\(#fileID) | function: \(#function) | line: \(#line) | ERROR: \(error.localizedDescription)")
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func callApiSubmitQuiz(newQuizChoices: [StructQuizChoicesSubmit], completion: @escaping (_ result: String) -> Void)
    {
        let encoder = JSONEncoder()
        let bar:Data? = try? encoder.encode(newQuizChoices)
        if 1 == 1 // add all questions to g_correct, remove incorect ones when you get api response
        {
            for foo in newQuizChoices {
                g_correctQuestionIds.append(foo.questionid)
            }
        }
        var semaphore = DispatchSemaphore (value: 332)
        let parameters = "{\"QuizChoices\":" + String(data: bar!, encoding: .utf8)!+"}"
        let postData = parameters.data(using: .utf8)
        var request = URLRequest(url: URL(string: hostApiUrl! + "/api/quiz/SubmitQuizResults")!,timeoutInterval: Double.infinity)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(g_accessToken!)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = postData
        let task = URLSession.shared.dataTask(with: request) { [self] data, response, error in
            guard let data = data else {
                print(String(describing: error))
                if (String(describing: error).contains("The Internet connection appears to be offline")) {
                    // FIXME: a separate function can be created as in here the bool result is not in use
                    GlobalManager.shared.checkInternetConnectionAndDisableOrEnableControls()
                }
                semaphore.signal()
                return
            }
            let result = String(data: data, encoding: .utf8)!
            print(result)
            let responseString = String(data: data, encoding: .utf8)
            let jsonData = Data(responseString!.utf8)
            var incorrectQuestions=""
            completion(responseString!)
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
}
