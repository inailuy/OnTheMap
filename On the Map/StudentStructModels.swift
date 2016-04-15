//
//  StudentLocationModel.swift
//  On the Map
//
//  Created by inailuy on 4/10/16.
//  Copyright © 2016 inailuy. All rights reserved.
//
struct StudentLocationModel {
    var objectId : String
    var uniqueKey: String
    var firstName : String
    var lastName : String
    var mapString : String
    var mediaURL : String
    var latitude : Float
    var longitude : Float
    
    init (objectId : String, uniqueKey: String, firstName: String, lastName: String, mapString: String, mediaURL: String, latitude: Float, longitude: Float){
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(fromDict dict: NSDictionary) {
        self.objectId = dict["objectId"] as! String
        self.uniqueKey = dict["uniqueKey"] as! String
        self.firstName = dict["firstName"] as! String
        self.lastName = dict["lastName"] as! String
        self.mapString = dict["mapString"] as! String
        self.mediaURL = dict["mediaURL"] as! String
        self.latitude = dict["latitude"] as! Float
        self.longitude = dict["longitude"] as! Float
    }
    
    func objectToString() -> String {
        do {
            let JSON = objectToJSON()
            let jsonData = try NSJSONSerialization.dataWithJSONObject(JSON, options: NSJSONWritingOptions())
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            return jsonString
        }
        catch {
            return ("Error: \(error)")
        }
    }
    
    func objectToJSON() -> [String: AnyObject] {
        return [
            "uniqueKey": uniqueKey,
            "firstName": firstName,
            "lastName": lastName,
            "mapString": mapString,
            "mediaURL": mediaURL,
            "latitude": latitude,
            "longitude": longitude
        ]
    }
    // Convenience
    func fullName() -> String {
        return firstName + " " + lastName
    }
}

struct LoginModel {
    let email: String
    let password: String
    
    func httpBody() -> String {
        do {
            let JSON = objectToJSON()
            let jsonData = try NSJSONSerialization.dataWithJSONObject(JSON, options: NSJSONWritingOptions())
            let jsonString = NSString(data: jsonData, encoding: NSUTF8StringEncoding) as! String
            return jsonString
        }
        catch {
            return ("Error: \(error)")
        }
    }
    
    func objectToJSON() -> [String: AnyObject] {
        return [
            "udacity" : [
                "username": email,
                "password": password
            ]
        ]
    }
}

struct UserModel {
    let firstName: String!
    let lastName: String!
    let uniqueKey: String!
    let sessionId: String!
}