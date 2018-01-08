//
//  Session.swift
//  TaskManagerIOS
//
//  Created by mac on 05.01.18.
//  Copyright © 2018 mac. All rights reserved.
//

import Foundation

class Session{
    
    private init(){}
    
    static let shared = Session()
    private let defaults = UserDefaults.standard
    private let tokenIdentifier = "Token"
    private let usernameIdentifier = "Username"
    private let roleIdentifier = "Role"
    
    enum Role:Int{
        case user = 2
        case admin = 1
    }
    
    var role:Role?{
        if let value = defaults.value(forKey: roleIdentifier) as? Int{
            return Role(rawValue: value)
        }
        return nil
    }
    
    
    
    
    var token:String?{
        return defaults.value(forKey: tokenIdentifier) as? String
    }
    
    var hasToken:Bool{
        return token != nil
    }
        
    var username:String?{
        return defaults.value(forKey: usernameIdentifier) as? String
    }
    
    func setToken(token:String){
        defaults.set(token, forKey: tokenIdentifier)
        defaults.synchronize()
    }
    
    func setUsername(username:String){
        defaults.set(username, forKey: usernameIdentifier)
        defaults.synchronize()
    }
    
    func setRole(role:Role){
        defaults.set(role.rawValue, forKey: roleIdentifier)
        defaults.synchronize()

    }
    
    func invalidateUsername(){
        setUsername(username: "")
    }
    
    func invalidateToken(){
        setToken(token: "")
    }
    
    
}
