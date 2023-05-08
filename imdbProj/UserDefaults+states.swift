//
//  UserDefaults+states.swift
//  imdbProj
//
//  Created by Steve Roseik on 8/5/21.
//

import Foundation

extension UserDefaults{
    
    func isLoggedin() -> Bool{
       
        return bool(forKey: "LogState")
    }
    
    func setGuest(){
        set(true, forKey: "LogState")
        set("guest", forKey: "username")
    }
    
    func isGuest() -> Bool{
        if UserDefaults.standard.string(forKey: "username") == "guest"{
            return true
        }
        return false
    }
    
    func login(user: String, pass:String){
        set(true, forKey: "LogState")
        set(user, forKey: "username")
        set(pass, forKey: "password")
    }
    
    func logout(){
        set(false, forKey: "LogState")
        set("", forKey: "username")
        set("", forKey: "password")
        
    }
    
    func getUser() -> String{
        
        return UserDefaults.standard.string(forKey: "username") ?? ""
    }
    
    
    
}
