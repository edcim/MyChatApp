//
//  LoginViewController.swift
//  ChatApp
//
//  Created by Siddhant on 27/02/21.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var lblTopLogin: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var lblDateOfBirth: UILabel!
    @IBOutlet weak var textFieldDateOfBirth: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISetUp()
    }
    
    // MARK: - Initial UI Setup
    func initialUISetUp() {
        self.navigationController?.navigationBar.isHidden = false
        if AppDelegate.sharedAppDelegate().isFromHome {
            self.navigationItem.setHidesBackButton(true, animated: false)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func btnLoginAction(_ sender: Any) {
        if let name = textFieldName.text, let dob = textFieldDateOfBirth.text {
            callForLogin(name: name,dob: dob)
        } else {
            let alert = UIAlertController(title: "Alert", message: "Please enter the name and dob..!!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func callForLogin(name: String,dob: String) {
        let service : LoginService = LoginService()
        let isSuccess = service.getUser(name: name, dob: dob)
        if isSuccess {
            UserDefaults.standard.set(true, forKey: NSMyProfileDefaultKeys.isLoginDone.rawValue)
            guard let homeVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "HomeViewController") as? HomeViewController else {
                return
            }
            homeVC.name = name
            homeVC.dob = dob
            self.navigationController?.pushViewController(homeVC, animated: false)
            
        } else {
            let alert = UIAlertController(title: "Alert", message: "You have not registered yet please resgister..!!", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
