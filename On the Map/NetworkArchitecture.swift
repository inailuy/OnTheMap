//
//  NetworkArchitecture.swift
//  On the Map
//
//  Created by inailuy on 4/8/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation

class NetworkArchitecture {

    let GET = "GET"
    let POST = "POST"
    let DELETE = "DELETE"
    let PUT = "PUT"
    
    let udacityURL = "https://www.udacity.com/api/session"
    let parseStudentURL = "https://api.parse.com/1/classes/StudentLocation"

    var accountKey : String!
    var sessionId : String!
    var studentLocationArray = [StudentLocationModel]()
    var session : NSURLSession!
    var fbAcessToken : FBSDKAccessToken!
    
    
    let ParseApplicationID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
    let RESTAPIKey = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    
    

    static let sharedInstance = NetworkArchitecture()
    
    func createRequest(url: NSURL, method: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    //MARK: Udacity API
    
    func creatingSession(loginModel :LoginModel?, loginVC : LoginVC) {
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
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
            do {
                let jsonArray = try NSJSONSerialization.JSONObjectWithData(newData, options:[])
                
                if let message = jsonArray["error"] as? String{
                    dispatch_async(dispatch_get_main_queue(),{
                        loginVC.handleErrors(message)
                    })
                }else {
                    if let account = jsonArray["account"] {
                        self.accountKey = account!["key"] as! String
                    }
                    if let session = jsonArray["session"] {
                        self.sessionId = session!["id"] as! String
                    }
                   loginVC.dismissView()
                }
                
            }
            catch {
                print("Error: \(error)")
            }
        }
        task.resume()
    }
    
    func deletingSession() {
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
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
        }
        task.resume()
    }
    
    func getPublicData() {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/users/"+accountKey)!)
        session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
        }
        task.resume()
    }
    
    //MARK: Parse API
    
    func getStudentLocations(completion: () -> Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: parseStudentURL+"?limit=200&order=-updatedAt")!)
        request.addValue(ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error...
                return
            }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject] {
                    self.studentLocationArray.removeAll()
                    let array = json["results"] as! NSArray
                    if array.count > 0 {
                        for dictionary in array {
                            let objectId = dictionary["objectId"] as! String
                            let uniqueKey = dictionary["uniqueKey"] as! String
                            let firstName = dictionary["firstName"] as! String
                            let lastName = dictionary["lastName"] as! String
                            let mapString = dictionary["mapString"] as! String
                            let mediaURL = dictionary["mediaURL"] as! String
                            let latitude = dictionary["latitude"] as! Float
                            let longitude = dictionary["longitude"] as! Float
                            
                            let studentLocation = StudentLocationModel(objectId: objectId, uniqueKey: uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: latitude, longitude: longitude)
                            self.studentLocationArray.append(studentLocation)
                        }
                    }
                }
            }
            catch {
                print("Error: \(error)")
            }
            completion()
        }
        task.resume()
    }
    
    func postStudentLocation(studentLocation: StudentLocationModel) {
        let request = NSMutableURLRequest(URL: NSURL(string: udacityURL)!)
        request.HTTPMethod = POST
        request.addValue(ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = studentLocation.objectToString().dataUsingEncoding(NSUTF8StringEncoding)
        session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
        }
        task.resume()
    }
    
    func putStudentLocation(studentLocation: StudentLocationModel) {
        let urlString = udacityURL+"/"+studentLocation.objectId
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = PUT
        request.addValue(ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(RESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = studentLocation.objectToString().dataUsingEncoding(NSUTF8StringEncoding)
        session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(NSString(data: data!, encoding: NSUTF8StringEncoding))
        }
        task.resume()
    }
}