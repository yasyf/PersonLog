//
//  LoginViewController.swift
//  FishBowl
//
//  Created by Larry Zhang on 4/5/15.
//  Copyright (c) 2015 com.fishbowl. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet var loginView: FBSDKLoginButton!
    let settings = Settings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginView.readPermissions = ["public_profile", "user_friends", "user_photos"]
        loginView.delegate = self
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        if (error) != nil {
            println(error)
        } else if result.isCancelled {
            println("cancelled")
        } else {
            self.setUserData({
                self.dismissViewControllerAnimated(false, completion: nil)
            })
            println("logged in")
        }
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        settings.clear()
    }

    func setUserData(completion: () -> Void) {
        let graphRequest:FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
        
        graphRequest.startWithCompletionHandler({(connection, result, error) in
            if error == nil {
                let fieldMap = ["first_name": "f_name", "last_name": "l_name", "id": "fb_id"]
                for (facebookField, settingField) in fieldMap {
                    let value = result.valueForKey(facebookField) as NSString
                    self.settings.defaults.setValue(value, forKey: settingField)
                }
                let userID = result.valueForKey("id") as NSString
                self.settings.setphotoURL("https://graph.facebook.com/\(userID)/picture?type=large")
            } else {
                println("Error: \(error)")
            }
            completion()
        })
    }
}
