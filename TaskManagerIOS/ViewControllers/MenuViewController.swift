//
//  MenuViewController.swift
//  TaskManagerIOS
//
//  Created by mac on 08.01.18.
//  Copyright © 2018 mac. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController  {

    override func viewDidLoad() {
        super.viewDidLoad()
            
    }
    
    override func customAdaptation() {
        let navBar = self.navigationController
      //  navBar?.isEnabled = false
    }
    
}


protocol AdminElements{
    func customAdaptation()
}

extension AdminElements{

}


extension AdminElements where Self: UIViewController{
    
    func adaptUIForRole(){
        Session.shared.setRole(role: .user)
        let views = (self.view.subviews)

        for view in views {
            if let _ = view as? HideAble{
                view.isHidden = !view.onlyAdminAccessible
            }
        }

    }
    

    
}

class BaseViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        defer{
            adaptUIForRole()
            customAdaptation()
        }
    }
    
    func customAdaptation() {}
}

extension BaseViewController:AdminElements{
}



protocol HideAble {}

class HideAbleBarButton:UIBarButtonItem,HideAble{}
class HideAbleButton:UIButton,HideAble{}
class HideAbleLabel:UILabel,HideAble{}
class HideAbleTextField:UITextField,HideAble{}























