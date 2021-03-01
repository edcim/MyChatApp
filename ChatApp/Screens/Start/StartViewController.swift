//
//  StartViewController.swift
//  ChatApp
//
//  Created by Siddhant on 27/02/21.
//

import UIKit

class StartViewController: UIViewController {
    
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialUISetUp()
    }
    
    // MARK: - Initial UI Setup
    func initialUISetUp() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: - Actions
    
    @IBAction func btnLoginAction(_ sender: Any) {
        AppDelegate.sharedAppDelegate().isFromHome = false
        guard let loginVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else { return }
        self.navigationController?.pushViewController(loginVC, animated: false)
    }
    
    @IBAction func btnSignUpAction(_ sender: Any) {
        guard let signUpVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(identifier: "SignUpViewController") as? SignUpViewController else {
            return
        }
        self.navigationController?.pushViewController(signUpVC, animated: false)
    }
    
}
