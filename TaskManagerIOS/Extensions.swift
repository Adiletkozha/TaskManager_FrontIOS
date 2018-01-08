//
//  Extensions.swift
//  TaskManagerIOS
//
//  Created by mac on 08.01.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit




extension UIView{
    
    
    var onlyAdminAccessible:Bool{
        guard let role = Session.shared.role else{return false}
        switch role {
        case .admin:
            return true
        default:
            return false
        }
        
    }
}
