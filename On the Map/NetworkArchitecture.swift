//
//  NetworkArchitecture.swift
//  On the Map
//
//  Created by inailuy on 4/8/16.
//  Copyright © 2016 inailuy. All rights reserved.
//
class NetworkArchitecture {
    let connectionError = "No Internet Connection"
    
    let GET = "GET"
    let POST = "POST"
    let DELETE = "DELETE"
    let PUT = "PUT"
    
    let udacityURL = "https://www.udacity.com/api/session"
    let parseStudentURL = "https://api.parse.com/1/classes/StudentLocation"

    let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

    var userModel : UserModel!
    var currentStudentLocation :StudentLocationModel!
    
    var session : NSURLSession!
    var fbAcessToken : FBSDKAccessToken!
    
    static let sharedInstance = NetworkArchitecture()
    
    func createRequest(url: NSURL, method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    //MARK: Udacity API
    func creatingSession(loginModel :LoginModel?, completion: (errorString: String?) -> Void) {
        if !hasConnectivity() {
            completion(errorString: connectionError)
            return
        }
        
        let request = createRequest(NSURL.init(string: udacityURL)!, method:POST)
        if fbAcessToken != nil {
            let bodyString = "{\"facebook_mobile\": {\"access_token\": \"" + fbAcessToken.tokenString + ";\"}}"
            request.HTTPBody = bodyString.dataUsingEncoding(NSUTF8StringEncoding)
        } else {
            request.HTTPBody = loginModel!.httpBody().dataUsingEncoding(NSUTF8StringEncoding)
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completion(errorString: error?.localizedDescription)
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            do {
                let jsonArray = try NSJSONSerialization.JSONObjectWithData(newData, options:[])
                
                if let message = jsonArray["error"] as? String{
                    completion(errorString: message)
                }else {
                    let account = jsonArray["account"]
                    let accountKey = account!!["key"] as! String
                    
                    let session = jsonArray["session"]
                    let sessionId = session!!["id"] as! String
                    
                    self.getPublicData(accountKey, sessionId: sessionId)
                    completion(errorString: nil)
                }
                
            }
            catch {}
        }
        task.resume()
    }
    
    func deletingSession(completion: (didFinished: Bool, errorString: String?) -> Void) {
        if !hasConnectivity() {
            completion(didFinished: true, errorString: connectionError)
            return
        }
        
        if NetworkArchitecture.sharedInstance.fbAcessToken != nil {
            let loginManager = FBSDKLoginManager()
            loginManager.logOut()
            NetworkArchitecture.sharedInstance.fbAcessToken = nil
            
            completion(didFinished: true, errorString: nil)
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: udacityURL)!)
        request.HTTPMethod = DELETE
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                completion(didFinished: false, errorString: error?.localizedDescription)
                return
            }
            completion(didFinished: true, errorString: error?.localizedDescription)
        }
        task.resume()
    }
    
    func getPublicData(userKey: String, sessionId: String) {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/"+userKey)!)
        session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { /* Handle error */ return }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(newData, options: []) as? [String:AnyObject] {
                    let dict = json["user"]
                    let firstName = dict!["first_name"] as! String
                    let lastName = dict!["last_name"] as! String
                    
                    self.userModel = UserModel(firstName: firstName, lastName: lastName, uniqueKey: userKey, sessionId: sessionId)
                }
            }
            catch {}
        }
        task.resume()
    }
    //MARK: Parse API
    func getStudentLocations(completion: (errorString: String?) -> Void) {
        if !hasConnectivity() {
            completion(errorString: connectionError)
            return
        }
        
        let request = NSMutableURLRequest(URL: NSURL(string: parseStudentURL+"?limit=100&order=-updatedAt")!)
        request.addValue(ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completion(errorString: error?.localizedDescription)
                return
            }
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject] {
                    studentLocationArray.removeAll()
                    let array = json["results"] as! NSArray
                    if array.count > 0 {
                        for dictionary in array {
                            let studentLocation = StudentLocationModel(fromDict: dictionary as! NSDictionary)
                            studentLocationArray.append(studentLocation)
                        }
                    }
                }
            }
            catch {}
            completion(errorString: nil)
        }
        task.resume()
    }
    
    func postStudentLocation(studentLocation: StudentLocationModel,
                             completion: (didFinished: Bool, errorString: String?) -> Void) {
        if !hasConnectivity() {
            completion(didFinished: true, errorString: connectionError)
            return
        }
        
        if studentLocation.objectId != "" {
            putStudentLocation(studentLocation, completion: completion)
            return
        }
        
        let urlString = parseStudentURL
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = POST
        request.addValue(ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = studentLocation.objectToString().dataUsingEncoding(NSUTF8StringEncoding)
        session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completion (didFinished: true, errorString: error?.localizedDescription)
                return
            }
            completion(didFinished: true, errorString:nil)
        }
        task.resume()
    }
    // Querying for a StudentLocation
    func getStudentLocation() {
        if userModel != nil {
            let urlString = parseStudentURL+"?where=%7B%22uniqueKey%22%3A%22"+userModel.uniqueKey+"%22%7D"
            let url = NSURL(string: urlString)
            let request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = GET
            request.addValue(ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue(RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request) { data, response, error in
                if error != nil { /* Handle error */ return }
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject] {
                        let array = json["results"] as! NSArray
                        self.currentStudentLocation = StudentLocationModel(fromDict: array.lastObject as! NSDictionary)
                    }
                }
                catch {}
            }
            task.resume()
        }
    }
    // Updating StudentLocation
    func putStudentLocation(studentLocation: StudentLocationModel,
                            completion: (didFinished: Bool, errorString: String?) -> Void) {
        if !hasConnectivity() {
            completion(didFinished: true, errorString: connectionError)
            return
        }
        let urlString = parseStudentURL+"/"+studentLocation.objectId
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = PUT
        request.addValue(ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = studentLocation.objectToString().dataUsingEncoding(NSUTF8StringEncoding)
        session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil {
                completion(didFinished: true, errorString: error?.localizedDescription)
                return
            }
            completion(didFinished: true, errorString: nil)
        }
        task.resume()
    }
    // Checking Internet Connectivity
    func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.reachabilityForInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        return networkStatus != 0
    }
}