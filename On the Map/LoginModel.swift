//
//  LoginModel.swift
//  On the Map
//
//  Created by inailuy on 4/8/16.
//  Copyright © 2016 inailuy. All rights reserved.
//

import Foundation

struct LoginModel {
    let email: String
    let password: String
    
    func httpBody() -> String {
        return "{\"udacity\": {\"username\": \"" + email + "\", \"password\": \"" + password + "\"}}"
    }
}

