//
//  LoginViewController.swift
//  TaskManagerIOS
//
//  Created by mac on 03.01.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    var loginResource:LoginResource!
    var loginRequest:LoginRequest!
    
    @IBAction func login(_ sender: Any) {
        
        loginResource = LoginResource(login: "admin@example.com", password: "Admin123@")
       
        loginRequest = LoginRequest(resource: loginResource)
      
        loginRequest.load {[unowned self] (error, token) in
            if error != nil {
                print(error)
            }
            if let token = token {
                Session.shared.setToken(token:token)
            }
            
            print(Session.shared.token)
            
        }
        
    }
    
    deinit {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
