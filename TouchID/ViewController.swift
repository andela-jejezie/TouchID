//
//  ViewController.swift
//  TouchID
//
//  Created by Johnson Ejezie on 06/12/2016.
//  Copyright © 2016 johnsonejezie. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    let reason = NSLocalizedString("Just because we can", comment: "authReason")
    var errorPointer:NSError?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        touchIDAuthentication()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func touchIDAuthentication() {
        let context = LAContext() //1
        
        //2
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &errorPointer) {
            //3
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                        //Authentication was successful
                    }
                    
                }else {
                    DispatchQueue.main.async {
                        //Authentication failed. Show alert indicating what error occurred
                        self.displayErrorMessage(error: error as! LAError )
                    }
                    
                }
            })
        }else {
           //Touch ID is not available on Device, use password.
            self.showAlertWith(title: "Error", message: (errorPointer?.localizedDescription)!)
            
        }
    }

    func displayErrorMessage(error:LAError) {
        var message = ""
        switch error.code {
        case LAError.authenticationFailed:
            message = "Authentication was not successful because the user failed to provide valid credentials."
            break
        case LAError.userCancel:
            message = "Authentication was canceled by the user"
            break
        case LAError.userFallback:
            message = "Authentication was canceled because the user tapped the fallback button"
            break
        case LAError.touchIDNotEnrolled:
            message = "Authentication could not start because Touch ID has no enrolled fingers."
        case LAError.passcodeNotSet:
            message = "Passcode is not set on the device."
            break
        case LAError.systemCancel:
            message = "Authentication was canceled by system"
            break
        default:
            message = error.localizedDescription
        }
        
        self.showAlertWith(title: "Authentication Failed", message: message)
    }

}

extension UIViewController {
    func showAlertWith(title:String, message:String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let actionButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(actionButton)
        self.present(alertController, animated: true, completion: nil)
    }
}

